// To parse this JSON data, do
//
//     final loginModel = loginModelFromJson(jsonString);

import 'dart:convert';

LoginModel loginModelFromJson(String str) => LoginModel.fromJson(json.decode(str));

String loginModelToJson(LoginModel data) => json.encode(data.toJson());

class LoginModel {
    LoginModel({
        this.jwt,
        this.user,
    });

    String jwt;
    User user;

    factory LoginModel.fromJson(Map<String, dynamic> json) => LoginModel(
        jwt: json["jwt"],
        user: User.fromJson(json["user"]),
    );

    Map<String, dynamic> toJson() => {
        "jwt": jwt,
        "user": user.toJson(),
    };
}

class User {
    User({
        this.id,
        this.username,
        this.email,
        this.provider,
        this.confirmed,
        this.blocked,
        this.role,
        this.telefono,
        this.isPaciente,
        this.sexo,
        this.createdAt,
        this.updatedAt,
    });

    int id;
    String username;
    String email;
    String provider;
    bool confirmed;
    dynamic blocked;
    Role role;
    dynamic telefono;
    bool isPaciente;
    bool sexo;
    DateTime createdAt;
    DateTime updatedAt;

    factory User.fromJson(Map<String, dynamic> json) => User(
        id: json["id"],
        username: json["username"],
        email: json["email"],
        provider: json["provider"],
        confirmed: json["confirmed"],
        blocked: json["blocked"],
        role: Role.fromJson(json["role"]),
        telefono: json["telefono"],
        isPaciente: json["is_paciente"],
        sexo: json["sexo"],
        createdAt: DateTime.parse(json["created_at"]),
        updatedAt: DateTime.parse(json["updated_at"]),
    );

    Map<String, dynamic> toJson() => {
        "id": id,
        "username": username,
        "email": email,
        "provider": provider,
        "confirmed": confirmed,
        "blocked": blocked,
        "role": role.toJson(),
        "telefono": telefono,
        "is_paciente": isPaciente,
        "sexo": sexo,
        "created_at": createdAt.toIso8601String(),
        "updated_at": updatedAt.toIso8601String(),
    };
}

class Role {
    Role({
        this.id,
        this.name,
        this.description,
        this.type,
    });

    int id;
    String name;
    String description;
    String type;

    factory Role.fromJson(Map<String, dynamic> json) => Role(
        id: json["id"],
        name: json["name"],
        description: json["description"],
        type: json["type"],
    );

    Map<String, dynamic> toJson() => {
        "id": id,
        "name": name,
        "description": description,
        "type": type,
    };
}
