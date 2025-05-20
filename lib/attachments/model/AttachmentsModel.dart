import 'dart:convert';

import 'package:sa_common/Controller/BaseRepository.dart';

class AttachmentsModelFields {
  static final String companySlug = 'companySlug';
  static final String name = 'name';
  static final String path = 'path';
  static final String date = 'date';
  static final String source = 'source';
  static final String sourceId = 'sourceId';
  static final String attachInEmail = 'attachInEmail';
  static final String updatedOn = 'updatedOn';
  static final String id = 'id';
}

class AttachmentsModel extends BaseModel<int> {
  String? companySlug;
  String? name;
  String? path;
  DateTime? date;
  String? source;
  int? sourceId;
  bool? attachInEmail;
  String? updatedOn;
  int? id;

  AttachmentsModel({
    this.companySlug,
    this.name,
    this.path,
    this.date,
    this.source,
    this.sourceId,
    this.attachInEmail,
    this.updatedOn,
    this.id,
  });

  factory AttachmentsModel.fromMap(Map<String, dynamic> json, {String? slug}) => AttachmentsModel(
        companySlug: json['companySlug'],
        name: json["name"],
        path: json["path"],
        date: json["date"] == null ? null : DateTime.parse(json["date"]),
        source: json["source"],
        sourceId: json["sourceId"],
        attachInEmail: json["attachInEmail"] == 0 ? false : true,
        updatedOn: json['updatedOn'] != null ? json['updatedOn'] as String : null,
        id: json["id"],
      );

  Map<String, dynamic> toMap() => {
        "companySlug": companySlug,
        "name": name,
        "path": path,
        "date": date?.toIso8601String() ?? DateTime.now().toIso8601String(),
        "source": source,
        "sourceId": sourceId,
        "attachInEmail": attachInEmail,
        "updatedOn": updatedOn,
        "id": id,
      };

  @override
  BaseModel fromJson(Map<String, dynamic> json, {String? slug}) {
    return AttachmentsModel.fromMap(json, slug: slug);
  }

  @override
  Map<String, dynamic> toJson() {
    return toMap();
  }

  List<AttachmentsModel> AttachmentsModelFromJson(String str) => List<AttachmentsModel>.from(json.decode(str).map((x) => AttachmentsModel.fromMap(x)));

  String AttachmentsModelToJson(List<AttachmentsModel> data) => json.encode(List<dynamic>.from(data.map((x) => x.toJson())));
}
