import 'dart:convert';

import 'package:sa_common/schemes/models/SubAreasModel.dart';

import '../../Controller/BaseRepository.dart';
import '../../SalesPerson/model/SalesPersonModel.dart';

class CustomerFields {
  static final String id = 'id';
  static final String idTemp = 'idTemp';
  static final String name = 'name';
  static final String base64ImageString = 'base64ImageString';
  static final String imageUrl = 'imageUrl';
  static final String code = 'code';
  static final String series = 'series';
  static final String contactType = 'contactType';
  static final String customerCategoryId = 'customerCategoryId';
  static final String categoryName = 'categoryName';
  static final String countryId = 'countryId';
  static final String CurrencyId = 'currencyId';
  static final String companySlug = 'companySlug';
  static final String address1 = 'address1';
  static final String address2 = 'address2';
  static final String city = 'city';
  static final String contactPerson = 'contactPerson';
  static final String phone = 'phone';
  static final String fax = 'fax';
  static final String opening = 'opening';
  static final String asOfDate = 'asOfDate';
  static final String creditLimit = 'creditLimit';
  static final String creditLimitDays = 'creditLimitDays';
  static final String displayName = 'displayName';
  static final String printName = 'printName';
  static final String cNIC = 'cNIC';
  static final String outstandingBalance = 'outstandingBalance';
  static final String dateOfBirth = 'dateOfBirth';
  static final String sTN = 'sTN';
  static final String exchangeRate = 'exchangeRate';
  static final String isSync = 'isSync';
  static final String isNew = 'isNew';
  static final String isEdit = 'isEdit';
  static final String isDeleted = 'isDeleted';
  static final String discountInPercent = 'discountInPercent';
  static final String syncDate = 'syncDate';
  static final String insertedDate = 'insertedDate';
  static final String isActive = 'isActive';
  static final String textField2Value = 'textField2Value';
  static final String textField1Value = 'textField1Value';
  static final String state = 'state';
  static final String zip = 'zip';
  static final String email = 'email';
  static final String subAreaId = 'subAreaId';
  static final String branchId = 'branchId';
  static final String longitude = 'longitude';
  static final String latitude = 'latitude';
}

class CustomerModel extends BaseModel<int> with DropDown {
  @override
  int? id;
  String name;
  String? base64ImageString;
  String? imageUrl;
  String code;
  String series;
  int contactType;
  int? customerCategoryId;
  String categoryName;
  int? countryId;
  int? currencyId;
  String? companySlug;
  String? address1;
  String? address2;
  String? city;
  String? contactPerson;
  String? phone;
  String? fax;
  double? opening;
  DateTime? asOfDate;
  double? creditLimit;
  int? creditLimitDays;
  String? displayName;
  String? printName;
  String? cNIC;
  double outstandingBalance;
  DateTime? dateOfBirth;
  String? sTN;
  double? exchangeRate;
  bool isSync;
  bool isNew;
  bool isEdit;
  bool isDeleted;
  double? discountInPercent;
  DateTime? syncDate;
  DateTime? insertedDate;
  bool isActive;
  String? textField2Value;
  String? textField1Value;
  String? state;
  String? zip;
  String? email;
  int? subAreaId;
  SubAreasModel? subArea;
  int? branchId;
  double? longitude;
  double? latitude;

  CustomerModel(
      {this.id,
      this.name = "",
      this.base64ImageString,
      this.imageUrl,
      this.code = "",
      this.series = "",
      this.contactType = 0,
      this.customerCategoryId,
      this.categoryName = "",
      this.countryId,
      this.currencyId,
      this.companySlug = "",
      this.address1,
      this.address2,
      this.city,
      this.contactPerson,
      this.phone,
      this.fax,
      this.opening,
      this.asOfDate,
      this.creditLimit,
      this.creditLimitDays,
      this.displayName,
      this.printName,
      this.cNIC,
      this.outstandingBalance = 0.0,
      this.dateOfBirth,
      this.sTN,
      this.exchangeRate,
      this.latitude,
      this.longitude,
      this.isSync = false,
      this.isNew = false,
      this.isEdit = false,
      this.isDeleted = false,
      this.discountInPercent,
      this.syncDate,
      this.insertedDate,
      this.isActive = true,
      this.textField2Value,
      this.textField1Value,
      this.email,
      this.state,
      this.zip,
      this.subArea,
      this.subAreaId,
      this.branchId});

