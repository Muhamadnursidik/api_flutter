class Field {
  final int id;
  final String name;
  final String img;
  final int locationId;
  final String type;
  final int pricePerHour;
  final String description;

  Field({
    required this.id,
    required this.name,
    required this.img,
    required this.locationId,
    required this.type,
    required this.pricePerHour,
    required this.description,
  });

  factory Field.fromJson(Map<String, dynamic> json) {
    return Field(
      id: json['id'],
      name: json['name'],
      img: json['img'],
      locationId: json['location_id'],
      type: json['type'],
      pricePerHour: json['price_per_hour'],
      description: json['description'],
    );
  }
}
