import 'dart:convert';

Users usersFromJson(String str) => Users.fromJson(json.decode(str));

String usersToJson(Users data) => json.encode(data.toJson());

class Users {
  Users({
    required this.assurance,
    required this.visite,
    required this.vignette,
  });

  String assurance;
  String visite;
  String vignette;

  factory Users.fromJson(Map<String, dynamic> json) => Users(
        assurance: json["assurance"],
        visite: json["visite"],
        vignette: json["vignette"],
      );

  Map<String, dynamic> toJson() => {
        "assurance": assurance,
        "visite": visite,
        "vignette": vignette,
      };
}
