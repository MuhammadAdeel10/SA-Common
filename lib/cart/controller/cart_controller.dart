import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:sa_common/MultiPriceLevel/Controller/SalesPriceController.dart';
import 'package:sa_common/MultiPriceLevel/Model/SalePriceParams.dart';
import 'package:sa_common/cart/database/cart_database.dart';
import 'package:sa_common/cart/database/cart_discount_database.dart';
import 'package:sa_common/cart/model/cart_discountView_model.dart';
import 'package:sa_common/cart/model/cart_discount_model.dart';
import 'package:sa_common/cart/model/cart_model.dart';
import 'package:sa_common/Controller/BaseController.dart';
import 'package:sa_common/HttpService/Basehttp.dart';
import 'package:sa_common/SyncSetting/Database.dart';
import 'package:sa_common/sale_order/database/sale_order_detail_database.dart';
import 'package:sa_common/sale_order/database/sale_order_detail_tax_database.dart';
import 'package:sa_common/schemes/Database/discount_database.dart';
import 'package:sa_common/schemes/Database/subArea_database.dart';
import 'package:sa_common/schemes/controllers/schemes_controller.dart';
import 'package:sa_common/schemes/models/discount_model.dart';
import 'package:sa_common/schemes/models/invoiceDetailTaxModel.dart';
import 'package:sa_common/schemes/models/invoiceModel.dart';
import 'package:sa_common/schemes/models/product_model.dart';
import 'package:sa_common/synchronization/Database/customer_database.dart';
import 'package:sa_common/utils/ApiEndPoint.dart';
import 'package:sa_common/utils/Enums.dart';
import 'package:sa_common/utils/Helper.dart';
import 'package:sa_common/utils/TablesName.dart';
// import 'package:sa_common/utils/utils.dart';

class CartController extends BaseController {
  late RxList<TextEditingController> qtyTextEditingController;
  SchemesController schemesController = Get.put(SchemesController());
  SchemeInvoiceModel schemeModel = SchemeInvoiceModel(invoiceDetails: [], invoiceDiscounts: []);
  late List<int> qty;
  RxNum taxes = RxNum(0);
  RxNum schemeDiscountPercent = RxNum(0);
  RxNum schemeDiscountAmount = RxNum(0);
  RxList<String> discountSelectedList = RxList.empty();
  RxList<LineItemTaxModel> taxesList = RxList.empty();
  RxInt discount = 0.obs;
  RxBool discountAmount = false.obs;
  RxNum productAmount = RxNum(0);
  RxNum netAmount = RxNum(0);
  RxNum cartItemCount = RxNum(0);

  void initializeList() {
    var length = Helper.productList.length;
    discountSelectedList = ["%", Helper.homeCurrency, "dp"].obs;

    qtyTextEditingController = List.generate(length, (_) => TextEditingController(text: "1")).obs;
    qty = List.generate(length, (_) => 1);
  }

  void incrementCartItemCount(num count) {
    cartItemCount.value += count;
    update();
  }

  Future<void> loadSavedTaxes({int? saleOrderDetailId}) async {
    var savedTaxes = await SaleOrderDetailTaxesDatabase.dao.SelectList("saleOrderDetailId = ${saleOrderDetailId}");

    if (savedTaxes != null) {
      for (var savedTax in savedTaxes) {
        if (!(taxesList.any((element) => element.taxId == savedTax.taxId))) ;
        savedTax.tax = Helper.taxModel.firstWhere((element) => element.id == savedTax.taxId);
        taxesList.add(savedTax);
      }
    }
  }

  Future<void> qtyUpdate(CartModel model, int index, {bool isPlus = true, BuildContext? context}) async {
    if (model.isAppliedScheme) {
      return;
    }
    if (isPlus) {
      qty[index]++;
      qtyTextEditingController[index].text = qty[index].toString();
      model.qty = num.parse(qty[index].toString());
      update();
    } else {
      if (qty[index] > 0) {
        qty[index]--;
        qtyTextEditingController[index].text = qty[index].toString();
        model.qty = num.parse(qty[index].toString());
        update();
      }
    }
    update();
  }

