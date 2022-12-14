import 'package:customer_support_app/screens/registration_screen.dart';
import 'package:customer_support_app/widgets/custom_button.dart';
import 'package:flutter/material.dart';
import '../constants.dart';
import 'package:customer_support_app/widgets/verify_credentials.dart';

class LoginPage extends StatefulWidget {
  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {

  bool showLoadingCircle = false;
  String emailValue = '';
  String passwordValue = '';
  // FocusNode _passwordNode = FocusNode();

  void formSubmission() async{
    setState(() {
      showLoadingCircle = true;
    });
    await VerifyCredentials(
      passContext: context,
    ).signInUser(emailValue, passwordValue);
    setState(() {
      showLoadingCircle = false;
    });
  }

  @override
  void initState() {
    // _passwordNode = FocusNode();
    super.initState();
  }

  @override
  void dispose() {
    // _passwordNode.dispose();
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
                    'Welcome User! Login Now',
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
                      // _passwordNode.requestFocus();
                    },
                    // focusNode: FocusNode(),
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
                    btnText: 'Login',
                    btnPressed: () {
                      formSubmission();
                      print('Login button tapped');
                    },
                    isVisible: showLoadingCircle,
                    isColor: false,
                  )
                ]),
                CustomBtn(
                  btnText: 'Create New Account',
                  btnPressed: () {
                    Navigator.push(context, MaterialPageRoute(builder:(context)=>RegistrationScreen()));
                  },
                  isColor: true, isVisible: false,
                ),
              ]),
        ),
      ),
    );
  }
}

