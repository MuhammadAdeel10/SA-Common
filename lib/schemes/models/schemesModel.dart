import 'dart:convert';

import 'package:sa_common/Controller/BaseRepository.dart';

class SchemesField {
  static final String id = 'id';
  static final String companySlug = 'companySlug';
  static final String isSync = 'isSync';
  static final String syncDate = 'syncDate';
  static final String updatedOn = 'updatedOn';
  static final String series = 'series';
  static final String number = 'number';
  static final String name = 'name';
  static final String schemeTypeId = 'schemeTypeId';
  static final String startDate = 'startDate';
  static final String endDate = 'endDate';
  static final String startTime = 'startTime';
  static final String endTime = 'endTime';
  static final String dayTypeId = 'dayTypeId';
  static final String reference = 'reference';
  static final String dayType = 'dayType';
  static final String status = 'status';
  static final String isActive = 'isActive';
  static final String discountId = 'discountId';
  static final String discountApplyOn = 'discountApplyOn';
  static final String enableMRPTax = 'enableMRPTax';
  static final String weekDays = 'weekDays';
  static final String isTimeSensitiveScheme = 'isTimeSensitiveScheme';
}

class SchemesModel extends BaseModel<int> {
  @override
  int? id;
  @override
  String? companySlug;
  bool isSync;
  DateTime? syncDate;
  DateTime? updatedOn;
  String? series;
  String? number;
  String? name;
  int? schemeTypeId;
  DateTime? startDate;
  DateTime? endDate;
  DateTime? startTime;
  DateTime? endTime;
  int? dayTypeId;
  String? reference;
  int? dayType;
  int? status;
  bool isActive;
  int? discountId;
  int? discountApplyOn;
  bool? enableMRPTax;
  String? weekDays;
  bool isTimeSensitiveScheme;

  SchemesModel(
      {this.id,
      this.companySlug,
      this.series,
      this.number,
      this.name,
      this.schemeTypeId,
      this.startDate,
      this.endDate,
      this.startTime,
      this.endTime,
      this.dayTypeId,
      this.reference,
      this.dayType,
      this.status,
      this.isActive = false,
      this.discountId,
      this.discountApplyOn,
      this.enableMRPTax,
      this.weekDays,
      this.updatedOn,
      this.isSync = false,
      this.syncDate,
      this.isTimeSensitiveScheme = false});

  SchemesModel copyWith({
    int? id,
    String? companySlug,
    String? series,
    String? number,
    String? name,
    int? schemeTypeId,
    DateTime? startDate,
    DateTime? endDate,
    DateTime? startTime,
    DateTime? endTime,
    int? dayTypeId,
    String? reference,
    int? dayType,
    int? status,
    bool? isActive,
    int? discountId,
    int? discountApplyOn,
    bool? enableMRPTax,
    String? weekDays,
    DateTime? updatedOn,
    bool? isSync,
    DateTime? syncDate,
  }) {
    return SchemesModel(
      id: id ?? this.id,
      companySlug: companySlug ?? this.companySlug,
      series: series ?? this.series,
      number: number ?? this.number,
      name: name ?? this.name,
      schemeTypeId: schemeTypeId ?? this.schemeTypeId,
      startDate: startDate ?? this.startDate,
      endDate: endDate ?? this.endDate,
      startTime: startTime ?? this.startTime,
      endTime: endTime ?? this.endTime,
      dayTypeId: dayTypeId ?? this.dayTypeId,
      reference: reference ?? this.reference,
      dayType: dayType ?? this.dayType,
      status: status ?? this.status,
      isActive: isActive ?? this.isActive,
      discountId: discountId ?? this.discountId,
      discountApplyOn: discountApplyOn ?? this.discountApplyOn,
      enableMRPTax: enableMRPTax ?? this.enableMRPTax,
      weekDays: weekDays ?? this.weekDays,
      updatedOn: updatedOn ?? this.updatedOn,
      isSync: isSync ?? this.isSync,
      syncDate: syncDate ?? this.syncDate,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'companySlug': companySlug,
      'series': series,
      'number': number,
      'name': name,
      'schemeTypeId': schemeTypeId,
      'startDate': startDate?.toIso8601String(),
      'endDate': endDate != null ? endDate?.toIso8601String() : null,
      'startTime': startTime?.toIso8601String(),
      'endTime': endTime?.toIso8601String(),
      'dayTypeId': dayTypeId,
      'reference': reference,
      'dayType': dayType,
      'status': status,
      'isActive': isActive == true ? 1 : 0,
      'discountId': discountId,
      'discountApplyOn': discountApplyOn,
      'enableMRPTax': enableMRPTax == true ? 1 : 0,
      'isTimeSensitiveScheme': isTimeSensitiveScheme == true ? 1 : 0,
      'weekDays': weekDays,
      'updatedOn': updatedOn?.toIso8601String(),
      'isSync': isSync == true ? 1 : 0,
      'syncDate': syncDate?.toIso8601String(),
    };
  }

