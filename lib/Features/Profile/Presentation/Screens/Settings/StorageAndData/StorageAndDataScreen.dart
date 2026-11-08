import 'dart:math' as math;
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:mobile_app/L10n/AppLocalizations.dart';
import '../../../../../../Core/Widgets/AppBreadcrumbs/AppBreadcrumbs.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:share_plus/share_plus.dart';
import '../../../../../../Core/Constants/AppColors/AppColors.dart';
import '../../../../../../Core/Constants/AppTextStyles/AppTextStyles.dart';
import '../../../../../../Core/Utils/CacheUtils/CacheUtils.dart';
import 'StorageUsage/StorageUsageScreen.dart';
import 'NetworkUsage/NetworkUsageScreen.dart';
import 'Proxy/ProxyScreen.dart';
import 'UploadQuality/UploadQualityScreen.dart';
import 'DownloadQuality/DownloadQualityScreen.dart';
import 'AutoDownload/PhotoAutoDownloadScreen.dart';
import 'AutoDownload/AudioAutoDownloadScreen.dart';
import 'AutoDownload/VideoAutoDownloadScreen.dart';
import 'AutoDownload/DocumentAutoDownloadScreen.dart';

final storageDataProvider = ChangeNotifierProvider<StorageDataController>((ref) => StorageDataController());

enum AutoDownloadPolicy { never, wifi, wifiAndCellular }
enum MediaQuality { standard, hd }

class StorageDataController extends ChangeNotifier {
  static const _uploadKey = 'storage_upload_quality';
  static const _downloadKey = 'storage_download_quality';
  static const _callKey = 'storage_low_call_data';
  static const _autoPrefix = 'storage_auto_';
  static const _statsKey = 'storage_network_stats';
  final Map<String, int> stats = {};
  MediaQuality upload = MediaQuality.standard;
  MediaQuality download = MediaQuality.standard;
  bool lowCallData = false;
  final Map<String, AutoDownloadPolicy> auto = {
    'Foto': AutoDownloadPolicy.wifiAndCellular,
    'Audio': AutoDownloadPolicy.wifiAndCellular,
    'Video': AutoDownloadPolicy.wifiAndCellular,
    'Dokumen': AutoDownloadPolicy.wifiAndCellular,
  };

  StorageDataController() { _load(); }
  Future<void> _load() async {
    final p = await SharedPreferences.getInstance();
    upload = MediaQuality.values[p.getInt(_uploadKey) ?? 0];
    download = MediaQuality.values[p.getInt(_downloadKey) ?? 0];
    lowCallData = p.getBool(_callKey) ?? false;
    for (final key in auto.keys) {
      auto[key] = AutoDownloadPolicy.values[p.getInt('$_autoPrefix$key') ?? 2];
    }
    final raw = p.getStringList(_statsKey) ?? <String>[];
    stats.clear();
    for (final item in raw) { final pair = item.split(':'); if (pair.length == 2) stats[pair[0]] = int.tryParse(pair[1]) ?? 0; }
    notifyListeners();
  }
  Future<void> setUpload(MediaQuality value) async { upload = value; final p = await SharedPreferences.getInstance(); await p.setInt(_uploadKey, value.index); notifyListeners(); }
  Future<void> setDownload(MediaQuality value) async { download = value; final p = await SharedPreferences.getInstance(); await p.setInt(_downloadKey, value.index); notifyListeners(); }
  Future<void> setLowCallData(bool value) async { lowCallData = value; final p = await SharedPreferences.getInstance(); await p.setBool(_callKey, value); notifyListeners(); }
  Future<void> setAuto(String key, AutoDownloadPolicy value) async { auto[key] = value; final p = await SharedPreferences.getInstance(); await p.setInt('$_autoPrefix$key', value.index); notifyListeners(); }
  Future<void> resetAuto() async { for (final key in auto.keys) { auto[key] = AutoDownloadPolicy.wifiAndCellular; } final p = await SharedPreferences.getInstance(); for (final key in auto.keys) { await p.setInt('$_autoPrefix$key', 2); } notifyListeners(); }
  Future<void> resetStats() async { stats.clear(); final p = await SharedPreferences.getInstance(); await p.setStringList(_statsKey, []); notifyListeners(); }
}

