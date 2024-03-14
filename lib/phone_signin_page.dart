import 'dart:developer';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/foundation/key.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:google_fonts/google_fonts.dart';

class PhoneSignIn extends StatelessWidget {
  const PhoneSignIn({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    TextEditingController phoneController = TextEditingController();

    return Scaffold(
      backgroundColor: Colors.green.shade400,
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              "Sign in with phone",
              style:
                  GoogleFonts.lato(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            SizedBox(
              height: 10,
            ),
            StreamBuilder<User?>(
                stream: FirebaseAuth.instance.userChanges(),
                builder: (context, snapshot) {
                  if (snapshot.hasData) {
                    return Text(
                        "You have sign in as ${snapshot.data!.phoneNumber}");
                  }
                  return Text("You haven't signed in yet");
                }),
            SizedBox(
              height: 15,
            ),
            Container(
              margin: EdgeInsets.fromLTRB(30, 0, 30, 15),
              padding: EdgeInsets.symmetric(horizontal: 15),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(15),
              ),
              child: TextField(
                controller: phoneController,
                keyboardType: TextInputType.phone,
                cursorColor: Colors.green,
                decoration: InputDecoration(
                  border: InputBorder.none,
                  hintText: "Phone Number",
                ),
              ),
            ),
            SizedBox(
              width: 150,
              child: ElevatedButton(
                style: ButtonStyle(
                  backgroundColor:
                      MaterialStateProperty.all(Colors.green.shade800),
                ),
                onPressed: () async {
                  if (FirebaseAuth.instance.currentUser == null) {
                    await FirebaseAuth.instance.verifyPhoneNumber(
                      phoneNumber: '+${phoneController.text}',
                      verificationCompleted: (credential) async {
                        await FirebaseAuth.instance
                            .signInWithCredential(credential);
                      },
                      verificationFailed: (exception) {
                        showNotification(context, exception.message.toString());
                      },
                      codeSent: (verificationId, resendCode) async {
                        String? smsCode = await askingSMSCode(context);
                        if (smsCode != null) {
                          PhoneAuthCredential credential =
                              PhoneAuthProvider.credential(
                            verificationId: verificationId,
                            smsCode: smsCode,
                          );
                          try {
                            FirebaseAuth.instance
                                .signInWithCredential(credential);
                          } on FirebaseException catch (e) {
                            log(e.message.toString());
                          }
                        }
                      },
                      codeAutoRetrievalTimeout: (verificationId) {},
                    );
                  } else {
                    FirebaseAuth.instance.signOut();
                  }
                },
                child: StreamBuilder<User?>(
                  stream: FirebaseAuth.instance.userChanges(),
                  builder: (context, snapshot) {
                    if (snapshot.hasData) {
                      return Text("Sign out");
                    }
                    return Text("Sign in");
                  },
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  void showNotification(BuildContext context, String message) {
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        backgroundColor: Colors.green.shade800,
        content: Text(message.toString())));
  }

  Future<String?> askingSMSCode(BuildContext context) async {
    return await showDialog<String>(
        context: context,
        builder: (_) {
          TextEditingController controller = TextEditingController();

          return SimpleDialog(
            title: Text("Tolong masukan kode sms yang telah dikirimakan"),
            children: [
              Container(
                margin: EdgeInsets.fromLTRB(30, 0, 30, 15),
                padding: EdgeInsets.symmetric(horizontal: 15),
                color: Color.fromARGB(255, 240, 240, 240),
                child: TextField(
                  controller: controller,
                  keyboardType: TextInputType.number,
                  cursorColor: Colors.green,
                  decoration: InputDecoration(
                    border: InputBorder.none,
                    hintText: "sms code",
                  ),
                ),
              ),
              TextButton(
                  onPressed: () {
                    Navigator.pop(context, controller.text);
                  },
                  child: Text(
                    "Confrim",
                    style: TextStyle(color: Colors.green.shade900),
                  ))
            ],
          );
        });
  }
}