  factory SchemesModel.fromMap(Map<String, dynamic> map, {String? slug}) {
    return SchemesModel(
      id: map['id']?.toInt(),
      companySlug: slug ?? map['companySlug'],
      series: map['series'],
      number: map['number'],
      name: map['name'],
      schemeTypeId: map['schemeTypeId']?.toInt(),
      startDate:
          map['startDate'] != null ? DateTime.parse(map['startDate']) : null,
      endDate: map['endDate'] != null ? DateTime.parse(map['endDate']) : null,
      startTime: map['startTime'] != null ? DateTime.parse(map['startTime']) : null,
      endTime: map['endTime'] != null ? DateTime.parse(map['endTime']) : null,
      dayTypeId: map['dayTypeId']?.toInt(),
      reference: map['reference'],
      dayType: map['dayType']?.toInt(),
      status: map['status']?.toInt(),
      isActive:
          (map['isActive'] == 0 || map['isActive'] == false) ? false : true,
      isTimeSensitiveScheme: (map['isTimeSensitiveScheme'] == 0 ||
              map['isTimeSensitiveScheme'] == false)
          ? false
          : true,
      discountId: map['discountId']?.toInt(),
      discountApplyOn: map['discountApplyOn']?.toInt(),
      enableMRPTax: (map['enableMRPTax'] == 0 || map['enableMRPTax'] == false)
          ? false
          : true,
      weekDays: map['weekDays'],
      updatedOn:
          map['updatedOn'] != null ? DateTime.parse(map['updatedOn']) : null,
      isSync: (map['isSync'] == 0 || map['isSync'] == false) ? false : true,
      syncDate:
          map['syncDate'] != null ? DateTime.parse(map['syncDate']) : null,
    );
  }
  @override
  String toString() {
    return 'SchemesModel(id: $id, companySlug: $companySlug, series: $series, number: $number, name: $name, schemeTypeId: $schemeTypeId, startDate: $startDate, endDate: $endDate, startTime: $startTime, endTime: $endTime, dayTypeId: $dayTypeId, reference: $reference, dayType: $dayType, status: $status, isActive: $isActive, discountId: $discountId, discountApplyOn: $discountApplyOn, enableMRPTax: $enableMRPTax, weekDays: $weekDays, updatedOn: $updatedOn, isSync: $isSync, syncDate: $syncDate)';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is SchemesModel &&
        other.id == id &&
        other.companySlug == companySlug &&
        other.series == series &&
        other.number == number &&
        other.name == name &&
        other.schemeTypeId == schemeTypeId &&
        other.startDate == startDate &&
        other.endDate == endDate &&
        other.startTime == startTime &&
        other.endTime == endTime &&
        other.dayTypeId == dayTypeId &&
        other.reference == reference &&
        other.dayType == dayType &&
        other.status == status &&
        other.isActive == isActive &&
        other.discountId == discountId &&
        other.discountApplyOn == discountApplyOn &&
        other.enableMRPTax == enableMRPTax &&
        other.weekDays == weekDays &&
        other.updatedOn == updatedOn &&
        other.isSync == isSync &&
        other.syncDate == syncDate;
  }

  @override
  int get hashCode {
    return id.hashCode ^
        companySlug.hashCode ^
        series.hashCode ^
        number.hashCode ^
        name.hashCode ^
        schemeTypeId.hashCode ^
        startDate.hashCode ^
        endDate.hashCode ^
        startTime.hashCode ^
        endTime.hashCode ^
        dayTypeId.hashCode ^
        reference.hashCode ^
        dayType.hashCode ^
        status.hashCode ^
        isActive.hashCode ^
        discountId.hashCode ^
        discountApplyOn.hashCode ^
        enableMRPTax.hashCode ^
        weekDays.hashCode ^
        updatedOn.hashCode ^
        isSync.hashCode ^
        syncDate.hashCode;
  }

  @override
  BaseModel fromJson(Map<String, dynamic> json, {String? slug}) {
    return SchemesModel.fromMap(json, slug: slug);
  }

  @override
  Map<String, dynamic> toJson() {
    return toMap();
  }

  List<SchemesModel> FromJson(String str, String slug) =>
      List<SchemesModel>.from(
          json.decode(str).map((x) => SchemesModel().fromJson(x, slug: slug)));

  String ToJson(List<SchemesModel> data) =>
      json.encode(List<dynamic>.from(data.map((x) => x.toJson())));
}
