//
//
// class LabSearchModel {
//   final int labId;
//   final String labName;
//   final String location;
//   final String city;
//   final double latitude;
//   final double longitude;
//   final List<TestModel> tests;
//   final List<PackageModel> packages;
//   final double distanceKm;
//   final int tatTime;
//
//   LabSearchModel({
//     required this.labId, required this.labName, required this.location,
//     required this.city, required this.latitude, required this.longitude,
//     required this.tests, required this.packages, required this.distanceKm,
//     required this.tatTime,
//   });
//
//   factory LabSearchModel.fromJson(Map<String, dynamic> json) {
//     return LabSearchModel(
//       labId: json['labId'] ?? 0,
//       labName: json['labName'] ?? "N/A",
//       location: json['location'] ?? "N/A",
//       city: json['city'] ?? "N/A",
//       latitude: (json['latitude'] as num?)?.toDouble() ?? 0.0,
//       longitude: (json['longitude'] as num?)?.toDouble() ?? 0.0,
//       tests: (json['tests'] as List?)?.map((e) => TestModel.fromJson(e)).toList() ?? [],
//       packages: (json['packages'] as List?)?.map((e) => PackageModel.fromJson(e)).toList() ?? [],
//       distanceKm: (json['distanceKm'] as num?)?.toDouble() ?? 0.0,
//       tatTime: (json['tatTime'] as num?)?.toInt() ?? 0,
//     );
//   }
// }
//
// class TestModel {
//   final int labTestId;
//   final String testName;
//   final double price;
//   TestModel({required this.labTestId, required this.testName, required this.price});
//   factory TestModel.fromJson(Map<String, dynamic> json) => TestModel(
//     labTestId: json['labTestId'] ?? 0,
//     testName: json['testName'] ?? "",
//     price: (json['price'] as num?)?.toDouble() ?? 0.0,
//   );
// }
//
// class PackageModel {
//   final int packageId;
//   final String packageName;
//   final double price;
//   PackageModel({required this.packageId, required this.packageName, required this.price});
//   factory PackageModel.fromJson(Map<String, dynamic> json) => PackageModel(
//     packageId: json['packageId'] ?? 0,
//     packageName: json['packageName'] ?? "",
//     price: (json['price'] as num?)?.toDouble() ?? 0.0,
//   );
// }

class LabSearchModel {
  final int labId;
  final String labName;
  final String location;
  final String city;
  final String address;
  final bool isInWishlist;
  final bool homeCollection;
  final double latitude;
  final double longitude;
  final List<TestModel> tests;
  final List<PackageModel> packages;
  final double distanceKm;
  final int tatTime;

  LabSearchModel({
    required this.labId,
    required this.labName,
    required this.location,
    required this.city,
    required this.address,
    required this.isInWishlist,
    required this.homeCollection,
    required this.latitude,
    required this.longitude,
    required this.tests,
    required this.packages,
    required this.distanceKm,
    required this.tatTime,
  });

  factory LabSearchModel.fromJson(Map<String, dynamic> json) {
    return LabSearchModel(
      labId: json['labId'] ?? 0,
      labName: json['labName'] ?? "N/A",
      location: json['location'] ?? "N/A",
      city: json['city'] ?? "N/A",
      address: json['address'] ?? "N/A",
      isInWishlist: json['isInWishlist'] ?? false,
      homeCollection: json['homeCollection'] ?? false,
      latitude: (json['latitude'] as num?)?.toDouble() ?? 0.0,
      longitude: (json['longitude'] as num?)?.toDouble() ?? 0.0,
      tests: (json['tests'] as List?)
          ?.map((e) => TestModel.fromJson(e))
          .toList() ?? [],
      packages: (json['packages'] as List?)
          ?.map((e) => PackageModel.fromJson(e))
          .toList() ?? [],
      distanceKm: (json['distanceKm'] as num?)?.toDouble() ?? 0.0,
      tatTime: (json['tatTime'] as num?)?.toInt() ?? 0,
    );
  }
}

class TestModel {
  final int labTestId;
  final String testName;
  final String description;
  final double price;

  TestModel({
    required this.labTestId,
    required this.testName,
    required this.description,
    required this.price,
  });

  factory TestModel.fromJson(Map<String, dynamic> json) => TestModel(
    labTestId: json['labTestId'] ?? 0,
    testName: json['testName'] ?? "",
    description: json['discription'] ?? "", // Note: API me spelling 'discription' hai
    price: (json['price'] as num?)?.toDouble() ?? 0.0,
  );
}

class PackageModel {
  final int labPackageMasterId;
  final String packageName;
  final String description;
  final double price;

  PackageModel({
    required this.labPackageMasterId,
    required this.packageName,
    required this.description,
    required this.price,
  });

  factory PackageModel.fromJson(Map<String, dynamic> json) => PackageModel(
    labPackageMasterId: json['labPackageMasterId'] ?? 0,
    packageName: json['packageName'] ?? "",
    description: json['description'] ?? "",
    price: (json['price'] as num?)?.toDouble() ?? 0.0,
  );
}