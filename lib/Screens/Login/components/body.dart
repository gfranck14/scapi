import 'dart:async';
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:http/http.dart' as http;
import 'package:new_scapi/Screens/Login/components/background.dart';
import 'package:new_scapi/Screens/Select/select_screen.dart';
import 'package:new_scapi/components/rounded_button.dart';

import '../../../constants.dart';

class Body extends StatefulWidget {
  const Body({
    required Key key,
  }) : super(key: key);

  @override
  State<Body> createState() => _BodyState();
}

class _BodyState extends State<Body> {
  TextEditingController _username = TextEditingController();
  TextEditingController _password = TextEditingController();
  bool hidePassword = false;

  get key => null;

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Background(
      key: ValueKey(key),
      child: SingleChildScrollView(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Text(
              "LOGIN",
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
            SizedBox(height: size.height * 0.03),
            SvgPicture.asset(
              "assets/icons/login.svg",
              height: size.height * 0.35,
            ),
            SizedBox(height: size.height * 0.03),
            Container(
              margin: EdgeInsets.symmetric(vertical: 10),
              padding: EdgeInsets.symmetric(horizontal: 20, vertical: 5),
              width: size.width * 0.8,
              decoration: BoxDecoration(
                color: kPrimaryLightColor,
                borderRadius: BorderRadius.circular(29),
              ),
              child: TextField(
                controller: _username,
                // onChanged: onChanged,
                cursorColor: kPrimaryColor,
                decoration: InputDecoration(
                  icon: Icon(
                    Icons.person,
                    color: kPrimaryColor,
                  ),
                  hintText: "Your Email",
                  border: InputBorder.none,
                ),
              ),
            ),
            Container(
              margin: EdgeInsets.symmetric(vertical: 10),
              padding: EdgeInsets.symmetric(horizontal: 20, vertical: 5),
              width: size.width * 0.8,
              decoration: BoxDecoration(
                color: kPrimaryLightColor,
                borderRadius: BorderRadius.circular(29),
              ),
              child: TextField(
                controller: _password,
                obscureText: hidePassword,
                //  onChanged: onChanged,
                cursorColor: kPrimaryColor,
                decoration: InputDecoration(
                  hintText: "Password",
                  icon: Icon(
                    Icons.lock,
                    color: kPrimaryColor,
                  ),
                  suffixIcon: IconButton(
                    onPressed: () {
                      setState(() {
                        hidePassword = !hidePassword;
                      });
                    },
                    color: kPrimaryColor,
                    icon: Icon(
                        hidePassword ? Icons.visibility_off : Icons.visibility),
                  ),
                  border: InputBorder.none,
                ),
              ),
            ),
            RoundedButton(
              text: "NEXT",
              press: () {
                //var usernamefield = _username.text;
                //var passwordfield = _password.text;
                //getLogin(usernamefield, passwordfield);
                Navigator.of(context).push(
                    MaterialPageRoute(builder: (context) => SelectScreen()));
              },
              key: ValueKey(1),
            ),
          ],
        ),
      ),
    );
  }

  getLogin(String username, String password) async {
    final url =
        "https://api.iquipedigital.com/car/?endpoint=agent-login&username=$username&password=$password";
    final response = await http.get(url);

    //  debugPrint(response.statusCode.toString());
    if (response.statusCode == 200) {
      if (response.body == "false") {
        final snackBar = SnackBar(
          content: Text(
            "Identifiants incorrects",
            style: TextStyle(fontSize: 16),
          ),
          backgroundColor: Colors.red,
        );
        ScaffoldMessenger.of(context).showSnackBar(snackBar);
        debugPrint("Identifiants incorrects");
      } else {
        final jsonLogin = jsonDecode(response.body);
        final snackBar = SnackBar(
          content: Text(
            "Accès autorisé",
            style: TextStyle(fontSize: 16),
          ),
          backgroundColor: Colors.green,
        );
        ScaffoldMessenger.of(context).showSnackBar(snackBar);
        debugPrint("Identifiants corrects");
        // Agent.fromJson(jsonLogin);
        Timer(Duration(seconds: 3), () {
          Navigator.of(context)
              .push(MaterialPageRoute(builder: (context) => SelectScreen()));
        });
      }
    } else {
      // snqckbqr indentifiqnts incorrects
      throw Exception();
    }
  }
}

//...........................
// getLogin(String username, String password) async {
//   final url =
//       "https://api.iquipedigital.com/car/?endpoint=agent-login&username=$username&password=$password";
//   final response = await http.get(url);
//
//       debugPrint(response.statusCode.toString());
//   if (response.statusCode == 200) {
//     if (response.body == "false") {
//       debugPrint("Identifiants incorrects");
//     } else {
//       final jsonLogin = jsonDecode(response.body);
//       debugPrint("Identifiants corrects");
//     return Agent.fromJson(jsonLogin);
//     }
//
//
//   } else {
//     // snqckbqr indentifiqnts incorrects
//     throw Exception();
//   }
// }

//............................api request
