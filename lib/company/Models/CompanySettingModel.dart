import 'dart:convert';

import 'package:flutter_guid/flutter_guid.dart';
import 'package:sa_common/utils/Enums.dart';

import '../../Controller/BaseRepository.dart';

class CompanySettingField {
  static final String id = 'id';
  static final String slug = 'slug';
  static final String name = 'name';
  static final String allowDiscountOnPosProduct = 'allowDiscountOnPosProduct';
  static final String allowPriceChangeForPosProduct = 'allowPriceChangeForPosProduct';
  static final String allowRemovePosProductAfterScanning = 'allowRemovePosProductAfterScanning';
  static final String allowOverallDiscountPos = 'allowOverallDiscountPos';
  static final String manuallyManageEOD = 'manuallyManageEOD';
  static final String enableFbrPos = 'enableFbrPos';
  static final String enableFbrPosFee = 'enableFbrPosFee';
  static final String fbrPosFeeAccountType = 'fbrPosFeeAccountType';
  static final String enableSalesmansOnPos = 'enableSalesmansOnPos';
  static final String isSalesmanRequiredOnPos = 'isSalesmanRequiredOnPos';
  static final String enableSalesGeography = 'enableSalesGeography';
  static final String currencyId = 'currencyId';
  static final String enableMasterGroups = 'enableMasterGroups';
  static final String masterGroupCaption = 'masterGroupCaption';
  static final String detailAGroupCaption = 'detailAGroupCaption';
  static final String detailBGroupCaption = 'detailBGroupCaption';
  static final String enableDetailAGroups = 'enableDetailAGroups';
  static final String enableDetailBGroups = 'enableDetailBGroups';
  static final String isSync = 'isSync';
  static final String syncDate = 'syncDate';
  static final String printerName = 'printerName';
  static final String logo = 'logo';
  static final String enableScheme = 'enableScheme';
  static final String defaultPOSCustomerId = 'defaultPOSCustomerId';
  static final String decimalPlaces = 'decimalPlaces';
  static final String enableCustomerLoyaltyPoints = 'enableCustomerLoyaltyPoints';
  static final String customerLoyaltyPointsToAmountConversionRate = 'customerLoyaltyPointsToAmountConversionRate';
  static final String customerLoyaltyAmountToPointsConversionRate = 'customerLoyaltyAmountToPointsConversionRate';
  static final String customerLoyaltyDiscountAccountId = 'customerLoyaltyDiscountAccountId';
  static final String customerLoyaltyProgramCategories = 'customerLoyaltyProgramCategories';
  static final String customerLoyaltyCalculationType = 'customerLoyaltyCalculationType';
  static final String currencySymbol = 'currencySymbol';
  static final String allowDuplicateProducts = 'allowDuplicateProducts';
  static final String allowNegativeStock = 'allowNegativeStock';
  static final String OrderDateFilter = 'OrderDateFilter';
}

class CompanySettingModel extends BaseModel<Guid> {
  @override
  Guid? id;
  // String companyId;

  String? slug;
  String name;
  bool allowDiscountOnPosProduct;
  bool allowPriceChangeForPosProduct;
  bool allowRemovePosProductAfterScanning;
  bool allowOverallDiscountPos;
  bool manuallyManageEOD;
  bool enableFbrPos;
  bool enableFbrPosFee;
  int fbrPosFeeAccountType;
  bool enableSalesmansOnPos;
  bool isSalesmanRequiredOnPos;
  DateTime? syncDate;
  bool isSync;
  bool enableSalesGeography;
  int? currencyId;
  bool enableMasterGroups;
  String? masterGroupCaption;
  bool enableDetailAGroups;
  String? detailAGroupCaption;
  bool enableDetailBGroups;
  bool allowDuplicateProducts;
  String? detailBGroupCaption;
  String? printerName;
  String? logo;
  bool enableScheme;
  int defaultPOSCustomerId;
  bool enableCustomerLoyaltyPoints;
  double customerLoyaltyPointsToAmountConversionRate;
  double customerLoyaltyAmountToPointsConversionRate;
  int? customerLoyaltyDiscountAccountId;
  String? customerLoyaltyProgramCategories;
  int decimalPlaces;
  CustomerLoyaltyCalculationType customerLoyaltyCalculationType;
  bool currencySymbol;
  bool allowNegativeStock;
  OrderDayType? orderDateFilter;