class StorageAndDataScreen extends ConsumerWidget {
  const StorageAndDataScreen({super.key});
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final c = ref.watch(storageDataProvider);
    final l = AppLocalizations.of(context)!;
    return Scaffold(
      backgroundColor: const Color(0xFF0A0A0A),
      appBar: AppBar(
        backgroundColor: const Color(0xFF0A0A0A),
        title: Text(l.storageAndData),
        automaticallyImplyLeading: false,
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(36),
          child: const AppBreadcrumbs.global(),
        ),
      ),
      body: ListView(padding: const EdgeInsets.fromLTRB(44, 8, 44, 28), children: [
        _section(l.storage),
        _group([_row(context, l.clearSomeStorage, onTap: () => Navigator.push(context, MaterialPageRoute(builder: (_) => const StorageUsageSettingsScreen()))) ]),
        _section(l.network),
        _group([
          _row(context, l.networkUsage, onTap: () => Navigator.push(context, MaterialPageRoute(builder: (_) => const NetworkUsageSettingsScreen()))),
          _switchRow(l.reduceCallData, c.lowCallData, c.setLowCallData),
          _row(context, l.proxy, onTap: () => Navigator.push(context, MaterialPageRoute(builder: (_) => const ProxySettingsScreen()))),
        ]),
        _section(l.mediaQuality),
        _group([
          _row(context, l.uploadQuality, value: c.upload == MediaQuality.hd ? 'HD' : l.standard, onTap: () => Navigator.push(context, MaterialPageRoute(builder: (_) => UploadQualityScreen(title: l.uploadQuality)))),
          _row(context, l.autoDownloadQuality, onTap: () => Navigator.push(context, MaterialPageRoute(builder: (_) => DownloadQualityScreen(title: l.autoDownloadQuality)))),
        ]),
        _section(l.automaticMediaDownload),
        _group([
          ...c.auto.keys.map((key) => _row(context, _displayMediaKey(key, l), value: _policyLabel(c.auto[key]!, l), onTap: () => Navigator.push(context, MaterialPageRoute(builder: (_) => _autoDownloadPage(key))))),
          _row(context, l.resetAutoDownload, destructive: true, onTap: () async { if (await _confirm(context, '${l.resetAutoDownload}?')) await ref.read(storageDataProvider).resetAuto(); }),
        ]),
        const SizedBox(height: 14),
        Text(l.voiceMessagesAuto),
      ]),
    );
  }
}

String _displayMediaKey(String key, AppLocalizations l) {
  final isId = l.localeName.startsWith('id');
  return switch (key) {
    'Foto' => isId ? 'Foto' : 'Photos',
    'Audio' => isId ? 'Audio' : 'Audio',
    'Video' => isId ? 'Video' : 'Videos',
    'Dokumen' => isId ? 'Dokumen' : 'Documents',
    _ => key,
  };
}

Widget _group(List<Widget> children) => Container(
  decoration: BoxDecoration(color: const Color(0xFF1C1C1E), borderRadius: BorderRadius.circular(16)),
  clipBehavior: Clip.antiAlias,
  child: Column(children: children),
);
Widget _section(String text) => Padding(padding: const EdgeInsets.only(top: 22, bottom: 10, left: 44), child: Text(text, style: const TextStyle(fontSize: 17, fontWeight: FontWeight.w600, color: Color(0xFF9B9B9F))));
Widget _row(BuildContext context, String title, {String? value, VoidCallback? onTap, bool destructive = false}) => InkWell(
  onTap: onTap,
  child: Container(
    constraints: const BoxConstraints(minHeight: 66),
    padding: const EdgeInsets.only(left: 22, right: 16),
    decoration: const BoxDecoration(border: Border(bottom: BorderSide(color: Color(0xFF303033), width: .6))),
    child: Row(children: [Expanded(child: Text(title, style: TextStyle(fontSize: 17, color: destructive ? const Color(0xFFFF5266) : Colors.white))), if (value != null) Text(value, style: const TextStyle(fontSize: 16, color: Color(0xFF929297))), if (onTap != null && !destructive) const Padding(padding: EdgeInsets.only(left: 16), child: Icon(Icons.chevron_right, color: Color(0xFF9B9B9F), size: 27))]),
  ),
);
Widget _switchRow(String title, bool value, ValueChanged<bool> onChanged) => Container(
  constraints: const BoxConstraints(minHeight: 66),
  padding: const EdgeInsets.only(left: 22, right: 8),
  decoration: const BoxDecoration(border: Border(bottom: BorderSide(color: Color(0xFF303033), width: .6))),
  child: Row(children: [Expanded(child: Text(title, style: const TextStyle(fontSize: 17, color: Colors.white))), Switch.adaptive(value: value, onChanged: onChanged)]),
);
Widget _storageBreadcrumb(BuildContext context, String current) {
  final l = AppLocalizations.of(context)!;
  return AppBreadcrumbs(items: [
    AppBreadcrumbItem(l.home, onTap: () => context.go('/home')),
    AppBreadcrumbItem(l.profile, onTap: () => context.go('/profile')),
    AppBreadcrumbItem(l.settings, onTap: () => context.go('/settings')),
    AppBreadcrumbItem(l.storageAndData, onTap: () => context.go('/storage-and-data')),
    AppBreadcrumbItem(current),
  ]);
}

