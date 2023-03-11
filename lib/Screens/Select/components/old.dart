// To parse this JSON data, do
//
//     final agent = agentFromJson(jsonString);

import 'package:meta/meta.dart';
import 'dart:convert';

Users usersFromJson(String str) => Users.fromJson(json.decode(str));

String usersToJson(Users data) => json.encode(data.toJson());

class Users {
  Users({
    required this.ower,
    required this.insurance,
    required this.technical,
    required this.vignette,
  });

  Ower ower;
  Insurance insurance;
  Technical technical;
  Vignette vignette;

  factory Users.fromJson(Map<String, dynamic> json) => Users(
    ower: Ower.fromJson(json["ower"]),
    insurance: Insurance.fromJson(json["insurance"]),
    technical: Technical.fromJson(json["technical"]),
    vignette: Vignette.fromJson(json["vignette"]),
  );

  Map<String, dynamic> toJson() => {
    "ower": ower.toJson(),
    "insurance": insurance.toJson(),
    "technical": technical.toJson(),
  };
}

class Vignette {
  Vignette({
    required this.vignetteId,
    required this.adminId,
    required this.ownerId,
    required this.createDate,
    required this.vignette,
    required this.stopdate,
    required this.cardNum,
    required this.statusId,
  });

  String vignetteId;
  String adminId;
  String ownerId;
  DateTime createDate;
  DateTime vignette;
  DateTime stopdate;
  String cardNum;
  String statusId;

  factory Vignette.fromJson(Map<String, dynamic> json) => Vignette(
    vignetteId: json["vignette_id"],
    adminId: json["admin_id"],
    ownerId: json["owner_id"],
    createDate: DateTime.parse(json["create_date"]),
    vignette: DateTime.parse(json["vignette"]),
    stopdate: DateTime.parse(json["stopdate"]),
    cardNum: json["card_num"],
    statusId: json["status_id"],
  );

  Map<String, dynamic> toJson() => {
    "vignette_id": vignetteId,
    "admin_id": adminId,
    "owner_id": ownerId,
    "create_date": createDate.toIso8601String(),
    "vignette": "${vignette.year.toString().padLeft(4, '0')}-${vignette.month.toString().padLeft(2, '0')}-${vignette.day.toString().padLeft(2, '0')}",
    "stopdate": "${stopdate.year.toString().padLeft(4, '0')}-${stopdate.month.toString().padLeft(2, '0')}-${stopdate.day.toString().padLeft(2, '0')}",
    "card_num": cardNum,
    "status_id": statusId,
  };
}


class Insurance {
  Insurance({
    required this.insuranceId,
    required this.adminId,
    required this.ownerId,
    required this.createDate,
    required this.insuranceDate,
    required this.istopdate,
    required this.cardNum,
    required this.statusId,
  });

  String insuranceId;
  String adminId;
  String ownerId;
  DateTime createDate;
  DateTime insuranceDate;
  DateTime istopdate;
  String cardNum;
  String statusId;

  factory Insurance.fromJson(Map<String, dynamic> json) => Insurance(
    insuranceId: json["insurance_id"],
    adminId: json["admin_id"],
    ownerId: json["owner_id"],
    createDate: DateTime.parse(json["create_date"]),
    insuranceDate: DateTime.parse(json["insurance_date"]),
    istopdate: DateTime.parse(json["istopdate"]),
    cardNum: json["card_num"],
    statusId: json["status_id"],
  );

  Map<String, dynamic> toJson() => {
    "insurance_id": insuranceId,
    "admin_id": adminId,
    "owner_id": ownerId,
    "create_date": createDate.toIso8601String(),
    "insurance_date": "${insuranceDate.year.toString().padLeft(4, '0')}-${insuranceDate.month.toString().padLeft(2, '0')}-${insuranceDate.day.toString().padLeft(2, '0')}",
    "istopdate": "${istopdate.year.toString().padLeft(4, '0')}-${istopdate.month.toString().padLeft(2, '0')}-${istopdate.day.toString().padLeft(2, '0')}",
    "card_num": cardNum,
    "status_id": statusId,
  };
}

class Ower {
  Ower({
    required this.ownershipId,
    required this.createdDate,
    required this.fname,
    required this.mname,
    required this.lname,
    required this.dob,
    required this.brand,
    required this.chasirNum,
    required this.purchasing,
    required this.customeSlip,
    required this.manufactureYr,
    required this.importSource,
    required this.serialNum,
    required this.plateNum,
    required this.mobile,
  });

  String ownershipId;
  DateTime createdDate;
  String fname;
  String mname;
  String lname;
  String dob;
  String brand;
  String chasirNum;
  String purchasing;
  dynamic customeSlip;
  dynamic manufactureYr;
  dynamic importSource;
  dynamic serialNum;
  String plateNum;
  dynamic mobile;

  factory Ower.fromJson(Map<String, dynamic> json) => Ower(
    ownershipId: json["ownership_id"],
    createdDate: DateTime.parse(json["created_date"]),
    fname: json["fname"],
    mname: json["mname"],
    lname: json["lname"],
    dob: json["dob"],
    brand: json["brand"],
    chasirNum: json["chasir_num"],
    purchasing: json["purchasing"],
    customeSlip: json["custome_slip"],
    manufactureYr: json["manufacture_yr"],
    importSource: json["import_source"],
    serialNum: json["serial_num"],
    plateNum: json["plate_num"],
    mobile: json["mobile"],
  );

  Map<String, dynamic> toJson() => {
    "ownership_id": ownershipId,
    "created_date": createdDate.toIso8601String(),
    "fname": fname,
    "mname": mname,
    "lname": lname,
    "dob": dob,
    "brand": brand,
    "chasir_num": chasirNum,
    "purchasing": purchasing,
    "custome_slip": customeSlip,
    "manufacture_yr": manufactureYr,
    "import_source": importSource,
    "serial_num": serialNum,
    "plate_num": plateNum,
    "mobile": mobile,
  };
}

class Technical {
  Technical({
    required this.technicalId,
    required this.adminId,
    required this.ownerId,
    required this.createDate,
    required this.technicalVisit,
    required this.tstopdate,
    required this.cardNum,
    required this.statusId,
  });

  String technicalId;
  String adminId;
  String ownerId;
  DateTime createDate;
  DateTime technicalVisit;
  dynamic tstopdate;
  String cardNum;
  String statusId;

  factory Technical.fromJson(Map<String, dynamic> json) => Technical(
    technicalId: json["technical_id"],
    adminId: json["admin_id"],
    ownerId: json["owner_id"],
    createDate: DateTime.parse(json["create_date"]),
    technicalVisit: DateTime.parse(json["technical_visit"]),
    tstopdate: json["tstopdate"],
    cardNum: json["card_num"],
    statusId: json["status_id"],
  );

  Map<String, dynamic> toJson() => {
    "technical_id": technicalId,
    "admin_id": adminId,
    "owner_id": ownerId,
    "create_date": createDate.toIso8601String(),
    "technical_visit": "${technicalVisit.year.toString().padLeft(4, '0')}-${technicalVisit.month.toString().padLeft(2, '0')}-${technicalVisit.day.toString().padLeft(2, '0')}",
    "tstopdate": tstopdate,
    "card_num": cardNum,
    "status_id": statusId,
  };
}
