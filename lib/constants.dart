import 'package:flutter/material.dart';

const kCheckText = TextStyle(
  fontSize: 30.0,
  fontStyle: FontStyle.italic,
);

const kTextFieldDecoration = InputDecoration(
  fillColor: Color(0xFFF2F2F2),
  filled: true,
  hintText: 'Enter a value',
  contentPadding: EdgeInsets.symmetric(horizontal: 10.0, vertical: 10.0),
  border: OutlineInputBorder(
    borderRadius: BorderRadius.all(
      Radius.circular(10.0),
    ),
  ),
  enabledBorder: OutlineInputBorder(
    borderSide: BorderSide(color:Colors.black, width:1.0),
    borderRadius: BorderRadius.all(
      Radius.circular(10.0),
    ),
  ),
  focusedBorder: OutlineInputBorder(
    borderSide: BorderSide(color:Colors.black, width:2.0),
    borderRadius: BorderRadius.all(
      Radius.circular(10.0),
    ),
  ),
);

const kHeadingStyle = TextStyle(fontSize: 25.0, fontWeight: FontWeight.w500);

const kCartTextStyle= TextStyle(
  fontSize: 25.0,
  fontWeight: FontWeight.w600,
  color: Colors.white,
);

const kPriceTextStyle = TextStyle(
  color: Color(0xFFFF1E00),
  fontSize: 25.0,
  fontWeight: FontWeight.w600,
);

const kShoeNameStyle = TextStyle(fontSize: 25.0, fontWeight: FontWeight.w700);

const kShoePriceStyle = TextStyle(
  color: Color(0xFFFF1E00),
  fontSize: 24.0,
  fontWeight: FontWeight.w600,
);

const kShoeDescStyle = TextStyle(fontSize:16.0, color:Colors.black54);

const kShoeSizeStyle = TextStyle(
  color: Colors.black,
  fontSize: 20.0,
  fontWeight: FontWeight.w600,
);

const kAddToCartStyle =TextStyle(
  fontSize: 25.0,
  fontWeight: FontWeight.w400,
  color: Colors.white,
);

const kCartShoeSizeStyle = TextStyle(fontSize:19.0, color:Colors.black54, fontWeight: FontWeight.w400);
