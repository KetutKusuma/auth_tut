import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/foundation/key.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:google_fonts/google_fonts.dart';

class EmailSignInPage extends StatelessWidget {
  const EmailSignInPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    TextEditingController emailController = TextEditingController();
    TextEditingController pswdController = TextEditingController();

    return Scaffold(
      backgroundColor: Colors.orange.shade200,
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              "Sign in with Email and Password",
              style:
                  GoogleFonts.lato(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(
              height: 10,
            ),
            StreamBuilder<User?>(
                stream: FirebaseAuth.instance.userChanges(),
                builder: (context, snapshot) {
                  if (snapshot.hasData) {
                    return Text("You have sign in as ${snapshot.data!.email}");
                  }
                  return Text("You have not sign in yet");
                }),
            Container(
              margin: EdgeInsets.fromLTRB(30, 15, 30, 10),
              padding: EdgeInsets.symmetric(horizontal: 15),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(15),
              ),
              child: TextField(
                controller: emailController,
                cursorColor: Colors.orange,
                decoration: InputDecoration(
                  border: InputBorder.none,
                  hintText: "Email",
                ),
                keyboardType: TextInputType.emailAddress,
              ),
            ),
            Container(
              margin: EdgeInsets.fromLTRB(30, 15, 30, 10),
              padding: EdgeInsets.symmetric(horizontal: 15),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(15),
              ),
              child: TextField(
                controller: pswdController,
                cursorColor: Colors.orange,
                decoration: InputDecoration(
                  border: InputBorder.none,
                  hintText: "Password",
                ),
              ),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                SizedBox(
                  width: 150,
                  child: ElevatedButton(
                    style: ButtonStyle(
                      backgroundColor: MaterialStateProperty.all(
                        Colors.orange.shade800,
                      ),
                    ),
                    onPressed: () async {
                      if (FirebaseAuth.instance.currentUser == null) {
                        try {
                          await FirebaseAuth.instance
                              .createUserWithEmailAndPassword(
                                  email: emailController.text,
                                  password: pswdController.text);
                        } on FirebaseAuthException catch (e) {
                          showNotification(context, e.message.toString());
                        }
                      }
                      FirebaseAuth.instance.signOut();
                    },
                    child: StreamBuilder<User?>(
                      stream: FirebaseAuth.instance.userChanges(),
                      builder: (context, snapshot) {
                        if (snapshot.hasData) {
                          return Text("Sign out");
                        }
                        return Text("Sign Up");
                      },
                    ),
                  ),
                ),
                SizedBox(
                  width: 15,
                ),
                SizedBox(
                  width: 150,
                  child: ElevatedButton(
                    style: ButtonStyle(
                      backgroundColor: MaterialStateProperty.all(
                        Colors.orange.shade800,
                      ),
                    ),
                    onPressed: () async {
                      try {
                        if (FirebaseAuth.instance.currentUser == null) {
                          try {
                            FirebaseAuth.instance.signInWithEmailAndPassword(
                                email: emailController.text,
                                password: pswdController.text);
                          } on FirebaseAuthException catch (e) {
                            showNotification(
                              context,
                              e.message.toString(),
                            );
                          }
                        }
                        FirebaseAuth.instance.signOut();
                      } catch (e) {
                        print(e);
                      }
                    },
                    child: StreamBuilder<User?>(
                      stream: FirebaseAuth.instance.userChanges(),
                      builder: (context, snapshot) {
                        if (snapshot.hasData) {
                          return Text("Sign out");
                        }
                        return Text("Sign In");
                      },
                    ),
                  ),
                ),
              ],
            ),
            TextButton(
              onPressed: () async {
                try {
                  await FirebaseAuth.instance
                      .sendPasswordResetEmail(email: emailController.text);
                } on FirebaseAuthException catch (e) {
                  showNotification(context, e.message.toString());
                }
              },
              child: Text(
                "Forgot Password?",
                style: TextStyle(color: Colors.orange.shade800),
              ),
            ),
          ],
        ),
      ),
    );
  }

  void showNotification(BuildContext context, String message) {
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        backgroundColor: Colors.orange.shade800,
        content: Text(message.toString())));
  }
}
