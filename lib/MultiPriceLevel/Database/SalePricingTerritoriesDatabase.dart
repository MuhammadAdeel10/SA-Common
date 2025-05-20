import 'package:sa_common/Controller/BaseRepository.dart';
import 'package:sa_common/MultiPriceLevel/Model/SalePricingTerritoriesModel.dart';
import 'package:sa_common/utils/TablesName.dart';

class SalePricingTerritoriesDatabase {
  static final dao = BaseRepository<SalePricingTerritoriesModel>(SalePricingTerritoriesModel(), tableName: Tables.SalePricingTerritories);
  Future<SalePricingTerritoriesModel> find(int id) => dao.find(id);
  Future<List<SalePricingTerritoriesModel>> getAll() => dao.getAll();
  Future<List<SalePricingTerritoriesModel>> getByCompanySlug() => dao.getByCompanySlug();
  Future<int> insert(SalePricingTerritoriesModel model) => dao.insert(model);
  Future<void> update(SalePricingTerritoriesModel model) => dao.update(model);
  Future<void> delete(SalePricingTerritoriesModel model) => dao.delete(model);
  Future<void> deleteById(int id) => dao.deleteById(id);

  static Future<void> bulkInsert(List<SalePricingTerritoriesModel> model) async {
    var exist = await dao.getByCompanySlug();
    await BaseRepository.bulkInsertOrUpdate<SalePricingTerritoriesModel>(models: model, tableName: Tables.SalePricingTerritories, idField: "id", getExistingData: exist, toJson: (model) => model.toJson());
  }
}
