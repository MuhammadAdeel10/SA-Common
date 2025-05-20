import 'package:sa_common/Controller/BaseRepository.dart';
import 'package:sa_common/MultiPriceLevel/Model/SalePricingZonesModel.dart';
import 'package:sa_common/utils/TablesName.dart';

class SalePricingZoneDatabase {
  static final dao = BaseRepository<SalePricingZonesModel>(SalePricingZonesModel(), tableName: Tables.SalePricingZones);
  Future<SalePricingZonesModel> find(int id) => dao.find(id);
  Future<List<SalePricingZonesModel>> getAll() => dao.getAll();
  Future<List<SalePricingZonesModel>> getByCompanySlug() => dao.getByCompanySlug();
  Future<int> insert(SalePricingZonesModel model) => dao.insert(model);
  Future<void> update(SalePricingZonesModel model) => dao.update(model);
  Future<void> delete(SalePricingZonesModel model) => dao.delete(model);
  Future<void> deleteById(int id) => dao.deleteById(id);

  static Future<void> bulkInsert(List<SalePricingZonesModel> model) async {
    var exist = await dao.getByCompanySlug();
    await BaseRepository.bulkInsertOrUpdate<SalePricingZonesModel>(models: model, tableName: Tables.SalePricingZones, idField: "id", getExistingData: exist, toJson: (model) => model.toJson());
  }
}
