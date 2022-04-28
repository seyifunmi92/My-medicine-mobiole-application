import 'package:flutter/material.dart';

class ShopByHealth {
  String asset;
  String text;
  ShopByHealth({required this.asset, required this.text});
}

class SanitaryAsset {
  String asset;
  String text;
  String category;
  SanitaryAsset(
      {required this.asset, required this.category, required this.text});
}

class CartCheckedBoxState {
  String text;
  bool isChecked = false;
  CartCheckedBoxState({required this.text, required this.isChecked});
}
class CartModel {
  String name;
  String price;
  int quantity;
  bool isChecked;
  String image;

  CartModel(
      {required this.name,
      required this.price,
      required this.quantity,
      required this.isChecked,
      required this.image});
}

class RefillOrders {
  String name;
  String orderNum;
  int quantity;
  String startDate;
  String refillCycle;
  String progress;

  RefillOrders(
      {required this.name,
      required this.orderNum,
      required this.quantity,
      required this.startDate,
      required this.refillCycle,
      required this.progress});
}

class User {
  String name;
  String email;
  int quantity;

  User({required this.name, required this.email, required this.quantity});
}

class OrderModel {
  String name;
  String price;
  int quantity;
  bool isChecked;
  String status;
  String orderStatus;
  String image;

  OrderModel(
      {required this.name,
      required this.price,
      required this.quantity,
      required this.isChecked,
      required this.status,
      required this.orderStatus,
      required this.image});
}

class ServerResponse {
  dynamic href;
  bool status;
  String message;
  String statusCode;
  dynamic errors;
  dynamic self;
  dynamic data;

  ServerResponse(
      {required this.href,
      required this.status,
      required this.message,
      required this.statusCode,
      required this.errors,
      required this.self,
      required this.data});

  factory ServerResponse.fromJson(Map<String, dynamic> json) {
    return ServerResponse(
      href: json['href'] as dynamic,
      status: json['status'] as bool,
      message: json['message'] as String,
      statusCode: json['statusCode'] as String,
      errors: json['errors'] as dynamic,
      self: json['self'] as dynamic,
      data: json['data'] as dynamic,
    );
  }
}

class AllData {
  int offset;
  int limit;
  int size;
  dynamic first;
  dynamic self;
  dynamic value;

  AllData({
    required this.offset,
    required this.limit,
    required this.size,
    required this.first,
    required this.self,
    required this.value,
  });

  factory AllData.fromJson(Map<String, dynamic> json) {
    return AllData(
      offset: json['offset'] as int,
      limit: json['limit'] as int,
      size: json['size'] as int,
      first: json['first'] as dynamic,
      self: json['self'] as dynamic,
      value: json['value'] as dynamic,
    );
  }
}

class WishlistValue {
  int? productId;
  String? productName;
  String? productImageUrl;
  int? bundleId;
  String? bundleName;
  String? bundleImageUrl;
  double? maxPrice;
  double? minPrice;
  int? quantity;
  double? modPrice;
  double? bundlePrice;

  // String bundleName;
  // String bundleImageUrl;

  WishlistValue({
    required this.productId,
    required this.productName,
    required this.productImageUrl,
    required this.bundleId,
    required this.bundleName,
    required this.bundleImageUrl,
    required this.maxPrice,
    required this.minPrice,
    required this.modPrice,
    required this.bundlePrice,
    required this.quantity,
  });

  factory WishlistValue.fromJson(Map<String, dynamic> json) {
    return WishlistValue(
      productId: json['productId'],
      productName: json['productName'],
      productImageUrl: json['productImageUrl'],
      bundleId: json['bundleId'],
      bundleName: json['bundleName'],
      maxPrice: json['maxPrice'],
      minPrice: json['minPrice'],
      modPrice: json['modPrice'],
      bundleImageUrl: json['bundleImageUrl'],
      bundlePrice: json['bundlePrice'],
      quantity: json['quantity'],
    );
  }
}

class AllBundle {
  int id;
  String name;
  int creatorUserId;
  int bundleId;
  int documentUploadId;
  int bundleCategoryId;
  String description;
  String highlight;
  double currentCost;
  String dateCreated;
  String dateModified;
  int clientOutletId;
  double price;
  dynamic deletedByUserId;
  String bundleCategory;
  dynamic bundleItems;

  AllBundle({
    required this.id,
    required this.name,
    required this.creatorUserId,
    required this.bundleId,
    required this.documentUploadId,
    required this.bundleCategoryId,
    required this.description,
    required this.highlight,
    required this.currentCost,
    required this.dateCreated,
    required this.dateModified,
    required this.clientOutletId,
    required this.price,
    required this.deletedByUserId,
    required this.bundleCategory,
    required this.bundleItems,
  });

  factory AllBundle.fromJson(Map<String, dynamic> json) {
    return AllBundle(
      id: json['id'],
      name: json['name'],
      creatorUserId: json['creatorUserId'],
      bundleId: json['bundleId'],
      documentUploadId: json['documentUploadId'],
      bundleCategoryId: json['bundleCategoryId'],
      description: json['description'],
      highlight: json['highlight'],
      currentCost: json['currentCost'],
      dateCreated: json['dateCreated'],
      dateModified: json['dateModified'],
      clientOutletId: json['clientOutletId'],
      price: json['price'],
      deletedByUserId: json['deletedByUserId'],
      bundleCategory: json['bundleCategory'],
      bundleItems: json['bundleItems'],
    );
  }
}

class BundleItem {
  int id;
  int bundleId;
  int productId;
  int quantity;
  int packSizeId;
  String productName;

  BundleItem({
    required this.id,
    required this.bundleId,
    required this.productId,
    required this.quantity,
    required this.packSizeId,
    required this.productName,
  });

  factory BundleItem.fromJson(Map<String, dynamic> json) {
    return BundleItem(
      id: json['id'],
      bundleId: json['bundleId'],
      productId: json['productId'],
      quantity: json['quantity'],
      packSizeId: json['packSizeId'],
      productName: json['productName'],
    );
  }
}

class MedUser {
  String firstName;
  String lastName;
  String email;
  String phoneNumber;
  String userName;
  Object role;
  Object token;

  MedUser(
      {required this.firstName,
      required this.lastName,
      required this.email,
      required this.phoneNumber,
      required this.userName,
      required this.role,
      required this.token});

  factory MedUser.fromJson(Map<String, dynamic> json) {
    return MedUser(
      firstName: json['firstName'],
      lastName: json['lastName'],
      email: json['email'],
      phoneNumber: json['phoneNumber'],
      userName: json['userName'],
      role: json['role'],
      token: json['token'],
    );
  }
}

class MedUserToken {
  String accessToken;
  String expiresIn;
  String refreshToken;

  MedUserToken(
      {required this.accessToken,
      required this.expiresIn,
      required this.refreshToken});

  factory MedUserToken.fromJson(Map<String, dynamic> json) {
    return MedUserToken(
      accessToken: json['accessToken'],
      expiresIn: json['expiresIn'],
      refreshToken: json['refreshToken'],
    );
  }
}

class MedUserRole {
  int id;
  String name;

  MedUserRole({required this.id, required this.name});
  factory MedUserRole.fromJson(Map<String, dynamic> json) {
    return MedUserRole(id: json['id'], name: json['name']);
  }
}
class MedFaq {
  int id;
  String? question;
  String? answer;
  int faqStatusId;
  String? faqStatus;
  int faqCategoryId;
  String? faqCategory;
  int creatorUserId;
  String? author;
  int modifiedByUserId;
  String? dateCreated;
  String? datePublished;

  MedFaq({
    required this.id,
    required this.question,
    required this.answer,
    required this.faqStatusId,
    required this.faqStatus,
    required this.faqCategoryId,
    required this.faqCategory,
    required this.creatorUserId,
    required this.author,
    required this.modifiedByUserId,
    required this.dateCreated,
    required this.datePublished,
  });

