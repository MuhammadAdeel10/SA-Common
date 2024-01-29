class UserFields {
  static final List<String> values = [
    /// Add all fields
    id, email, password, expiry, companyId, branchId, userId
  ];
  static final String id = 'id';
  static final String email = 'email';
  static final String password = 'password';
  static final String expiry = 'expiry';
  static final String companyId = 'companyId';
  static final String branchId = 'branchId';
  static final String userId = 'userId';
  static final String branchPrefix = 'branchPrefix';
  static final String phoneNumber = 'phoneNumber';
  static final String isPrivacyMode = 'isPrivacyMode';
  static final String isActive = 'isActive';
  static final String imageUrl = 'imageUrl';
  static final String fullName = 'fullName';
}

class UserModel {
  final int? id;
  final String email;
  final String password;
  final DateTime? expiry;
  final String? companyId;
  final int? branchId;
  final String? userId;
  final String? prefix;
  String? phoneNumber;
  bool? isPrivacyMode;
  bool? isActive;
  String? imageUrl;
  String? fullName;

  UserModel(
      {this.id,
      this.email = "",
      this.password = "",
      this.expiry,
      this.branchId,
      this.companyId,
      this.userId,
      this.prefix,
      this.isPrivacyMode,
      this.phoneNumber,
      this.fullName,
      this.imageUrl,
      this.isActive});

  UserModel copy(
          {int? id,
          String? email,
          String? password,
          DateTime? expiry,
          String? userId}) =>
      UserModel(
          id: id ?? this.id,
          email: email ?? this.email,
          password: password ?? this.password,
          expiry: expiry ?? this.expiry,
          branchId: branchId ?? this.branchId,
          companyId: companyId ?? this.companyId,
          userId: userId ?? this.userId);

  static UserModel fromJson(Map<String, Object?> json,
          {bool isProfile = false}) =>
      UserModel(
        id: isProfile == true ? null : json[UserFields.id] as int?,
        email: json[UserFields.email].toString(),
        password: json[UserFields.password].toString(),
        expiry: isProfile == true
            ? null
            : DateTime.parse(json[UserFields.expiry] as String),
        branchId: json[UserFields.branchId] as int?,
        companyId: json[UserFields.companyId] as String?,
        userId: json[UserFields.userId] as String?,
        prefix: json[UserFields.branchPrefix] as String?,
        phoneNumber: json[UserFields.phoneNumber] as String?,
        fullName: json[UserFields.fullName] as String?,
        imageUrl: json[UserFields.imageUrl] as String?,
        isActive:
            (json['isActive'] == 0 || json['isActive'] == false) ? false : true,
        isPrivacyMode:
            (json['isPrivacyMode'] == 0 || json['isPrivacyMode'] == false)
                ? false
                : true,
        // userId: json[UserFields.userId] != null
        //     ? Guid(json[UserFields.userId] as String?)
        //     : null,
      );

  Map<String, Object?> toJson() => {
        UserFields.id: id,
        UserFields.email: email,
        UserFields.password: password,
        UserFields.expiry: expiry?.toIso8601String(),
        UserFields.branchId: branchId,
        UserFields.companyId: companyId,
        UserFields.userId: userId,
        UserFields.branchPrefix: prefix,
        UserFields.phoneNumber: phoneNumber,
        UserFields.fullName: fullName,
        UserFields.imageUrl: imageUrl,
        UserFields.isActive: isActive == true ? 1 : 0,
        UserFields.isPrivacyMode: isPrivacyMode == true ? 1 : 0,
      };
}
