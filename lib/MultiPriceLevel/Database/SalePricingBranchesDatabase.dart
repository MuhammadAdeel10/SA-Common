import 'package:sa_common/Controller/BaseRepository.dart';
import 'package:sa_common/MultiPriceLevel/Model/SalePricingBranchesModel.dart';
import 'package:sa_common/utils/TablesName.dart';

class SalePricingBranchesDatabase {
  static final dao = BaseRepository<SalePricingBranchesModel>(SalePricingBranchesModel(), tableName: Tables.SalePricingBranches);
  Future<SalePricingBranchesModel> find(int id) => dao.find(id);
  Future<List<SalePricingBranchesModel>> getAll() => dao.getAll();
  Future<List<SalePricingBranchesModel>> getByCompanySlug() => dao.getByCompanySlug();
  Future<int> insert(SalePricingBranchesModel model) => dao.insert(model);
  Future<void> update(SalePricingBranchesModel model) => dao.update(model);
  Future<void> delete(SalePricingBranchesModel model) => dao.delete(model);
  Future<void> deleteById(int id) => dao.deleteById(id);

  static Future<void> bulkInsert(List<SalePricingBranchesModel> model) async {
    var exist = await dao.getByCompanySlug();
    await BaseRepository.bulkInsertOrUpdate<SalePricingBranchesModel>(models: model, tableName: Tables.SalePricingBranches, idField: "id", getExistingData: exist, toJson: (model) => model.toJson());
  }
}
