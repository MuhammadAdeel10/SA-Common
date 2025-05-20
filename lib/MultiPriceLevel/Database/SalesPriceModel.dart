import 'package:sa_common/Controller/BaseRepository.dart';
import 'package:sa_common/MultiPriceLevel/Model/SalesPriceModel.dart';
import 'package:sa_common/utils/TablesName.dart';

class SalePricingDatabase {
  static final dao = BaseRepository<SalePricingsModel>(SalePricingsModel(), tableName: Tables.SalesPrice);
  Future<SalePricingsModel> find(int id) => dao.find(id);
  Future<List<SalePricingsModel>> getAll() => dao.getAll();
  Future<List<SalePricingsModel>> getByCompanySlug() => dao.getByCompanySlug();
  Future<int> insert(SalePricingsModel model) => dao.insert(model);
  Future<void> update(SalePricingsModel model) => dao.update(model);
  Future<void> delete(SalePricingsModel model) => dao.delete(model);
  Future<void> deleteById(int id) => dao.deleteById(id);

  static Future<void> bulkInsert(List<SalePricingsModel> model) async {
    var exist = await dao.getByCompanySlug();
    await BaseRepository.bulkInsertOrUpdate<SalePricingsModel>(models: model, tableName: Tables.SalesPrice, idField: "id", getExistingData: exist, toJson: (model) => model.toJson());
  }
}