  Future<CartModel> UpdateCartQty(CartModel model, String qty) async {
    int previousQty = model.qty.toInt();
    if (qty.isNotEmpty) {
      if (qty.characters.last == ".") {
        model.qty = num.parse("$qty");
        return model;
      }
      num qtyParse = num.parse(qty);
      if (model.qty != qtyParse) {
        model.qty = qtyParse;
      }
    } else {
      model.qty = 0;
    }
    if (model.discountType == null)
      model.grossAmount = (await this.CalculateTotalPrice(model)).grossAmount;
    else {
      model.grossAmount = this.calculateDiscount(model);
      model.netAmount = this.calculateDiscount(model);
    }
    await CartDatabase.dao.update(model);
    Helper.cartList[Helper.cartList.indexWhere((element) => element.id == model.id)] = model;
    incrementCartItemCount(model.qty.toInt() - previousQty);
    update();
    return model;
  }

  Future<CartModel> UpdatePrice(CartModel model, String price) async {
    if (price.isNotEmpty || price != "") {
      if (price.characters.last == ".") {
        model.price = num.parse("$price");
        return model;
      }
      num parsePrice = num.parse(price);
      if (model.price != parsePrice) {
        model.price = parsePrice;
      }
    } else {
      model.price = 0;
    }
    if (model.discountType == null)
      model.grossAmount = (await this.CalculateTotalPrice(model)).grossAmount;
    else {
      model.grossAmount = this.calculateDiscount(model);
      model.netAmount = this.calculateDiscount(model);
    }
    await CartDatabase.dao.update(model);
    Helper.cartList[Helper.cartList.indexWhere((element) => element.id == model.id)] = model;
    update();
    return model;
  }

  num calculateDiscount(CartModel model) {
    var totalPrice = model.qty * model.price;
    if (model.discountInAmount == DiscountType.Amount) {
      totalPrice = totalPrice - model.discountInAmount!;
    } else {
      totalPrice = totalPrice - (totalPrice / 100 * (model.discountInPercent ?? 0));
    }
    return totalPrice;
  }

  Future<num> GetPrice({required ProductModel product, required date, required int customerId}) async {
    SalesPriceController salesPriceController = Get.put(SalesPriceController());
    if (Helper.requestContext.enableSalePricing) {
      var param = SalePriceFilter(compaluSlug: Helper.user.companyId ?? "", enableGeography: Helper.requestContext.enableSalesGeography, productId: product.id!, currencyId: (Helper.requestContext.currencyId ?? 1), date: date, customerId: customerId, branchId: Helper.user.branchId);
      if (customerId != 0) {
        var customer = await CustomerDatabase.dao.find(customerId);
        if (customer.subAreaId != null) {
          var subArea = await SubAreasDatabase.dao.find(customer.subAreaId!);
          param.regionId = subArea.regionId;
          param.zoneId = subArea.zoneId;
          param.territoryId = subArea.territoryId;
          param.areaId = subArea.areaId;
          param.subAreaId = customer.subAreaId;
        }
        if (customer.customerCategoryId != null) {
          param.customerCategoryId = customer.customerCategoryId;
        }
      }
      var price = await salesPriceController.getSalePrice(filter: param);
      if (price != null) return price.price;
    }
    return product.salePrice;
  }

  Future<bool> AddCart(ProductModel productModel, num qty, {int? index, required int customerId}) async {
    var cart = Helper.cartList.firstWhereOrNull((element) => element.productId == productModel.id);
    num productPrice = await GetPrice(product: productModel, date: Helper.OnlyDateToday(), customerId: customerId);

    if (cart != null && !cart.isAppliedScheme && Helper.requestContext.allowDuplicateProducts == false) {
      cart.qty += qty;
      var calculate = await CalculateTotalPrice(cart);
      cart.grossAmount = calculate.grossAmount;
      cart.netAmount = calculate.netAmount;
      await CartDatabase.dao.update(cart);
    } else {
      var newCartItem = CartModel(
        productId: productModel.id,
        productName: productModel.name,
        price: productPrice,
        qty: qty,
        fractionalUnit: productModel.fractionalUnit,
        customerId: customerId,
        isMRPExclusiveTax: productModel.isMRPExclusiveTax,
        purchasePrice: productModel.purchasePrice,
        maximumRetailPrice: productModel.maximumRetailPrice,
        totalTaxAmonut: productModel.saleTaxes?.first.taxAmount,
        isNew: true,
      );
      var calculate = await CalculateTotalPrice(newCartItem);
      newCartItem.grossAmount = calculate.grossAmount;
      newCartItem.netAmount = calculate.netAmount;
      newCartItem.description = productModel.description;
      await CartDatabase.dao.insert(newCartItem);
    }
    _resetQtyController(index);
    incrementCartItemCount(qty);
    await GetCarts();

    update();
    return true;
  }

