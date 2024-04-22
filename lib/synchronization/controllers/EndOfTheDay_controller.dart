import '../../Controller/BaseController.dart';
import '../../HttpService/Basehttp.dart';
import '../../utils/ApiEndPoint.dart';
import '../../utils/Helper.dart';
import '../Database/EndOfTheDay_database.dart';
import '../Models/EndOfTheDay_model.dart';

class EndOfTheDayController extends BaseController {
  //
  Future<void> GetLastEndOfTheDay(String baseUrl) async {
    var user = Helper.user;
    var slug = user.companyId;
    var branchId = user.branchId;
    var response = await BaseClient().get(baseUrl, "$slug/${branchId}${ApiEndPoint.EndOfTheFDay}").catchError(
      (error) {
        handleError(error);
      },
    );
    if (response != null) {
      if (response.statusCode == 200) {
        var endOfTheDayDb = EndOfTheDayDatabase.dao;
        var endOfTheDayModel = EndOfTheDayModel.fromJson(response.body);
        endOfTheDayModel.companySlug = slug;
        endOfTheDayModel.branchId = branchId;

        var existEndOfTheDay = await endOfTheDayDb.SelectSingle("Id = ${endOfTheDayModel.id}");
        if (existEndOfTheDay != null) {
          await endOfTheDayDb.update(endOfTheDayModel);
        } else {
          await EndOfTheDayDatabase.DeletePrevious();
          await await endOfTheDayDb.insert(endOfTheDayModel);
        }
      }
    }
    Helper.endOfTheDayModel = await GetLastEndOfTheDayLocal();
  }

  Future<EndOfTheDayModel?> GetLastEndOfTheDayLocal() async {
    var branchId = Helper.user.branchId;
    var getLastEndOfDay = await EndOfTheDayDatabase.dao.SelectSingle("branchId = $branchId order by endOfDayDate desc");
    if (getLastEndOfDay != null) {
      Helper.endOfTheDayModel = getLastEndOfDay;
      return getLastEndOfDay;
    }
    return null;
  }
}