class StorageUsageScreen extends ConsumerStatefulWidget { const StorageUsageScreen({super.key}); @override ConsumerState<StorageUsageScreen> createState() => _StorageUsageState(); }
class _StorageUsageState extends ConsumerState<StorageUsageScreen> {
  int total = 0; final selected = <String, bool>{}; final names = ['Aneka Ragam', 'Berkas', 'Avatar', 'Foto', 'Video', 'Audio', 'Lainnya'];
  @override void initState() { super.initState(); for (final n in names) { selected[n] = true; } _load(); }
  Future<void> _load() async { final value = await getAppCacheSize(); if (mounted) setState(() => total = value); }
  String get selectedSize => formatStorageBytes(selected.values.any((v) => v) ? total : 0);
  @override Widget build(BuildContext context) {
    final l = AppLocalizations.of(context)!;
    final isId = l.localeName.startsWith('id');
    return Scaffold(appBar: AppBar(title: Text(l.storageUsage), automaticallyImplyLeading: false, bottom: PreferredSize(preferredSize: const Size.fromHeight(36), child: _storageBreadcrumb(context, l.storageAndData))), body: ListView(padding: const EdgeInsets.all(16), children: [
    Center(child: SizedBox(width: 190, height: 190, child: CustomPaint(painter: _DonutPainter(total), child: Center(child: Text(formatStorageBytes(total), style: AppTextStyles.headTitle))))),
    const SizedBox(height: 12), if (total == 0) Center(child: Text(l.noCache)) else ...names.map((name) => CheckboxListTile(value: selected[name], onChanged: (v) => setState(() => selected[name] = v ?? false), title: Text(name), subtitle: Text('${total == 0 ? 0 : 100 ~/ names.length}%  •  ${formatStorageBytes(total ~/ names.length)}'), secondary: CircleAvatar(radius: 7, backgroundColor: _color(names.indexOf(name))))),
    const SizedBox(height: 8), LinearProgressIndicator(value: total == 0 ? 0 : .12), const SizedBox(height: 8), Text(isId ? 'Aplikasi memakai ${formatStorageBytes(total)} dari ruang penyimpanan' : 'App uses ${formatStorageBytes(total)} of storage'), const SizedBox(height: 16),
    FilledButton(onPressed: total == 0 ? null : () async { if (!await _confirm(context, l.clearCacheConfirm)) return; await clearAppCache(); await _load(); }, child: Text('${l.clearAllCache} $selectedSize')), const SizedBox(height: 16), Text(l.mediaServerNote, textAlign: TextAlign.center),
  ])); }
}

class NetworkUsageScreen extends ConsumerWidget {
  const NetworkUsageScreen({super.key});
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final c = ref.watch(storageDataProvider);
    final l = AppLocalizations.of(context)!;
    final isId = l.localeName.startsWith('id');
    final groups = <String, List<String>>{
      isId ? 'Pesan' : 'Messages': isId ? ['Dikirim', 'Diterima', 'Bita Dikirim', 'Bita Diterima'] : ['Sent', 'Received', 'Bytes Sent', 'Bytes Received'],
      isId ? 'Chat Media' : 'Media': isId ? ['Bita Dikirim', 'Bita Diterima'] : ['Bytes Sent', 'Bytes Received'],
      isId ? 'Status Media' : 'Status': isId ? ['Bita Dikirim', 'Bita Diterima'] : ['Bytes Sent', 'Bytes Received'],
      isId ? 'Panggilan' : 'Calls': isId ? ['Keluar', 'Masuk', 'Bita Dikirim', 'Bita Diterima', 'Waktu Total'] : ['Outgoing', 'Incoming', 'Bytes Sent', 'Bytes Received', 'Total Time'],
      isId ? 'Total Bita' : 'Total Bytes': isId ? ['Dikirim', 'Diterima'] : ['Sent', 'Received'],
    };
    return Scaffold(
      appBar: AppBar(title: Text(l.networkUsage), automaticallyImplyLeading: false, bottom: PreferredSize(preferredSize: const Size.fromHeight(36), child: _storageBreadcrumb(context, l.storageAndData))),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          ...groups.entries.map((entry) => Card(
            child: Padding(
              padding: const EdgeInsets.all(12),
              child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                Text(entry.key, style: AppTextStyles.h3),
                ...entry.value.map((label) => ListTile(
                  dense: true,
                  title: Text(label),
                  trailing: Text(formatStorageBytes(c.stats[label] ?? 0)),
                )),
              ]),
            ),
          )),
          OutlinedButton(
            onPressed: () async {
              if (await _confirm(context, '${l.resetStatistics}?')) {
                await ref.read(storageDataProvider).resetStats();
              }
            },
            child: Text(l.resetStatistics),
          ),
          const SizedBox(height: 8),
          Text(l.resetLast(isId ? 'Belum pernah' : 'Never')),
        ],
      ),
    );
  }
}

