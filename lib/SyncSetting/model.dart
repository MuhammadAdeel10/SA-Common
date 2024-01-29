// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:json_annotation/json_annotation.dart';
import 'package:sa_common/Controller/BaseRepository.dart';
part 'model.g.dart';

class SyncSettingFields {
  static final String id = 'id';
  static final String tableName = 'tableName';
  static final String IsSync = 'isSync';
  static final String SyncDate = 'syncDate';
  static final String companySlug = 'companySlug';
  static final String branchId = 'branchId';
}

@JsonSerializable()
class SyncSettingModel extends BaseModel<int> {
  @override
  int? id;
  DateTime? syncDate;
  bool isSync;
  String tableName;
  String? companySlug;
  int? branchId;

  SyncSettingModel(
      {this.syncDate,
      this.isSync = false,
      this.tableName = "",
      this.companySlug = "",
      this.id,
      this.branchId});
  SyncSettingModel copy(
          {int? id,
          DateTime? syncDate,
          bool? isSync,
          String? tableName,
          String? companySlug,
          int? branchId}) =>
      SyncSettingModel(
        id: id ?? this.id,
        syncDate: syncDate ?? this.syncDate,
        tableName: tableName ?? this.tableName,
        companySlug: companySlug ?? this.companySlug,
        isSync: isSync ?? this.isSync,
        branchId: branchId ?? this.branchId,
      );
  @override
  Map<String, dynamic> toJson() => _$SyncSettingModelToJson(this);

  @override
  BaseModel fromJson(Map<String, dynamic> json, {String? slug}) {
    return _$SyncSettingModelFromJson(json);
  }
}
