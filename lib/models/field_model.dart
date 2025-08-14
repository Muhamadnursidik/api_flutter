import 'dart:convert';

Field fieldModelFromJson(String str) => Field.fromJson(json.decode(str));

String fieldModelToJson(Field data) => json.encode(data.toJson());

class Field {
    bool? success;
    List<DataField>? data;
    String? message;

    Field({
        this.success,
        this.data,
        this.message,
    });

    factory Field.fromJson(Map<String, dynamic> json) => Field(
        success: json["success"],
        data: json["data"] == null ? [] : List<DataField>.from(json["data"]!.map((x) => DataField.fromJson(x))),
        message: json["message"],
    );

    Map<String, dynamic> toJson() => {
        "success": success,
        "data": data == null ? [] : List<dynamic>.from(data!.map((x) => x.toJson())),
        "message": message,
    };
}

class DataField {
    final int? id;
    final String? name;
    final String? img;
    final int? locationId;
    final String? type;
    final int? pricePerHour;
    final String? description;
    final DateTime? createdAt;
    final DateTime? updatedAt;
    final Location? location;

    DataField({
        this.id,
        this.name,
        this.img,
        this.locationId,
        this.type,
        this.pricePerHour,
        this.description,
        this.createdAt,
        this.updatedAt,
        this.location,
    });

    factory DataField.fromJson(Map<String, dynamic> json) => DataField(
        id: json["id"],
        name: json["name"],
        img: json["img"],
        locationId: json["location_id"],
        type: json["type"],
        pricePerHour: json["price_per_hour"],
        description: json["description"],
        createdAt: json["created_at"] == null ? null : DateTime.parse(json["created_at"]),
        updatedAt: json["updated_at"] == null ? null : DateTime.parse(json["updated_at"]),
        location: json["location"] == null ? null : Location.fromJson(json["location"]),
    );

    Map<String, dynamic> toJson() => {
        "id": id,
        "name": name,
        "img": img,
        "location_id": locationId,
        "type": type,
        "price_per_hour": pricePerHour,
        "description": description,
        "created_at": createdAt?.toIso8601String(),
        "updated_at": updatedAt?.toIso8601String(),
        "location": location?.toJson(),
    };
}

class Location {
    int? id;
    String? name;
    String? address;
    String? maps;
    DateTime? createdAt;
    DateTime? updatedAt;

    Location({
        this.id,
        this.name,
        this.address,
        this.maps,
        this.createdAt,
        this.updatedAt,
    });

    factory Location.fromJson(Map<String, dynamic> json) => Location(
        id: json["id"],
        name: json["name"],
        address: json["address"],
        maps: json["maps"],
        createdAt: json["created_at"] == null ? null : DateTime.parse(json["created_at"]),
        updatedAt: json["updated_at"] == null ? null : DateTime.parse(json["updated_at"]),
    );

    Map<String, dynamic> toJson() => {
        "id": id,
        "name": name,
        "address": address,
        "maps": maps,
        "created_at": createdAt?.toIso8601String(),
        "updated_at": updatedAt?.toIso8601String(),
    };
}
