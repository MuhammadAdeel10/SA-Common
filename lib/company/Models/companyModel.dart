import 'dart:convert';

class CompanyModel {
  String? _id;
  String? _name;
  String? _slug;
  String? _logo;
  bool? _isDemo;
  bool? enableBranch;
  List<Branches>? _branches;

  CompanyModel({String? id, String? name, String? slug, List<Branches>? branches, String? logo, bool? isDemo, this.enableBranch}) {
    if (id != null) {
      this._id = id;
    }
    if (name != null) {
      this._name = name;
    }
    if (slug != null) {
      this._slug = slug;
    }
    if (logo != null) {
      this._logo = logo;
    }
    if (branches != null) {
      this._branches = branches;
    }
    if (isDemo != null) {
      this._isDemo = isDemo;
    }
  }

  String? get id => _id;
  set id(String? id) => _id = id;
  String? get name => _name;
  set name(String? name) => _name = name;
  String? get slug => _slug;
  set slug(String? slug) => _slug = slug;
  String? get logo => _logo;
  set logo(String? logo) => _logo = logo;
  List<Branches>? get branches => _branches;
  set branches(List<Branches>? branches) => _branches = branches;
  bool? get isDemo => _isDemo;
  set isDemo(bool? isDemo) => _isDemo = isDemo;
  CompanyModel.fromJson(Map<String, dynamic> json) {
    _id = json['id'];
    _name = json['name'];
    _slug = json['slug'];
    _logo = json['logo'];
    _isDemo = json['isDemo'];
    enableBranch = json['enableBranch'];
    if (json['branches'] != null) {
      _branches = <Branches>[];
      json['branches'].forEach((v) {
        _branches!.add(new Branches.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this._id;
    data['name'] = this._name;
    data['slug'] = this._slug;
    data['logo'] = this._logo;
    data['isDemo'] = this._isDemo == true ? 1 : 0;
    data['enableBranch'] = this.enableBranch == true ? 1 : 0;
    if (this._branches != null) {
      data['branches'] = this._branches!.map((v) => v.toJson()).toList();
    }
    return data;
  }

  List<CompanyModel> stringToList(String str) => List<CompanyModel>.from(json.decode(str).map((x) => CompanyModel.fromJson(x)));
}

class Branches {
  String? _name;
  int? _id;
  String? _prefix;
  int? _defaultPOSCustomerId;
  String? _address1;
  String? _address2;
  String? _city;
  String? _state;
  String? _zip;
  int? _countryId;
  String? _phone;
  bool _isActive;

  Branches({String? name, int? id, String? prefix, int? defaultPOSCustomerId, String? address1, String? address2, String? city, String? state, String? zip, int? countryId, String? phone, bool isActive = false}) : _isActive = isActive {
    if (name != null) {
      this._name = name;
    }
    if (id != null) {
      this._id = id;
    }
    if (prefix != null) {
      this._prefix = prefix;
    }
    if (address1 != null) {
      this._address1 = address1;
    }
    if (address2 != null) {
      this._address2 = address2;
    }
    if (city != null) {
      this._city = city;
    }
    if (state != null) {
      this._state = state;
    }
    if (zip != null) {
      this._zip = zip;
    }
    if (countryId != null) {
      this._countryId = countryId;
    }
    if (phone != null) {
      this._phone = phone;
    }
    if (defaultPOSCustomerId != null) {
      this._defaultPOSCustomerId = defaultPOSCustomerId;
    }
  }

  String? get name => _name;
  set name(String? name) => _name = name;
  String? get prefix => _prefix;
  set prefix(String? prefix) => _prefix = prefix;
  int? get id => _id;
  set id(int? id) => _id = id;
  String? get address1 => _address1;
  set address1(String? address1) => _address1 = address1;
  String? get address2 => _address2;
  set address2(String? address2) => _address2 = address2;
  String? get city => _city;
  set city(String? city) => _city = city;
  String? get state => _state;
  set state(String? state) => _state = state;
  String? get zip => _zip;
  set zip(String? zip) => _zip = zip;
  int? get countryId => _countryId;
  set countryId(int? countryId) => _countryId = countryId;
  String? get phone => _phone;
  set phone(String? phone) => _phone = phone;

  int? get defaultPOSCustomerId => _defaultPOSCustomerId;
  set defaultPOSCustomerId(int? defaultPOSCustomerId) => _defaultPOSCustomerId = defaultPOSCustomerId;
  bool get isActive => _isActive;
  set isActive(bool isActive) => _isActive = isActive;

  Branches.fromJson(Map<String, dynamic> json)
      : _isActive = json['isActive'],
        _name = json['name'],
        _id = json['id'],
        _prefix = json['prefix'],
        _defaultPOSCustomerId = json['defaultPOSCustomerId'],
        _address1 = json['address1'],
        _address2 = json['address2'],
        _city = json['city'],
        _state = json['state'],
        _zip = json['zip'],
        _countryId = json['countryId'],
        _phone = json['phone'];

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['name'] = this._name;
    data['id'] = this._id;
    data['prefix'] = this.prefix;
    data['defaultPOSCustomerId'] = this.defaultPOSCustomerId;
    data['_isActive'] = this._isActive;
    data['address1'] = this._address1;
    data['address2'] = this._address2;
    data['city'] = this._city;
    data['state'] = this._state;
    data['zip'] = this._zip;
    data['countryId'] = this._countryId;
    data['phone'] = this._phone;
    return data;
  }

  List<Branches> FromJson(String str) => List<Branches>.from(json.decode(str).map((x) => Branches.fromJson(x)));
}
