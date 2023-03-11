// To parse this JSON data, do
//
//     final users = usersFromJson(jsonString);

import 'dart:convert';

Users usersFromJson(String str) => Users.fromJson(json.decode(str));

String usersToJson(Users data) => json.encode(data.toJson());

class Users {
  Users({
    required this.vehicule,
    required this.vignette,
    required this.visite,
    required this.assurance,
  });

  Vehicule vehicule;
  String vignette;
  String visite;
  String assurance;

  factory Users.fromJson(Map<String, dynamic> json) => Users(
        vehicule: Vehicule.fromJson(json["vehicule"]),
        vignette: json["vignette"],
        visite: json["visite"],
        assurance: json["assurance"],
      );

  Map<String, dynamic> toJson() => {
        "vehicule": vehicule.toJson(),
        "vignette": vignette,
        "visite": visite,
        "assurance": assurance,
      };
}

class Vehicule {
  Vehicule({
    required this.id,
    required this.matricule,
    required this.marque,
    required this.chassis,
    required this.prix,
    required this.origine,
    required this.annee,
    required this.serie,
    required this.dateAcquisition,
    required this.bordereau,
    required this.visite,
    required this.assurence,
    required this.vignette,
    required this.userId,
    required this.createdAt,
    required this.updatedAt,
    required this.proprio,
  });

  int id;
  String matricule;
  String marque;
  String chassis;
  int prix;
  String origine;
  int annee;
  String serie;
  DateTime dateAcquisition;
  dynamic bordereau;
  int visite;
  int assurence;
  int vignette;
  int userId;
  DateTime createdAt;
  DateTime updatedAt;
  Proprio proprio;

  factory Vehicule.fromJson(Map<String, dynamic> json) => Vehicule(
        id: json["id"],
        matricule: json["matricule"],
        marque: json["marque"],
        chassis: json["chassis"],
        prix: json["prix"],
        origine: json["origine"],
        annee: json["annee"],
        serie: json["serie"],
        dateAcquisition: DateTime.parse(json["dateAcquisition"]),
        bordereau: json["bordereau"],
        visite: json["visite"],
        assurence: json["assurence"],
        vignette: json["vignette"],
        userId: json["user_id"],
        createdAt: DateTime.parse(json["created_at"]),
        updatedAt: DateTime.parse(json["updated_at"]),
        proprio: Proprio.fromJson(json["proprio"]),
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "matricule": matricule,
        "marque": marque,
        "chassis": chassis,
        "prix": prix,
        "origine": origine,
        "annee": annee,
        "serie": serie,
        "dateAcquisition":
            "${dateAcquisition.year.toString().padLeft(4, '0')}-${dateAcquisition.month.toString().padLeft(2, '0')}-${dateAcquisition.day.toString().padLeft(2, '0')}",
        "bordereau": bordereau,
        "visite": visite,
        "assurence": assurence,
        "vignette": vignette,
        "user_id": userId,
        "created_at": createdAt.toIso8601String(),
        "updated_at": updatedAt.toIso8601String(),
        "proprio": proprio.toJson(),
      };
}

class Proprio {
  Proprio({
    required this.id,
    required this.nom,
    required this.prenom,
    required this.tel,
    required this.dateNaiss,
    required this.email,
    required this.adresse,
    required this.sexe,
    required this.groupeSanguin,
  });

  int id;
  String nom;
  String prenom;

  String tel;
  DateTime dateNaiss;
  String email;
  dynamic adresse;
  String sexe;
  String groupeSanguin;

  factory Proprio.fromJson(Map<String, dynamic> json) => Proprio(
        id: json["id"],
        nom: json["nom"],
        prenom: json["prenom"],
        tel: json["tel"],
        dateNaiss: DateTime.parse(json["dateNaiss"]),
        email: json["email"],
        adresse: json["adresse"],
        sexe: json["sexe"],
        groupeSanguin: json["groupeSanguin"],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "nom": nom,
        "prenom": prenom,
        "tel": tel,
        "dateNaiss": dateNaiss.toIso8601String(),
        "email": email,
        "adresse": adresse.toString(),
        "sexe": sexe,
        "groupeSanguin": groupeSanguin,
      };
}
