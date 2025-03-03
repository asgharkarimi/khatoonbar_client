class Vehicle {
  int? vehicleID;
  String vehicleName;
  String plateNumber;

  Vehicle({
    this.vehicleID,
    required this.vehicleName,
    required this.plateNumber,
  });

  factory Vehicle.fromJson(Map<String, dynamic> json) {
    return Vehicle(
      vehicleID: json['VehicleID'],
      vehicleName: json['VehicleName'],
      plateNumber: json['PlateNumber'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'VehicleID': vehicleID,
      'VehicleName': vehicleName,
      'PlateNumber': plateNumber,
    };
  }
} 