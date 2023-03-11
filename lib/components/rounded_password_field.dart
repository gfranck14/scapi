import 'package:flutter/material.dart';
import 'package:new_scapi/components/text_field_container.dart';
import 'package:new_scapi/constants.dart';

class RoundedPasswordField extends StatelessWidget {

  final ValueChanged<String> onChanged;
  const RoundedPasswordField({
    required Key key,
    required this.onChanged, required TextEditingController controller,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return TextFieldContainer(
      key: ObjectKey(TextFieldContainer),
      child: TextField(
        obscureText: true,
        onChanged: onChanged,
        cursorColor: kPrimaryColor,
        decoration: InputDecoration(
          hintText: "Password",
          icon: Icon(
            Icons.lock,
            color: kPrimaryColor,
          ),
          suffixIcon: Icon(
            Icons.visibility,
            color: kPrimaryColor,
          ),
          border: InputBorder.none,
        ),
      ),
    );
  }
}
