class ApiEndPoint {
  // static const baseUrl = "http://localhost:44356/api/";
  static String baseUrl = "";
  // static const ImageBaseUrl = "https://qa.splendidaccounts.com/";
  static String ImageBaseUrl = "";

  static const logIn = "auth/login";
  static const refreshToken = "auth/refreshToken";
  static const getAllCompanies = "companies";
  static const licenseStatus = "/LicenseActiveSubscription/LicenseStatus";
  static const allActiveSubscription =
      "/LicenseActiveSubscription/AllActiveSubscription";
  static const getAllProduct = "/Products/Updated?start=";
  static const getProductCategories = "ProductCategories/Updated?start=";
  static const defaultContacts = "/Contacts/Default";
  static const brands = "/Brands";
  static const getUnit = "/products/Unit";
  static const getTaxes = "/Taxes/Updated?";
  static const deleteCategories = "/ProductCategories/Deleted?start=";
  static const deleteProduct = "/Products/Deleted?start=";
  static const getCountries = "countries";
  static const getCurrencies = "Currencies";
  static const getCustomerCategories = "CustomerCategories/Updated?start=";
  static const deleteCustomerCategories = "/CustomerCategories/Deleted?start=";
  static const getCustomer = "/customers/ModifiedBetween/";
  static const deleteCustomer = "/customers/Deleted?start=";
  static const getMasterGroups = "/masterGroups/Updated?start=";
  static const deleteMasterGroups = "/masterGroups/Deleted?start=";
  static const getDetailBGroups = "/detailbgroups/Updated?start=";
  static const deleteDetailBGroups = "/detailbgroups/Deleted?start=";
  static const getDetailAGroups = "/detailAGroups/Updated?start=";
  static const deleteDetailAGroups = "/detailAGroups/Deleted?start=";
  static const getAccounts = "/Accounts/Updated?start=";
  static const deleteAccounts = "/Accounts/Deleted?start=";
  static const getDiscount = "/Discounts/Updated?start=";
  static const deleteDiscount = "/Discounts/Deleted?start=";
  static const getSalesPersons = "/salesPersons/Updated?start=";
  static const deleteSalesPersons = "/salesPersons/Deleted?start=";
  static const getWarehouses = "/Warehouses";
  static const posCashRegisters = "/PosCashRegisters/Updated?start=";
  static const forgotPassword = "auth/RequestPassword";
  static const branches = "Branches/Users/";
  static const reserve = "/PosCashRegisters/CheckReserveCounter";
  static const getProposedNumber =
      "/PosCashRegisters/GetLastNumberOfSeries?series=";
  static const schemes = "/Schemes/ModifiedBetween/";
  static const regions = "/Regions/ModifiedBetween/";
  static const zones = "/Zones/ModifiedBetween/";
  static const areas = "/Areas/ModifiedBetween/";
  static const subareas = "/SubAreas/ModifiedBetween/";
  static const territories = "/Territories/ModifiedBetween/";
  static const bulkUpdate = "/PosInvoices/SaveAndApprove";
  static const getBatches = "/Batches/ModifiedBetween/";
  static const getProductStocks = "/Products/ModifiedBetween/";
  static const getTransaction =
      "/PosCashRegisters/GetTransactionModifiedBetween/";
  static const getTemplateDefinitionPOSInvoice =
      "/TemplateDefinitions/PosInvoice/ActiveTemplates/";
  static const saleReturn = "/saleReturns/UnAllocatedByNumber/";
  static const fbrInvoiceNumber = "/PosInvoices/FBRInvoiceNo";
  static const creditNotes = "/creditNotes/UnAllocatedByNumber/";
  static const defaultBatchesByProductWarehouse =
      "/DefaultBatchesByProductWarehouse";
  static const cashAndBankAccounts =
      "/CashAndBankAccounts?currencyId=&includeHomeCurrency=true&isActive=true";
  static const fundTransfer = "/FundsTransfer/SaveAndApprove?";
  static const authorizeFundTransfer = "/FundsTransfer/AuthorizeFundTransfer?";
  static const attachmentsFundTransfer = "/attachments/FundTransfer/0";
  static const attachments = "/attachments/";
  static const downloadAttachments = "/attachments/doc/";
  static const getCustomerLoyaltyPoint =
      "/CustomerLoyatyPoint/ModifiedBetween/";
  static const getCustomerLoyaltyPointBalance =
      "/CustomerLoyatyPoint/CustomerLoyatyPointBalance/";
  static const EndOfTheFDay = "/EndOfDay/GetLastEndOfDay/";
}
