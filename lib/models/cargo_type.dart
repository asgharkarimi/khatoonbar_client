class CargoType {
  int? cargoTypeID;
  String cargoTypeName;

  CargoType({
    this.cargoTypeID,
    required this.cargoTypeName,
  });

  factory CargoType.fromJson(Map<String, dynamic> json) {
    return CargoType(
      cargoTypeID: json['CargoTypeID'],
      cargoTypeName: json['CargoTypeName'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'CargoTypeID': cargoTypeID,
      'CargoTypeName': cargoTypeName,
    };
  }
} 