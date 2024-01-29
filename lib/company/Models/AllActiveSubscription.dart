class AllActiveSubscriptionModel {
  int? pricingPlanId;
  String? expiryDate;

  AllActiveSubscriptionModel({this.pricingPlanId, this.expiryDate});

  AllActiveSubscriptionModel.fromJson(Map<String, dynamic> json) {
    pricingPlanId = json['pricingPlanId'];
    expiryDate = json['expiryDate'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['pricingPlanId'] = this.pricingPlanId;
    data['expiryDate'] = this.expiryDate;
    return data;
  }
}