class QualityScreen extends ConsumerWidget {
  final String title;
  final bool upload;
  const QualityScreen({super.key, required this.title, this.upload = false});
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final controller = ref.watch(storageDataProvider);
    final active = upload ? controller.upload : controller.download;
    final l = AppLocalizations.of(context)!;
    return Scaffold(
      appBar: AppBar(title: Text(title), automaticallyImplyLeading: false, bottom: PreferredSize(preferredSize: const Size.fromHeight(36), child: _storageBreadcrumb(context, l.storageAndData))),
      body: ListView(padding: const EdgeInsets.all(16), children: [
        Text(l.chooseMediaQuality),
        const SizedBox(height: 12),
        _choice(context, ref, l.standard, l.standardQualityDescription, MediaQuality.standard, active, upload),
        _choice(context, ref, 'HD', l.hdQualityDescription, MediaQuality.hd, active, upload),
      ]),
    );
  }
}

Widget _choice(BuildContext context, WidgetRef ref, String title, String description, MediaQuality value, MediaQuality active, bool upload) {
  return Card(
    child: ListTile(
      title: Text(title),
      subtitle: Text(description),
      trailing: value == active ? const Icon(Icons.check, color: AppColors.primaryColor) : null,
      onTap: () {
        if (upload) {
          ref.read(storageDataProvider).setUpload(value);
        } else {
          ref.read(storageDataProvider).setDownload(value);
        }
        Navigator.pop(context);
      },
    ),
  );
}

class AutoDownloadScreen extends ConsumerWidget {
  final String mediaType;
  const AutoDownloadScreen({super.key, required this.mediaType});
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final current = ref.watch(storageDataProvider).auto[mediaType]!;
    final l = AppLocalizations.of(context)!;
    return Scaffold(
      appBar: AppBar(title: Text('${l.automaticMediaDownload}: ${_displayMediaKey(mediaType, l)}'), automaticallyImplyLeading: false, bottom: PreferredSize(preferredSize: const Size.fromHeight(36), child: _storageBreadcrumb(context, l.storageAndData))),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: AutoDownloadPolicy.values.map((policy) => Card(
          child: ListTile(
            title: Text(_policyLabel(policy, l)),
            trailing: policy == current ? const Icon(Icons.check, color: AppColors.primaryColor) : null,
            onTap: () {
              ref.read(storageDataProvider).setAuto(mediaType, policy);
              Navigator.pop(context);
            },
          ),
        )).toList(),
      ),
    );
  }
}

