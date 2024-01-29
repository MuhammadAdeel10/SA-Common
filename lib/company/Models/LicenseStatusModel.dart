class LicenseStatusModel {
  int? pricingPlanType;
  int? licenseStatus;
  dynamic paymentMode;
  dynamic expiresIn;
  dynamic message;
  int? planType;
  int? units;
  int? allowedUsers;

  LicenseStatusModel(
      {this.pricingPlanType,
      this.licenseStatus,
      this.paymentMode,
      this.expiresIn,
      this.message,
      this.planType,
      this.units,
      this.allowedUsers});

  LicenseStatusModel.fromJson(Map<String, dynamic> json) {
    pricingPlanType = json['pricingPlanType'];
    licenseStatus = json['licenseStatus'];
    paymentMode = json['paymentMode'];
    expiresIn = json['expiresIn'];
    message = json['message'];
    planType = json['planType'];
    units = json['units'];
    allowedUsers = json['allowedUsers'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['pricingPlanType'] = this.pricingPlanType;
    data['licenseStatus'] = this.licenseStatus;
    data['paymentMode'] = this.paymentMode;
    data['expiresIn'] = this.expiresIn;
    data['message'] = this.message;
    data['planType'] = this.planType;
    data['units'] = this.units;
    data['allowedUsers'] = this.allowedUsers;
    return data;
  }
}
