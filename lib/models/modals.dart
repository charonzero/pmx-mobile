class PackageData {
  final int? packageId;
  final String? packageSecret;
  final String name;
  final String phone;
  final String address;
  final int? townshipId;
  final String? townshipName;
  final String? cityName;
  final String? stateName;
  final String? countryName;
  final int weight;
  final int paymentTypeId;
  final PaymentTypeData? paymentType;
  final int deliveryFee;
  final int cashOnDelivery;
  final int total;
  final String? remark;
  final int packageTypeId;
  final PackageTypeData? packageType;
  final DateTime? createdDate;
  final int? packageStatusId;
  final PackageStatusData? packageStatus;
  final int? shipperId;
  final UserData? shipper;
  final int? guestId;
  final GuestData? guest;
  final int? userId;
  final UserData? user;
  final bool paid;
  final List<DeliveryData>? deliveries;
  final PackageStatusData? status;

  PackageData({
    this.packageId,
    this.packageSecret,
    required this.name,
    required this.phone,
    required this.address,
    this.townshipId,
    this.townshipName,
    this.cityName,
    this.stateName,
    this.countryName,
    required this.weight,
    required this.paymentTypeId,
    this.paymentType,
    required this.deliveryFee,
    required this.cashOnDelivery,
    required this.total,
    this.remark,
    required this.packageTypeId,
    this.packageType,
    this.createdDate,
    this.packageStatusId,
    this.packageStatus,
    this.shipperId,
    this.shipper,
    this.guestId,
    this.guest,
    this.userId,
    this.user,
    required this.paid,
    this.deliveries,
    this.status,
  });

  factory PackageData.fromJson(Map<String, dynamic> json) {
    print(GuestData.fromJson(json['guest'] as Map<String, dynamic>));
    return PackageData(
      packageId: json['package_id'] as int?,
      packageSecret: json['package_secret'] as String?,
      name: json['name'] as String,
      phone: json['phone'] as String,
      address: json['address'] as String,
      townshipId: json['township_id'] as int?,
      townshipName: json['township_name'] as String?,
      cityName: json['city_name'] as String?,
      stateName: json['state_name'] as String?,
      countryName: json['country_name'] as String?,
      weight: json['weight'] as int,
      paymentTypeId: json['payment_type_id'] as int,
      deliveryFee: json['delivery_fee'] as int,
      cashOnDelivery: json['cash_on_delivery'] as int,
      total: json['total'] as int,
      remark: json['remark'] as String?,
      packageTypeId: json['package_type_id'] as int,
      createdDate: json['created_date'] != null
          ? DateTime.parse(json['created_date'] as String)
          : null,
      packageStatusId: json['package_status_id'] as int?,
      shipperId: json['shipper_id'] as int?,
      guestId: json['guest_id'] as int?,
      userId: json['user_id'] as int?,
      paid: json['paid'] as bool,
      deliveries: json['deliveries'] != null
          ? (json['deliveries'] as List<dynamic>)
              .map((x) => DeliveryData.fromJson(x as Map<String, dynamic>))
              .toList()
          : null,
      status: json['status'] != null
          ? PackageStatusData.fromJson(json['status'] as Map<String, dynamic>)
          : null,
      shipper: json['shipper'] != null && json['shipper']['user_id'] != null
          ? UserData.fromJson(json['shipper'] as Map<String, dynamic>)
          : null,
      guest: json['guest'] != null && json['guest']['guest_id'] != null
          ? GuestData.fromJson(json['guest'] as Map<String, dynamic>)
          : null,
      user: json['user'] != null && json['user']['user_id'] != null
          ? UserData.fromJson(json['user'] as Map<String, dynamic>)
          : null,
    );
  }
}

class DeliveryData {
  final int? deliveryId;
  final int? userId;
  final int? packageId;
  final String? recordedDate;
  final int? deliveryStatusId;

  DeliveryData({
    this.deliveryId,
    this.userId,
    this.packageId,
    this.recordedDate,
    this.deliveryStatusId,
  });

  factory DeliveryData.fromJson(Map<String, dynamic> json) {
    return DeliveryData(
      deliveryId: json['delivery_id'] as int?,
      userId: json['user_id'] as int?,
      packageId: json['package_id'] as int?,
      recordedDate: json['recorded_date'] as String?,
      deliveryStatusId: json['delivery_status_id'] as int?,
    );
  }
}

class UserData {
  final int? userId;
  final String? username;
  final String? password;
  final String? salt;
  final int roleId;
  final RoleData? role;
  final String email;
  final String name;
  final String address;
  final int townshipId;
  final String phone;
  final TownshipData? township;
  final CityData? city;
  final StateData? state;
  final CountryData? country;
  final String? img;
  final String? image;