  factory MedFaq.fromJson(Map<String, dynamic> json) {
    return MedFaq(
      id: json['id'],
      question: json['question'],
      answer: json['answer'],
      faqStatusId: json['faqStatusId'],
      faqStatus: json['faqStatus'],
      faqCategoryId: json['faqCategoryId'],
      faqCategory: json['faqCategory'],
      creatorUserId: json['creatorUserId'],
      author: json['author'],
      modifiedByUserId: json['modifiedByUserId'],
      dateCreated: json['dateCreated'],
      datePublished: json['datePublished'],
    );
  }
}

class MedBlog {
  int id;
  String? author;
  String? title;
  String? htmlText;
  String? datePublished;
  int? likes;
  int blogPostStatusId;
  String? blogPostStatus;
  int blogCategoryId;
  String? blogCategory;
  String? highlight;
  String? mainImageUrl;
  dynamic? blogPostImages;
  dynamic? blogPostTags;

  MedBlog({
    required this.id,
    required this.title,
    required this.htmlText,
    required this.blogPostStatusId,
    required this.likes,
    required this.blogPostStatus,
    required this.blogCategoryId,
    required this.author,
    required this.blogCategory,
    required this.highlight,
    required this.datePublished,
    required this.mainImageUrl,
    required this.blogPostImages,
    required this.blogPostTags,
  });

  factory MedBlog.fromJson(Map<String, dynamic> json) {
    return MedBlog(
      id: json['id'],
      title: json['title'],
      htmlText: json['htmlText'],
      blogPostStatusId: json['blogPostStatusId'],
      likes: json['likes'],
      blogPostStatus: json['blogPostStatus'],
      blogCategoryId: json['blogCategoryId'],
      author: json['author'],
      blogCategory: json['blogCategory'],
      highlight: json['highlight'],
      datePublished: json['datePublished'],
      mainImageUrl: json['mainImageUrl'],
      blogPostImages: json['blogPostImages'],
      blogPostTags: json['blogPostTags'],
    );
  }
}

class MedBlogTags {
  int id;
  int blogPostId;
  int tagId;
  String tagName;

  MedBlogTags(
      {required this.id,
      required this.blogPostId,
      required this.tagId,
      required this.tagName});

  factory MedBlogTags.fromJson(Map<String, dynamic> json) {
    return MedBlogTags(
      id: json['id'],
      blogPostId: json['blogPostId'],
      tagId: json['tagId'],
      tagName: json['tagName'],
    );
  }
}

class MedCountry {
  int id;
  String name;
  String dialingCode;
  String countryCode;

  MedCountry(
      {required this.id,
      required this.name,
      required this.dialingCode,
      required this.countryCode});

  factory MedCountry.fromJson(Map<String, dynamic> json) {
    return MedCountry(
      id: json['id'],
      name: json['name'],
      dialingCode: json['dialingCode'],
      countryCode: json['countryCode'],
    );
  }
}

class MedSates {
  int? id;
  String? name;
  int? countryId;
  String? longitude;
  String? latitude;

  MedSates(
      {required this.id,
      required this.name,
      required this.countryId,
      required this.longitude,
      required this.latitude});

  factory MedSates.fromJson(Map<String, dynamic> json) {
    return MedSates(
      id: json['id'],
      name: json['name'],
      countryId: json['countryId'],
      longitude: json['longitude'],
      latitude: json['latitude'],
    );
  }
}

class MedLGAS {
  int id;
  String name;
  int stateId;
  String? longitude;
  String? latitude;

  MedLGAS(
      {required this.id,
      required this.name,
      required this.stateId,
      required this.longitude,
      required this.latitude});

  factory MedLGAS.fromJson(Map<String, dynamic> json) {
    return MedLGAS(
      id: json['id'],
      name: json['name'],
      stateId: json['stateId'],
      longitude: json['longitude'],
      latitude: json['latitude'],
    );
  }
}

class MedShipAddrees {
  int customerShippingAddressId;
  String? houseNumber;
  String? street;
  String? city;
  String? lga;
  int? lgaId;
  String? state;
  int? stateId;
  String? country;
  int? countryId;
  bool? isDefault;
  String? firstName;
  String? lastName;
  String? phoneNumber;
  String? emailAddress;
  bool clicker = false;

  MedShipAddrees({
    required this.customerShippingAddressId,
    required this.houseNumber,
    required this.street,
    required this.city,
    required this.lga,
    required this.lgaId,
    required this.country,
    required this.state,
    required this.stateId,
    required this.countryId,
    required this.isDefault,
    required this.firstName,
    required this.lastName,
    required this.phoneNumber,
    required this.emailAddress,
  });

  factory MedShipAddrees.fromJson(Map<String, dynamic> json) {
    return MedShipAddrees(
      customerShippingAddressId: json['customerShippingAddressId'],
      houseNumber: json['houseNumber'],
      street: json['street'],
      city: json['city'],
      lga: json['lga'],
      lgaId: json['lgaId'],
      country: json['country'],
      state: json['state'],
      stateId: json['stateId'],
      countryId: json['countryId'],
      isDefault: json['isDefault'],
      firstName: json['firstName'],
      lastName: json['lastName'],
      phoneNumber: json['phoneNumber'],
      emailAddress: json['emailAddress'],
    );
  }
}

class RefillProducts {
  int refillId;
  int? productId;
  String? productName;
  String? brandName;
  String? productImageUrl;
  int? packSize;
  int? quantity = 0;
  String? startDate;
  String refillCycle;
  String? medicationRefillStatus;
  bool? remindBySMS;
  bool? remindByEmail;
  bool? remindByPushNotification;
  String? lastReminderDate;
  int? numberOfRemindersSent;
  String? endDate;

  RefillProducts({
    required this.refillId,
    required this.productId,
    required this.productName,
    required this.brandName,
    required this.productImageUrl,
    required this.packSize,
    required this.startDate,
    required this.refillCycle,
    required this.medicationRefillStatus,
    required this.remindBySMS,
    this.quantity,
    required this.remindByEmail,
    required this.remindByPushNotification,
    required this.lastReminderDate,
    required this.numberOfRemindersSent,
    required this.endDate,
  });

  factory RefillProducts.fromJson(Map<String, dynamic> json) {
    return RefillProducts(
      refillId: json['customerShippingAddressId'],
      productId: json['houseNumber'],
      productName: json['productName'],
      brandName: json['brandName'],
      productImageUrl: json['productImageUrl'],
      packSize: json['packSize'],
      startDate: json['startDate'],
      refillCycle: json['refillCycle'],
      medicationRefillStatus: json['medicationRefillStatus'],
      remindBySMS: json['remindBySMS'],
      remindByEmail: json['remindByEmail'],
      remindByPushNotification: json['remindByPushNotification'],
      lastReminderDate: json['lastReminderDate'],
      numberOfRemindersSent: json['numberOfRemindersSent'],
      endDate: json['endDate'],
    );
  }
}

class ProductSearch {
  int? productId;
  String? productName;
  String? productImageUrl;
  String? productImageUrl2;
  String? productImageUrl3;
  String? productImageUrl4;
  String? productImageUrl5;
  int? manufacturerId;
  String? manufacturer;
  int? productSubCategoryId;
  String? productSubCategory;
  int? productCategoryId;
  String? productCategory;
  int? dosageFormId;
  String? dosageForm;
  String? deescription;
  int? productStatusId;
  String? productStatus;
  String? highlight;
  String? sideEffects;
  String? barCodeNumber;
  String? universalProductCode;
  String? howToUse;
  String? precautions;
  String? storage;
  String? warning;
  int? creatorUserId;
  String? creatorName;
  int? creatorClientId;
  String? creatorClientName;
  String? creatorClientEmail;
  String? creatorPhoneNumber;
  double? minPrice;
  double? maxPrice;
  double? avgPrice;
  int? totalQuantityInStock;
  int? totalClientOutletsWithStock;
  double? modPrice;
  String? genericName;
  int? rating;
  bool? isdoctorsPrecriptionRequired;
  int? productTypeId;
  String? productType;
  dynamic? strength;
  String? strength2;
  String? strengthUnit;
  String? ingredients;
  String? productApprovalStatus;
  bool? noReturn;
  String? shippingPolicy;
  String? returnPolicy;
  String? brandName;
  bool addedToWishList = false;

