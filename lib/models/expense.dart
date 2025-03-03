class Expense {
  int? cargoID;
  double billOfLadingCost;
  String? billOfLadingImage;
  String? highwayTollImage;
  String? dieselCostImage;

  Expense({
    this.cargoID,
    required this.billOfLadingCost,
    this.billOfLadingImage,
    this.highwayTollImage,
    this.dieselCostImage,
  });

  Map<String, dynamic> toJson() {
    return {
      'CargoID': cargoID,
      'BillOfLadingCost': billOfLadingCost,
      'BillOfLadingImage': billOfLadingImage,
      'HighwayTollImage': highwayTollImage,
      'DieselCostImage': dieselCostImage,
    };
  }
} 