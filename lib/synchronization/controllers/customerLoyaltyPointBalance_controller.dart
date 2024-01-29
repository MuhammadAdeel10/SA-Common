import 'dart:convert';
import 'package:sa_common/Controller/BaseController.dart';
import 'package:sa_common/HttpService/Basehttp.dart';
import 'package:sa_common/SyncSetting/Database.dart';
import 'package:sa_common/synchronization/Database/customerLoyaltyPointBalance_database.dart';
import 'package:sa_common/synchronization/Models/CustomerLoyaltyPointBalanceModel.dart';
import 'package:sa_common/utils/ApiEndPoint.dart';
import 'package:sa_common/utils/Helper.dart';
import 'package:sa_common/utils/Logger.dart';
import 'package:sa_common/utils/TablesName.dart';

class CustomerLoyaltyPointBalanceController extends BaseController {
  Future<void> Pull(String slug, {int page = 1}) async {
    try {
      var getSyncSetting = await SyncSettingDatabase.GetByTableName(
          Tables.CustomerLoyaltyPointBalance,
          slug: slug);
      DateTime syncDate = DateTime.now().toUtc();
      var syncDateString = Helper.DateTimeRemoveZ(getSyncSetting.syncDate!);
      var response = await BaseClient()
          .get("$slug${ApiEndPoint.getCustomerLoyaltyPoint}"
              "${syncDateString}"
              "?page=${page}&pageSize=5000")
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
          //var pageSize = decode['size'];
          var totalPages = decode['pages'];
          // int totalRecord = decode['records'];
          var customerLoyalty = decode['results'];
          var customerLoyaltyList = List<CustomerLoyaltyPointBalanceModel>.from(
              customerLoyalty.map((x) =>
                  CustomerLoyaltyPointBalanceModel().fromJson(x, slug: slug)));

          await CustomerLoyaltyPointBalanceDatabase.bulkInsert(
              customerLoyaltyList);
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
    } catch (ex) {
      Logger.ErrorLog("Error Customer Pull: $ex");
    }
  }
}