class ProxyScreen extends StatefulWidget { const ProxyScreen({super.key}); @override State<ProxyScreen> createState() => _ProxyPageState(); }
class _ProxyPageState extends State<ProxyScreen> {
  bool enabled = false;
  String? host;
  final secure = const FlutterSecureStorage();
  @override void initState() { super.initState(); _load(); }
  Future<void> _load() async {
    final p = await SharedPreferences.getInstance();
    setState(() {
      enabled = p.getBool('proxy_enabled') ?? false;
      host = p.getString('proxy_host');
    });
  }
  @override Widget build(BuildContext context) {
    final l = AppLocalizations.of(context)!;
    return Scaffold(
      appBar: AppBar(
        title: Text(l.proxy),
        automaticallyImplyLeading: false,
        bottom: PreferredSize(preferredSize: const Size.fromHeight(36), child: _storageBreadcrumb(context, l.storageAndData)),
        actions: [IconButton(onPressed: host == null ? null : () => Share.share('Proxy: $host'), icon: const Icon(Icons.share))],
      ),
      body: ListView(padding: const EdgeInsets.all(16), children: [
        Card(child: SwitchListTile(title: Text(l.useProxy), subtitle: Text(l.proxyWarning), value: enabled, onChanged: host == null ? null : (v) async { final p = await SharedPreferences.getInstance(); await p.setBool('proxy_enabled', v); setState(() => enabled = v); })),
        ListTile(title: Text(host ?? l.noProxyServer), subtitle: Text(host == null ? l.addProxyServer : l.disconnected), trailing: IconButton(icon: const Icon(Icons.add), onPressed: _add)),
        if (host != null) ListTile(title: Text(l.deleteServer), textColor: Colors.red, onTap: () async { await secure.delete(key: 'proxy_password'); final p = await SharedPreferences.getInstance(); await p.remove('proxy_host'); setState(() { host = null; enabled = false; }); }),
      ]),
    );
  }
  Future<void> _add() async {
    final l = AppLocalizations.of(context)!;
    final controller = TextEditingController();
    final value = await showDialog<String>(context: context, builder: (_) => AlertDialog(title: Text(l.proxyServer), content: TextField(controller: controller, decoration: InputDecoration(hintText: l.proxyHostPort)), actions: [TextButton(onPressed: () => Navigator.pop(context), child: Text(l.cancel)), FilledButton(onPressed: () => Navigator.pop(context, controller.text), child: Text(l.save))]));
    if (value == null || value.isEmpty) return;
    final p = await SharedPreferences.getInstance();
    await p.setString('proxy_host', value);
    setState(() => host = value);
  }
}

Widget _autoDownloadPage(String key) {
  final page = switch (key) {
    'Foto' => const PhotoAutoDownloadScreen(),
    'Audio' => const AudioAutoDownloadScreen(),
    'Video' => const VideoAutoDownloadScreen(),
    'Dokumen' => const DocumentAutoDownloadScreen(),
    _ => AutoDownloadScreen(mediaType: key),
  };
  return page;
}

String _policyLabel(AutoDownloadPolicy p, AppLocalizations l) => switch (p) {
  AutoDownloadPolicy.never => l.never,
  AutoDownloadPolicy.wifi => l.wifi,
  AutoDownloadPolicy.wifiAndCellular => l.wifiAndCellular,
};

Future<bool> _confirm(BuildContext context, String text) async {
  final l = AppLocalizations.of(context)!;
  return await showDialog<bool>(
    context: context,
    builder: (_) => AlertDialog(
      title: Text(l.confirm),
      content: Text(text),
      actions: [
        TextButton(onPressed: () => Navigator.pop(context, false), child: Text(l.cancel)),
        FilledButton(onPressed: () => Navigator.pop(context, true), child: Text(l.confirm)),
      ],
    ),
  ) ?? false;
}

String formatStorageBytes(int bytes) {
  if (bytes < 1024) return '$bytes B';
  final units = ['KB', 'MB', 'GB'];
  var value = bytes.toDouble();
  var i = -1;
  while (value >= 1024 && i < units.length - 1) {
    value /= 1024;
    i++;
  }
  return '${value.toStringAsFixed(value >= 10 ? 0 : 1).replaceAll('.', ',')} ${units[i]}';
}

Color _color(int i) => [Colors.blue, Colors.orange, Colors.purple, Colors.green, Colors.red, Colors.teal, Colors.grey][i % 7];

class _DonutPainter extends CustomPainter {
  final int total;
  _DonutPainter(this.total);
  @override
  void paint(Canvas canvas, Size size) {
    final rect = Offset.zero & size;
    final paint = Paint()..style = PaintingStyle.stroke..strokeWidth = 24..strokeCap = StrokeCap.butt;
    final colors = [Colors.blue, Colors.orange, Colors.purple, Colors.green, Colors.red, Colors.teal, Colors.grey];
    for (var i = 0; i < colors.length; i++) {
      paint.color = colors[i];
      canvas.drawArc(rect.deflate(24), -math.pi / 2 + i * math.pi * 2 / 7, math.pi * 2 / 7 - .04, false, paint);
    }
  }
  @override
  bool shouldRepaint(covariant _DonutPainter oldDelegate) => oldDelegate.total != total;
}
