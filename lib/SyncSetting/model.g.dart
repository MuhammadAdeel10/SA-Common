// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

SyncSettingModel _$SyncSettingModelFromJson(Map<String, dynamic> json) =>
    SyncSettingModel(
        syncDate: json['syncDate'] == null
            ? null
            : DateTime.parse(json    ['syncDate'] as String),
        // isSync: json['isSync'] as bool,
        isSync: json['isSync'] == 1 ? true : false,
        tableName: json['tableName'] as String? ?? "",
        branchId: json['branchId'] as int? ?? 0,
        companySlug: json['companySlug'] as String? ?? "")
      ..id = json['id'] as int?;

Map<String, dynamic> _$SyncSettingModelToJson(SyncSettingModel instance) =>
    <String, dynamic>{
      'id': instance.id,
      'syncDate': instance.syncDate?.toIso8601String(),
      'isSync': instance.isSync ? 1 : 0,
      //  'isSync': instance.isSync,
      'tableName': instance.tableName,
      'companySlug': instance.companySlug,
      'branchId': instance.branchId,
    };