  ProductSearch(
      {this.productId,
      this.productName,
      this.productImageUrl,
      this.productImageUrl2,
      this.productImageUrl3,
      this.productImageUrl4,
      this.productImageUrl5,
      this.manufacturerId,
      this.manufacturer,
      this.productSubCategoryId,
      this.productSubCategory,
      this.productCategoryId,
      this.productCategory,
      this.dosageFormId,
      this.dosageForm,
      this.deescription,
      this.productStatusId,
      this.productStatus,
      this.highlight,
      this.sideEffects,
      this.barCodeNumber,
      this.universalProductCode,
      this.howToUse,
      this.precautions,
      this.storage,
      this.warning,
      this.creatorUserId,
      this.creatorName,
      this.creatorClientId,
      this.creatorClientName,
      this.creatorClientEmail,
      this.creatorPhoneNumber,
      this.minPrice,
      this.maxPrice,
      this.avgPrice,
      this.totalQuantityInStock,
      this.totalClientOutletsWithStock,
      this.modPrice,
      this.genericName,
      this.rating,
      this.isdoctorsPrecriptionRequired,
      this.productTypeId,
      this.productType,
      this.strength,
      this.strength2,
      this.strengthUnit,
      this.ingredients,
      this.productApprovalStatus,
      this.noReturn,
      this.shippingPolicy,
      this.returnPolicy,
      this.brandName});

  ProductSearch.fromJson(Map<String, dynamic> json) {
    productId = json['productId'];
    productName = json['productName'];
    productImageUrl = json['productImageUrl'];
    productImageUrl2 = json['productImageUrl2'];
    productImageUrl3 = json['productImageUrl3'];
    productImageUrl4 = json['productImageUrl4'];
    productImageUrl5 = json['productImageUrl5'];
    manufacturerId = json['manufacturerId'];
    manufacturer = json['manufacturer'];
    productSubCategoryId = json['productSubCategoryId'];
    productSubCategory = json['productSubCategory'];
    productCategoryId = json['productCategoryId'];
    productCategory = json['productCategory'];
    dosageFormId = json['dosageFormId'];
    dosageForm = json['dosageForm'];
    deescription = json['deescription'];
    productStatusId = json['productStatusId'];
    productStatus = json['productStatus'];
    highlight = json['highlight'];
    sideEffects = json['sideEffects'];
    barCodeNumber = json['barCodeNumber'];
    universalProductCode = json['universalProductCode'];
    howToUse = json['howToUse'];
    precautions = json['precautions'];
    storage = json['storage'];
    warning = json['warning'];
    creatorUserId = json['creatorUserId'];
    creatorName = json['creatorName'];
    creatorClientId = json['creatorClientId'];
    creatorClientName = json['creatorClientName'];
    creatorClientEmail = json['creatorClientEmail'];
    creatorPhoneNumber = json['creatorPhoneNumber'];
    minPrice = json['minPrice'];
    maxPrice = json['maxPrice'];
    avgPrice = json['avgPrice'];
    totalQuantityInStock = json['totalQuantityInStock'];
    totalClientOutletsWithStock = json['totalClientOutletsWithStock'];
    modPrice = json['modPrice'];
    genericName = json['genericName'];
    rating = json['rating'];
    isdoctorsPrecriptionRequired = json['isdoctorsPrecriptionRequired'];
    productTypeId = json['productTypeId'];
    productType = json['productType'];
    strength = json['strength'];
    strength2 = json['strength2'];
    strengthUnit = json['strengthUnit'];
    ingredients = json['ingredients'];
    productApprovalStatus = json['productApprovalStatus'];
    noReturn = json['noReturn'];
    shippingPolicy = json['shippingPolicy'];
    returnPolicy = json['returnPolicy'];
    brandName = json['brandName'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = Map<String, dynamic>();
    data['productId'] = productId;
    data['productName'] = productName;
    data['productImageUrl'] = productImageUrl;
    data['productImageUrl2'] = this.productImageUrl2;
    data['productImageUrl3'] = this.productImageUrl3;
    data['productImageUrl4'] = this.productImageUrl4;
    data['productImageUrl5'] = this.productImageUrl5;
    data['manufacturerId'] = this.manufacturerId;
    data['manufacturer'] = this.manufacturer;
    data['productSubCategoryId'] = this.productSubCategoryId;
    data['productSubCategory'] = this.productSubCategory;
    data['productCategoryId'] = this.productCategoryId;
    data['productCategory'] = this.productCategory;
    data['dosageFormId'] = this.dosageFormId;
    data['dosageForm'] = this.dosageForm;
    data['deescription'] = this.deescription;
    data['productStatusId'] = this.productStatusId;
    data['productStatus'] = this.productStatus;
    data['highlight'] = this.highlight;
    data['sideEffects'] = this.sideEffects;
    data['barCodeNumber'] = this.barCodeNumber;
    data['universalProductCode'] = this.universalProductCode;
    data['howToUse'] = this.howToUse;
    data['precautions'] = this.precautions;
    data['storage'] = this.storage;
    data['warning'] = this.warning;
    data['creatorUserId'] = this.creatorUserId;
    data['creatorName'] = this.creatorName;
    data['creatorClientId'] = this.creatorClientId;
    data['creatorClientName'] = this.creatorClientName;
    data['creatorClientEmail'] = this.creatorClientEmail;
    data['creatorPhoneNumber'] = this.creatorPhoneNumber;
    data['minPrice'] = this.minPrice;
    data['maxPrice'] = this.maxPrice;
    data['avgPrice'] = this.avgPrice;
    data['totalQuantityInStock'] = this.totalQuantityInStock;
    data['totalClientOutletsWithStock'] = this.totalClientOutletsWithStock;
    data['modPrice'] = this.modPrice;
    data['genericName'] = this.genericName;
    data['rating'] = this.rating;
    data['isdoctorsPrecriptionRequired'] = this.isdoctorsPrecriptionRequired;
    data['productTypeId'] = this.productTypeId;
    data['productType'] = this.productType;
    data['strength'] = this.strength;
    data['strength2'] = this.strength2;
    data['strengthUnit'] = this.strengthUnit;
    data['ingredients'] = this.ingredients;
    data['productApprovalStatus'] = this.productApprovalStatus;
    data['noReturn'] = this.noReturn;
    data['shippingPolicy'] = this.shippingPolicy;
    data['returnPolicy'] = this.returnPolicy;
    data['brandName'] = this.brandName;
    return data;
  }
}

class ProductDetails {
  int? id;
  String? name;
  String? brandName;
  String? genericName;
  int? manufacturerId;
  int? dosageFormId;
  int? documentUploadId;
  String? highlight;
  String? description;
  String? sideEffects;
  String? barCodeNumber;
  String? universalProductCode;
  String? howToUse;
  String? precautions;
  String? storage;
  String? warning;
  int? creatorUserId;
  int? productSubCategoryId;
  int? approverUserId;
  String? approvalDate;
  String? approvalComment;
  String? strength;
  int? strengthUnitId;
  int? productStatusId;
  bool? requiresPrescription;
  int? numberOfSachetsPerPack;
  int? packSize;
  String? productSubCategory;
  String? productStatus;
  String? manufacturer;
  String? productImageUrl;
  String? dosageForm;
  Object? minimumPrice;
  Object? maximumPrice;
  Object? modPrice;
  int? totalQuantityInStock;
  bool addedToWishList = false;

  ProductDetails(
      {this.id,
      this.name,
      this.brandName,
      this.genericName,
      this.manufacturerId,
      this.dosageFormId,
      this.documentUploadId,
      this.highlight,
      this.description,
      this.sideEffects,
      this.barCodeNumber,
      this.universalProductCode,
      this.howToUse,
      this.precautions,
      this.storage,
      this.warning,
      this.creatorUserId,
      this.productSubCategoryId,
      this.approverUserId,
      this.approvalDate,
      this.approvalComment,
      this.strength,
      this.strengthUnitId,
      this.productStatusId,
      this.requiresPrescription,
      this.numberOfSachetsPerPack,
      this.packSize,
      this.productSubCategory,
      this.productStatus,
      this.manufacturer,
      this.productImageUrl,
      this.dosageForm,
      this.minimumPrice,
      this.maximumPrice,
      this.totalQuantityInStock,
      this.modPrice});