  UserData({
    this.userId,
    this.username,
    this.password,
    this.salt,
    required this.roleId,
    this.role,
    required this.email,
    required this.name,
    required this.address,
    required this.townshipId,
    required this.phone,
    this.township,
    this.city,
    this.state,
    this.country,
    this.img,
    this.image,
  });

  factory UserData.fromJson(Map<String, dynamic> json) {
    return UserData(
      userId: json['user_id'] as int?,
      username: json['username'] as String?,
      password: json['password'] as String?,
      salt: json['salt'] as String?,
      roleId: json['role_id'] as int,
      role: json['role'] != null
          ? RoleData.fromJson(json['role'] as Map<String, dynamic>)
          : null,
      email: json['email'] as String,
      name: json['name'] as String,
      address: json['address'] as String,
      townshipId: json['township_id'] as int,
      phone: json['phone'] as String,
      township: json['township'] != null
          ? TownshipData.fromJson(json['township'] as Map<String, dynamic>)
          : null,
      city: json['city'] != null
          ? CityData.fromJson(json['city'] as Map<String, dynamic>)
          : null,
      state: json['state'] != null
          ? StateData.fromJson(json['state'] as Map<String, dynamic>)
          : null,
      country: json['country'] != null
          ? CountryData.fromJson(json['country'] as Map<String, dynamic>)
          : null,
      img: json['img'] as String?,
      image: json['image'] as String?,
    );
  }
  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = {};
    data['user_id'] = userId;
    data['username'] = username;
    data['password'] = password;
    data['salt'] = salt;
    data['role_id'] = roleId;
    data['role'] = role?.toJson();
    data['email'] = email;
    data['name'] = name;
    data['address'] = address;
    data['township_id'] = townshipId;
    data['phone'] = phone;
    data['township'] = township?.toJson();
    data['city'] = city?.toJson();
    data['state'] = state?.toJson();
    data['country'] = country?.toJson();
    data['img'] = img;
    data['image'] = image;
    return data;
  }
}

class GuestData {
  final int? guestId;
  final String? name;
  final String? phone;
  final String? address;
  final int? townshipId;
  final String? townshipName;
  final String? cityName;
  final String? stateName;
  final String? countryName;
  final String? remark;

  GuestData({
    this.guestId,
    this.name,
    this.phone,
    this.address,
    this.townshipId,
    this.townshipName,
    this.cityName,
    this.stateName,
    this.countryName,
    this.remark,
  });

  factory GuestData.fromJson(Map<String, dynamic> json) {
    return GuestData(
      guestId: json['guest_id'] as int?,
      name: json['name'] as String?,
      phone: json['phone'] as String?,
      address: json['address'] as String?,
      townshipId: json['township_id'] as int?,
      townshipName: json['township_name'] as String?,
      cityName: json['city_name'] as String?,
      stateName: json['state_name'] as String?,
      countryName: json['country_name'] as String?,
      remark: json['remark'] as String?,
    );
  }
}

class PaymentTypeData {
  final int? paymentTypeId;
  final String? typeName;
  final String? shortName;

  PaymentTypeData({
    this.paymentTypeId,
    this.typeName,
    this.shortName,
  });

  factory PaymentTypeData.fromJson(Map<String, dynamic> json) {
    return PaymentTypeData(
      paymentTypeId: json['payment_type_id'] as int?,
      typeName: json['type_name'] as String?,
      shortName: json['short_name'] as String?,
    );
  }
}

class PackageTypeData {
  final int? packageTypeId;
  final String? typeName;
  final String? shortName;

  PackageTypeData({
    this.packageTypeId,
    this.typeName,
    this.shortName,
  });

  factory PackageTypeData.fromJson(Map<String, dynamic> json) {
    return PackageTypeData(
      packageTypeId: json['package_type_id'] as int?,
      typeName: json['type_name'] as String?,
      shortName: json['short_name'] as String?,
    );
  }
}

class PackageStatusData {
  final int? packageStatusId;
  final String? statusName;
  final String? statusColor;

  PackageStatusData({
    this.packageStatusId,
    this.statusName,
    this.statusColor,
  });

  factory PackageStatusData.fromJson(Map<String, dynamic> json) {
    return PackageStatusData(
      packageStatusId: json['package_status_id'] as int?,
      statusName: json['status_name'] as String?,
      statusColor: json['status_color'] as String?,
    );
  }
}

class RoleData {
  final int? roleId;
  final String? roleName;
  final List<String>? permission;
  final String? permissionLevel;

  RoleData({
    this.roleId,
    this.roleName,
    this.permission,
    this.permissionLevel,
  });