  CompanySettingModel(
      {this.id,
      // this.companyId = "",
      this.slug,
      this.logo,
      this.name = "",
      this.allowDiscountOnPosProduct = false,
      this.allowPriceChangeForPosProduct = false,
      this.allowRemovePosProductAfterScanning = false,
      this.allowOverallDiscountPos = false,
      this.manuallyManageEOD = false,
      this.enableFbrPos = false,
      this.allowDuplicateProducts = false,
      this.enableFbrPosFee = false,
      this.fbrPosFeeAccountType = 0,
      this.enableSalesmansOnPos = false,
      this.isSalesmanRequiredOnPos = false,
      this.syncDate,
      this.isSync = false,
      this.enableSalesGeography = false,
      this.currencyId,
      this.enableMasterGroups = false,
      this.masterGroupCaption,
      this.detailAGroupCaption,
      this.detailBGroupCaption,
      this.enableDetailAGroups = false,
      this.enableDetailBGroups = false,
      this.enableScheme = false,
      this.defaultPOSCustomerId = 0,
      this.enableCustomerLoyaltyPoints = false,
      this.customerLoyaltyAmountToPointsConversionRate = 0.0,
      this.customerLoyaltyDiscountAccountId,
      this.customerLoyaltyPointsToAmountConversionRate = 0.0,
      this.customerLoyaltyProgramCategories,
      this.printerName,
      this.decimalPlaces = 0,
      this.customerLoyaltyCalculationType = CustomerLoyaltyCalculationType.None,
      this.currencySymbol = false,
      this.orderDateFilter,
      this.allowNegativeStock = false});