  ProductDetails.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    name = json['name'];
    brandName = json['brandName'];
    genericName = json['genericName'];
    manufacturerId = json['manufacturerId'];
    dosageFormId = json['dosageFormId'];
    documentUploadId = json['documentUploadId'];
    highlight = json['highlight'];
    description = json['description'];
    sideEffects = json['sideEffects'];
    barCodeNumber = json['barCodeNumber'];
    universalProductCode = json['universalProductCode'];
    howToUse = json['howToUse'];
    precautions = json['precautions'];
    storage = json['storage'];
    warning = json['warning'];
    totalQuantityInStock = json['totalQuantityInStock'];
    creatorUserId = json['creatorUserId'];
    productSubCategoryId = json['productSubCategoryId'];
    approverUserId = json['approverUserId'];
    approvalDate = json['approvalDate'];
    approvalComment = json['approvalComment'];
    strength = json['strength'];
    strengthUnitId = json['strengthUnitId'];
    productStatusId = json['productStatusId'];
    requiresPrescription = json['requiresPrescription'];
    numberOfSachetsPerPack = json['numberOfSachetsPerPack'];
    packSize = json['packSize'];
    productSubCategory = json['productSubCategory'];
    productStatus = json['productStatus'];
    manufacturer = json['manufacturer'];
    productImageUrl = json['productImageUrl'];
    dosageForm = json['dosageForm'];
    minimumPrice = json['minimumPrice'];
    maximumPrice = json['maximumPrice'];
    modPrice = json['modPrice'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['name'] = this.name;
    data['brandName'] = this.brandName;
    data['genericName'] = this.genericName;
    data['manufacturerId'] = this.manufacturerId;
    data['dosageFormId'] = this.dosageFormId;
    data['documentUploadId'] = this.documentUploadId;
    data['highlight'] = this.highlight;
    data['description'] = this.description;
    data['sideEffects'] = this.sideEffects;
    data['barCodeNumber'] = this.barCodeNumber;
    data['universalProductCode'] = this.universalProductCode;
    data['howToUse'] = this.howToUse;
    data['precautions'] = this.precautions;
    data['storage'] = this.storage;
    data['warning'] = this.warning;
    data['creatorUserId'] = this.creatorUserId;
    data['productSubCategoryId'] = this.productSubCategoryId;
    data['approverUserId'] = this.approverUserId;
    data['approvalDate'] = this.approvalDate;
    data['approvalComment'] = this.approvalComment;
    data['strength'] = this.strength;
    data['strengthUnitId'] = this.strengthUnitId;
    data['productStatusId'] = this.productStatusId;
    data['requiresPrescription'] = this.requiresPrescription;
    data['numberOfSachetsPerPack'] = this.numberOfSachetsPerPack;
    data['packSize'] = this.packSize;
    data['productSubCategory'] = this.productSubCategory;
    data['productStatus'] = this.productStatus;
    data['manufacturer'] = this.manufacturer;
    data['productImageUrl'] = this.productImageUrl;
    data['dosageForm'] = this.dosageForm;
    data['minimumPrice'] = this.minimumPrice;
    data['maximumPrice'] = this.maximumPrice;
    data['modPrice'] = this.modPrice;
    return data;
  }
}

class RefillCycle {
  int id;
  String name;
  int? val;

  RefillCycle({
    required this.id,
    required this.name,
    this.val,
  });

  factory RefillCycle.fromJson(Map<String, dynamic> json) {
    return RefillCycle(
      id: json['id'],
      name: json['name'],
    );
  }
}

class RefillProduct {
  int? refillId;
  int? productId;
  String? productName;
  String? brandName;
  String? productImageUrl;
  int? packSize;
  String? startDate;
  String? refillCycle;
  String? medicationRefillStatus;
  bool? remindBySMS;
  bool? remindByEmail;
  bool? remindByPushNotification;
  String? lastReminderDate;
  int? numberOfRemindersSent;
  String? endDate;
  bool? isLoading = false;
  int? quantity;

  RefillProduct(
      {this.refillId,
      this.productId,
      this.productName,
      this.brandName,
      this.productImageUrl,
      this.packSize,
      this.startDate,
      this.refillCycle,
      this.medicationRefillStatus,
      this.remindBySMS,
      this.remindByEmail,
      this.quantity,
      this.remindByPushNotification,
      this.lastReminderDate,
      this.numberOfRemindersSent,
      this.isLoading,
      this.endDate});

  RefillProduct.fromJson(Map<String, dynamic> json) {
    refillId = json['refillId'];
    productId = json['productId'];
    productName = json['productName'];
    brandName = json['brandName'];
    productImageUrl = json['productImageUrl'];
    packSize = json['packSize'];
    startDate = json['startDate'];
    refillCycle = json['refillCycle'];
    medicationRefillStatus = json['medicationRefillStatus'];
    remindBySMS = json['remindBySMS'];
    remindByEmail = json['remindByEmail'];
    remindByPushNotification = json['remindByPushNotification'];
    lastReminderDate = json['lastReminderDate'];
    numberOfRemindersSent = json['numberOfRemindersSent'];
    endDate = json['endDate'];
    quantity = json['quantity'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['refillId'] = this.refillId;
    data['productId'] = this.productId;
    data['productName'] = this.productName;
    data['brandName'] = this.brandName;
    data['productImageUrl'] = this.productImageUrl;
    data['packSize'] = this.packSize;
    data['startDate'] = this.startDate;
    data['refillCycle'] = this.refillCycle;
    data['medicationRefillStatus'] = this.medicationRefillStatus;
    data['remindBySMS'] = this.remindBySMS;
    data['remindByEmail'] = this.remindByEmail;
    data['remindByPushNotification'] = this.remindByPushNotification;
    data['lastReminderDate'] = this.lastReminderDate;
    data['numberOfRemindersSent'] = this.numberOfRemindersSent;
    data['endDate'] = this.endDate;
    return data;
  }
}

class CartItems {
  int? shoppingCartOrderItemId;
  int? shoppingCartOrderId;
  int? productId;
  String? productName;
  String? genericName;
  String? manufacturerName;
  String? dosageForm;
  String? imageUrl;
  int? bundleItemId;
  int? quantity;
  double? minUnitPrice;
  double? maxUnitPrice;
  bool? isChecked = false;
  bool? requiresPrescription;

  CartItems(
      {this.shoppingCartOrderItemId,
      this.shoppingCartOrderId,
      this.productId,
      this.productName,
      this.genericName,
      this.manufacturerName,
      this.dosageForm,
      this.imageUrl,
      this.bundleItemId,
      this.quantity,
      this.minUnitPrice,
      this.isChecked,
      this.requiresPrescription,
      this.maxUnitPrice});

  CartItems.fromJson(Map<String, dynamic> json) {
    shoppingCartOrderItemId = json['shoppingCartOrderItemId'];
    shoppingCartOrderId = json['shoppingCartOrderId'];
    productId = json['productId'];
    productName = json['productName'];
    genericName = json['genericName'];
    manufacturerName = json['manufacturerName'];
    dosageForm = json['dosageForm'];
    imageUrl = json['imageUrl'];
    bundleItemId = json['bundleItemId'];
    quantity = json['quantity'];
    minUnitPrice = json['minUnitPrice'];
    requiresPrescription = json['requiresPrescription'];
    maxUnitPrice = json['maxUnitPrice'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = Map<String, dynamic>();
    data['shoppingCartOrderItemId'] = this.shoppingCartOrderItemId;
    data['shoppingCartOrderId'] = this.shoppingCartOrderId;
    data['productId'] = this.productId;
    data['productName'] = this.productName;
    data['genericName'] = this.genericName;
    data['manufacturerName'] = this.manufacturerName;
    data['dosageForm'] = this.dosageForm;
    data['imageUrl'] = this.imageUrl;
    data['bundleItemId'] = this.bundleItemId;
    data['quantity'] = this.quantity;
    data['minUnitPrice'] = this.minUnitPrice;
    data['maxUnitPrice'] = this.maxUnitPrice;
    return data;
  }
}

class OrderData {
  int? salesOrderId;
  String? uniqueOrderId;
  String? orderStatus;
  String? channel;
  String? orderDate;
  String? salesOrderType;
  int? numberOfItems;
  double? subTotal;
  dynamic? deliveryCharge;
  double? paymentFees;
  String? paymentMethod;
  String? paymentReference;
  bool isChecked = false;

