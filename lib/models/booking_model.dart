// To parse this JSON data, do
//
//     final booking = bookingFromJson(jsonString);

import 'dart:convert';

Booking bookingFromJson(String str) => Booking.fromJson(json.decode(str));

String bookingToJson(Booking data) => json.encode(data.toJson());

class Booking {
    bool? success;
    List<Datum>? data;
    String? message;

    Booking({
        this.success,
        this.data,
        this.message,
    });

    factory Booking.fromJson(Map<String, dynamic> json) => Booking(
        success: json["success"],
        data: json["data"] == null ? [] : List<Datum>.from(json["data"]!.map((x) => Datum.fromJson(x))),
        message: json["message"],
    );

    Map<String, dynamic> toJson() => {
        "success": success,
        "data": data == null ? [] : List<dynamic>.from(data!.map((x) => x.toJson())),
        "message": message,
    };
}

class Datum {
    int? id;
    int? fieldId;
    int? userId;
    DateTime? startTime;
    DateTime? endTime;
    String? status;
    DateTime? createdAt;
    DateTime? updatedAt;
    Field? field;
    User? user;

    Datum({
        this.id,
        this.fieldId,
        this.userId,
        this.startTime,
        this.endTime,
        this.status,
        this.createdAt,
        this.updatedAt,
        this.field,
        this.user,
    });

    factory Datum.fromJson(Map<String, dynamic> json) => Datum(
        id: json["id"],
        fieldId: json["field_id"],
        userId: json["user_id"],
        startTime: json["start_time"] == null ? null : DateTime.parse(json["start_time"]),
        endTime: json["end_time"] == null ? null : DateTime.parse(json["end_time"]),
        status: json["status"],
        createdAt: json["created_at"] == null ? null : DateTime.parse(json["created_at"]),
        updatedAt: json["updated_at"] == null ? null : DateTime.parse(json["updated_at"]),
        field: json["field"] == null ? null : Field.fromJson(json["field"]),
        user: json["user"] == null ? null : User.fromJson(json["user"]),
    );

    Map<String, dynamic> toJson() => {
        "id": id,
        "field_id": fieldId,
        "user_id": userId,
        "start_time": startTime?.toIso8601String(),
        "end_time": endTime?.toIso8601String(),
        "status": status,
        "created_at": createdAt?.toIso8601String(),
        "updated_at": updatedAt?.toIso8601String(),
        "field": field?.toJson(),
        "user": user?.toJson(),
    };
}

class Field {
    int? id;
    String? name;
    String? img;
    int? locationId;
    String? type;
    int? pricePerHour;
    String? description;
    DateTime? createdAt;
    DateTime? updatedAt;

    Field({
        this.id,
        this.name,
        this.img,
        this.locationId,
        this.type,
        this.pricePerHour,
        this.description,
        this.createdAt,
        this.updatedAt,
    });

    factory Field.fromJson(Map<String, dynamic> json) => Field(
        id: json["id"],
        name: json["name"],
        img: json["img"],
        locationId: json["location_id"],
        type: json["type"],
        pricePerHour: json["price_per_hour"],
        description: json["description"],
        createdAt: json["created_at"] == null ? null : DateTime.parse(json["created_at"]),
        updatedAt: json["updated_at"] == null ? null : DateTime.parse(json["updated_at"]),
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
    };
}

class User {
    int? id;
    String? name;
    String? email;
    dynamic emailVerifiedAt;
    DateTime? createdAt;
    DateTime? updatedAt;

    User({
        this.id,
        this.name,
        this.email,
        this.emailVerifiedAt,
        this.createdAt,
        this.updatedAt,
    });

    factory User.fromJson(Map<String, dynamic> json) => User(
        id: json["id"],
        name: json["name"],
        email: json["email"],
        emailVerifiedAt: json["email_verified_at"],
        createdAt: json["created_at"] == null ? null : DateTime.parse(json["created_at"]),
        updatedAt: json["updated_at"] == null ? null : DateTime.parse(json["updated_at"]),
    );

    Map<String, dynamic> toJson() => {
        "id": id,
        "name": name,
        "email": email,
        "email_verified_at": emailVerifiedAt,
        "created_at": createdAt?.toIso8601String(),
        "updated_at": updatedAt?.toIso8601String(),
    };
}
