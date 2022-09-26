import 'package:customer_support_app/screens/query_screen.dart';
import 'package:customer_support_app/services/database.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class HomePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      // appBar: AppBar(
      //   foregroundColor: Colors.blueAccent,
      // ),
      body: Container(
        margin: EdgeInsets.symmetric(vertical: 20),
        padding: EdgeInsets.all(30),
        // color: Colors.yellow,
        child: Column(
          children: [
            SizedBox(
              height: 150,
            ),
            Container(
              // color: Colors.black,
              child: Center(
                child: GestureDetector(
                  onTap: () {
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => QueriesScreen()));
                  },
                  child: Container(
                    alignment: Alignment.center,
                    width: double.infinity,
                    height: 65.0,
                    decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(20)),
                    child: const Text(
                      "Queries Screen",
                      textAlign: TextAlign.center,
                      style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.w400,
                          color: Colors.black),
                    ),
                  ),
                ),
              ),
            ),
            const SizedBox(
              height: 50,
            ),
            Container(
              // color: Colors.black,
              child: Center(
                child: GestureDetector(
                  onTap: () {
                    FirebaseAuth.instance.signOut();
                  },
                  child: Container(
                    alignment: Alignment.center,
                    width: double.infinity,
                    height: 65.0,
                    decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(20)),
                    child: const Text(
                      "Log Out",
                      textAlign: TextAlign.center,
                      style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.w400,
                          color: Colors.black),
                    ),
                  ),
                ),
              ),
            ),
            const SizedBox(
              height: 50,
            ),
            // Container(
            //   // color: Colors.black,
            //   child: Center(
            //     child: GestureDetector(
            //       onTap: () {
            //         DatabaseMethods().getChatRoomsID();
            //       },
            //       child: Container(
            //         alignment: Alignment.center,
            //         width: double.infinity,
            //         height: 65.0,
            //         decoration: BoxDecoration(
            //             color: Colors.white,
            //             borderRadius: BorderRadius.circular(20)),
            //         child: const Text(
            //           "Queries 2",
            //           textAlign: TextAlign.center,
            //           style: TextStyle(
            //               fontSize: 20,
            //               fontWeight: FontWeight.w400,
            //               color: Colors.black),
            //         ),
            //       ),
            //     ),
            //   ),
            // ),
          ],
        ),
      ),
    );
  }
}
