import 'package:sa_common/Controller/BaseRepository.dart';
import 'package:sa_common/MultiPriceLevel/Model/SalePricingCustomersModel.dart';
import 'package:sa_common/utils/TablesName.dart';

class SalePricingCustomerDatabase {
  static final dao = BaseRepository<SalePricingCustomersModel>(SalePricingCustomersModel(), tableName: Tables.SalePricingCustomer);
  Future<SalePricingCustomersModel> find(int id) => dao.find(id);
  Future<List<SalePricingCustomersModel>> getAll() => dao.getAll();
  Future<List<SalePricingCustomersModel>> getByCompanySlug() => dao.getByCompanySlug();
  Future<int> insert(SalePricingCustomersModel model) => dao.insert(model);
  Future<void> update(SalePricingCustomersModel model) => dao.update(model);
  Future<void> delete(SalePricingCustomersModel model) => dao.delete(model);
  Future<void> deleteById(int id) => dao.deleteById(id);

  static Future<void> bulkInsert(List<SalePricingCustomersModel> model) async {
    var exist = await dao.getByCompanySlug();
    await BaseRepository.bulkInsertOrUpdate<SalePricingCustomersModel>(models: model, tableName: Tables.SalePricingCustomer, idField: "id", getExistingData: exist, toJson: (model) => model.toJson());
  }
}
