import 'dart:convert';

import '../../Controller/BaseRepository.dart';
import '../../SalesPerson/model/SalesPersonModel.dart';

class CurrencyField {
  static final String id = 'id';
  static final String name = 'name';
  static final String code = 'code';
  static final String symbol = 'symbol';
  static final String isDefault = 'isDefault';
  static final String companySlug = 'companySlug';
}

class CurrencyModel extends BaseModel<int> with DropDown {
  @override
  int? id;
  String name;
  String code;
  String symbol;
  bool isDefault;
  String? companySlug;
  CurrencyModel({
    this.name = "",
    this.code = "",
    this.symbol = "",
    this.isDefault = false,
    this.companySlug = "",
    this.id,
  });

  CurrencyModel copyWith({
    String? name,
    String? code,
    String? symbol,
    bool? isDefault,
    String? companySlug,
  }) {
    return CurrencyModel(
      name: name ?? this.name,
      code: code ?? this.code,
      symbol: symbol ?? this.symbol,
      isDefault: isDefault ?? this.isDefault,
      companySlug: companySlug ?? this.companySlug,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'name': name,
      'code': code,
      'symbol': symbol,
      'isDefault': isDefault == true ? 1 : 0,
      'companySlug': companySlug,
      'id': id
    };
  }

  factory CurrencyModel.fromMap(Map<String, dynamic> map, {String? slug}) {
    return CurrencyModel(
      name: map['name'] ?? '',
      code: map['code'] ?? '',
      symbol: map['symbol'] ?? '',
      isDefault:
          (map['isDefault'] == 0 || map['isDefault'] == false) ? false : true,
      companySlug: slug ?? '',
      id: map['id'] ?? 0,
    );
  }

  @override
  BaseModel fromJson(Map<String, dynamic> json, {String? slug}) {
    return CurrencyModel.fromMap(json, slug: slug);
  }

  @override
  Map<String, dynamic> toJson() {
    return toMap();
  }

  @override
  String toString() {
    return 'CurrencyModel(name: $name, code: $code, symbol: $symbol, isDefault: $isDefault, companySlug: $companySlug)';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is CurrencyModel &&
        other.name == name &&
        other.code == code &&
        other.symbol == symbol &&
        other.isDefault == isDefault &&
        other.companySlug == companySlug;
  }

  @override
  int get hashCode {
    return name.hashCode ^
        code.hashCode ^
        symbol.hashCode ^
        isDefault.hashCode ^
        companySlug.hashCode;
  }

  List<CurrencyModel> FromJson(String str, String slug) =>
      List<CurrencyModel>.from(
          json.decode(str).map((x) => CurrencyModel().fromJson(x, slug: slug)));

  String ToJson(List<CurrencyModel> data) =>
      json.encode(List<dynamic>.from(data.map((x) => x.toJson())));
}