  void _resetQtyController(int? index) {
    if (index != null) {
      qty[index] = 1;
      qtyTextEditingController[index].text = qty[index].toString();
    }
  }

  Future<CartModel> DiscountAdd(int discountType, int cartId, CartModel model, {String? discountValue}) async {
    var cartDiscountDb = CartDiscountDatabase();
    var cartDiscount = await cartDiscountDb.getDiscountByCartId(cartId);
    var discount = await DiscountDatabase.DefaultDiscount();
    CartDiscountModel discountModel = CartDiscountModel();
    if (discountValue!.isNotEmpty) {
      if (discountValue.characters.last == ".") {
        model.price = num.parse("$discountValue");
        return model;
      }
    }
    if (discountType == DiscountType.Percent.value) {
      discountModel.discountType = DiscountType.Percent;
      discountModel.discountInPercent = num.parse(discountValue != "" ? discountValue : "0");
      discountModel.discountInAmount = (model.price * model.qty) * discountModel.discountInPercent! / 100;
    } else if (discountType == DiscountType.Amount.value) {
      discountModel.discountType = DiscountType.Amount;
      discountModel.discountInAmount = num.parse(discountValue != "" ? discountValue : "0");
    } else {
      discountModel.discountType = DiscountType.Price;
      discountModel.discountInAmount = model.price - num.parse(discountValue != "" ? discountValue : "0");
      discountModel.discountInPrice = num.parse(discountValue != "" ? discountValue : "0");
    }
    if (discount != null) discountModel.discountId = discount.id!;
    discountModel.cartId = cartId;
    if ((discountModel.discountInAmount != null && discountModel.discountInAmount != 0) || (discountModel.discountInPercent != null && discountModel.discountInPercent != 0)) {
      if (cartDiscount.length == 1) {
        discountModel.id = cartDiscount[0].id;
        discountModel.companySlug = cartDiscount[0].companySlug;
        await cartDiscountDb.update(discountModel);
        //Update
      } else {
        discountModel.isSync = false;
        await cartDiscountDb.insert(discountModel);
        //Insert
      }
    }
    model = await CartDatabase.dao.find(cartId);
    var calculate = await this.CalculateTotalPrice(model);
    model.netAmount = calculate.netAmount;
    model.grossAmount = calculate.grossAmount;
    model.discountInAmount = model.cartDiscounts?.fold<num>(0, (previousValue, element) => previousValue + (element.discountAmount ?? 0));
    model.discountInPercent = model.cartDiscounts?.fold<num>(0, (previousValue, element) => previousValue + (element.discountInPercent ?? 0));
    await CartDatabase.dao.update(model);
    Helper.cartList.value = await GetCarts();
    return model;
  }

  Future<void> CalculateAllDiscount({int? cartId, required int customerId}) async {
    schemeModel = await schemesController.MapCartToInvoice(customerId, cartModelList: Helper.cartList);
    await CalculateTax(schemeModel);
    await GetCarts();
  }

