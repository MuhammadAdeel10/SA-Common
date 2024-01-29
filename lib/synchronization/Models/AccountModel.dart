import 'dart:convert';

import '../../Controller/BaseRepository.dart';

class AccountField {
  static final String id = 'id';
  static final String code = 'code';
  static final String name = 'name';
  static final String description = 'description';
  static final String accountTypeId = 'accountTypeId';
  static final String includeHomeCurrency = 'includeHomeCurrency';
  static final String accountClass = 'accountClass';
  static final String accountGroupName = 'accountGroupName';
  static final String accountGroup = 'accountGroup';
  static final String systemAccount = 'systemAccount';
  static final String order = 'order';
  static final String currencyId = 'currencyId';
  static final String isActive = 'isActive';
  static final String hide = 'hide';
  static final String companySlug = 'companySlug';
  static final String isSync = 'isSync';
  static final String syncDate = 'syncDate';
}

class AccountModel extends BaseModel<int> {
  @override
  int? id;
  String? code;
  String name;
  String? description;
  int? accountTypeId;
  bool includeHomeCurrency;
  int accountClass;
  int accountGroupName;
  int accountGroup;
  int? systemAccount;
  int order;
  int currencyId;
  bool isActive;
  bool hide;
  String? companySlug;
  bool isSync;
  DateTime? syncDate;
  AccountModel({
    this.id,
    this.code,
    this.name = "",
    this.description,
    this.accountTypeId,
    this.includeHomeCurrency = false,
    this.accountClass = 0,
    this.accountGroupName = 0,
    this.accountGroup = 0,
    this.systemAccount,
    this.order = 0,
    this.currencyId = 0,
    this.isActive = true,
    this.hide = false,
    this.companySlug = "",
    this.isSync = false,
    this.syncDate,
  });

  AccountModel copyWith({
    int? id,
    String? code,
    String? name,
    String? description,
    int? accountTypeId,
    bool? includeHomeCurrency,
    int? accountClass,
    int? accountGroupName,
    int? accountGroup,
    int? systemAccount,
    int? order,
    int? currencyId,
    bool? isActive,
    bool? hide,
    String? companySlug,
    bool? isSync,
    DateTime? syncDate,
  }) {
    return AccountModel(
      id: id ?? this.id,
      code: code ?? this.code,
      name: name ?? this.name,
      description: description ?? this.description,
      accountTypeId: accountTypeId ?? this.accountTypeId,
      includeHomeCurrency: includeHomeCurrency ?? this.includeHomeCurrency,
      accountClass: accountClass ?? this.accountClass,
      accountGroupName: accountGroupName ?? this.accountGroupName,
      accountGroup: accountGroup ?? this.accountGroup,
      systemAccount: systemAccount ?? this.systemAccount,
      order: order ?? this.order,
      currencyId: currencyId ?? this.currencyId,
      isActive: isActive ?? this.isActive,
      hide: hide ?? this.hide,
      companySlug: companySlug ?? this.companySlug,
      isSync: isSync ?? this.isSync,
      syncDate: syncDate ?? this.syncDate,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'code': code,
      'name': name,
      'description': description,
      'accountTypeId': accountTypeId,
      'includeHomeCurrency': includeHomeCurrency == true ? 1 : 0,
      'accountClass': accountClass,
      'accountGroupName': accountGroupName,
      'accountGroup': accountGroup,
      'systemAccount': systemAccount,
      'order': order,
      'currencyId': currencyId,
      'isActive': isActive == true ? 1 : 0,
      'hide': hide == true ? 1 : 0,
      'companySlug': companySlug,
      'isSync': isSync == true ? 1 : 0,
      'syncDate':
          syncDate?.toIso8601String() ?? DateTime.now().toIso8601String(),
    };
  }

  factory AccountModel.fromMap(Map<String, dynamic> map, {String? slug}) {
    return AccountModel(
      id: map['id']?.toInt(),
      code: map['code'],
      name: map['name'] ?? '',
      description: map['description'],
      accountTypeId: map['accountTypeId']?.toInt(),
      includeHomeCurrency: (map['includeHomeCurrency'] == 1 ||
              map['includeHomeCurrency'] == true)
          ? true
          : false,
      accountClass: map['accountClass']?.toInt() ?? 0,
      accountGroupName: map['accountGroupName']?.toInt() ?? 0,
      accountGroup: map['accountGroup']?.toInt() ?? 0,
      systemAccount: map['systemAccount']?.toInt(),
      order: map['order']?.toInt() ?? 0,
      currencyId: map['currencyId']?.toInt() ?? 0,
      isActive:
          (map['isActive'] == 1 || map['isActive'] == true) ? true : false,
      hide: (map['hide'] == 1 || map['hide'] == true) ? true : false,
      companySlug: slug ?? '',
      isSync:
          (map['isSync'] == 1 || map['isSync'] == true || map['isSync'] == null)
              ? true
              : false,
      syncDate:
          map['syncDate'] != null ? DateTime.parse(map['syncDate']) : null,
    );
  }

  @override
  BaseModel fromJson(Map<String, dynamic> json, {String? slug}) {
    return AccountModel.fromMap(json, slug: slug);
  }

  @override
  Map<String, dynamic> toJson() {
    return toMap();
  }

  @override
  String toString() {
    return 'AccountModel(id: $id, code: $code, name: $name, description: $description, accountTypeId: $accountTypeId, includeHomeCurrency: $includeHomeCurrency, accountClass: $accountClass, accountGroupName: $accountGroupName, accountGroup: $accountGroup, systemAccount: $systemAccount, order: $order, currencyId: $currencyId, isActive: $isActive, hide: $hide, companySlug: $companySlug, isSync: $isSync, syncDate: $syncDate)';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is AccountModel &&
        other.id == id &&
        other.code == code &&
        other.name == name &&
        other.description == description &&
        other.accountTypeId == accountTypeId &&
        other.includeHomeCurrency == includeHomeCurrency &&
        other.accountClass == accountClass &&
        other.accountGroupName == accountGroupName &&
        other.accountGroup == accountGroup &&
        other.systemAccount == systemAccount &&
        other.order == order &&
        other.currencyId == currencyId &&
        other.isActive == isActive &&
        other.hide == hide &&
        other.companySlug == companySlug &&
        other.isSync == isSync &&
        other.syncDate == syncDate;
  }

  @override
  int get hashCode {
    return id.hashCode ^
        code.hashCode ^
        name.hashCode ^
        description.hashCode ^
        accountTypeId.hashCode ^
        includeHomeCurrency.hashCode ^
        accountClass.hashCode ^
        accountGroupName.hashCode ^
        accountGroup.hashCode ^
        systemAccount.hashCode ^
        order.hashCode ^
        currencyId.hashCode ^
        isActive.hashCode ^
        hide.hashCode ^
        companySlug.hashCode ^
        isSync.hashCode ^
        syncDate.hashCode;
  }

  List<AccountModel> FromJson(String str, String slug) =>
      List<AccountModel>.from(
          json.decode(str).map((x) => AccountModel().fromJson(x, slug: slug)));

  String ToJson(List<AccountModel> data) =>
      json.encode(List<dynamic>.from(data.map((x) => x.toJson())));
}
