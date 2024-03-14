import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/foundation/key.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:google_sign_in/google_sign_in.dart';

class GoogleSignInPage extends StatelessWidget {
  const GoogleSignInPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.purple.shade300,
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              "Sign in with google account",
              style: GoogleFonts.lato(
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
                    Text(
                        "Sign in as ${snapshot.data!.displayName} (${FirebaseAuth.instance.currentUser!.email})");
                  }
                  return Text("you haven't sign in yet");
                }),
            SizedBox(
              height: 15,
            ),
            SizedBox(
              width: 150,
              child: ElevatedButton(
                style: ButtonStyle(
                  backgroundColor:
                      MaterialStateProperty.all(Colors.purple.shade800),
                ),
                onPressed: () async {
                  if (FirebaseAuth.instance.currentUser == null) {
                    GoogleSignInAccount? account =
                        await GoogleSignIn().signIn();
                    if (account != null) {
                      GoogleSignInAuthentication auth =
                          await account.authentication;
                      OAuthCredential credential =
                          GoogleAuthProvider.credential(
                        accessToken: auth.accessToken,
                        idToken: auth.idToken,
                      );
                      await FirebaseAuth.instance
                          .signInWithCredential(credential);
                    }
                  } else {
                    GoogleSignIn().signOut();
                    FirebaseAuth.instance.signOut();
                  }
                },
                child: StreamBuilder<User?>(
                    stream: FirebaseAuth.instance.userChanges(),
                    builder: (context, snapshot) {
                      if (snapshot.hasData) {
                        return Text("Sign Out");
                      }
                      return Text("Sign in ");
                    }),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
