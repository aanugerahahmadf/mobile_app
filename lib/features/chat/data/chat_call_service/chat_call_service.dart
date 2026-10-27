import 'dart:async';
import 'package:dio/dio.dart';
import 'package:flutter_webrtc/flutter_webrtc.dart';
import '../../../../core/api/api_endpoints/api_endpoints.dart';
import '../../../../core/api/dio_client/dio_client.dart';

/// First-party voice call transport. Signaling is persisted by Laravel; media
/// itself never leaves the two devices through a third-party meeting service.
class ChatCallService {
  ChatCallService({Dio? dio}) : _dio = dio ?? DioClient.instance;
  final Dio _dio;
  RTCPeerConnection? _peer;
  MediaStream? _local;
  Timer? _timer;
  String? token;
  String? guestId;
  final Set<String> _seenIce = {};

  Future<String> start(int inboxId, {String? guestId}) async {
    this.guestId = guestId;
    final endpoint = guestId == null ? ApiEndpoints.chatCalls : ApiEndpoints.guestChatCalls;
    final response = await _dio.post(endpoint,
        data: {'inbox_id': inboxId, if (guestId != null) 'guest_id': guestId});
    token = response.data['call']['token'] as String;
    await _prepareCaller();
    return token!;
  }

  Future<void> _prepareCaller() async {
    final configuration = <String, dynamic>{'iceServers': <dynamic>[]};
    _peer = await createPeerConnection(configuration);
    _local = await navigator.mediaDevices.getUserMedia({'audio': true, 'video': false});
    for (final track in _local!.getTracks()) {
      await _peer!.addTrack(track, _local!);
    }
    _peer!.onIceCandidate = (candidate) async {
      if (candidate.candidate == null || token == null) return;
      await _signal('ice', {
        'candidate': candidate.candidate,
        'sdpMid': candidate.sdpMid,
        'sdpMLineIndex': candidate.sdpMLineIndex,
      });
    };
    final offer = await _peer!.createOffer();
    await _peer!.setLocalDescription(offer);
    await _signal('offer', {'type': offer.type, 'sdp': offer.sdp});
    _timer = Timer.periodic(const Duration(milliseconds: 700), (_) => poll());
  }

  Future<Map<String, dynamic>> poll() async {
    final current = token;
    if (current == null) return const {};
    final endpoint = guestId == null ? ApiEndpoints.chatCallState(current) : ApiEndpoints.guestChatCallState(current);
    final response = await _dio.get(endpoint, queryParameters: {if (guestId != null) 'guest_id': guestId});
    final call = Map<String, dynamic>.from(response.data['call'] as Map);
    final answer = call['answer'];
    if (answer is Map && _peer != null && _peer!.remoteDescription == null) {
      await _peer!.setRemoteDescription(RTCSessionDescription(answer['sdp'] as String?, answer['type'] as String?));
    }
    for (final raw in (call['ice_candidates'] as List? ?? const [])) {
      final candidate = Map<String, dynamic>.from(raw as Map);
      final key = '${candidate['candidate']}:${candidate['sdpMid']}:${candidate['sdpMLineIndex']}';
      if (_seenIce.add(key)) {
        await _peer?.addCandidate(RTCIceCandidate(candidate['candidate'] as String?, candidate['sdpMid'] as String?, candidate['sdpMLineIndex'] as int?));
      }
    }
    return call;
  }

  Future<void> _signal(String type, Map<String, dynamic> value) async {
    final endpoint = guestId == null ? ApiEndpoints.chatCallSignal(token!) : ApiEndpoints.guestChatCallSignal(token!);
    await _dio.post(endpoint, data: {'type': type, 'value': value, if (guestId != null) 'guest_id': guestId});
  }

  Future<void> end() async {
    _timer?.cancel();
    if (token != null) {
      final endpoint = guestId == null ? ApiEndpoints.chatCallEnd(token!) : ApiEndpoints.guestChatCallEnd(token!);
      await _dio.post(endpoint, data: {if (guestId != null) 'guest_id': guestId});
    }
    await _local?.dispose();
    await _peer?.close();
    _local = null;
    _peer = null;
    token = null;
    guestId = null;
  }
}
