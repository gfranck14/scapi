// To parse this JSON data, do
//
//     final agent = agentFromJson(jsonString);

import 'package:meta/meta.dart';
import 'dart:convert';

Agent agentFromJson(String str) => Agent.fromJson(json.decode(str));

String agentToJson(Agent data) => json.encode(data.toJson());

class Agent {
  Agent({
    required this.adminId,
    required this.fullname,
    required this.email,
    required this.mobile,
    required this.username,
    required this.password,
    required this.department,
    required this.role,
    required this.statusId,
  });

  String adminId;
  String fullname;
  String email;
  String mobile;
  String username;
  String password;
  String department;
  String role;
  String statusId;

  factory Agent.fromJson(Map<String, dynamic> json) => Agent(
    adminId: json["admin_id"],
    fullname: json["fullname"],
    email: json["email"],
    mobile: json["mobile"],
    username: json["username"],
    password: json["password"],
    department: json["department"],
    role: json["role"],
    statusId: json["status_id"],
  );

  Map<String, dynamic> toJson() => {
    "admin_id": adminId,
    "fullname": fullname,
    "email": email,
    "mobile": mobile,
    "username": username,
    "password": password,
    "department": department,
    "role": role,
    "status_id": statusId,
  };
}