  OrderData(
      {this.salesOrderId,
      this.uniqueOrderId,
      this.orderStatus,
      this.channel,
      this.orderDate,
      this.salesOrderType,
      this.numberOfItems,
      this.subTotal,
      this.deliveryCharge,
      this.paymentFees,
      this.paymentMethod,
      this.paymentReference,
      required this.isChecked});

  OrderData.fromJson(Map<String, dynamic> json) {
    salesOrderId = json['salesOrderId'];
    uniqueOrderId = json['uniqueOrderId'];
    orderStatus = json['orderStatus'];
    channel = json['channel'];
    orderDate = json['orderDate'];
    salesOrderType = json['salesOrderType'];
    numberOfItems = json['numberOfItems'];
    subTotal = json['subTotal'];
    deliveryCharge = json['deliveryCharge'];
    paymentFees = json['paymentFees'];
    paymentMethod = json['paymentMethod'];
    paymentReference = json['paymentReference'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = Map<String, dynamic>();
    data['salesOrderId'] = this.salesOrderId;
    data['uniqueOrderId'] = this.uniqueOrderId;
    data['orderStatus'] = this.orderStatus;
    data['channel'] = this.channel;
    data['orderDate'] = this.orderDate;
    data['salesOrderType'] = this.salesOrderType;
    data['numberOfItems'] = this.numberOfItems;
    data['subTotal'] = this.subTotal;
    data['deliveryCharge'] = this.deliveryCharge;
    data['paymentFees'] = this.paymentFees;
    data['paymentMethod'] = this.paymentMethod;
    data['paymentReference'] = this.paymentReference;
    return data;
  }
}

class OrderDataDetails2 {
  int? salesOrderId;
  String? orderDate;
  String? paymentMethod;
  dynamic? subTotal;
  dynamic? deliveryCharge;
  dynamic? paymentFees;
  String? streetNumber;
  String? uniqueOrderId;
  String? dateDelivered;
  String? logisticDeliveryType;
  String? logisticsClientName;
  String? orderReturnStatus;
  int? orderReturnId;
  String? uploadPrescriptionUrl;

  String? street;
  String? city;
  String? lga;
  String? state;
  String? country;
  dynamic? orderItems;

  OrderDataDetails2(
      {this.salesOrderId,
      this.orderDate,
      this.paymentMethod,
      this.subTotal,
      this.deliveryCharge,
      this.paymentFees,
      this.streetNumber,
      this.street,
      this.uniqueOrderId,
      this.dateDelivered,
      this.logisticDeliveryType,
      this.logisticsClientName,
      this.orderReturnStatus,
      this.orderReturnId,
      this.city,
      this.lga,
      this.state,
      this.uploadPrescriptionUrl,
      this.country,
      this.orderItems});

