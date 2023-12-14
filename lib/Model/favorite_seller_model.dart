class Favorite {
  bool? error;
  String? message;
  String? total;
  List<Data>? data;

  Favorite({this.error, this.message, this.total, this.data});

  Favorite.fromJson(Map<String, dynamic> json) {
    error = json['error'];
    message = json['message'];
    total = json['total'];
    if (json['data'][0] != null) {
      data = <Data>[];
      json['data'][0].forEach((v) {
        data!.add(Data.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['error'] = error;
    data['message'] = message;
    data['total'] = total;
    if (this.data != null) {
      data['data'][0] = this.data!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class Data {
  String? id;
  String? userId;
  String? slug;
  dynamic categoryIds;
  String? storeName;
  String? storeDescription;
  String? logo;
  String? storeUrl;
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

  Data(
      {this.id,
      this.userId,
      this.slug,
      this.categoryIds,
      this.storeName,
      this.storeDescription,
      this.logo,
      this.storeUrl,
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

  Data.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    userId = json['user_id'];
    slug = json['slug'];
    categoryIds = json['category_ids'];
    storeName = json['store_name'];
    storeDescription = json['store_description'];
    logo = json['logo'];
    storeUrl = json['store_url'];
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
