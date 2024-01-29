import 'dart:convert';
import 'package:sa_common/Controller/BaseRepository.dart';

class TaxFields {
  static final String id = 'id';
  static final String name = 'name';
  static final String abbreviation = 'abbreviation';
  static final String rate = 'rate';
  static final String $in = 'in';
  static final String accountInId = 'accountInId';
  static final String out = 'out';
  static final String accountOutId = 'accountOutId';
  static final String isActive = 'isActive';
  static final String updatedOn = 'updatedOn';
  static final String companySlug = 'companySlug';
}

class TaxModel extends BaseModel<int> {
  // {
  //     "name": "GST",
  //     "abbreviation": "GST",
  //     "rate": 17.000000,
  //     "in": true,
  //     "accountInId": 252392,
  //     "out": true,
  //     "accountOutId": 252350,
  //     "isActive": false,
  //     "updatedOn": "2020-06-19T05:12:01.7689922Z",
  //     "id": 3335
  // }
  @override
  int? id;

  String name;
  String abbreviation;
  num rate;
  bool $in;
  int? accountInId;
  bool out;
  int? accountOutId;
  bool isActive;
  DateTime? updatedOn;
  String? companySlug;
  TaxModel(
      {this.name = "",
      this.abbreviation = "",
      this.rate = 0.00,
      this.$in = false,
      this.accountInId,
      this.out = false,
      this.accountOutId,
      this.isActive = true,
      this.updatedOn,
      this.companySlug = "",
      this.id});

  TaxModel copyWith(
      {int? id,
      String? name,
      String? abbreviation,
      double? rate,
      bool? $in,
      int? accountInId,
      bool? out,
      int? accountOutId,
      bool? isActive,
      DateTime? updatedOn,
      String? companySlug}) {
    return TaxModel(
        name: name ?? this.name,
        abbreviation: abbreviation ?? this.abbreviation,
        rate: rate ?? this.rate,
        $in: $in ?? this.$in,
        accountInId: accountInId ?? this.accountInId,
        out: out ?? this.out,
        accountOutId: accountOutId ?? this.accountOutId,
        isActive: isActive ?? this.isActive,
        updatedOn: updatedOn ?? this.updatedOn,
        companySlug: companySlug ?? this.companySlug);
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
      'abbreviation': abbreviation,
      'rate': rate,
      'in': $in == true ? 1 : 0,
      'accountInId': accountInId,
      'out': out == true ? 1 : 0,
      'accountOutId': accountOutId,
      'isActive': isActive == true ? 1 : 0,
      'updatedOn': updatedOn?.toIso8601String(),
      'companySlug': companySlug
    };
  }

  factory TaxModel.fromMap(Map<String, dynamic> map, {String? slug}) {
    return TaxModel(
        id: map['id'] ?? 0,
        name: map['name'] ?? '',
        abbreviation: map['abbreviation'] ?? '',
        rate: map['rate']?.toDouble() ?? 0.0,
        $in: (map['in'] == 0 || map['in'] == false) ? false : true,
        accountInId: map['accountInId']?.toInt(),
        out: (map['out'] == 0 || map['out'] == false) ? false : true,
        accountOutId: map['accountOutId']?.toInt(),
        isActive:
            (map['isActive'] == 0 || map['isActive'] == false) ? false : true,
        updatedOn: map['updatedOn'] == null
            ? null
            : DateTime.parse(map['updatedOn'] as String),
        companySlug: slug ?? '');
  }

  // String toJson() => json.encode(toMap());

  // factory TaxModel.fromJson(String source) =>
  //     TaxModel.fromMap(json.decode(source));

  @override
  String toString() {
    return 'TaxModel(id: $id, name: $name, abbreviation: $abbreviation, rate: $rate,accountInId: $accountInId, out: $out, accountOutId: $accountOutId, isActive: $isActive, updatedOn: $updatedOn)';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is TaxModel &&
        other.id == id &&
        other.name == name &&
        other.abbreviation == abbreviation &&
        other.rate == rate &&
        other.$in == $in &&
        other.accountInId == accountInId &&
        other.out == out &&
        other.accountOutId == accountOutId &&
        other.isActive == isActive &&
        other.updatedOn == updatedOn;
  }

  @override
  int get hashCode {
    return id.hashCode ^
        name.hashCode ^
        abbreviation.hashCode ^
        rate.hashCode ^
        $in.hashCode ^
        accountInId.hashCode ^
        out.hashCode ^
        accountOutId.hashCode ^
        isActive.hashCode ^
        updatedOn.hashCode;
  }

  @override
  BaseModel fromJson(Map<String, dynamic> json, {String? slug}) {
    return TaxModel.fromMap(json, slug: slug);
  }

  @override
  Map<String, dynamic> toJson() {
    return toMap();
  }

  List<TaxModel> FromJson(String str, String slug) => List<TaxModel>.from(
      json.decode(str).map((x) => TaxModel().fromJson(x, slug: slug)));

  String ToJson(List<TaxModel> data) =>
      json.encode(List<dynamic>.from(data.map((x) => x.toJson())));
}