  OrderDataDetails2.fromJson(Map<String, dynamic> json) {
    uniqueOrderId = json['uniqueOrderId'];
    dateDelivered = json['dateDelivered'];
    logisticDeliveryType = json['logisticDeliveryType'];
    logisticsClientName = json['logisticsClientName'];
    orderReturnStatus = json['orderReturnStatus'];
    orderReturnId = json['orderReturnId'];
    salesOrderId = json['salesOrderId'];
    orderDate = json['orderDate'];
    paymentMethod = json['paymentMethod'];
    subTotal = json['subTotal'];
    deliveryCharge = json['deliveryCharge'];
    paymentFees = json['paymentFees'];
    streetNumber = json['streetNumber'];
    street = json['street'];
    city = json['city'];
    lga = json['lga'];
    uploadPrescriptionUrl = json['uploadPrescriptionUrl'];
    state = json['state'];
    country = json['country'];
    orderItems = json['orderItems'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = Map<String, dynamic>();
    data['salesOrderId'] = this.salesOrderId;
    data['orderDate'] = this.orderDate;
    data['paymentMethod'] = this.paymentMethod;
    data['subTotal'] = this.subTotal;
    data['deliveryCharge'] = this.deliveryCharge;
    data['paymentFees'] = this.paymentFees;
    data['streetNumber'] = this.streetNumber;
    data['street'] = this.street;
    data['city'] = this.city;
    data['lga'] = this.lga;
    data['state'] = this.state;
    data['uploadPrescriptionUrl'] = this.uploadPrescriptionUrl;
    data['country'] = this.country;
    if (this.orderItems != null) {
      data['orderItems'] = this.orderItems.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class OrderItems {
  int? salesOrderItemId;
  String? productName;
  String? productImageUrl;
  int? packSize;
  int? quantity;
  int? productId;
  double? unitprice;
  double? couponDiscount;
  bool isChecked = false;

  OrderItems(
      {this.salesOrderItemId,
      this.productName,
      this.productImageUrl,
      this.packSize,
      this.quantity,
      this.unitprice,
      this.productId,
      this.couponDiscount});

  factory OrderItems.fromJson(Map<String, dynamic> map) {

    return OrderItems(
    salesOrderItemId : map['salesOrderItemId'],
    productName : map['productName'],
    productImageUrl : map['productImageUrl'],
    packSize : map['packSize'],
    quantity : map['quantity'],
    productId : map['productId'],
    unitprice : map['unitPrice'],
    couponDiscount : map['couponDiscount'],
    );
  }

  // factory Photo.fromMap(Map<String, dynamic> map) {
  //   return Photo(
  //       id: map["id"],
  //       url: map["urls"]["regular"],
  //       description: map["description"] ?? "No Description",
  //       user: User.fromMap(map["user"]));
  // }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = Map<String, dynamic>();
    data['salesOrderItemId'] = this.salesOrderItemId;
    data['productName'] = this.productName;
    data['productImageUrl'] = this.productImageUrl;
    data['packSize'] = this.packSize;
    data['quantity'] = this.quantity;
    data['unitprice'] = this.unitprice;
    data['couponDiscount'] = this.couponDiscount;
    return data;
  }
}

class ReturnCondition {
  int id;
  String name;
  bool clicked = false;

  ReturnCondition({
    required this.id,
    required this.name,
    required this.clicked,
  });

  factory ReturnCondition.fromJson(Map<String, dynamic> json) {
    return ReturnCondition(id: json['id'], name: json['name'], clicked: false);
  }
}

class OrderHistory {
  String activityDate;
  String activity;
  String comments;

  OrderHistory({
    required this.activityDate,
    required this.activity,
    required this.comments,
  });

  factory OrderHistory.fromJson(Map<String, dynamic> json) {
    return OrderHistory(
        activityDate: json['activityDate'],
        activity: json['activity'],
        comments: json['comments']);
  }
}

class ProductReview {
  String reviewDate;
  String reviewer;
  String comments;
  int rating;

  ProductReview({
    required this.reviewDate,
    required this.reviewer,
    required this.comments,
    required this.rating,
  });

  factory ProductReview.fromJson(Map<String, dynamic> json) {
    return ProductReview(
        reviewDate: json['reviewDate'],
        reviewer: json['reviewer'],
        comments: json['comments'],
        rating: json['rating']);
  }
}

class ProductRating {
  int averageRatings;
  int numberOfReviews;

  ProductRating({
    required this.averageRatings,
    required this.numberOfReviews,
  });

  factory ProductRating.fromJson(Map<String, dynamic> json) {
    return ProductRating(
        averageRatings: json['averageRatings'],
        numberOfReviews: json['numberOfReviews']);
  }
}

class LogisticsDelivery {
  int? logisticsDeliveryOptionId;
  String? logisticsDeliveryCompany;
  String? logisticsDeliveryType;
  double? fee;
  int? minDuration;
  int? maxDuration;
  int? stateId;
  bool? isClicked = false;
  int? lgaId;

  LogisticsDelivery(
      {this.logisticsDeliveryOptionId,
      this.logisticsDeliveryCompany,
      this.logisticsDeliveryType,
      this.fee,
      this.minDuration,
      this.maxDuration,
      this.stateId,
      this.isClicked,
      this.lgaId});

  LogisticsDelivery.fromJson(Map<String, dynamic> json) {
    logisticsDeliveryOptionId = json['logisticsDeliveryOptionId'];
    logisticsDeliveryCompany = json['logisticsDeliveryCompany'];
    logisticsDeliveryType = json['logisticsDeliveryType'];
    fee = json['fee'];
    minDuration = json['minDuration'];
    maxDuration = json['maxDuration'];
    stateId = json['stateId'];
    lgaId = json['lgaId'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = Map<String, dynamic>();
    data['logisticsDeliveryOptionId'] = this.logisticsDeliveryOptionId;
    data['logisticsDeliveryCompany'] = this.logisticsDeliveryCompany;
    data['logisticsDeliveryType'] = this.logisticsDeliveryType;
    data['fee'] = this.fee;
    data['minDuration'] = this.minDuration;
    data['maxDuration'] = this.maxDuration;
    data['stateId'] = this.stateId;
    data['lgaId'] = this.lgaId;
    return data;
  }
}

class MyBanner {
  int? id;
  String? name;
  String? description;
  String? dateCreated;
  int? creatorUserId;
  String? bannerStatus;
  dynamic bannerImages;

  MyBanner(
      {this.id,
      this.name,
      this.description,
      this.dateCreated,
      this.creatorUserId,
      this.bannerStatus,
      this.bannerImages});

  MyBanner.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    name = json['name'];
    description = json['description'];
    dateCreated = json['dateCreated'];
    creatorUserId = json['creatorUserId'];
    bannerStatus = json['bannerStatus'];
    bannerImages = json['bannerImages'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['name'] = this.name;
    data['description'] = this.description;
    data['dateCreated'] = this.dateCreated;
    data['creatorUserId'] = this.creatorUserId;
    data['bannerStatus'] = this.bannerStatus;
    data['bannerImages'] = this.bannerImages;
    return data;
  }
}

class BannerImages {
  String? name;
  String? imageUrl;

  BannerImages({this.name, this.imageUrl});

  BannerImages.fromJson(Map<String, dynamic> json) {
    name = json['name'];
    imageUrl = json['imageUrl'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['name'] = this.name;
    data['imageUrl'] = this.imageUrl;
    return data;
  }
}

class WishList {
  int? productId;
  String? productName;
  String? productImageUrl;
  int? bundleId;
  String? bundleName;
  String? bundleImageUrl;

  WishList(
      {this.productId,
      this.productName,
      this.productImageUrl,
      this.bundleId,
      this.bundleName,
      this.bundleImageUrl});

  WishList.fromJson(Map<String, dynamic> json) {
    productId = json['productId'];
    productName = json['productName'];
    productImageUrl = json['productImageUrl'];
    bundleId = json['bundleId'];
    bundleName = json['bundleName'];
    bundleImageUrl = json['bundleImageUrl'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['productId'] = this.productId;
    data['productName'] = this.productName;
    data['productImageUrl'] = this.productImageUrl;
    data['bundleId'] = this.bundleId;
    data['bundleName'] = this.bundleName;
    data['bundleImageUrl'] = this.bundleImageUrl;
    return data;
  }
}

class Bundles {
  int? id;
  String? category;
  String? bundleImageUrl;
  String? bundleName;
  int? numOfProducts;
  String? dateCreated;

  Bundles(
      {this.id,
      this.category,
      this.bundleImageUrl,
      this.bundleName,
      this.numOfProducts,
      this.dateCreated});

  Bundles.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    category = json['category'];
    bundleImageUrl = json['bundleImageUrl'];
    bundleName = json['bundleName'];
    numOfProducts = json['numOfProducts'];
    dateCreated = json['dateCreated'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['category'] = this.category;
    data['bundleImageUrl'] = this.bundleImageUrl;
    data['bundleName'] = this.bundleName;
    data['numOfProducts'] = this.numOfProducts;
    data['dateCreated'] = this.dateCreated;
    return data;
  }
}

class BundleItems {
  int? id;
  int? bundleId;
  int? productId;
  String? productName;
  int? quantity;
  int? packSizeId;

  BundleItems(
      {this.id,
      this.bundleId,
      this.productId,
      this.productName,
      this.quantity,
      this.packSizeId});

  BundleItems.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    bundleId = json['bundleId'];
    productId = json['productId'];
    productName = json['productName'];
    quantity = json['quantity'];
    packSizeId = json['packSizeId'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data =  Map<String, dynamic>();
    data['id'] = this.id;
    data['bundleId'] = this.bundleId;
    data['productId'] = this.productId;
    data['productName'] = this.productName;
    data['quantity'] = this.quantity;
    data['packSizeId'] = this.packSizeId;
    return data;
  }
}

class ProductList {
  int? productId;
  String? productName;
  String? productImageUrl;
  int? manufacturerId;
  String? manufacturer;
  int? productSubCategoryId;
  String? productSubCategory;
  int? productCategoryId;
  String? productCategory;
  int? dosageFormId;
  String? dosageForm;
  String? description;
  int? productStatusId;
  String? productStatus;
  String? highlight;
  String? sideEffects;
  String? barCodeNumber;
  String? universalProductCode;
  String? howToUse;
  String? precautions;
  String? storage;
  String? warning;
  int? creatorUserId;
  String? creatorName;
  int? creatorClientId;
  String? creatorClientName;
  double? minPrice;
  double? maxPrice;
  double? avgPrice;
  int? totalQuantityInStock;
  int? totalClientOutletsWithStock;
  double? modPrice;
  double? rating;
  bool? isdoctorsPrecriptionRequired;
  bool addedToWishList = false;

  ProductList(
      {this.productId,
      this.productName,
      this.productImageUrl,
      this.manufacturerId,
      this.manufacturer,
      this.productSubCategoryId,
      this.productSubCategory,
      this.productCategoryId,
      this.productCategory,
      this.dosageFormId,
      this.dosageForm,
      this.description,
      this.productStatusId,
      this.productStatus,
      this.highlight,
      this.sideEffects,
      this.barCodeNumber,
      this.universalProductCode,
      this.howToUse,
      this.precautions,
      this.storage,
      this.warning,
      this.creatorUserId,
      this.creatorName,
      this.creatorClientId,
      this.creatorClientName,
      this.minPrice,
      this.maxPrice,
      this.avgPrice,
      this.totalQuantityInStock,
      this.totalClientOutletsWithStock,
      this.modPrice,
      this.rating,
      this.isdoctorsPrecriptionRequired});

  ProductList.fromJson(Map<String, dynamic> json) {
    productId = json['productId'];
    productName = json['productName'];
    productImageUrl = json['productImageUrl'];
    manufacturerId = json['manufacturerId'];
    manufacturer = json['manufacturer'];
    productSubCategoryId = json['productSubCategoryId'];
    productSubCategory = json['productSubCategory'];
    productCategoryId = json['productCategoryId'];
    productCategory = json['productCategory'];
    dosageFormId = json['dosageFormId'];
    dosageForm = json['dosageForm'];
    description = json['deescription'];
    productStatusId = json['productStatusId'];
    productStatus = json['productStatus'];
    highlight = json['highlight'];
    sideEffects = json['sideEffects'];
    barCodeNumber = json['barCodeNumber'];
    universalProductCode = json['universalProductCode'];
    howToUse = json['howToUse'];
    precautions = json['precautions'];
    storage = json['storage'];
    warning = json['warning'];
    creatorUserId = json['creatorUserId'];
    creatorName = json['creatorName'];
    creatorClientId = json['creatorClientId'];
    creatorClientName = json['creatorClientName'];
    minPrice = json['minPrice'];
    maxPrice = json['maxPrice'];
    avgPrice = json['avgPrice'];
    totalQuantityInStock = json['totalQuantityInStock'];
    totalClientOutletsWithStock = json['totalClientOutletsWithStock'];
    modPrice = json['modPrice'];
    rating = json['rating'];
    isdoctorsPrecriptionRequired = json['isdoctorsPrecriptionRequired'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['productId'] = this.productId;
    data['productName'] = this.productName;
    data['productImageUrl'] = this.productImageUrl;
    data['manufacturerId'] = this.manufacturerId;
    data['manufacturer'] = this.manufacturer;
    data['productSubCategoryId'] = this.productSubCategoryId;
    data['productSubCategory'] = this.productSubCategory;
    data['productCategoryId'] = this.productCategoryId;
    data['productCategory'] = this.productCategory;
    data['dosageFormId'] = this.dosageFormId;
    data['dosageForm'] = this.dosageForm;
    data['deescription'] = this.description;
    data['productStatusId'] = this.productStatusId;
    data['productStatus'] = this.productStatus;
    data['highlight'] = this.highlight;
    data['sideEffects'] = this.sideEffects;
    data['barCodeNumber'] = this.barCodeNumber;
    data['universalProductCode'] = this.universalProductCode;
    data['howToUse'] = this.howToUse;
    data['precautions'] = this.precautions;
    data['storage'] = this.storage;
    data['warning'] = this.warning;
    data['creatorUserId'] = this.creatorUserId;
    data['creatorName'] = this.creatorName;
    data['creatorClientId'] = this.creatorClientId;
    data['creatorClientName'] = this.creatorClientName;
    data['minPrice'] = this.minPrice;
    data['maxPrice'] = this.maxPrice;
    data['avgPrice'] = this.avgPrice;
    data['totalQuantityInStock'] = this.totalQuantityInStock;
    data['totalClientOutletsWithStock'] = this.totalClientOutletsWithStock;
    data['modPrice'] = this.modPrice;
    data['rating'] = this.rating;
    data['isdoctorsPrecriptionRequired'] = this.isdoctorsPrecriptionRequired;
    return data;
  }
}

class ProductCategory {
  int? id;
  String? name;
  int? numOfProducts;
  bool? clicked = false;

  ProductCategory(
      {this.id, this.name, this.numOfProducts, required this.clicked});

  ProductCategory.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    name = json['name'];
    numOfProducts = json['numOfProducts'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['name'] = this.name;
    data['numOfProducts'] = this.numOfProducts;
    return data;
  }
}

class TermsAndCondition {
  String? htmlText;

  TermsAndCondition({this.htmlText});

  TermsAndCondition.fromJson(Map<String, dynamic> json) {
    htmlText = json['htmlText'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['htmlText'] = this.htmlText;
    return data;
  }
}

class ProductSubCategory {
  int? id;
  String? name;
  int? productCategoryId;
  bool? clicked = false;

  ProductSubCategory(
      {this.id, this.name, this.productCategoryId, required this.clicked});

  ProductSubCategory.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    name = json['name'];
    productCategoryId = json['productCategoryId'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['name'] = this.name;
    data['productCategoryId'] = this.productCategoryId;
    return data;
  }
}

class RecentlyViewedModel {
  int? id;
  int? productId;
  int? userId;
  String? dateViewed;
  String? productName;
  double? price;
  dynamic? productRatings;
  String? productImage;
  String? productStatus;
  String? productDescription;

  RecentlyViewedModel(
      {this.productId,
      this.productName,
      this.id,
      this.userId,
      this.dateViewed,
      this.price,
      this.productRatings,
      this.productImage,
      this.productStatus,
      this.productDescription});

  RecentlyViewedModel.fromJson(Map<String, dynamic> json) {
    productId = json['productId'];
    productName = json['productName'];
    id = json['id'];
    userId = json['userId'];
    dateViewed = json['dateViewed'];
    productName = json['productName'];
    price = json['price'];
    productRatings = json['productRatings'];
    productImage = json['productImage'];
    productStatus = json['productStatus'];
    productDescription = json['productDescription'];
  }
}

class ProductFromSubcategory {
  int? productId;
  String? productName;
  String? productImageUrl;
  String? productImageUrl2;
  String? productImageUrl3;
  String? productImageUrl4;
  String? productImageUrl5;
  int? manufacturerId;
  String? manufacturer;
  int? productSubCategoryId;
  String? productSubCategory;
  int? productCategoryId;
  String? productCategory;
  int? dosageFormId;
  String? dosageForm;
  String? deescription;
  int? productStatusId;
  String? productStatus;
  String? highlight;
  String? sideEffects;
  String? barCodeNumber;
  String? universalProductCode;
  String? howToUse;
  String? precautions;
  String? storage;
  String? warning;
  int? creatorUserId;
  String? creatorName;
  int? creatorClientId;
  String? creatorClientName;
  double? minPrice;
  double? maxPrice;
  double? avgPrice;
  int? totalQuantityInStock;
  int? totalClientOutletsWithStock;
  double? modPrice;
  int? rating;
  bool? isdoctorsPrecriptionRequired;
  int? productTypeId;
  String? productType;
  int? strength;
  dynamic? strengthUnit;
  bool? addedToWishList = false;

  ProductFromSubcategory(
      {this.productId,
      this.productName,
      this.productImageUrl,
      this.productImageUrl2,
      this.productImageUrl3,
      this.productImageUrl4,
      this.productImageUrl5,
      this.manufacturerId,
      this.manufacturer,
      this.productSubCategoryId,
      this.productSubCategory,
      this.productCategoryId,
      this.productCategory,
      this.dosageFormId,
      this.dosageForm,
      this.deescription,
      this.productStatusId,
      this.productStatus,
      this.highlight,
      this.sideEffects,
      this.barCodeNumber,
      this.universalProductCode,
      this.howToUse,
      this.precautions,
      this.storage,
      this.warning,
      this.creatorUserId,
      this.creatorName,
      this.creatorClientId,
      this.creatorClientName,
      this.minPrice,
      this.maxPrice,
      this.avgPrice,
      this.totalQuantityInStock,
      this.totalClientOutletsWithStock,
      this.modPrice,
      this.rating,
      this.isdoctorsPrecriptionRequired,
      this.productTypeId,
      this.productType,
      this.strength,
      this.strengthUnit,
      this.addedToWishList});

  ProductFromSubcategory.fromJson(Map<String, dynamic> json) {
    productId = json['productId'];
    productName = json['productName'];
    productImageUrl = json['productImageUrl'];
    productImageUrl2 = json['productImageUrl2'];
    productImageUrl3 = json['productImageUrl3'];
    productImageUrl4 = json['productImageUrl4'];
    productImageUrl5 = json['productImageUrl5'];
    manufacturerId = json['manufacturerId'];
    manufacturer = json['manufacturer'];
    productSubCategoryId = json['productSubCategoryId'];
    productSubCategory = json['productSubCategory'];
    productCategoryId = json['productCategoryId'];
    productCategory = json['productCategory'];
    dosageFormId = json['dosageFormId'];
    dosageForm = json['dosageForm'];
    deescription = json['deescription'];
    productStatusId = json['productStatusId'];
    productStatus = json['productStatus'];
    highlight = json['highlight'];
    sideEffects = json['sideEffects'];
    barCodeNumber = json['barCodeNumber'];
    universalProductCode = json['universalProductCode'];
    howToUse = json['howToUse'];
    precautions = json['precautions'];
    storage = json['storage'];
    warning = json['warning'];
    creatorUserId = json['creatorUserId'];
    creatorName = json['creatorName'];
    creatorClientId = json['creatorClientId'];
    creatorClientName = json['creatorClientName'];
    minPrice = json['minPrice'];
    maxPrice = json['maxPrice'];
    avgPrice = json['avgPrice'];
    totalQuantityInStock = json['totalQuantityInStock'];
    totalClientOutletsWithStock = json['totalClientOutletsWithStock'];
    modPrice = json['modPrice'];
    rating = json['rating'];
    isdoctorsPrecriptionRequired = json['isdoctorsPrecriptionRequired'];
    productTypeId = json['productTypeId'];
    productType = json['productType'];
    strength = json['strength'];
    strengthUnit = json['strengthUnit'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['productId'] = this.productId;
    data['productName'] = this.productName;
    data['productImageUrl'] = this.productImageUrl;
    data['productImageUrl2'] = this.productImageUrl2;
    data['productImageUrl3'] = this.productImageUrl3;
    data['productImageUrl4'] = this.productImageUrl4;
    data['productImageUrl5'] = this.productImageUrl5;
    data['manufacturerId'] = this.manufacturerId;
    data['manufacturer'] = this.manufacturer;
    data['productSubCategoryId'] = this.productSubCategoryId;
    data['productSubCategory'] = this.productSubCategory;
    data['productCategoryId'] = this.productCategoryId;
    data['productCategory'] = this.productCategory;
    data['dosageFormId'] = this.dosageFormId;
    data['dosageForm'] = this.dosageForm;
    data['deescription'] = this.deescription;
    data['productStatusId'] = this.productStatusId;
    data['productStatus'] = this.productStatus;
    data['highlight'] = this.highlight;
    data['sideEffects'] = this.sideEffects;
    data['barCodeNumber'] = this.barCodeNumber;
    data['universalProductCode'] = this.universalProductCode;
    data['howToUse'] = this.howToUse;
    data['precautions'] = this.precautions;
    data['storage'] = this.storage;
    data['warning'] = this.warning;
    data['creatorUserId'] = this.creatorUserId;
    data['creatorName'] = this.creatorName;
    data['creatorClientId'] = this.creatorClientId;
    data['creatorClientName'] = this.creatorClientName;
    data['minPrice'] = this.minPrice;
    data['maxPrice'] = this.maxPrice;
    data['avgPrice'] = this.avgPrice;
    data['totalQuantityInStock'] = this.totalQuantityInStock;
    data['totalClientOutletsWithStock'] = this.totalClientOutletsWithStock;
    data['modPrice'] = this.modPrice;
    data['rating'] = this.rating;
    data['isdoctorsPrecriptionRequired'] = this.isdoctorsPrecriptionRequired;
    data['productTypeId'] = this.productTypeId;
    data['productType'] = this.productType;
    data['strength'] = this.strength;
    data['strengthUnit'] = this.strengthUnit;
    return data;
  }
}

class MedRating {
  String? reviewDate;
  String? reviewer;
  String? comments;
  int? rating;

  MedRating({this.reviewDate, this.reviewer, this.comments, this.rating});

  MedRating.fromJson(Map<String, dynamic> json) {
    reviewDate = json['reviewDate'];
    reviewer = json['reviewer'];
    comments = json['comments'];
    rating = json['rating'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['reviewDate'] = this.reviewDate;
    data['reviewer'] = this.reviewer;
    data['comments'] = this.comments;
    data['rating'] = this.rating;
    return data;
  }
}

class BundleDetails {
  List<BundleItems2>? bundleItems;
  int? id;
  String? category;
  String? bundleImageUrl;
  String? bundleName;
  int? numOfProducts;
  String? dateCreated;
  String? uniqueBundleCode;
  String? howToUse;
  String? precaution;
  String? warning;
  String? storage;
  bool? requiresPrescription;
  bool? noReturn;
  int? numOfItems;
  String? sideEffect;
  String? description;
  double? price;
  bool? bundleStatus;

  BundleDetails(
      {this.bundleItems,
      this.id,
      this.category,
      this.bundleImageUrl,
      this.bundleName,
      this.numOfProducts,
      this.dateCreated,
      this.uniqueBundleCode,
      this.howToUse,
      this.precaution,
      this.warning,
      this.storage,
      this.requiresPrescription,
      this.noReturn,
      this.numOfItems,
      this.sideEffect,
      this.description,
      this.price,
      this.bundleStatus});

  BundleDetails.fromJson(Map<String, dynamic> json) {
    if (json['bundleItems'] != null) {
      bundleItems = [];
      json['bundleItems'].forEach((v) {
        bundleItems!.add(BundleItems2.fromJson(v));
      });
    }
    id = json['id'];
    category = json['category'];
    bundleImageUrl = json['bundleImageUrl'];
    bundleName = json['bundleName'];
    numOfProducts = json['numOfProducts'];
    dateCreated = json['dateCreated'];
    uniqueBundleCode = json['uniqueBundleCode'];
    howToUse = json['howToUse'];
    precaution = json['precaution'];
    warning = json['warning'];
    storage = json['storage'];
    requiresPrescription = json['requiresPrescription'];
    noReturn = json['noReturn'];
    numOfItems = json['numOfItems'];
    sideEffect = json['sideEffect'];
    description = json['description'];
    price = json['price'];
    bundleStatus = json['bundleStatus'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    if (this.bundleItems != null) {
      data['bundleItems'] = this.bundleItems!.map((v) => v.toJson()).toList();
    }
    data['id'] = this.id;
    data['category'] = this.category;
    data['bundleImageUrl'] = this.bundleImageUrl;
    data['bundleName'] = this.bundleName;
    data['numOfProducts'] = this.numOfProducts;
    data['dateCreated'] = this.dateCreated;
    data['uniqueBundleCode'] = this.uniqueBundleCode;
    data['howToUse'] = this.howToUse;
    data['precaution'] = this.precaution;
    data['warning'] = this.warning;
    data['storage'] = this.storage;
    data['requiresPrescription'] = this.requiresPrescription;
    data['noReturn'] = this.noReturn;
    data['numOfItems'] = this.numOfItems;
    data['sideEffect'] = this.sideEffect;
    data['description'] = this.description;
    data['price'] = this.price;
    data['bundleStatus'] = this.bundleStatus;
    return data;
  }
}

class BundleItems2 {
  int? id;
  int? bundleId;
  int? productId;
  String? productName;
  int? quantity;
  int? packSizeId;

  BundleItems2(
      {this.id,
      this.bundleId,
      this.productId,
      this.productName,
      this.quantity,
      this.packSizeId});

  BundleItems2.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    bundleId = json['bundleId'];
    productId = json['productId'];
    productName = json['productName'];
    quantity = json['quantity'];
    packSizeId = json['packSizeId'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = Map<String, dynamic>();
    data['id'] = this.id;
    data['bundleId'] = this.bundleId;
    data['productId'] = this.productId;
    data['productName'] = this.productName;
    data['quantity'] = this.quantity;
    data['packSizeId'] = this.packSizeId;
    return data;
  }
}

class DeleteCartItems {
  String? sessionID;
  int? creatorUserId;
  int? shoppingCartOrderItemId;
  int? productId;
  int? channelId;
  int? bundleId;

  DeleteCartItems({
    this.sessionID,
    this.creatorUserId,
    this.shoppingCartOrderItemId,
    this.productId,
    this.channelId,
    this.bundleId,
  });

  DeleteCartItems.fromJson(Map<String, dynamic> json) {
    sessionID = json['sessionID'];
    creatorUserId = json['creatorUserId'];
    shoppingCartOrderItemId = json['shoppingCartOrderItemId'];
    productId = json['productId'];
    channelId = json['channelId'];
    bundleId = json['bundleId'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['sessionID'] = this.sessionID;
    data['creatorUserId'] = this.creatorUserId;
    data['shoppingCartOrderItemId'] = this.shoppingCartOrderItemId;
    data['productId'] = this.productId;
    data['channelId'] = this.channelId;
    data['bundleId'] = this.bundleId;
    return data;
  }
}

class SignUpUser {
  String? fName;
  String? lName;
  String? email;
  String? phone;
  String? gender;
  String? password;

  SignUpUser({
    this.fName,
    this.lName,
    this.email,
    this.phone,
    this.gender,
    this.password,
  });
}

class RefillObj {
  int? productId;
  String? productImage;
  double? price;
  String? productName;
  int? quantity;

  RefillObj(
      {this.productId,
      this.productImage,
      this.price,
      this.productName,
      this.quantity});
}

class ResponseObject {
  int? responseCode;
  String? responseBody;

  ResponseObject({
    this.responseCode,
    this.responseBody,
  });
}
