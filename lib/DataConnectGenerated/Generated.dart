library DataconnectGenerated;

import 'package:firebase_data_connect/firebase_data_connect.dart';
import 'package:flutter/foundation.dart';
import 'dart:convert';

part './InsertWedding.dart';

part './UpdateWedding.dart';

part './DeleteWedding.dart';

part './GetWedding.dart';

part './ListWeddings.dart';

part './InsertArrangement.dart';

part './UpdateArrangement.dart';

part './DeleteArrangement.dart';

part './GetArrangement.dart';

part './ListArrangements.dart';

part './InsertVenueArea.dart';

part './UpdateVenueArea.dart';

part './DeleteVenueArea.dart';

part './GetVenueArea.dart';

part './ListVenueAreas.dart';

part './InsertFlowerItem.dart';

part './UpdateFlowerItem.dart';

part './DeleteFlowerItem.dart';

part './GetFlowerItem.dart';

part './ListFlowerItems.dart';

part './InsertReferenceImage.dart';

part './UpdateReferenceImage.dart';

part './DeleteReferenceImage.dart';

part './GetReferenceImage.dart';

part './ListReferenceImages.dart';

class ExampleConnector {
  InsertWeddingVariablesBuilder insertWedding() {
    return InsertWeddingVariablesBuilder(dataConnect);
  }

  UpdateWeddingVariablesBuilder updateWedding({required String id}) {
    return UpdateWeddingVariablesBuilder(dataConnect, id: id);
  }

  DeleteWeddingVariablesBuilder deleteWedding({required String id}) {
    return DeleteWeddingVariablesBuilder(dataConnect, id: id);
  }

  GetWeddingVariablesBuilder getWedding({required String id}) {
    return GetWeddingVariablesBuilder(dataConnect, id: id);
  }

  ListWeddingsVariablesBuilder listWeddings() {
    return ListWeddingsVariablesBuilder(dataConnect);
  }

  InsertArrangementVariablesBuilder insertArrangement({
    required String name,
    required String type,
    required String status,
    required String weddingId,
  }) {
    return InsertArrangementVariablesBuilder(
      dataConnect,
      name: name,
      type: type,
      status: status,
      weddingId: weddingId,
    );
  }

  UpdateArrangementVariablesBuilder updateArrangement({required String id}) {
    return UpdateArrangementVariablesBuilder(dataConnect, id: id);
  }

  DeleteArrangementVariablesBuilder deleteArrangement({required String id}) {
    return DeleteArrangementVariablesBuilder(dataConnect, id: id);
  }

  GetArrangementVariablesBuilder getArrangement({required String id}) {
    return GetArrangementVariablesBuilder(dataConnect, id: id);
  }

  ListArrangementsVariablesBuilder listArrangements() {
    return ListArrangementsVariablesBuilder(dataConnect);
  }

  InsertVenueAreaVariablesBuilder insertVenueArea({
    required String name,
    required String weddingId,
  }) {
    return InsertVenueAreaVariablesBuilder(
      dataConnect,
      name: name,
      weddingId: weddingId,
    );
  }

  UpdateVenueAreaVariablesBuilder updateVenueArea({required String id}) {
    return UpdateVenueAreaVariablesBuilder(dataConnect, id: id);
  }

  DeleteVenueAreaVariablesBuilder deleteVenueArea({required String id}) {
    return DeleteVenueAreaVariablesBuilder(dataConnect, id: id);
  }

  GetVenueAreaVariablesBuilder getVenueArea({required String id}) {
    return GetVenueAreaVariablesBuilder(dataConnect, id: id);
  }

  ListVenueAreasVariablesBuilder listVenueAreas() {
    return ListVenueAreasVariablesBuilder(dataConnect);
  }

  InsertFlowerItemVariablesBuilder insertFlowerItem({
    required String name,
    required String color,
    required String arrangementId,
  }) {
    return InsertFlowerItemVariablesBuilder(
      dataConnect,
      name: name,
      color: color,
      arrangementId: arrangementId,
    );
  }

  UpdateFlowerItemVariablesBuilder updateFlowerItem({required String id}) {
    return UpdateFlowerItemVariablesBuilder(dataConnect, id: id);
  }

  DeleteFlowerItemVariablesBuilder deleteFlowerItem({required String id}) {
    return DeleteFlowerItemVariablesBuilder(dataConnect, id: id);
  }

  GetFlowerItemVariablesBuilder getFlowerItem({required String id}) {
    return GetFlowerItemVariablesBuilder(dataConnect, id: id);
  }

  ListFlowerItemsVariablesBuilder listFlowerItems() {
    return ListFlowerItemsVariablesBuilder(dataConnect);
  }

  InsertReferenceImageVariablesBuilder insertReferenceImage({
    required String imageUrl,
    required String description,
    required String weddingId,
  }) {
    return InsertReferenceImageVariablesBuilder(
      dataConnect,
      imageUrl: imageUrl,
      description: description,
      weddingId: weddingId,
    );
  }

  UpdateReferenceImageVariablesBuilder updateReferenceImage({
    required String id,
  }) {
    return UpdateReferenceImageVariablesBuilder(dataConnect, id: id);
  }

  DeleteReferenceImageVariablesBuilder deleteReferenceImage({
    required String id,
  }) {
    return DeleteReferenceImageVariablesBuilder(dataConnect, id: id);
  }

  GetReferenceImageVariablesBuilder getReferenceImage({required String id}) {
    return GetReferenceImageVariablesBuilder(dataConnect, id: id);
  }

  ListReferenceImagesVariablesBuilder listReferenceImages() {
    return ListReferenceImagesVariablesBuilder(dataConnect);
  }

  static ConnectorConfig connectorConfig = ConnectorConfig(
    'us-east4',
    'example',
    'mobileapp',
  );

  ExampleConnector({required this.dataConnect});
  static ExampleConnector get instance {
    CacheSettings cacheSettings = CacheSettings(
      maxAge: Duration(milliseconds: 0),
      storage: CacheStorage.persistent,
    );

    return ExampleConnector(
      dataConnect: FirebaseDataConnect.instanceFor(
        connectorConfig: connectorConfig,

        cacheSettings: cacheSettings,

        sdkType: CallerSDKType.generated,
      ),
    );
  }

  FirebaseDataConnect dataConnect;
}
