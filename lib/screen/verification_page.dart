import 'package:chat_app_29_9_2015/fire_store/add_user.dart';
import 'package:chat_app_29_9_2015/provider/chat_provider.dart';
import 'package:chat_app_29_9_2015/screen/main_screen.dart';
import 'package:chat_app_29_9_2015/screen/sign_up.dart';

import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:provider/provider.dart';

class VerificationPage extends StatefulWidget {
  const VerificationPage({Key? key}) : super(key: key);

  @override
  _VerificationPageState createState() => _VerificationPageState();
}

class _VerificationPageState extends State<VerificationPage> {
  @override
  void initState() {
    if (FirebaseAuth.instance.currentUser!.emailVerified == true) {
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => const MainScreen(),
        ),
      );
    }
    super.initState();
  }

  final signUppage = SignUp();
  final _addUser = AddUser();
  bool verifyCheck = false;
  String verificationMessage = '';
  @override
  Widget build(BuildContext context) {
    dynamic _height = MediaQuery.of(context).size.height;
    dynamic _width = MediaQuery.of(context).size.width;
    return Scaffold(
      backgroundColor: Provider.of<ChatProvider>(context).backGroundColor,
      appBar: AppBar(
        backgroundColor: Provider.of<ChatProvider>(context).mainColor,
        leading: IconButton(
          onPressed: () {
            Navigator.pop(context);
          },
          icon: const Icon(Icons.arrow_back),
        ),
        title: const Text(
          'Chat App',
          style: TextStyle(color: Colors.white),
        ),
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          SizedBox(
            height: _height * 0.2,
          ),
          SizedBox(
            height: MediaQuery.of(context).size.height * 0.15,
            width: MediaQuery.of(context).size.width,
            child: Image.asset('assets/images/verify.png'),
          ),
          SizedBox(
            height: MediaQuery.of(context).size.height * 0.05,
          ),
          Text(
            'Email verification',
            style: TextStyle(
                color: Provider.of<ChatProvider>(context).mainColor,
                fontSize: 25),
          ),
          SizedBox(
            height: _height * 0.01,
          ),
          const Text(
              '                our app needs to verify your email . \n We have sent a verification message to your email .'),
          SizedBox(
            height: _height * 0.08,
            child: Center(
              child: Text(
                verificationMessage,
                style: const TextStyle(color: Colors.red),
              ),
            ),
          ),
          InkWell(
            onTap: () async {
              await FirebaseAuth.instance.currentUser!.reload();
              if (FirebaseAuth.instance.currentUser!.emailVerified == true) {
                await FirebaseAuth.instance.currentUser!.updateDisplayName(
                    Provider.of<ChatProvider>(context, listen: false)
                        .userName
                        .text);
                _addUser.addUser(
                    Provider.of<ChatProvider>(context, listen: false)
                        .userName
                        .text,
                    Provider.of<ChatProvider>(context, listen: false)
                        .email
                        .text);
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => const MainScreen()),
                );
              } else {
                setState(() {
                  verificationMessage = 'your email has not verified yet .';
                });
              }
            },
            child: Container(
              height: _height * 0.055,
              width: _width * 0.5,
              decoration: BoxDecoration(
                borderRadius: const BorderRadius.all(
                  Radius.circular(40),
                ),
                color: Provider.of<ChatProvider>(context).mainColor,
                boxShadow: [
                  BoxShadow(
                      color: Colors.black.withOpacity(0.3),
                      blurRadius: 4,
                      spreadRadius: 4,
                      offset: const Offset(1.5, 2))
                ],
              ),
              child: const Center(
                child: Text(
                  'Continue',
                  style: TextStyle(color: Colors.white),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
