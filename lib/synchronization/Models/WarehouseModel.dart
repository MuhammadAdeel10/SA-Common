import 'dart:convert';

import 'package:sa_common/Controller/BaseRepository.dart';

class WarehouseFiled {
  static final String id = 'id';
  static final String companySlug = 'companySlug';
  static final String name = 'name';
  static final String address1 = 'address1';
  static final String address2 = 'address2';
  static final String city = 'city';
  static final String state = 'state';
  static final String zip = 'zip';
  static final String countryId = 'countryId';
  static final String contactPerson = 'contactPerson';
  static final String email = 'email';
  static final String phone = 'phone';
  static final String fax = 'fax';
  static final String isDefault = 'isDefault';
  static final String isTransit = 'isTransit';
  static final String isActive = 'isActive';
  static final String branchId = 'branchId';
  static final String updatedOn = 'updatedOn';
  static final String isSync = 'isSync';
}

class Warehouse extends BaseModel<int> {
  @override
  int? id;
  @override
  String? companySlug;
  String? name;
  String? address1;
  String? address2;
  String? city;
  String? state;
  String? zip;
  dynamic countryId;
  String? contactPerson;
  String? email;
  String? phone;
  String? fax;
  bool? isDefault;
  bool? isTransit;
  bool? isActive;
  int? branchId;
  DateTime? updatedOn;
  bool isSync;

  Warehouse({
    this.name,
    this.address1,
    this.address2,
    this.city,
    this.state,
    this.zip,
    this.countryId,
    this.contactPerson,
    this.email,
    this.phone,
    this.fax,
    this.isDefault,
    this.isTransit,
    this.isActive,
    this.branchId,
    this.updatedOn,
    this.id,
    this.companySlug,
    this.isSync = false,
  });

  factory Warehouse.fromMap(Map<String, dynamic> json, {String? slug}) => Warehouse(
        name: json["name"],
        address1: json["address1"],
        address2: json["address2"],
        city: json["city"],
        state: json["state"],
        zip: json["zip"],
        countryId: json["countryId"],
        isSync: (json['isSync'] == 0 || json['isSync'] == false) ? false : true,
        contactPerson: json["contactPerson"],
        email: json["email"],
        phone: json["phone"],
        fax: json["fax"],
        isDefault: json["isDefault"],
        isTransit: json["isTransit"],
        isActive: json["isActive"],
        branchId: json["branchId"],
        updatedOn: json["updatedOn"] == null ? null : DateTime.parse(json["updatedOn"]),
        id: json["id"],
        companySlug: slug,
      );

  Map<String, dynamic> toMap() => {
        "name": name,
        "address1": address1,
        "address2": address2,
        "city": city,
        "state": state,
        "zip": zip,
        "countryId": countryId,
        'isSync': isSync == true ? 1 : 0,
        "contactPerson": contactPerson,
        "email": email,
        "phone": phone,
        "fax": fax,
        "isDefault": isDefault,
        "isTransit": isTransit,
        "isActive": isActive,
        "branchId": branchId,
        "updatedOn": updatedOn?.toIso8601String(),
        "id": id,
        "companySlug": companySlug,
      };
  @override
  BaseModel fromJson(Map<String, dynamic> json, {String? slug}) {
    return Warehouse.fromMap(json, slug: slug);
  }

  @override
  Map<String, dynamic> toJson() {
    return toMap();
  }

  List<Warehouse> FromJson(String str, String slug) => List<Warehouse>.from(json.decode(str).map((x) => Warehouse().fromJson(x, slug: slug)));

  String ToJson(List<Warehouse> data) => json.encode(List<dynamic>.from(data.map((x) => x.toJson())));
}
