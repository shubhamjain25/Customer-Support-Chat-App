import 'package:flutter/material.dart';
import 'package:customer_support_app/constants.dart';

class CustomBtn extends StatelessWidget {
  final bool isColor;
  final Function btnPressed;
  final String btnText;
  final bool isVisible;

  CustomBtn(
      {required this.isColor,
      required this.btnPressed,
      required this.btnText,
      required this.isVisible});

  @override
  Widget build(BuildContext context) {
    bool _isColor = isColor ? true:false;
    bool _isVisible = isVisible ? true:false;
    //If variable isVisible equals null then _isVisible becomes false

    return GestureDetector(
      onTap: () => btnPressed(),
      child: Container(
        width: double.infinity,
        margin: EdgeInsets.symmetric(horizontal: 20.0, vertical: 20.0),
        height: 60.0,
        decoration: BoxDecoration(
          border: Border.all(
            width: 1.5,
            color: _isColor ? Colors.black : Colors.white,
          ),
          color: _isColor ? Colors.white : Colors.black,
          borderRadius: BorderRadius.circular(12.0),
        ),
        child: Stack(
          children: <Widget>[
            Visibility(
              visible: _isVisible ? false : true,
              child: Center(
                child: Text(
                  btnText,
                  style: TextStyle(
                      fontSize: 22.0,
                      color: _isColor ? Colors.black : Colors.white,
                      fontWeight: FontWeight.w500),
                ),
              ),
            ),
            Visibility(
              visible: _isVisible ? true : false,
              child: Container(
                child: Center(
                  child: CircularProgressIndicator(),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class CustomTextField extends StatelessWidget {
  final bool isObscureText;
  final String hintMessage;
  final Function(String) onChanged;
  final Function(String) onSubmit;
  // final FocusNode focusNode;

  CustomTextField({
    required this.isObscureText,
    required this.hintMessage,
    required this.onChanged,
    required this.onSubmit,
    // required this.focusNode
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 20.0, vertical: 5.0),
      child: TextField(
        onChanged: onChanged,
        onSubmitted: onSubmit,
        // focusNode: focusNode,
        obscureText: isObscureText,
        keyboardType: TextInputType.emailAddress,
        decoration: kTextFieldDecoration.copyWith(
          hintText: hintMessage,
          hintStyle: TextStyle(
            fontSize: 20.0,
          ),
        ),
      ),
    );
  }
}
