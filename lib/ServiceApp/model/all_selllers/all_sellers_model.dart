class AllSellersRes {
  Pagination? pagination;
  List<Data>? data;

  AllSellersRes({this.pagination, this.data});

  AllSellersRes.fromJson(Map<String, dynamic> json) {
    pagination = json['pagination'] != null
        ? Pagination.fromJson(json['pagination'])
        : null;
    if (json['data'] != null) {
      data = <Data>[];
      json['data'].forEach((v) {
        data!.add(Data.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    if (pagination != null) {
      data['pagination'] = pagination!.toJson();
    }
    if (this.data != null) {
      data['data'] = this.data!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class Pagination {
  int? totalItems;
  int? perPage;
  int? currentPage;
  int? totalPages;
  int? from;
  int? to;
  dynamic nextPage;
  dynamic previousPage;

  Pagination(
      {this.totalItems,
      this.perPage,
      this.currentPage,
      this.totalPages,
      this.from,
      this.to,
      this.nextPage,
      this.previousPage});

  Pagination.fromJson(Map<String, dynamic> json) {
    totalItems = json['total_items'];
    perPage = json['per_page'];
    currentPage = json['currentPage'];
    totalPages = json['totalPages'];
    from = json['from'];
    to = json['to'];
    nextPage = json['next_page'];
    previousPage = json['previous_page'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['total_items'] = totalItems;
    data['per_page'] = perPage;
    data['currentPage'] = currentPage;
    data['totalPages'] = totalPages;
    data['from'] = from;
    data['to'] = to;
    data['next_page'] = nextPage;
    data['previous_page'] = previousPage;
    return data;
  }
}

class Data {
  int? id;
  String? firstName;
  String? lastName;
  String? username;
  dynamic providerId;
  int? status;
  String? description;
  String? userType;
  String? email;
  String? contactNumber;
  int? countryId;
  int? stateId;
  int? cityId;
  String? cityName;
  String? address;
  int? providerTypeId;
  String? providerType;
  int? isFeatured;
  String? displayName;
  String? createdAt;
  String? updatedAt;
  dynamic deletedAt;
  String? profileImage;
  String? timeZone;
  dynamic uid;
  dynamic loginType;
  dynamic serviceAddressId;
  String? lastNotificationSeen;
  int? providersServiceRating;
  int? handymanRating;
  int? isVerifyProvider;
  int? isHandymanAvailable;
  String? designation;
  int? handymanTypeId;
  String? handymanType;
  String? knownLanguages;
  String? skills;
  int? isFavorite;
  int? totalServicesBooked;

  Data(
      {this.id,
      this.firstName,
      this.lastName,
      this.username,
      this.providerId,
      this.status,
      this.description,
      this.userType,
      this.email,
      this.contactNumber,
      this.countryId,
      this.stateId,
      this.cityId,
      this.cityName,
      this.address,
      this.providerTypeId,
      this.providerType,
      this.isFeatured,
      this.displayName,
      this.createdAt,
      this.updatedAt,
      this.deletedAt,
      this.profileImage,
      this.timeZone,
      this.uid,
      this.loginType,
      this.serviceAddressId,
      this.lastNotificationSeen,
      this.providersServiceRating,
      this.handymanRating,
      this.isVerifyProvider,
      this.isHandymanAvailable,
      this.designation,
      this.handymanTypeId,
      this.handymanType,
      this.knownLanguages,
      this.skills,
      this.isFavorite,
      this.totalServicesBooked});

  Data.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    firstName = json['first_name'];
    lastName = json['last_name'];
    username = json['username'];
    providerId = json['provider_id'];
    status = json['status'];
    description = json['description'];
    userType = json['user_type'];
    email = json['email'];
    contactNumber = json['contact_number'];
    countryId = json['country_id'];
    stateId = json['state_id'];
    cityId = json['city_id'];
    cityName = json['city_name'];
    address = json['address'];
    providerTypeId = json['providertype_id'];
    providerType = json['providertype'];
    isFeatured = json['is_featured'];
    displayName = json['display_name'];
    createdAt = json['created_at'];
    updatedAt = json['updated_at'];
    deletedAt = json['deleted_at'];
    profileImage = json['profile_image'];
    timeZone = json['time_zone'];
    uid = json['uid'];
    loginType = json['login_type'];
    serviceAddressId = json['service_address_id'];
    lastNotificationSeen = json['last_notification_seen'];
    providersServiceRating = json['providers_service_rating'];
    handymanRating = json['handyman_rating'];
    isVerifyProvider = json['is_verify_provider'];
    isHandymanAvailable = json['isHandymanAvailable'];
    designation = json['designation'];
    handymanTypeId = json['handymantype_id'];
    handymanType = json['handymantype'];
    knownLanguages = json['known_languages'];
    skills = json['skills'];
    isFavorite = json['is_favourite'];
    // if (json['player_ids'] != null) {
    //   playerIds = <Null>[];
    //   json['player_ids'].forEach((v) {
    //     playerIds!.add(new Null.fromJson(v));
    //   });
    // }
    totalServicesBooked = json['total_services_booked'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['first_name'] = firstName;
    data['last_name'] = lastName;
    data['username'] = username;
    data['provider_id'] = providerId;
    data['status'] = status;
    data['description'] = description;
    data['user_type'] = userType;
    data['email'] = email;
    data['contact_number'] = contactNumber;
    data['country_id'] = countryId;
    data['state_id'] = stateId;
    data['city_id'] = cityId;
    data['city_name'] = cityName;
    data['address'] = address;
    data['providertype_id'] = providerTypeId;
    data['providertype'] = providerType;
    data['is_featured'] = isFeatured;
    data['display_name'] = displayName;
    data['created_at'] = createdAt;
    data['updated_at'] = updatedAt;
    data['deleted_at'] = deletedAt;
    data['profile_image'] = profileImage;
    data['time_zone'] = timeZone;
    data['uid'] = uid;
    data['login_type'] = loginType;
    data['service_address_id'] = serviceAddressId;
    data['last_notification_seen'] = lastNotificationSeen;
    data['providers_service_rating'] = providersServiceRating;
    data['handyman_rating'] = handymanRating;
    data['is_verify_provider'] = isVerifyProvider;
    data['isHandymanAvailable'] = isHandymanAvailable;
    data['designation'] = designation;
    data['handymantype_id'] = handymanTypeId;
    data['handymantype'] = handymanType;
    data['known_languages'] = knownLanguages;
    data['skills'] = skills;
    data['is_favourite'] = isFavorite;
    // if (this.playerIds != null) {
    //   data['player_ids'] = this.playerIds!.map((v) => v.toJson()).toList();
    // }
    data['total_services_booked'] = totalServicesBooked;
    return data;
  }
}
