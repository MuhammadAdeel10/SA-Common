import 'dart:convert';
import '../Database/territory_database.dart';
import 'package:sa_common/Controller/BaseController.dart';
import 'package:sa_common/HttpService/Basehttp.dart';
import 'package:sa_common/SyncSetting/Database.dart';
import 'package:sa_common/utils/ApiEndPoint.dart';
import 'package:sa_common/utils/Helper.dart';
import 'package:sa_common/utils/TablesName.dart';

import '../models/territoriesModel.dart';

class TerritoriesController extends BaseController {
  Future<void> Pull(String slug, {int page = 1}) async {
    var getSyncSetting = await SyncSettingDatabase.GetByTableName(
      Tables.Territories,
      slug: slug,
    );
    DateTime syncDate = DateTime.now().toUtc();
    var syncDateString = Helper.DateTimeRemoveZ(getSyncSetting.syncDate!);
    var response = await BaseClient()
        .get(
      "${slug}${ApiEndPoint.territories}"
      "${syncDateString}"
      "?page=${page}&pageSize=5000",
    )
        .catchError(
      (error) {
        handleError(error);
      },
    );
    if (response != null) {
      var decode = json.decode(response.body);
      //as List<Map<String, dynamic>>;
      if (decode.length > 0) {
        var currentPage = decode['page'];
        var totalPages = decode['pages'];
        var territories = decode['results'];
        var pullData = List<TerritoriesModel>.from(
            territories.map((x) => TerritoriesModel().fromJson(x, slug: slug)));

        await TerritoriesDatabase.bulkInsert(pullData);
        if (currentPage <= totalPages) {
          print("Pages" + "$currentPage");
          await Pull(slug, page: currentPage + 1);
        }
      }
      getSyncSetting.companySlug = slug;
      getSyncSetting.syncDate = syncDate;
      getSyncSetting.isSync = true;
      await SyncSettingDatabase.dao.update(getSyncSetting);
    }
  }
}
