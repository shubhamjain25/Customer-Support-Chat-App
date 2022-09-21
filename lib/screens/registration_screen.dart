import 'package:customer_support_app/constants.dart';
import 'package:customer_support_app/screens/home_page.dart';
import 'package:customer_support_app/widgets/custom_button.dart';
import 'package:customer_support_app/widgets/verify_credentials.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';

class RegistrationScreen extends StatefulWidget {
  @override
  _RegistrationScreenState createState() => _RegistrationScreenState();
}

class _RegistrationScreenState extends State<RegistrationScreen> {
  bool showLoadingCircle = false;
  String emailValue = '';
  String passwordValue = '';
  late FocusNode _passwordNode;

  void formSubmission() async {
    setState(() {
      showLoadingCircle = true;
    });
    await VerifyCredentials(
      passContext: context,
    ).createNewUser(emailValue, passwordValue);
    setState(() {
      showLoadingCircle = false;
    });
  }

  @override
  void initState() {
    _passwordNode = FocusNode();
    super.initState();
  }

  @override
  void dispose() {
    _passwordNode.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Container(
          width: double.infinity,
          child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                Container(
                  padding: EdgeInsets.only(top: 30.0),
                  child: Text(
                    'Hey There! Register Now',
                    textAlign: TextAlign.center,
                    style: kHeadingStyle,
                  ),
                ),
                Column(children: <Widget>[
                  CustomTextField(
                    onChanged: (value) {
                      emailValue = value;
                    },
                    isObscureText: false,
                    hintMessage: 'Enter your email id',
                    onSubmit: (value) {
                      _passwordNode.requestFocus();
                    },
                  ),
                  CustomTextField(
                    onChanged: (value) {
                      passwordValue = value;
                    },
                    isObscureText: true,
                    hintMessage: 'Enter your password',
                    // focusNode: _passwordNode,
                    onSubmit: (value) {
                      print('Email equals $emailValue');
                      print('Password equals $passwordValue');
                    },
                  ),
                  CustomBtn(
                    btnText: 'Register Account',
                    btnPressed: () {
                      formSubmission();
                      print('Register button tapped');
                    },
                    isVisible: showLoadingCircle,
                    isColor: false,
                  )
                ]),
                CustomBtn(
                  btnText: 'Back to Login',
                  btnPressed: () {
                    Navigator.pop(context);
                    print('Back to Login button tapped');
                  },
                  isColor: true,
                  isVisible: false,
                ),
              ]),
        ),
      ),
    );
  }
}
