import 'package:sa_common/Controller/BaseRepository.dart';
import 'package:sa_common/MultiPriceLevel/Model/SalePricingRegionsModel.dart';
import 'package:sa_common/utils/TablesName.dart';

class SalePricingRegionDatabase {
  static final dao = BaseRepository<SalePricingRegionsModel>(SalePricingRegionsModel(), tableName: Tables.SalePricingRegions);
  Future<SalePricingRegionsModel> find(int id) => dao.find(id);
  Future<List<SalePricingRegionsModel>> getAll() => dao.getAll();
  Future<List<SalePricingRegionsModel>> getByCompanySlug() => dao.getByCompanySlug();
  Future<int> insert(SalePricingRegionsModel model) => dao.insert(model);
  Future<void> update(SalePricingRegionsModel model) => dao.update(model);
  Future<void> delete(SalePricingRegionsModel model) => dao.delete(model);
  Future<void> deleteById(int id) => dao.deleteById(id);

  static Future<void> bulkInsert(List<SalePricingRegionsModel> model) async {
    var exist = await dao.getByCompanySlug();
    await BaseRepository.bulkInsertOrUpdate<SalePricingRegionsModel>(models: model, tableName: Tables.SalePricingRegions, idField: "id", getExistingData: exist, toJson: (model) => model.toJson());
  }
}
