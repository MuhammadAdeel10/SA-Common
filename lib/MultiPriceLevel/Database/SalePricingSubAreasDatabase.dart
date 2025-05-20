import 'package:sa_common/Controller/BaseRepository.dart';
import 'package:sa_common/MultiPriceLevel/Model/SalePricingSubAreasModel.dart';
import 'package:sa_common/utils/TablesName.dart';

class SalePricingSubAreaDatabase {
  static final dao = BaseRepository<SalePricingSubAreasModel>(SalePricingSubAreasModel(), tableName: Tables.SalePricingSubAreas);
  Future<SalePricingSubAreasModel> find(int id) => dao.find(id);
  Future<List<SalePricingSubAreasModel>> getAll() => dao.getAll();
  Future<List<SalePricingSubAreasModel>> getByCompanySlug() => dao.getByCompanySlug();
  Future<int> insert(SalePricingSubAreasModel model) => dao.insert(model);
  Future<void> update(SalePricingSubAreasModel model) => dao.update(model);
  Future<void> delete(SalePricingSubAreasModel model) => dao.delete(model);
  Future<void> deleteById(int id) => dao.deleteById(id);

  static Future<void> bulkInsert(List<SalePricingSubAreasModel> model) async {
    var exist = await dao.getByCompanySlug();
    await BaseRepository.bulkInsertOrUpdate<SalePricingSubAreasModel>(models: model, tableName: Tables.SalePricingSubAreas, idField: "id", getExistingData: exist, toJson: (model) => model.toJson());
  }
}
