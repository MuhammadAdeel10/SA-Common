import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:sa_common/schemes/models/schemeCustomerCategoriesModel.dart';
import 'package:sa_common/schemes/models/schemeDetailsModel.dart';
import 'package:sa_common/schemes/models/schemeSalesGeographyModel.dart';
import 'SchemeBranchesModel.dart';

class SchemeGetModel {
  int? id;
  String? companySlug;
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
  List<DetailsSchemesModel>? schemeDetails;
  List<BranchesSchemesModel>? linkedBranches;
  List<CustomerCategoriesSchemesModel>? linkedCustomerCategories;
  List<SalesGeographySchemesModel>? schemeSalesGeography;
  bool isTimeSensitiveScheme;

  SchemeGetModel(
      {this.id,
      this.companySlug,
      this.updatedOn,
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
      this.schemeDetails,
      this.linkedBranches,
      this.linkedCustomerCategories,
      this.schemeSalesGeography,
      this.isTimeSensitiveScheme = false});

  SchemeGetModel copyWith({
    int? id,
    String? companySlug,
    DateTime? updatedOn,
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
    List<DetailsSchemesModel>? schemeDetails,
    List<BranchesSchemesModel>? linkedBranches,
    List<CustomerCategoriesSchemesModel>? linkedCustomerCategories,
    List<SalesGeographySchemesModel>? schemeSalesGeography,
  }) {
    return SchemeGetModel(
      id: id ?? this.id,
      companySlug: companySlug ?? this.companySlug,
      updatedOn: updatedOn ?? this.updatedOn,
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
      schemeDetails: schemeDetails ?? this.schemeDetails,
      linkedBranches: linkedBranches ?? this.linkedBranches,
      linkedCustomerCategories:
          linkedCustomerCategories ?? this.linkedCustomerCategories,
      schemeSalesGeography: schemeSalesGeography ?? this.schemeSalesGeography,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'companySlug': companySlug,
      'updatedOn': updatedOn?.toIso8601String(),
      'series': series,
      'number': number,
      'name': name,
      'schemeTypeId': schemeTypeId,
      'startDate': startDate?.toIso8601String(),
      'endDate': endDate?.toIso8601String(),
      'startTime': startTime?.toIso8601String(),
      'endTime': endTime?.toIso8601String(),
      'dayTypeId': dayTypeId,
      'reference': reference,
      'dayType': dayType,
      'status': status,
      'isActive': isActive,
      'discountId': discountId,
      'discountApplyOn': discountApplyOn,
      'enableMRPTax': enableMRPTax,
      'weekDays': weekDays,
      'schemeDetails': schemeDetails?.map((x) => x.toMap()).toList(),
      'linkedBranches': linkedBranches?.map((x) => x.toMap()).toList(),
      'linkedCustomerCategories':
          linkedCustomerCategories?.map((x) => x.toMap()).toList(),
      'schemeSalesGeography':
          schemeSalesGeography?.map((x) => x.toMap()).toList(),
      'isTimeSensitiveScheme': isTimeSensitiveScheme == true ? 1 : 0,
    };
  }

  factory SchemeGetModel.fromMap(Map<String, dynamic> map, {String? slug}) {
    return SchemeGetModel(
      id: map['id']?.toInt(),
      companySlug: slug ?? map['companySlug'],
      updatedOn:
          map['updatedOn'] != null ? DateTime.parse(map['updatedOn']) : null,
      series: map['series'],
      number: map['number'],
      name: map['name'],
      schemeTypeId: map['schemeTypeId']?.toInt(),
      startDate:
          map['startDate'] != null ? DateTime.parse(map['startDate']) : null,
      endDate: map['endDate'] != null ? DateTime.parse(map['endDate']) : null,
      startTime:
          map['startTime'] != null ? DateTime.parse(map['startTime']) : null,
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
      enableMRPTax: map['enableMRPTax'],
      weekDays: map['weekDays'],
      schemeDetails: map['schemeDetails'] != null
          ? List<DetailsSchemesModel>.from(
              map['schemeDetails']?.map((x) => DetailsSchemesModel.fromMap(
                    x,
                  )))
          : null,
      linkedBranches: map['linkedBranches'] != null
          ? List<BranchesSchemesModel>.from(map['linkedBranches']
              ?.map((x) => BranchesSchemesModel.fromMap(x)))
          : null,
      linkedCustomerCategories: map['linkedCustomerCategories'] != null
          ? List<CustomerCategoriesSchemesModel>.from(
              map['linkedCustomerCategories']
                  ?.map((x) => CustomerCategoriesSchemesModel.fromMap(x)))
          : null,
      schemeSalesGeography: map['schemeSalesGeography'] != null
          ? List<SalesGeographySchemesModel>.from(map['schemeSalesGeography']
              ?.map((x) => SalesGeographySchemesModel.fromMap(x)))
          : null,
    );
  }

  String toJson() => json.encode(toMap());

  factory SchemeGetModel.fromJson(String source, {String? slug}) =>
      SchemeGetModel.fromMap(
          json.decode(
            source,
          ),
          slug: slug);

  @override
  String toString() {
    return 'SchemeGetModel(id: $id, companySlug: $companySlug, updatedOn: $updatedOn, series: $series, number: $number, name: $name, schemeTypeId: $schemeTypeId, startDate: $startDate, endDate: $endDate, startTime: $startTime, endTime: $endTime, dayTypeId: $dayTypeId, reference: $reference, dayType: $dayType, status: $status, isActive: $isActive, discountId: $discountId, discountApplyOn: $discountApplyOn, enableMRPTax: $enableMRPTax, weekDays: $weekDays, schemeDetails: $schemeDetails, linkedBranches: $linkedBranches, linkedCustomerCategories: $linkedCustomerCategories, schemeSalesGeography: $schemeSalesGeography)';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is SchemeGetModel &&
        other.id == id &&
        other.companySlug == companySlug &&
        other.updatedOn == updatedOn &&
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
        listEquals(other.schemeDetails, schemeDetails) &&
        listEquals(other.linkedBranches, linkedBranches) &&
        listEquals(other.linkedCustomerCategories, linkedCustomerCategories) &&
        listEquals(other.schemeSalesGeography, schemeSalesGeography);
  }

  @override
  int get hashCode {
    return id.hashCode ^
        companySlug.hashCode ^
        updatedOn.hashCode ^
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
        schemeDetails.hashCode ^
        linkedBranches.hashCode ^
        linkedCustomerCategories.hashCode ^
        schemeSalesGeography.hashCode;
  }
}
