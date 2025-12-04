class PlanModel {
  final String id;
  final String name;
  final int durationInMonths;
  final double price;
  final String description;

  PlanModel({
    required this.id,
    required this.name,
    required this.durationInMonths,
    required this.price,
    required this.description,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
      'durationInMonths': durationInMonths,
      'price': price,
      'description': description,
    };
  }

  factory PlanModel.fromMap(Map<String, dynamic> map, String id) {
    return PlanModel(
      id: id,
      name: map['name'] ?? '',
      durationInMonths: map['durationInMonths'] ?? 1,
      price: (map['price'] ?? 0).toDouble(),
      description: map['description'] ?? '',
    );
  }
}
