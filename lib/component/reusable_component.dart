import 'package:flutter/material.dart';
import 'package:goat/styles/colors.dart';

Text defualtText(
    {required String txt,
     Color? color,
    FontWeight? fontwit,
    int? mxLines}) {
  return Text(
    txt,
    maxLines: mxLines,
    style: TextStyle(
      color: color,
      fontWeight: fontwit,
    ),
  );
}

IconButton defualtIconButton(
    {required Icon icon, required onpressed, double? siz, Color? color}) {
  return IconButton(
    onPressed: onpressed,
    icon: icon,
    iconSize: siz,
    color: color,
  );
}

SizedBox defualtVersticalSizedBox({required double height}) {
  return SizedBox(
    height: height,
  );
}

SizedBox defualtHorizontalSizedBox({required double width}) {
  return SizedBox(
    width: width,
  );
}

TextFormField defualtTextForm(
    {required onTap,
    required InputDecoration decoration,
    required TextEditingController controller,
    required TextInputType keyboardType,
    onSubmit,
    })=>
 TextFormField(
    onTap: onTap,
    decoration: decoration,
    controller: controller,
    keyboardType: keyboardType,
    onFieldSubmitted: onSubmit,
   cursorColor: wit_300,
  );
