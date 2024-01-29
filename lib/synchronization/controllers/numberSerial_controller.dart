import 'dart:convert';

import 'package:sa_common/Controller/BaseController.dart';
import 'package:sa_common/HttpService/Basehttp.dart';
import 'package:sa_common/login/UserDatabase.dart';
import 'package:sa_common/synchronization/Database/numberSerial_database.dart';
import 'package:sa_common/synchronization/Models/NumberSerialsModel.dart';
import 'package:sa_common/utils/ApiEndPoint.dart';
import 'package:sa_common/utils/Helper.dart';
import 'package:sa_common/utils/LocalStorageKey.dart';
import 'package:sa_common/utils/pref_utils.dart';

import '../Models/PosCashRegister_model.dart';

class NumberSerialController extends BaseController {
  Future<String> GetLastPOSInvoiceNumber(String series, PosCashRegisterModel data) async {
    var pref = PrefUtils();
    var userId = pref.GetPreferencesInteger(LocalStorageKey.localUserId);
    var user = await UserDatabase.instance.GetUserById(userId);

    var response = await BaseClient().get("${user.companyId}/${user.branchId}" + ApiEndPoint.getProposedNumber + series).catchError(
      (error) {
        handleError(error);
      },
    );
    String lastNumber = "";

    if (response != null) {
      var getNumberSerial = await NumberSerialDatabase().GetLastNumber(series, (user.companyId ?? ""), (user.branchId ?? 0));
      if (getNumberSerial == null) {
        String jsonDecode = json.decode(response.body);

        if (jsonDecode.isEmpty || jsonDecode == "") {
          var numberSeries = NumberSerialsModel(branchId: user.branchId, companySlug: user.companyId, series: series, entityName: "PosInvoice", lastNumber: user.prefix == "_" ? "${series}-000001" : "${user.prefix}-${series}-000001");
          await NumberSerialDatabase.dao.insert(numberSeries);
          //Insert New Number Serial
        } else {
          var splitNumber = jsonDecode.split("$series-");
          var lastNumber = splitNumber[1];
          if (lastNumber.isNotEmpty) {
            var number = int.parse(lastNumber);
            number = number - 1;
            jsonDecode = user.prefix == "_" ? series + splitNumber[0] + "-" + number.toString().padLeft(6, "0") : splitNumber[0] + series + "-" + number.toString().padLeft(6, "0");
            var numberSeries = NumberSerialsModel(
              branchId: user.branchId,
              companySlug: user.companyId,
              series: series,
              entityName: "PosInvoice",
              lastNumber: jsonDecode,
            );
            // numberSeries.lastNumber =
            //     (data.prefix ?? "") + "-" + numberSeries.lastNumber;
            await NumberSerialDatabase.dao.insert(numberSeries);
            // Insert old number serial
          }
        }
      }
    }
    return lastNumber;
  }

  Future<void> DeleteLastNumber(String series) async {
    var user = Helper.user;
    await NumberSerialDatabase().DeleteNumberSerials(series, (user.companyId ?? ""), (user.branchId ?? 0));
  }

  Future<String?> CreateNewNumber(String series, PosCashRegisterModel data) async {
    var pref = PrefUtils();
    var userId = pref.GetPreferencesInteger(LocalStorageKey.localUserId);
    var user = await UserDatabase.instance.GetUserById(userId);
    // await GetLastNumber(series, data);
    var getNumberSerial = await NumberSerialDatabase().GetLastNumber(series, (user.companyId ?? ""), (user.branchId ?? 0));
    if (getNumberSerial != null) {
      var splitNumber = getNumberSerial.lastNumber.split("$series-");
      var lastNumber = splitNumber[1];
      if (lastNumber.isNotEmpty) {
        var number = int.parse(lastNumber);
        number = number + 1;
        getNumberSerial.lastNumber = user.prefix == "_" ? series + splitNumber[0] + "-" + number.toString().padLeft(6, "0") : splitNumber[0] + series + "-" + number.toString().padLeft(6, "0");

        await NumberSerialDatabase.dao.update(getNumberSerial);
      }
    } else {
      var numberSeries = NumberSerialsModel(branchId: data.branchId, companySlug: data.companySlug, series: series, entityName: "PosInvoice", lastNumber: user.prefix == "_" ? "${series}-000001" : user.prefix! + "-" + "${series}-000001");

      await NumberSerialDatabase.dao.insert(numberSeries);
      return numberSeries.lastNumber;
    }

    return getNumberSerial.lastNumber;
  }

  Future<String> GetLastSaleReturnInvoiceNumber(String series, PosCashRegisterModel data) async {
    var pref = PrefUtils();
    var userId = pref.GetPreferencesInteger(LocalStorageKey.localUserId);
    var user = await UserDatabase.instance.GetUserById(userId);

    var response = await BaseClient().get("${user.companyId}/${user.branchId}" + "/SaleReturns/GetProposedNumber?series=" + series).catchError(
      (error) {
        handleError(error);
      },
    );
    String lastNumber = "";

    if (response != null) {
      var getNumberSerial = await NumberSerialDatabase().GetLastNumber(series, (user.companyId ?? ""), (user.branchId ?? 0));
      if (getNumberSerial == null) {
        String jsonDecode = json.decode(response.body);

        if (jsonDecode.isEmpty || jsonDecode == "") {
          var numberSeries = NumberSerialsModel(branchId: user.branchId, companySlug: user.companyId, series: series, entityName: "SaleReturn", lastNumber: user.prefix == "_" ? "${series}-000001" : "${user.prefix}-${series}-000001");
          await NumberSerialDatabase.dao.insert(numberSeries);
          //Insert New Number Serial
        } else {
          var splitNumber = jsonDecode.split("$series-");
          var lastNumber = splitNumber[1];
          if (lastNumber.isNotEmpty) {
            var number = int.parse(lastNumber);
            number = number - 1;
            jsonDecode = user.prefix == "_" ? series + splitNumber[0] + "-" + number.toString().padLeft(6, "0") : splitNumber[0] + series + "-" + number.toString().padLeft(6, "0");
            var numberSeries = NumberSerialsModel(
              branchId: user.branchId,
              companySlug: user.companyId,
              series: series,
              entityName: "SaleReturn",
              lastNumber: jsonDecode,
            );
            // numberSeries.lastNumber =
            //     (data.prefix ?? "") + "-" + numberSeries.lastNumber;
            await NumberSerialDatabase.dao.insert(numberSeries);
            // Insert old number serial
          }
        }
      }
    }
    return lastNumber;
  }
}
