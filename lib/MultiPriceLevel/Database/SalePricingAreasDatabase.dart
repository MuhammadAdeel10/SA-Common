import 'package:sa_common/Controller/BaseRepository.dart';
import 'package:sa_common/MultiPriceLevel/Model/SalePricingAreasModel.dart';
import 'package:sa_common/utils/TablesName.dart';

class SalePricingAreasDatabase {
  static final dao = BaseRepository<SalePricingAreasModel>(SalePricingAreasModel(), tableName: Tables.SalePricingAreas);
  Future<SalePricingAreasModel> find(int id) => dao.find(id);
  Future<List<SalePricingAreasModel>> getAll() => dao.getAll();
  Future<List<SalePricingAreasModel>> getByCompanySlug() => dao.getByCompanySlug();
  Future<int> insert(SalePricingAreasModel model) => dao.insert(model);
  Future<void> update(SalePricingAreasModel model) => dao.update(model);
  Future<void> delete(SalePricingAreasModel model) => dao.delete(model);
  Future<void> deleteById(int id) => dao.deleteById(id);

  static Future<void> bulkInsert(List<SalePricingAreasModel> model) async {
    var exist = await dao.getByCompanySlug();
    await BaseRepository.bulkInsertOrUpdate<SalePricingAreasModel>(models: model, tableName: Tables.SalePricingAreas, idField: "id", getExistingData: exist, toJson: (model) => model.toJson());
  }
}
