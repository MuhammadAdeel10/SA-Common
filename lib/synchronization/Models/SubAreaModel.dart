// import 'dart:convert';

// import 'package:pos/Helper/Controller/BaseRepository.dart';

// class SubAreaFields {
//   static final String id = 'id';
//   static final String name = 'name';
//   static final String regionId = 'regionId';
//   static final String regionName = 'regionName';
//   static final String zoneId = 'zoneId';
//   static final String zoneName = 'zoneName';
//   static final String territoryId = 'territoryId';
//   static final String territoryName = 'territoryName';
//   static final String areaId = 'areaId';
//   static final String areaName = 'areaName';
//   static final String companySlug = 'companySlug';
//   static final String isSync = 'isSync';
//   static final String syncDate = 'syncDate';
// }

// class SubAreaModel extends BaseModel {
//   @override
//   int? id;
//   String name;
//   int regionId;
//   String regionName;
//   int zoneId;
//   String zoneName;
//   int territoryId;
//   String territoryName;
//   int areaId;
//   String areaName;
//   String companySlug;
//   bool isSync;
//   DateTime? syncDate;
//   SubAreaModel({
//     this.id,
//     this.name = "",
//     this.regionId = 0,
//     this.regionName = "",
//     this.zoneId = 0,
//     this.zoneName = "",
//     this.territoryId = 0,
//     this.territoryName = "",
//     this.areaId = 0,
//     this.areaName = "",
//     this.companySlug = "",
//     this.isSync = false,
//     this.syncDate,
//   });

//   SubAreaModel copyWith({
//     int? id,
//     String? name,
//     int? regionId,
//     String? regionName,
//     int? zoneId,
//     String? zoneName,
//     int? territoryId,
//     String? territoryName,
//     int? areaId,
//     String? areaName,
//     String? companySlug,
//     bool? isSync,
//     DateTime? syncDate,
//   }) {
//     return SubAreaModel(
//       id: id ?? this.id,
//       name: name ?? this.name,
//       regionId: regionId ?? this.regionId,
//       regionName: regionName ?? this.regionName,
//       zoneId: zoneId ?? this.zoneId,
//       zoneName: zoneName ?? this.zoneName,
//       territoryId: territoryId ?? this.territoryId,
//       territoryName: territoryName ?? this.territoryName,
//       areaId: areaId ?? this.areaId,
//       areaName: areaName ?? this.areaName,
//       companySlug: companySlug ?? this.companySlug,
//       isSync: isSync ?? this.isSync,
//       syncDate: syncDate ?? this.syncDate,
//     );
//   }

//   Map<String, dynamic> toMap() {
//     return {
//       'id': id,
//       'name': name,
//       'regionId': regionId,
//       'regionName': regionName,
//       'zoneId': zoneId,
//       'zoneName': zoneName,
//       'territoryId': territoryId,
//       'territoryName': territoryName,
//       'areaId': areaId,
//       'areaName': areaName,
//       'companySlug': companySlug,
//       'isSync': isSync == true ? 1 : 0,
//       'syncDate': syncDate?.toIso8601String(),
//     };
//   }

//   factory SubAreaModel.fromMap(Map<String, dynamic> map, {String? slug}) {
//     return SubAreaModel(
//       id: map['id']?.toInt(),
//       name: map['name'] ?? '',
//       regionId: map['regionId']?.toInt() ?? 0,
//       regionName: map['regionName'] ?? '',
//       zoneId: map['zoneId']?.toInt() ?? 0,
//       zoneName: map['zoneName'] ?? '',
//       territoryId: map['territoryId']?.toInt() ?? 0,
//       territoryName: map['territoryName'] ?? '',
//       areaId: map['areaId']?.toInt() ?? 0,
//       areaName: map['areaName'] ?? '',
//       companySlug: slug ?? '',
//       isSync: map['isSync'] == 0 ? false : true,
//       syncDate:
//           map['syncDate'] != null ? DateTime.parse(map['syncDate']) : null,
//     );
//   }

//   @override
//   BaseModel fromJson(Map<String, dynamic> json, {String? slug}) {
//     return SubAreaModel.fromMap(json, slug: slug);
//   }

//   @override
//   Map<String, dynamic> toJson() {
//     return toMap();
//   }

//   @override
//   String toString() {
//     return 'SubAreaModel(id: $id, name: $name, regionId: $regionId, regionName: $regionName, zoneId: $zoneId, zoneName: $zoneName, territoryId: $territoryId, territoryN: $territoryName, areaId: $areaId, areaName: $areaName, companySlug: $companySlug, isSync: $isSync, syncDate: $syncDate)';
//   }

//   @override
//   bool operator ==(Object other) {
//     if (identical(this, other)) return true;

//     return other is SubAreaModel &&
//         other.id == id &&
//         other.name == name &&
//         other.regionId == regionId &&
//         other.regionName == regionName &&
//         other.zoneId == zoneId &&
//         other.zoneName == zoneName &&
//         other.territoryId == territoryId &&
//         other.territoryName == territoryName &&
//         other.areaId == areaId &&
//         other.areaName == areaName &&
//         other.companySlug == companySlug &&
//         other.isSync == isSync &&
//         other.syncDate == syncDate;
//   }

//   @override
//   int get hashCode {
//     return id.hashCode ^
//         name.hashCode ^
//         regionId.hashCode ^
//         regionName.hashCode ^
//         zoneId.hashCode ^
//         zoneName.hashCode ^
//         territoryId.hashCode ^
//         territoryName.hashCode ^
//         areaId.hashCode ^
//         areaName.hashCode ^
//         companySlug.hashCode ^
//         isSync.hashCode ^
//         syncDate.hashCode;
//   }

//   List<SubAreaModel> FromJson(String str, String slug) =>
//       List<SubAreaModel>.from(
//           json.decode(str).map((x) => SubAreaModel().fromJson(x, slug: slug)));

//   String ToJson(List<SubAreaModel> data) =>
//       json.encode(List<dynamic>.from(data.map((x) => x.toJson())));
// }
