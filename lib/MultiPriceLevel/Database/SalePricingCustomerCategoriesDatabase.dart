import 'package:sa_common/Controller/BaseRepository.dart';
import 'package:sa_common/MultiPriceLevel/Model/SalePricingCustomerCategoriesModel.dart';
import 'package:sa_common/utils/TablesName.dart';

class SalePricingCustomerCategoriesDatabase {
  static final dao = BaseRepository<SalePricingCustomerCategoriesModel>(SalePricingCustomerCategoriesModel(), tableName: Tables.SalePricingCustomerCategories);
  Future<SalePricingCustomerCategoriesModel> find(int id) => dao.find(id);
  Future<List<SalePricingCustomerCategoriesModel>> getAll() => dao.getAll();
  Future<List<SalePricingCustomerCategoriesModel>> getByCompanySlug() => dao.getByCompanySlug();
  Future<int> insert(SalePricingCustomerCategoriesModel model) => dao.insert(model);
  Future<void> update(SalePricingCustomerCategoriesModel model) => dao.update(model);
  Future<void> delete(SalePricingCustomerCategoriesModel model) => dao.delete(model);
  Future<void> deleteById(int id) => dao.deleteById(id);

  static Future<void> bulkInsert(List<SalePricingCustomerCategoriesModel> model) async {
    var exist = await dao.getByCompanySlug();
    await BaseRepository.bulkInsertOrUpdate<SalePricingCustomerCategoriesModel>(models: model, tableName: Tables.SalePricingCustomerCategories, idField: "id", getExistingData: exist, toJson: (model) => model.toJson());
  }
}