  factory RoleData.fromJson(Map<String, dynamic> json) {
    return RoleData(
      roleId: json['role_id'] as int?,
      roleName: json['role_name'] as String?,
      permission: (json['permission'] as List<dynamic>?)
          ?.map((x) => x.toString())
          .toList(),
      permissionLevel: json['permission_level'] as String?,
    );
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = {};
    data['role_id'] = roleId;
    data['role_name'] = roleName;
    data['permission'] = permission;
    data['permission_level'] = permissionLevel;
    return data;
  }
}

class TownshipData {
  final int? townshipId;
  final String? townshipName;
  final int? cityId;

  TownshipData({
    this.townshipId,
    this.townshipName,
    this.cityId,
  });

  factory TownshipData.fromJson(Map<String, dynamic> json) {
    return TownshipData(
      townshipId: json['township_id'] as int?,
      townshipName: json['township_name'] as String?,
      cityId: json['city_id'] as int?,
    );
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = {};
    data['township_id'] = townshipId;
    data['township_name'] = townshipName;
    data['city_id'] = cityId;
    return data;
  }
}

class CityData {
  final int? cityId;
  final String? cityName;
  final int? stateId;

  CityData({
    this.cityId,
    this.cityName,
    this.stateId,
  });

  factory CityData.fromJson(Map<String, dynamic> json) {
    return CityData(
      cityId: json['city_id'] as int?,
      cityName: json['city_name'] as String?,
      stateId: json['state_id'] as int?,
    );
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = {};
    data['city_id'] = cityId;
    data['city_name'] = cityName;
    data['state_id'] = stateId;
    return data;
  }
}

class StateData {
  final int? stateId;
  final String? stateName;
  final int? countryId;

  StateData({
    this.stateId,
    this.stateName,
    this.countryId,
  });

  factory StateData.fromJson(Map<String, dynamic> json) {
    return StateData(
      stateId: json['state_id'] as int?,
      stateName: json['state_name'] as String?,
      countryId: json['country_id'] as int?,
    );
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = {};
    data['state_id'] = stateId;
    data['state_name'] = stateName;
    data['country_id'] = countryId;
    return data;
  }
}

class CountryData {
  final int? countryId;
  final String? countryName;
  final String? currency;

  CountryData({
    this.countryId,
    this.countryName,
    this.currency,
  });

  factory CountryData.fromJson(Map<String, dynamic> json) {
    return CountryData(
      countryId: json['country_id'] as int?,
      countryName: json['country_name'] as String?,
      currency: json['currency'] as String?,
    );
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = {};
    data['country_id'] = countryId;
    data['country_name'] = countryName;
    data['currency'] = currency;
    return data;
  }
}

class LocationData {
  final List<CountryData>? countries;
  final List<StateData>? states;
  final List<CityData>? cities;
  final List<TownshipData>? townships;

  LocationData({
    this.countries,
    this.states,
    this.cities,
    this.townships,
  });

  factory LocationData.fromJson(Map<String, dynamic> json) {
    return LocationData(
      countries: (json['countries'] as List<dynamic>?)
          ?.map((x) => CountryData.fromJson(x as Map<String, dynamic>))
          .toList(),
      states: (json['states'] as List<dynamic>?)
          ?.map((x) => StateData.fromJson(x as Map<String, dynamic>))
          .toList(),
      cities: (json['cities'] as List<dynamic>?)
          ?.map((x) => CityData.fromJson(x as Map<String, dynamic>))
          .toList(),
      townships: (json['townships'] as List<dynamic>?)
          ?.map((x) => TownshipData.fromJson(x as Map<String, dynamic>))
          .toList(),
    );
  }
}

class GlobalData {
  final LocationData? locationData;
  final List<RoleData>? roles;
  final List<PackageTypeData>? packagesType;
  final List<PaymentTypeData>? paymentsType;
  final List<PackageStatusData>? packageStatuses;

  GlobalData({
    this.locationData,
    this.roles,
    this.packagesType,
    this.paymentsType,
    this.packageStatuses,
  });

  factory GlobalData.fromJson(Map<String, dynamic> json) {
    return GlobalData(
      locationData: json['locationData'] != null
          ? LocationData.fromJson(json['locationData'] as Map<String, dynamic>)
          : null,
      roles: (json['roles'] as List<dynamic>?)
          ?.map((x) => RoleData.fromJson(x as Map<String, dynamic>))
          .toList(),
      packagesType: (json['packagesType'] as List<dynamic>?)
          ?.map((x) => PackageTypeData.fromJson(x as Map<String, dynamic>))
          .toList(),
      paymentsType: (json['paymentsType'] as List<dynamic>?)
          ?.map((x) => PaymentTypeData.fromJson(x as Map<String, dynamic>))
          .toList(),
      packageStatuses: (json['packageStatuses'] as List<dynamic>?)
          ?.map((x) => PackageStatusData.fromJson(x as Map<String, dynamic>))
          .toList(),
    );
  }
}