  CustomerModel copyWith(
      {int? id,
      String? name,
      String? base64ImageString,
      String? imageUrl,
      String? code,
      String? series,
      int? contactType,
      int? CustomerCategoryId,
      String? categoryName,
      int? CountryId,
      int? CurrencyId,
      String? companySlug,
      String? address1,
      String? Address2,
      String? city,
      String? contactPerson,
      String? phone,
      String? fax,
      double? opening,
      DateTime? asOfDate,
      double? creditLimit,
      int? creditLimitDays,
      String? displayName,
      String? printName,
      String? cNIC,
      double? outstandingBalance,
      DateTime? dateOfBirth,
      String? sTN,
      double? ExchangeRate,
      double? latitude,
      double? longitude,
      bool? isSync,
      bool? isNew,
      bool? isDeleted,
      double? DiscountInPercent,
      DateTime? syncDate,
      DateTime? insertedDate,
      bool? isActive,
      String? textField2Value,
      String? textField1Value,
      email,
      state,
      int? subAreaId,
      SubAreasModel? subArea,
      zip}) {
    return CustomerModel(
        id: id ?? this.id,
        name: name ?? this.name,
        base64ImageString: base64ImageString ?? this.base64ImageString,
        imageUrl: imageUrl ?? this.imageUrl,
        code: code ?? this.code,
        series: series ?? this.series,
        contactType: contactType ?? this.contactType,
        customerCategoryId: CustomerCategoryId ?? this.customerCategoryId,
        categoryName: categoryName ?? this.categoryName,
        countryId: CountryId ?? this.countryId,
        currencyId: CurrencyId ?? this.currencyId,
        companySlug: companySlug ?? this.companySlug,
        address1: address1 ?? this.address1,
        address2: Address2 ?? this.address2,
        city: city ?? this.city,
        contactPerson: contactPerson ?? this.contactPerson,
        phone: phone ?? this.phone,
        fax: fax ?? this.fax,
        opening: opening ?? this.opening,
        asOfDate: asOfDate ?? this.asOfDate,
        creditLimit: creditLimit ?? this.creditLimit,
        creditLimitDays: creditLimitDays ?? this.creditLimitDays,
        displayName: displayName ?? this.displayName,
        printName: printName ?? this.printName,
        cNIC: cNIC ?? this.cNIC,
        outstandingBalance: outstandingBalance ?? this.outstandingBalance,
        dateOfBirth: dateOfBirth ?? this.dateOfBirth,
        sTN: sTN ?? this.sTN,
        exchangeRate: ExchangeRate ?? this.exchangeRate,
        longitude: longitude ?? this.longitude,
        latitude: latitude ?? this.latitude,
        isSync: isSync ?? this.isSync,
        isNew: isNew ?? this.isNew,
        isDeleted: isDeleted ?? this.isDeleted,
        discountInPercent: DiscountInPercent ?? this.discountInPercent,
        syncDate: syncDate ?? this.syncDate,
        insertedDate: insertedDate ?? this.insertedDate,
        isActive: isActive ?? this.isActive,
        textField2Value: textField2Value ?? this.textField2Value,
        textField1Value: textField1Value ?? this.textField1Value,
        zip: zip ?? this.zip,
        state: state ?? this.state,
        email: email ?? this.email,
        subArea: subArea ?? this.subArea,
        subAreaId: subAreaId ?? this.subAreaId);
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
      'base64ImageString': base64ImageString,
      'imageUrl': imageUrl,
      'code': code,
      'series': series,
      'contactType': contactType,
      'customerCategoryId': customerCategoryId,
      'categoryName': categoryName,
      'countryId': countryId,
      'currencyId': currencyId,
      'companySlug': companySlug,
      'address1': address1,
      'address2': address2,
      'city': city,
      'contactPerson': contactPerson,
      'phone': phone,
      'fax': fax,
      'opening': opening,
      'asOfDate': asOfDate?.toIso8601String(),
      'creditLimit': creditLimit,
      'creditLimitDays': creditLimitDays,
      'displayName': displayName,
      'printName': printName,
      'cNIC': cNIC,
      'outstandingBalance': outstandingBalance,
      'dateOfBirth': dateOfBirth?.toIso8601String(),
      'sTN': sTN,
      'exchangeRate': exchangeRate,
      'latitude': latitude,
      'longitude': longitude,
      'isSync': isSync == false ? 0 : 1,
      'isNew': isNew == false ? 0 : 1,
      'isEdit': isEdit == false ? 0 : 1,
      'isDeleted': isDeleted == false ? 0 : 1,
      'discountInPercent': discountInPercent,
      'syncDate': syncDate?.toIso8601String(),
      'insertedDate': insertedDate?.toIso8601String() ?? DateTime.now().toIso8601String(),
      'isActive': isActive == false ? 0 : 1,
      'textField2Value': textField2Value,
      'textField1Value': textField1Value,
      'email': email,
      'state': state,
      'zip': zip,
      'subAreaId': subAreaId,
      'branchId': branchId
    };
  }

  factory CustomerModel.fromMap(Map<String, dynamic> map, {String? slug}) {
    return CustomerModel(
      id: map['id']?.toInt(),
      name: map['name'] ?? '',
      base64ImageString: map['base64ImageString'] ?? '',
      imageUrl: map['imageUrl'] ?? '',
      code: map['code'] ?? '',
      series: map['series'].toString(),
      contactType: map['contactType'] ?? 0,
      customerCategoryId: map['customerCategoryId']?.toInt(),
      branchId: map['branchId']?.toInt(),
      categoryName: map['customerCategoryName'] ?? '',
      countryId: map['countryId']?.toInt(),
      currencyId: map['currencyId']?.toInt(),
      companySlug: map['companySlug'] ?? slug,
      address1: map['address1'],
      address2: map['address2'],
      city: map['city'],
      contactPerson: map['contactPerson'],
      phone: map['phone'],
      fax: map['fax'],
      opening: map['opening']?.toDouble(),
      asOfDate: map['asOfDate'] != null ? DateTime.parse(map['asOfDate']) : null,
      creditLimit: map['creditLimit']?.toDouble(),
      creditLimitDays: map['creditLimitDays']?.toInt(),
      displayName: map['displayName'],
      printName: map['printName'],
      cNIC: map['cNIC'],
      outstandingBalance: map['outstandingBalance']?.toDouble() ?? 0.0,
      dateOfBirth: map['dateOfBirth'] != null ? DateTime.parse(map['dateOfBirth']) : null,
      sTN: map['sTN'],
      exchangeRate: map['exchangeRate']?.toDouble(),
      longitude: map['longitude']?.toDouble(),
      latitude: map['latitude']?.toDouble(),
      isSync: (map['isSync'] == 0 || map['isSync'] == false) ? false : true,

      isNew: (map['isNew'] == 0 || map['isNew'] == false || map['isNew'] == null) ? false : true,
      isEdit: (map['isEdit'] == 0 || map['isEdit'] == false || map['isEdit'] == null) ? false : true,
      isDeleted: (map['isDeleted'] == 1 || map['isDeleted'] == true) ? true : false,
      discountInPercent: map['discountInPercent']?.toDouble(),
      syncDate: map['syncDate'] != null ? DateTime.parse(map['syncDate']) : null,
      insertedDate: map['insertedDate'] != null ? DateTime.parse(map['insertedDate']) : null,
      isActive: (map['isActive'] == 0 || map['isActive'] == false) ? false : true,
      textField2Value: map['textField2Value'],
      textField1Value: map['textField1Value'],
      zip: map['zip'],
      state: map['state'],
      email: map['email'],
      subAreaId: map['subAreaId'],
      // subArea: map['subArea'] != null
      //     ? (map['subArea']?.map((x) => SubAreasModel.fromMap(x)))
      //     : null,
    );
  }

  @override
  BaseModel fromJson(Map<String, dynamic> json, {String? slug}) {
    return CustomerModel.fromMap(json, slug: slug);
  }

  @override
  Map<String, dynamic> toJson() {
    return toMap();
  }

  @override
  String toString() {
    return 'CustomerModel(id: $id, name: $name, base64ImageString: $base64ImageString, imageUrl: $imageUrl, code: $code, series: $series, contactType: $contactType, CustomerCategoryId: $customerCategoryId, categoryName: $categoryName, CountryId: $countryId, CurrencyId: $currencyId, companySlug: $companySlug, address1: $address1, Address2: $address2, city: $city, contactPerson: $contactPerson, phone: $phone, fax: $fax, opening: $opening, asOfDate: $asOfDate, creditLimit: $creditLimit, creditLimitDays: $creditLimitDays, displayName: $displayName, printName: $printName, cNIC: $cNIC, outstandingBalance: $outstandingBalance, dateOfBirth: $dateOfBirth, sTN: $sTN, ExchangeRate: $exchangeRate, latitude: $latitude, longitude: $longitude, isSync: $isSync, isNew: $isNew, isDeleted: $isDeleted, DiscountInPercent: $discountInPercent, syncDate: $syncDate, insertedDate: $insertedDate, isActive: $isActive, textField2Value: $textField2Value, textField1Value: $textField1Value)';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is CustomerModel &&
        other.id == id &&
        other.name == name &&
        other.base64ImageString == base64ImageString &&
        other.imageUrl == imageUrl &&
        other.code == code &&
        other.series == series &&
        other.contactType == contactType &&
        other.customerCategoryId == customerCategoryId &&
        other.categoryName == categoryName &&
        other.countryId == countryId &&
        other.currencyId == currencyId &&
        other.companySlug == companySlug &&
        other.address1 == address1 &&
        other.address2 == address2 &&
        other.city == city &&
        other.contactPerson == contactPerson &&
        other.phone == phone &&
        other.fax == fax &&
        other.opening == opening &&
        other.asOfDate == asOfDate &&
        other.creditLimit == creditLimit &&
        other.creditLimitDays == creditLimitDays &&
        other.displayName == displayName &&
        other.printName == printName &&
        other.cNIC == cNIC &&
        other.outstandingBalance == outstandingBalance &&
        other.dateOfBirth == dateOfBirth &&
        other.sTN == sTN &&
        other.exchangeRate == exchangeRate &&
        other.latitude == latitude &&
        other.longitude == longitude &&
        other.isSync == isSync &&
        other.isNew == isNew &&
        other.isDeleted == isDeleted &&
        other.discountInPercent == discountInPercent &&
        other.syncDate == syncDate &&
        other.insertedDate == insertedDate &&
        other.isActive == isActive &&
        other.textField2Value == textField2Value &&
        other.textField1Value == textField1Value;
  }

  @override
  int get hashCode {
    return id.hashCode ^
        name.hashCode ^
        base64ImageString.hashCode ^
        imageUrl.hashCode ^
        code.hashCode ^
        series.hashCode ^
        contactType.hashCode ^
        customerCategoryId.hashCode ^
        categoryName.hashCode ^
        countryId.hashCode ^
        currencyId.hashCode ^
        companySlug.hashCode ^
        address1.hashCode ^
        address2.hashCode ^
        city.hashCode ^
        contactPerson.hashCode ^
        phone.hashCode ^
        fax.hashCode ^
        opening.hashCode ^
        asOfDate.hashCode ^
        creditLimit.hashCode ^
        creditLimitDays.hashCode ^
        displayName.hashCode ^
        printName.hashCode ^
        cNIC.hashCode ^
        outstandingBalance.hashCode ^
        dateOfBirth.hashCode ^
        sTN.hashCode ^
        exchangeRate.hashCode ^
        longitude.hashCode ^
        latitude.hashCode ^
        isSync.hashCode ^
        isNew.hashCode ^
        isDeleted.hashCode ^
        discountInPercent.hashCode ^
        syncDate.hashCode ^
        insertedDate.hashCode ^
        isActive.hashCode ^
        textField2Value.hashCode ^
        textField1Value.hashCode;
  }

  List<CustomerModel> FromJson(String str, String slug) => List<CustomerModel>.from(json.decode(str).map((x) => CustomerModel().fromJson(x, slug: slug)));

  String ToJson(List<CustomerModel> data) => json.encode(List<dynamic>.from(data.map((x) => x.toJson())));
}
