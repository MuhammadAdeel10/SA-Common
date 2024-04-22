import 'dart:convert';

import '../../Controller/BaseRepository.dart';

class UnitFields {
  static final String id = 'id';
  static final String name = 'name';
  static final String symbol = 'symbol';
  static final String measure = 'measure';
  static final String active = 'active';
}

class UnitModel extends BaseModel {
  String name;
  String symbol;
  int measure;
  bool active;
  UnitModel({
    this.name = "",
    this.symbol = "",
    this.measure = 0,
    this.active = true,
  });

  UnitModel copyWith({
    String? name,
    String? symbol,
    int? measure,
    bool? active,
  }) {
    return UnitModel(
      name: name ?? this.name,
      symbol: symbol ?? this.symbol,
      measure: measure ?? this.measure,
      active: active ?? this.active,
    );
  }

  @override
  Map<String, dynamic> toJson() {
    return {
      'name': name,
      'symbol': symbol,
      'measure': measure,
      'active': active == true ? 1 : false,
    };
  }

  @override
  BaseModel fromJson(Map<String, dynamic> map, {String? slug}) {
    return UnitModel(
      name: map['name'] ?? '',
      symbol: map['symbol'] ?? '',
      measure: map['measure']?.toInt() ?? 0,
      active: (map['active'] == 0 || map['active'] == false) ? false : true,
    );
  }

  // factory UnitModel.fromJson(String source) =>
  //     UnitModel.fromMap(json.decode(source));

  @override
  String toString() {
    return 'UnitModel(name: $name, symbol: $symbol, measure: $measure, active: $active)';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is UnitModel && other.name == name && other.symbol == symbol && other.measure == measure && other.active == active;
  }

  @override
  int get hashCode {
    return name.hashCode ^ symbol.hashCode ^ measure.hashCode ^ active.hashCode;
  }

  List<UnitModel> FromJson(String str) => List<UnitModel>.from(json.decode(str).map((x) => UnitModel().fromJson(x)));

  String ToJson(List<UnitModel> data) => json.encode(List<dynamic>.from(data.map((x) => x.toJson())));
}
