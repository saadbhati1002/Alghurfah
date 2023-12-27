import 'package:flutter/foundation.dart';
import 'package:intl/intl.dart';
import '../Helper/String.dart';
import 'Section_Model.dart';

class Model {
  String? id,
      type,
      typeId,
      image,
      fromTime,
      lastTime,
      title,
      desc,
      status,
      email,
      date,
      msg,
      uid,
      prodId,
      varId,
      urlLink,
      delBy;
  bool? isDel;
  SellerDetail? sellerDetails;
  var list;
  String? name, banner;
  List<attachment>? attach;
  Model(
      {this.id,
      this.type,
      this.typeId,
      this.image,
      this.name,
      this.banner,
      this.list,
      this.title,
      this.fromTime,
      this.desc,
      this.email,
      this.status,
      this.lastTime,
      this.msg,
      this.attach,
      this.uid,
      this.date,
      this.prodId,
      this.isDel,
      this.varId,
      this.urlLink,
      this.delBy,
      this.sellerDetails});

  factory Model.fromSlider(Map<String, dynamic> parsedJson) {
    SellerDetail listSeller = SellerDetail();
    var listContent = parsedJson['data'];
    if (listContent.isEmpty) {
      listContent = [];
    } else {
      listContent = listContent[0];
      if (parsedJson[TYPE] == 'categories') {
        listContent = Product.fromCat(listContent);
      } else if (parsedJson[TYPE] == 'users') {
        listSeller = SellerDetail.fromJson(listContent);
      } else if (parsedJson[TYPE] == 'products') {
        listContent = Product.fromJson(listContent);
      }
    }

    return Model(
        id: parsedJson[ID],
        image: parsedJson[IMAGE],
        type: parsedJson[TYPE],
        typeId: parsedJson[TYPE_ID],
        urlLink: parsedJson[LINK],
        list: listContent,
        sellerDetails: listSeller);
  }

  factory Model.fromTimeSlot(Map<String, dynamic> parsedJson) {
    return Model(
        id: parsedJson[ID],
        name: parsedJson[TITLE],
        fromTime: parsedJson[FROMTIME],
        lastTime: parsedJson[TOTIME]);
  }

  factory Model.fromTicket(Map<String, dynamic> parsedJson) {
    String date = parsedJson[DATE_CREATED];
    date = DateFormat('dd-MM-yyyy').format(DateTime.parse(date));
    return Model(
      id: parsedJson[ID],
      title: parsedJson[SUB],
      desc: parsedJson[DESC],
      typeId: parsedJson[TICKET_TYPE],
      email: parsedJson[EMAIL],
      status: parsedJson[STATUS],
      date: date,
      type: parsedJson[TIC_TYPE],
    );
  }

  factory Model.fromSupport(Map<String, dynamic> parsedJson) {
    return Model(
      id: parsedJson[ID],
      title: parsedJson[TITLE],
    );
  }

  factory Model.fromChat(Map<String, dynamic> parsedJson) {
    List<attachment> attachList = [];
    var listContent = (parsedJson['attachments'] as List?);
    if (listContent!.isEmpty) {
      attachList = [];
    } else {
      attachList = listContent.map((data) => attachment.setJson(data)).toList();
    }

    String date = parsedJson[DATE_CREATED];

    date = DateFormat('dd-MM-yyyy hh:mm a').format(DateTime.parse(date));
    return Model(
      id: parsedJson[ID],
      title: parsedJson[TITLE],
      msg: parsedJson[MESSAGE],
      uid: parsedJson[USER_ID],
      name: parsedJson[NAME],
      date: date,
      attach: attachList,
    );
  }

  factory Model.setAllCat(String id, String name) {
    return Model(
      id: id,
      name: name,
    );
  }

  factory Model.checkDeliverable(Map<String, dynamic> parsedJson) {
    return Model(
        prodId: parsedJson[PRODUCT_ID],
        varId: parsedJson[VARIANT_ID],
        isDel: parsedJson[IS_DELIVERABLE],
        delBy: parsedJson[DELIVERY_BY],
        msg: parsedJson[MESSAGE]);
  }

/*  factory Model.checkDeliverable(Map<String, dynamic> parsedJson) {
    return Model(
      prodId: parsedJson[PRODUCT_ID],
      varId: parsedJson[VARIANT_ID],
      isDel: parsedJson[IS_DELIVERABLE],
      delBy: parsedJson[DELIVERY_BY],
    );
  }*/
}

class attachment {
  String? media, type;

  attachment({this.media, this.type});

  factory attachment.setJson(Map<String, dynamic> parsedJson) {
    return attachment(
      media: parsedJson[MEDIA],
      type: parsedJson[ICON],
    );
  }
}

class SellerDetail {
  String? id;
  String? userId;
  dynamic slug;
  String? categoryIds;
  String? storeName;
  String? storeDescription;
  String? logo;
  String? storeUrl;
  dynamic sellerRating;
  String? noOfRatings;
  String? rating;
  String? bankName;
  String? bankCode;
  String? accountName;
  String? accountNumber;
  String? nationalIdentityCard;
  String? addressProof;
  String? authorizedSignature;
  String? panNumber;
  String? taxName;
  String? taxNumber;
  String? permissions;
  String? commission;
  String? status;
  String? dateAdded;

  SellerDetail(
      {this.id,
      this.userId,
      this.slug,
      this.categoryIds,
      this.storeName,
      this.storeDescription,
      this.logo,
      this.storeUrl,
      this.sellerRating,
      this.noOfRatings,
      this.rating,
      this.bankName,
      this.bankCode,
      this.accountName,
      this.accountNumber,
      this.nationalIdentityCard,
      this.addressProof,
      this.authorizedSignature,
      this.panNumber,
      this.taxName,
      this.taxNumber,
      this.permissions,
      this.commission,
      this.status,
      this.dateAdded});

  SellerDetail.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    userId = json['user_id'];
    slug = json['slug'];
    categoryIds = json['category_ids'];
    storeName = json['store_name'];
    storeDescription = json['store_description'];
    logo = json['logo'];
    storeUrl = json['store_url'];
    sellerRating = json['seller_rating'];
    noOfRatings = json['no_of_ratings'];
    rating = json['rating'];
    bankName = json['bank_name'];
    bankCode = json['bank_code'];
    accountName = json['account_name'];
    accountNumber = json['account_number'];
    nationalIdentityCard = json['national_identity_card'];
    addressProof = json['address_proof'];
    authorizedSignature = json['authorized_signature'];
    panNumber = json['pan_number'];
    taxName = json['tax_name'];
    taxNumber = json['tax_number'];
    permissions = json['permissions'];
    commission = json['commission'];
    status = json['status'];
    dateAdded = json['date_added'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['user_id'] = userId;
    data['slug'] = slug;
    data['category_ids'] = categoryIds;
    data['store_name'] = storeName;
    data['store_description'] = storeDescription;
    data['logo'] = logo;
    data['store_url'] = storeUrl;
    data['seller_rating'] = sellerRating;
    data['no_of_ratings'] = noOfRatings;
    data['rating'] = rating;
    data['bank_name'] = bankName;
    data['bank_code'] = bankCode;
    data['account_name'] = accountName;
    data['account_number'] = accountNumber;
    data['national_identity_card'] = nationalIdentityCard;
    data['address_proof'] = addressProof;
    data['authorized_signature'] = authorizedSignature;
    data['pan_number'] = panNumber;
    data['tax_name'] = taxName;
    data['tax_number'] = taxNumber;
    data['permissions'] = permissions;
    data['commission'] = commission;
    data['status'] = status;
    data['date_added'] = dateAdded;
    return data;
  }
}