  CompanySettingModel copyWith({
    Guid? id,
    String? companySlug,
    String? name,
    bool? allowDiscountOnPosProduct,
    bool? allowPriceChangeForPosProduct,
    bool? allowRemovePosProductAfterScanning,
    bool? allowOverallDiscountPos,
    bool? manuallyManageEOD,
    bool? enableFbrPos,
    bool? enableFbrPosFee,
    bool? allowDuplicateProducts,
    int? fbrPosFeeAccountType,
    bool? enableSalesmansOnPos,
    bool? isSalesmanRequiredOnPos,
    DateTime? syncDate,
    bool? isSync,
    bool? enableSalesGeography,
  }) {
    return CompanySettingModel(
        id: id ?? this.id,
        // companyId: companyId ?? this.companyId,
        slug: slug ?? this.slug,
        name: name ?? this.name,
        allowDiscountOnPosProduct: allowDiscountOnPosProduct ?? this.allowDiscountOnPosProduct,
        allowPriceChangeForPosProduct: allowPriceChangeForPosProduct ?? this.allowPriceChangeForPosProduct,
        allowRemovePosProductAfterScanning: allowRemovePosProductAfterScanning ?? this.allowRemovePosProductAfterScanning,
        allowOverallDiscountPos: allowOverallDiscountPos ?? this.allowOverallDiscountPos,
        manuallyManageEOD: manuallyManageEOD ?? this.manuallyManageEOD,
        enableFbrPos: enableFbrPos ?? this.enableFbrPos,
        enableFbrPosFee: enableFbrPosFee ?? this.enableFbrPosFee,
        fbrPosFeeAccountType: fbrPosFeeAccountType ?? this.fbrPosFeeAccountType,
        enableSalesmansOnPos: enableSalesmansOnPos ?? this.enableSalesmansOnPos,
        isSalesmanRequiredOnPos: isSalesmanRequiredOnPos ?? this.isSalesmanRequiredOnPos,
        syncDate: syncDate ?? this.syncDate,
        isSync: isSync ?? this.isSync,
        allowDuplicateProducts: allowDuplicateProducts ?? this.allowDuplicateProducts,
        enableSalesGeography: enableSalesGeography ?? this.enableSalesGeography);
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id.toString(),
      // 'companyId': companyId,
      'slug': slug,
      'name': name,
      'logo': logo,
      'defaultPOSCustomerId': defaultPOSCustomerId,
      'decimalPlaces': decimalPlaces,
      'allowDiscountOnPosProduct': allowDiscountOnPosProduct == true ? 1 : 0,
      'allowPriceChangeForPosProduct': allowPriceChangeForPosProduct == true ? 1 : 0,
      'allowRemovePosProductAfterScanning': allowRemovePosProductAfterScanning == true ? 1 : 0,
      'allowOverallDiscountPos': allowOverallDiscountPos == true ? 1 : 0,
      'manuallyManageEOD': manuallyManageEOD == true ? 1 : 0,
      'enableFbrPos': enableFbrPos == true ? 1 : 0,
      'enableFbrPosFee': enableFbrPosFee == true ? 1 : 0,
      'allowDuplicateProducts': allowDuplicateProducts == true ? 1 : 0,
      'fbrPosFeeAccountType': fbrPosFeeAccountType,
      'enableSalesmansOnPos': enableSalesmansOnPos == true ? 1 : 0,
      'isSalesmanRequiredOnPos': isSalesmanRequiredOnPos == true ? 1 : 0,
      'syncDate': syncDate?.toIso8601String() ?? DateTime.now().toIso8601String(),
      'isSync': isSync == true ? 1 : 0,
      'enableSalesGeography': enableSalesGeography == true ? 1 : 0,
      'enableMasterGroups': enableMasterGroups == true ? 1 : 0,
      'currencyId': currencyId,
      'enableDetailAGroups': enableDetailAGroups == true ? 1 : 0,
      'enableDetailBGroups': enableDetailBGroups == true ? 1 : 0,
      'enableScheme': enableScheme == true ? 1 : 0,
      'masterGroupCaption': masterGroupCaption,
      'detailAGroupCaption': detailAGroupCaption,
      'detailBGroupCaption': detailBGroupCaption,
      'printerName': printerName,
      'enableCustomerLoyaltyPoints': enableCustomerLoyaltyPoints == true ? 1 : 0,
      'customerLoyaltyAmountToPointsConversionRate': customerLoyaltyAmountToPointsConversionRate,
      'customerLoyaltyPointsToAmountConversionRate': customerLoyaltyPointsToAmountConversionRate,
      'customerLoyaltyDiscountAccountId': customerLoyaltyDiscountAccountId,
      'customerLoyaltyProgramCategories': customerLoyaltyProgramCategories,
      'customerLoyaltyCalculationType': customerLoyaltyCalculationType.value,
      'currencySymbol': currencySymbol == true ? 1 : 0,
      'allowNegativeStock': allowNegativeStock == true ? 1 : 0,
      'orderDateFilter': orderDateFilter!.value,
    };
  }

  factory CompanySettingModel.fromMap(Map<String, dynamic> map) {
    return CompanySettingModel(
      id: Guid(map['id']),
      // companyId: map['id'] ?? '',
      slug: map['slug'] ?? '',
      name: map['name'] ?? '',
      defaultPOSCustomerId: map['defaultPOSCustomerId'] ?? 0,
      decimalPlaces: map['decimalPlaces'] ?? 0,
      allowDiscountOnPosProduct: (map['allowDiscountOnPosProduct'] == 0 || map['allowDiscountOnPosProduct'] == false) ? false : true,
      enableScheme: (map['enableScheme'] == 0 || map['enableScheme'] == false) ? false : true,
      allowDuplicateProducts: (map['allowDuplicateProducts'] == 1 || map['allowDuplicateProducts'] == true) ? true : false,
      allowPriceChangeForPosProduct: (map['allowPriceChangeForPosProduct'] == 0 || map['allowPriceChangeForPosProduct'] == false) ? false : true,
      allowRemovePosProductAfterScanning: (map['allowRemovePosProductAfterScanning'] == 0 || map['allowRemovePosProductAfterScanning'] == false) ? false : true,
      allowOverallDiscountPos: (map['allowOverallDiscountPos'] == 0 || map['allowOverallDiscountPos'] == false) ? false : true,
      manuallyManageEOD: (map['manuallyManageEOD'] == 0 || map['manuallyManageEOD'] == false) ? false : true,
      enableFbrPos: (map['enableFbrPos'] == 0 || map['enableFbrPos'] == false) ? false : true,
      enableFbrPosFee: (map['enableFbrPosFee'] == 0 || map['enableFbrPosFee'] == false) ? false : true,
      fbrPosFeeAccountType: map['fbrPosFeeAccountType']?.toInt() ?? 0,
      enableSalesmansOnPos: (map['enableSalesmansOnPos'] == 0 || map['enableSalesmansOnPos'] == false) ? false : true,
      isSalesmanRequiredOnPos: (map['isSalesmanRequiredOnPos'] == 0 || map['isSalesmanRequiredOnPos'] == false) ? false : true,
      syncDate: map['syncDate'] != null ? DateTime.parse(map['syncDate']) : null,
      isSync: (map['isSync'] == 0 || map['isSync'] == false) ? false : true,
      enableSalesGeography: (map['enableSalesGeography'] == 0 || map['enableSalesGeography'] == false) ? false : true,
      enableMasterGroups: (map['enableMasterGroups'] == 0 || map['enableMasterGroups'] == false) ? false : true,
      currencyId: map['currencyId']?.toInt() ?? 0,
      enableDetailBGroups: (map['enableDetailBGroups'] == 0 || map['enableDetailBGroups'] == false) ? false : true,
      enableDetailAGroups: (map['enableDetailAGroups'] == 0 || map['enableDetailAGroups'] == false) ? false : true,
      masterGroupCaption: map['masterGroupCaption'] ?? '',
      detailAGroupCaption: map['detailAGroupCaption'] ?? '',
      detailBGroupCaption: map['detailBGroupCaption'] ?? '',
      printerName: map['printerName'] ?? '',
      logo: map['logo'] ?? '',
      enableCustomerLoyaltyPoints: (map['enableCustomerLoyaltyPoints'] == 0 || map['enableCustomerLoyaltyPoints'] == false) ? false : true,
      customerLoyaltyProgramCategories: map['customerLoyaltyProgramCategories'],
      customerLoyaltyDiscountAccountId: map['customerLoyaltyDiscountAccountId'] ?? 0,
      customerLoyaltyAmountToPointsConversionRate: map['customerLoyaltyAmountToPointsConversionRate']?.toDouble() ?? 0.0,
      customerLoyaltyPointsToAmountConversionRate: map['customerLoyaltyPointsToAmountConversionRate']?.toDouble() ?? 0.0,
      customerLoyaltyCalculationType: intToCustomerLoyaltyCalculationType(map['customerLoyaltyCalculationType'] ?? 0),
      currencySymbol: (map['currencySymbol'] == 0 || map['currencySymbol'] == false) ? false : true,
      allowNegativeStock: (map['allowNegativeStock'] == 0 || map['allowNegativeStock'] == false) ? false : true,
      orderDateFilter: map['orderDateFilter'] == null ? OrderDayType.Today : intoOrderDateFilterEnum(map['orderDateFilter']),
    );
  }

  @override
  BaseModel fromJson(Map<String, dynamic> json, {String? slug}) {
    return CompanySettingModel.fromMap(json);
  }

  @override
  Map<String, dynamic> toJson() {
    return toMap();
  }

  List<CompanySettingModel> FromJson(String str) => List<CompanySettingModel>.from(json.decode(str).map((x) => CompanySettingModel().fromJson(x)));

  String ToJson(List<CompanySettingModel> data) => json.encode(List<dynamic>.from(data.map((x) => x.toJson())));
}
