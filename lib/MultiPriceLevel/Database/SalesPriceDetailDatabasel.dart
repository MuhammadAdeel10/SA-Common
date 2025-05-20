import 'package:sa_common/Controller/BaseRepository.dart';
import 'package:sa_common/MultiPriceLevel/Model/SalesPriceDetailModel.dart';
import 'package:sa_common/utils/TablesName.dart';

class SalePricingDetailsDatabase {
  static final dao = BaseRepository<SalePricingDetailsModel>(SalePricingDetailsModel(), tableName: Tables.SalesPriceDetail);
  Future<SalePricingDetailsModel> find(int id) => dao.find(id);
  Future<List<SalePricingDetailsModel>> getAll() => dao.getAll();
  Future<List<SalePricingDetailsModel>> getByCompanySlug() => dao.getByCompanySlug();
  Future<int> insert(SalePricingDetailsModel model) => dao.insert(model);
  Future<void> update(SalePricingDetailsModel model) => dao.update(model);
  Future<void> delete(SalePricingDetailsModel model) => dao.delete(model);
  Future<void> deleteById(int id) => dao.deleteById(id);

  static Future<void> bulkInsert(List<SalePricingDetailsModel> model) async {
    var exist = await dao.getByCompanySlug();
    await BaseRepository.bulkInsertOrUpdate<SalePricingDetailsModel>(models: model, tableName: Tables.SalesPriceDetail, idField: "id", getExistingData: exist, toJson: (model) => model.toJson());
  }
}