  Future<void> checkSchemes(SchemeInvoiceModel model) async {
    var companySlug = Helper.user.companyId ?? "";
    var cartDb = await CartDatabase();
    List<CartModel> lstCartModel = [];
    taxesList.value = [];
    for (var detail in model.invoiceDetails.where((element) => element.isBonusProduct == true)) {
      var cartModel = CartModel();
      if (detail.id == null) {
        cartModel.productId = detail.productId;
        cartModel.productName = detail.product!.name;
        cartModel.qty = detail.quantity ?? 0;
        cartModel.grossAmount = detail.grossAmount ?? 0;
        cartModel.netAmount = detail.netAmount ?? 0;
        cartModel.price = detail.price ?? 0;
        cartModel.purchasePrice = detail.purchasePrice ?? 0;
        cartModel.maximumRetailPrice = detail.maximumRetailPrice ?? 0;
        cartModel.companySlug = companySlug;
        cartModel.serialNumber = detail.serialNumber;
        cartModel.batchId = detail.batchId;
        cartModel.isAppliedScheme = true;
        cartModel.totalTaxAmonut = detail.taxAmount;
        cartModel.fractionalUnit = detail.product!.fractionalUnit;
        cartModel.description = detail.description;
        lstCartModel.add(cartModel);
      }
    }
    await cartDb.bulkInsert(lstCartModel, Helper.cartList, companySlug);
    if (model.invoiceDiscounts.isNotEmpty) {
      schemeDiscountPercent.value = model.invoiceDiscounts.fold<num>(0, (previousValue, element) => previousValue + (element.discountPercent ?? 0));
      schemeDiscountAmount.value = model.invoiceDiscounts.fold<num>(0, (previousValue, element) => previousValue + (element.discountAmount ?? 0));
    } else {
      schemeDiscountPercent.value = 0;
      schemeDiscountAmount.value = 0;
    }
    if (model.invoiceDetails.isNotEmpty) {
      for (var detail in model.invoiceDetails) {
        List<CartDiscountModel> cartDiscounts = [];
        var cartModel = CartModel();
        if (detail.discounts != null && detail.discounts!.isNotEmpty) {
          for (var discount in detail.discounts!.where((element) => element.schemeId != null)) {
            if (discount.id != null) {
              await CartDiscountDatabase.dao.deleteById(discount.id!);
            } else {
              var cartDiscount = CartDiscountModel();
              cartDiscount.cartId = detail.id;
              cartDiscount.companySlug = companySlug;
              cartDiscount.discountId = discount.discountId;
              cartDiscount.discountAmount = discount.discountAmount;
              cartDiscount.discountInAmount = discount.discountAmount;
              cartDiscount.discountInPercent = discount.discountInPercent;
              cartDiscount.discountType = discount.discountType;
              cartDiscount.schemeDetailId = discount.schemeDetailId;
              cartDiscount.schemeId = discount.schemeId;
              cartModel.isProductScheme = true;
              cartModel.description = detail.description;
              cartDiscounts.add(cartDiscount);
            }
          }
          await CartDiscountDatabase.bulkInsert(cartDiscounts, productId: detail.productId, slug: companySlug);
        } else {
          await CartDiscountDatabase().deleteBySchemeId(detail.productId ?? 0);
        }
        cartModel.productId = detail.productId;
        cartModel.productName = detail.product != null ? detail.product!.name : "";
        cartModel.qty = detail.quantity ?? 0;
        cartModel.companySlug = companySlug;
        cartModel.discountInPercent = detail.discountInPercent;
        cartModel.discountInAmount = detail.discountAmount;
        cartModel.discountType = intToDiscountType(detail.discountType ?? 0);
        cartModel.grossAmount = detail.grossAmount ?? 0;
        cartModel.purchasePrice = detail.purchasePrice ?? 0;
        cartModel.maximumRetailPrice = detail.maximumRetailPrice ?? 0;
        cartModel.netAmount = detail.netAmount ?? 0;
        cartModel.price = detail.price ?? 0;
        cartModel.id = detail.id;
        cartModel.serialNumber = detail.serialNumber;
        cartModel.batchId = detail.batchId;
        cartModel.fractionalUnit = detail.product != null ? detail.product!.fractionalUnit : false;
        cartModel.totalTaxAmonut = (detail.taxAmount ?? 0);
        cartModel.description = detail.description;
        var db = SaleOrderDetailTaxesDatabase.dao;
        var savedTaxes = await db.SelectList("saleOrderDetailId = ${detail.id}");
        if (detail.taxes != null) {
          for (var element in detail.taxes!) {
            element.id = null;
            element.saleOrderDetailId = detail.id;
            element.tax = Helper.taxModel.firstWhere((p0) => p0.id == element.taxId);

            if (savedTaxes != null) {
              var isTaxAdd = (savedTaxes.any((a) => (a.taxId == element.taxId)));
              if (isTaxAdd != true) {
                await db.insert(element);
              }
            } else {
              await db.insert(element);
            }
          }
        }
        await cartDb.update(cartModel);
        await GetCarts();
      }
    }
  }

