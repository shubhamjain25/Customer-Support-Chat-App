import 'package:customer_support_app/screens/home_page.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:customer_support_app/screens/login_page.dart';

class LandingPage extends StatelessWidget {

  final Future<FirebaseApp> _initialization = Firebase.initializeApp();

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
        future: _initialization,
        builder: (context, snapshot) {
          if (snapshot.hasError) {
            return Scaffold(
              body: Center(
                child: Text('Error: ${snapshot.error}'),
              ),
            );
          }
          if (snapshot.connectionState == ConnectionState.done) {
            return StreamBuilder(
                stream: FirebaseAuth.instance.authStateChanges(),
                builder: (context, streamSnapshot) {
                  if (streamSnapshot.hasError) {
                    return Scaffold(
                      body: Center(
                        child: Text('Error: ${streamSnapshot.error}',),
                      ),
                    );
                  }
                  if (streamSnapshot.connectionState ==
                      ConnectionState.active) {
                    Object? _currentUser = streamSnapshot.data;
                    if (_currentUser == null) {
                      return LoginPage();
                    } else {
                      return HomePage();
                    }
                  }
                  return const Center(
                    child: Text('Error 404! Try again later'),
                  );
                });
          }
          return const Scaffold(
            body: Center(
              child: Text('Initializing App...'),
            ),
          );
        });
  }
}
