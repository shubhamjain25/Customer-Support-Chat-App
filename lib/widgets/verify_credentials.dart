import 'package:customer_support_app/screens/home_page.dart';
import 'package:customer_support_app/services/database.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';

class VerifyCredentials{

  final FirebaseAuth _auth = FirebaseAuth.instance;


  final BuildContext passContext;

  VerifyCredentials({required this.passContext});

  Future<String> createNewUser(String registeredEmail, String registeredPassword) async {
    try {
      UserCredential _user = await _auth.createUserWithEmailAndPassword(
          email: registeredEmail, password: registeredPassword);

      Map<String, String> userInfoMap = {
        "name" : "Frank Adam",
        "email" : registeredEmail
      };

      DatabaseMethods().uploadUserInfo(userInfoMap);

      Navigator.pop(passContext);
      return "";
    }
    on FirebaseAuthException catch (e) {
      String _feedback="";
      if (e.code == 'weak-password') {
        _feedback = 'The password provided is too weak.';
      } else if (e.code == 'email-already-in-use') {
        _feedback = 'The account already exists for that email.';
      } else {
        _feedback = e.code;
      }
      _alertDialog(_feedback);
      return _feedback;
    }
    catch (e) {
      _alertDialog(e.toString());
      return e.toString();
    }
  }

  Future<String> signInUser(String registeredEmail, String registeredPassword) async{
    try {
      UserCredential _user = await _auth.signInWithEmailAndPassword(
          email: registeredEmail, password: registeredPassword);
      return "";
    }
    on FirebaseAuthException catch (e) {
      String _feedback="";
      if (e.code == 'weak-password') {
        _feedback = 'The password provided is too weak.';
      } else if (e.code == 'email-already-in-use') {
        _feedback = 'The account already exists for that email.';
      } else {
        _feedback = e.code;
      }
      _alertDialog(_feedback);
      return _feedback;
    }
    catch (e) {
      _alertDialog(e.toString());
      return e.toString();
    }
  }

  Future<void> _alertDialog(String errorMessage) async {
    return showDialog(
        barrierDismissible: false,
        context: passContext,
        builder: (context) {
          return AlertDialog(
            title: Text('Error'),
            content: Text(errorMessage),
            actions: [
              TextButton(
                onPressed: () {
                  Navigator.pop(context);
                },
                child: Text('Close Dialog'),
              )
            ],
          );
        });
  }

  // void fillForm2(String action) async{
  //   String _feedback = await signInUser();
  //
  //   if (_feedback != null) {
  //     _alertDialog(_feedback);
  //   }
  //   else {
  //     // If signed in, it won't go back to login page but instead to Homepage
  //     //Because main.dart looks after the state, and directs to HomePage as signedIn.
  //   }
  // }

  // void fillForm(String action) async{
  //   // String _feedback = action=='SignUp'?await createNewUser():await signInUser();
  //
  //   String
  //
  //   if (_feedback != null) {
  //     _alertDialog(_feedback);
  //   }
  //   else {
  //     if(action=='SignUp'){Navigator.pop(passContext);}
  //     else {}
  //     // If signed in, it won't go back to login page but instead to Homepage
  //     //Because main.dart looks after the state, and directs to HomePage as signedIn.
  //   }
  // }

}