  Future<void> deleteById(int id, int index) async {
    var cartItem = Helper.cartList.firstWhere((e) => e.id == id);
    await CartDatabase.dao.deleteById(id);
    Helper.cartList.removeWhere((e) => e.id == id);
    await SaleOrderDetailDatabase.dao.deleteById(id);
    incrementCartItemCount(-cartItem.qty.toInt());
    update();
  }

  Future<void> cartItemDelete() async {
    await CartDatabase().DeleteAll();
    Helper.cartList.clear();
  }

  Future<void> CalculateTax(SchemeInvoiceModel model) async {
    for (var detail in model.invoiceDetails) {
      var cartDb = await CartDatabase();
      var cart = await CartDatabase.dao.SelectSingle("id = ${detail.id}");
      if (cart != null) {
        cart.totalTaxAmonut = detail.taxAmount;
        await cartDb.update(cart);
      }
    }
  }

  Future<CartModel> CalculateTotalPrice(CartModel cartModel) async {
    cartModel.grossAmount = cartModel.qty * cartModel.price;
    if (cartModel.cartDiscounts == null) {
      if (cartModel.id != null) {
        cartModel.cartDiscounts = await CartDiscountDatabase().getDiscountByCartId(cartModel.id!);
      }
      if (cartModel.cartDiscounts == null) {
        cartModel.cartDiscounts = [];
      }
    }
    for (var detailDiscount in cartModel.cartDiscounts!) {
      if (detailDiscount.discountType != null) {
        switch (detailDiscount.discountType!) {
          case DiscountType.Percent:
            detailDiscount.discountAmount = (cartModel.grossAmount * (detailDiscount.discountInPercent ?? 0)) / 100;
            break;
          case DiscountType.Amount:
            detailDiscount.discountAmount = detailDiscount.discountInAmount;
            break;
          case DiscountType.Price:
            detailDiscount.discountAmount = cartModel.qty * (detailDiscount.discountInAmount ?? 0);
            break;
        }
      }
    }
    cartModel.discountInAmount = cartModel.cartDiscounts!.fold<num>(0, (previousValue, element) => previousValue + (element.discountAmount ?? 0));
    num netAmount = cartModel.grossAmount - (cartModel.discountInAmount ?? 0);
    cartModel.netAmount = netAmount;
    return cartModel;
  }

  Future<List<CartModel>> GetCarts() async {
    var carts = await CartDatabase().getByCartID();
    Helper.cartList.value = carts;
    return carts;
  }

  Future<void> DiscountPull(String slug) async {
    var getSyncSetting = await SyncSettingDatabase.GetByTableName(Tables.Discount, slug: slug);
    DateTime syncDate = DateTime.now().toUtc();
    var response = await BaseClient().get(ApiEndPoint.baseUrl, "$slug${ApiEndPoint.getDiscount}").catchError(
      (error) {
        handleError(error);
      },
    );
    if (response != null) {
      var pullData = DiscountModel().FromJson(response.body, slug);
      DiscountDatabase.bulkInsert(pullData);
      getSyncSetting.companySlug = slug;
      getSyncSetting.syncDate = syncDate;
      getSyncSetting.isSync = true;
      await SyncSettingDatabase.dao.update(getSyncSetting);
    }
  }

