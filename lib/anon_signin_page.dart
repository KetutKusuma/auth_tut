// ignore_for_file: depend_on_referenced_packages

import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter/src/foundation/key.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:firebase_auth/firebase_auth.dart';

class AnonSignInPage extends StatelessWidget {
  const AnonSignInPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.lightBlue.shade100,
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              "Sign In Anonymously",
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(
              height: 10,
            ),
            StreamBuilder<User?>(
                stream: FirebaseAuth.instance.userChanges(),
                builder: (context, snapshot) {
                  if (snapshot.hasData) {
                    return Text(
                      "You have sign in as ${snapshot.data?.uid}",
                      style: GoogleFonts.lato(
                          fontSize: 14, fontWeight: FontWeight.w400),
                    );
                  } else {
                    return Text(
                      "You have not sign in yet",
                      style: GoogleFonts.lato(
                          fontSize: 14, fontWeight: FontWeight.w400),
                    );
                  }
                }),
            SizedBox(
              height: 15,
            ),
            SizedBox(
              width: 150,
              child: ElevatedButton(
                style: ButtonStyle(
                  backgroundColor: MaterialStateProperty.all(
                    Colors.blue,
                  ),
                ),
                onPressed: () {
                  if (FirebaseAuth.instance.currentUser != null) {
                    FirebaseAuth.instance.signOut();
                  } else {
                    FirebaseAuth.instance.signInAnonymously();
                  }
                },
                child: StreamBuilder<User?>(
                    stream: FirebaseAuth.instance.userChanges(),
                    builder: (context, snapshot) {
                      if (snapshot.hasData) {
                        return Text("Sign Out");
                      } else {
                        return Text(
                          "Sign in",
                        );
                      }
                    }),
              ),
            )
          ],
        ),
      ),
    );
  }
}
