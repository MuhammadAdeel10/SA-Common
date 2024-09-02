import 'dart:convert';

import 'package:sa_common/Controller/BaseRepository.dart';

class SalesPersonFiles {
  static final String id = 'id';
  static final String name = 'name';
  static final String companySlug = 'companySlug';
  static final String isSync = 'isSync';
  static final String syncDate = 'syncDate';
  static final String isOrderBooker = 'isOrderBooker';
  static final String isDeliveryPerson = 'isDeliveryPerson';
  static final String isSalesman = 'isSalesman';
  static final String CanChangePrice = 'canChangePrice';
  static final String CanAddDiscount = 'canAddDiscount';
  static final String applicationUserId = 'applicationUserId';
  static final String cashAccountId = 'cashAccountId';
  static final String receiveMoneySeries = 'receiveMoneySeries';
  static final String saleOrderSeries = 'saleOrderSeries';
  static final String isActive = 'isActive';
  static final String branchId = 'branchId';
}
mixin  DropDown{ 
abstract String name;
}
class SalesPersonModel extends BaseModel<int> with DropDown  {
  @override
  int? id;
  @override
  String? companySlug;
  @override
  String name;
  bool isOrderBooker;
  bool isDeliveryPerson;
  bool isSalesman;
  bool CanChangePrice;
  bool CanAddDiscount;
  String applicationUserId;
  int? cashAccountId;
  String receiveMoneySeries;
  String saleOrderSeries;
  bool isSync;
  DateTime? syncDate;
  bool isActive;
  int? branchId;
  SalesPersonModel({this.id, this.companySlug, this.name = "", this.isOrderBooker = false, this.isDeliveryPerson = false, this.isSalesman = false, this.CanChangePrice = false, this.CanAddDiscount = false, this.applicationUserId = "", this.cashAccountId, this.receiveMoneySeries = "", this.saleOrderSeries = "", this.isSync = false, this.syncDate, this.isActive = true, this.branchId});

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'companySlug': companySlug,
      'name': name,
      'isOrderBooker': isOrderBooker,
      'isDeliveryPerson': isDeliveryPerson == true ? 1 : 0,
      'isSalesman': isSalesman == true ? 1 : 0,
      'canChangePrice': CanChangePrice == true ? 1 : 0,
      'canAddDiscount': CanAddDiscount == true ? 1 : 0,
      'applicationUserId': applicationUserId,
      'cashAccountId': cashAccountId,
      'receiveMoneySeries': receiveMoneySeries,
      'saleOrderSeries': saleOrderSeries,
      'isSync': isSync == true ? 1 : 0,
      'syncDate': syncDate?.toIso8601String(),
      'isActive': isActive == false ? 0 : 1,
      'branchId': branchId
    };
  }

  factory SalesPersonModel.fromMap(Map<String, dynamic> map, {String? slug}) {
    return SalesPersonModel(
      id: map['id']?.toInt(),
      companySlug: slug ?? map['companySlug'],
      name: map['name'] ?? '',
      isOrderBooker: (map['isOrderBooker'] == 0 || map['isOrderBooker'] == false) ? false : true,
      isDeliveryPerson: (map['isDeliveryPerson'] == 0 || map['isDeliveryPerson'] == false) ? false : true,
      isSalesman: (map['isSalesman'] == 0 || map['isSalesman'] == false) ? false : true,
      CanChangePrice: (map['canChangePrice'] == 0 || map['canChangePrice'] == false) ? false : true,
      CanAddDiscount: (map['canAddDiscount'] == 0 || map['canAddDiscount'] == false) ? false : true,
      applicationUserId: map['applicationUserId'] ?? '',
      cashAccountId: map['cashAccountId']?.toInt(),
      receiveMoneySeries: map['receiveMoneySeries'] ?? '',
      saleOrderSeries: map['saleOrderSeries'] ?? '',
      isSync: (map['isSync'] == 0 || map['isSync'] == false) ? false : true,
      syncDate: map['syncDate'] != null ? DateTime.parse(map['syncDate']) : null,
      isActive: (map['isActive'] == 0 || map['isActive'] == false) ? false : true,
      branchId: map['branchId']?.toInt(),
    );
  }

  @override
  BaseModel fromJson(Map<String, dynamic> json, {String? slug}) {
    return SalesPersonModel.fromMap(json, slug: slug);
  }

  @override
  Map<String, dynamic> toJson() {
    return toMap();
  }

  List<SalesPersonModel> FromJson(String str, String slug) => List<SalesPersonModel>.from(json.decode(str).map((x) => SalesPersonModel().fromJson(x, slug: slug)));

  String ToJson(List<SalesPersonModel> data) => json.encode(List<dynamic>.from(data.map((x) => x.toJson())));
}