  Future<void> DiscountDelete(String slug) async {
    var getSyncSetting = await SyncSettingDatabase.GetByTableName(Tables.Discount, slug: slug);
    DateTime syncDate = DateTime.now().toUtc();
    var getAll = await DiscountDatabase.dao.getAll();
    var getSyncSettingDate = getSyncSetting.syncDate;
    final String formatted = Helper.dateFormatter.format(getSyncSettingDate ?? DateTime.now());
    var response = await BaseClient().get(ApiEndPoint.baseUrl, "${slug}${ApiEndPoint.deleteDiscount}${formatted}").catchError(
      (error) {
        handleError(error);
      },
    );

    if (response != null) {
      var models = DiscountModel().FromJson(response.body, slug);

      if (models.any((element) => true)) {
        for (var model in models) {
          var exist = getAll.any((element) => element.id == model.id);
          if (exist) {
            await DiscountDatabase.dao.deleteById(model.id!);
          }
        }
        getSyncSetting.companySlug = slug;
        getSyncSetting.syncDate = syncDate;
        getSyncSetting.isSync = true;
        await SyncSettingDatabase.dao.update(getSyncSetting);
      }
    }
  }

  Future<List<CartDiscountViewModel>> GetCartDiscount(int cartId) async {
    List<CartDiscountViewModel> lst = RxList.empty();
    lst = await CartDiscountDatabase().getCartDiscount(cartId);
    return lst;
  }

  Future<void> DeleteDiscount(int id, {CartModel? model, required int customerId}) async {
    await CartDiscountDatabase.dao.deleteById(id);
    if (model != null) {
      model.cartDiscounts?.removeWhere((element) => element.id == id);
      var calculate = await CalculateTotalPrice(model);
      model.netAmount = calculate.netAmount;
      model.grossAmount = calculate.grossAmount;
      model.discountInAmount = model.cartDiscounts?.fold<num>(0, (previousValue, element) => previousValue + (element.discountAmount ?? 0));
      model.discountInPercent = model.cartDiscounts?.fold<num>(0, (previousValue, element) => previousValue + (element.discountInPercent ?? 0));

      model.discountType = null;
      await CartDatabase.dao.update(model);
      await CalculateAllDiscount(cartId: model.id!, customerId: customerId);
    }
    Helper.cartList.value = await GetCarts();
  }

  Future<List<DiscountModel>> GetAllDiscountType() async {
    Future.delayed(Duration(seconds: 1));
    var data = await DiscountDatabase.dao.getByCompanySlug();
    return data;
  }

  Future<void> AddDiscount(int discountId, String amount, DiscountType discountType, int cartId, {required int customerId}) async {
    var model = CartDiscountModel(
      cartId: cartId,
      discountId: discountId,
    );
    var cart = await CartDatabase.dao.find(cartId);

    if (discountType == DiscountType.Percent) {
      model.discountInPercent = num.parse(amount);
      model.discountType = DiscountType.Percent;
      model.discountAmount = cart.grossAmount * model.discountInPercent! / 100;
    } else if (discountType == DiscountType.Amount) {
      model.discountInAmount = num.tryParse(amount);
      model.discountAmount = model.discountInAmount;
      model.discountType = DiscountType.Amount;
    } else {
      model.discountInAmount = num.tryParse(amount);
      model.discountAmount = model.discountInAmount;
      model.discountType = DiscountType.Price;
    }

    await CartDiscountDatabase.dao.insert(model);
    var calculate = await this.CalculateTotalPrice(cart);
    cart.grossAmount = calculate.grossAmount;
    cart.netAmount = calculate.netAmount;
    await CartDatabase.dao.update(cart);
    await CalculateAllDiscount(cartId: cartId, customerId: customerId);
  }

  Future<void> GetCart() async {
    Helper.cartList.value = await CartDatabase.dao.getByCompanySlug();
    var model = await schemesController.MapCartToInvoice(Helper.user.customerId ?? 0, cartModelList: Helper.cartList);
    if (Helper.requestContext.enableScheme == true) {
      await checkSchemes(model);
    }
    cartItemCount.value = 0;
    var count = Helper.cartList.fold<num>(0, (previousValue, element) => previousValue + element.qty);
    incrementCartItemCount(count);
  }
}
