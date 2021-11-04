import 'package:chat_app_29_9_2015/fire_store/add_user.dart';
import 'package:chat_app_29_9_2015/provider/chat_provider.dart';

import 'package:chat_app_29_9_2015/screen/main_screen.dart';
import 'package:chat_app_29_9_2015/screen/sign_up.dart';
import 'package:chat_app_29_9_2015/widgets/widgets.dart';
import 'package:flutter/material.dart';
import 'package:chat_app_29_9_2015/widgets/clipper.dart';
import 'package:firebase_auth/firebase_auth.dart';

import 'package:google_sign_in/google_sign_in.dart';
import 'package:provider/provider.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({Key? key}) : super(key: key);

  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  //* an instance of add user class
  AddUser _addUser = new AddUser();

  bool val = false;

  //* an instance of firebase auth
  FirebaseAuth auth = FirebaseAuth.instance;

  TextEditingController email = TextEditingController();
  TextEditingController password = TextEditingController();

  //*this key is to validate the formfields
  final formKey = GlobalKey<FormState>();

  //* this method is to sign in with google
  Future<UserCredential> signInWithGoogle() async {
    // Trigger the authentication flow
    final GoogleSignInAccount? googleUser = await GoogleSignIn().signIn();

    // Obtain the auth details from the request
    final GoogleSignInAuthentication googleAuth =
        await googleUser!.authentication;

    // Create a new credential
    final credential = GoogleAuthProvider.credential(
      accessToken: googleAuth.accessToken,
      idToken: googleAuth.idToken,
    );
    // Once signed in, return the UserCredential
    return await FirebaseAuth.instance.signInWithCredential(credential);
  }

  @override
  Widget build(BuildContext context) {
    dynamic _height = MediaQuery.of(context).size.height;
    dynamic _width = MediaQuery.of(context).size.width;
    return Scaffold(
      backgroundColor: Provider.of<ChatProvider>(context).backGroundColor,
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Stack(
              children: [
                ClipPath(
                  clipper: WaveClipper(),
                  child: Container(
                    height: _height * 0.3,
                    width: _width * 1,
                    color: Provider.of<ChatProvider>(context).mainColor,
                  ),
                ),
                ClipPath(
                  clipper: WaveClipper(),
                  child: Container(
                    height: MediaQuery.of(context).size.height * 0.33,
                    width: MediaQuery.of(context).size.width * 1,
                    color: Provider.of<ChatProvider>(context)
                        .mainColor
                        .withOpacity(0.5),
                  ),
                ),
                ClipPath(
                  clipper: WaveClipper(),
                  child: Container(
                    height: _height * 0.36,
                    width: _width * 1,
                    color: Provider.of<ChatProvider>(context)
                        .mainColor
                        .withOpacity(0.3),
                  ),
                ),
              ],
            ),
            Container(
              margin: EdgeInsets.only(top: _height * 0.03),
              child: Text(
                'Welcome Back',
                style: TextStyle(
                    color: Provider.of<ChatProvider>(context).mainColor,
                    fontSize: 20),
              ),
            ),
            Form(
              key: formKey,
              child: Column(
                children: [
                  containerFeilds(
                    _height * 0.066,
                    _width * 0.85,
                    EdgeInsets.only(top: _height * 0.03),
                    Provider.of<ChatProvider>(context).darkMood == true
                        ? const Color(0xff334756)
                        : Colors.grey[100],
                    Padding(
                      padding: EdgeInsets.only(left: _width * 0.05),
                      child: TextFormField(
                          controller: email,
                          textInputAction: TextInputAction.next,
                          style: TextStyle(
                              color:
                                  Provider.of<ChatProvider>(context).darkMood ==
                                          true
                                      ? Colors.white
                                      : const Color(0xff775fd3)),
                          decoration: InputDecoration(
                            hintText: 'Email',
                            hintStyle: TextStyle(color: Colors.grey[500]),
                            border: InputBorder.none,
                            focusedBorder: InputBorder.none,
                            enabledBorder: InputBorder.none,
                            errorBorder: InputBorder.none,
                            disabledBorder: InputBorder.none,
                          ),
                          validator: (val) {
                            if (!RegExp(
                                    "^[a-zA-Z0-9+_.-]+@[a-zA-Z0-9.-]+.[a-z]")
                                .hasMatch(val!)) {
                              return 'please enter a valid email';
                            }
                          }),
                    ),
                  ),
                  containerFeilds(
                    _height * 0.066,
                    _width * 0.85,
                    EdgeInsets.only(top: _height * 0.03),
                    Provider.of<ChatProvider>(context).darkMood == true
                        ? const Color(0xff334756)
                        : Colors.grey[100],
                    Padding(
                      padding: EdgeInsets.only(
                        left: _width * 0.05,
                      ),
                      child: TextFormField(
                          obscureText: true,
                          controller: password,
                          style: TextStyle(
                              color:
                                  Provider.of<ChatProvider>(context).darkMood ==
                                          true
                                      ? Colors.white
                                      : const Color(0xff775fd3)),
                          decoration: InputDecoration(
                            hintText: 'Password',
                            hintStyle: TextStyle(color: Colors.grey[500]),
                            border: InputBorder.none,
                            focusedBorder: InputBorder.none,
                            enabledBorder: InputBorder.none,
                            errorBorder: InputBorder.none,
                            disabledBorder: InputBorder.none,
                          ),
                          validator: (val) {
                            if (val!.length < 6) {
                              return 'Password should be greater than 6 charactars ';
                            }
                          }),
                    ),
                  ),
                ],
              ),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Container(
                  margin: EdgeInsets.only(
                      left: MediaQuery.of(context).size.width * 0.06,
                      top: MediaQuery.of(context).size.height * 0.01),
                  child: Row(
                    children: [
                      Checkbox(
                        value: val,
                        onChanged: (newValue) {
                          setState(() {
                            val = newValue!;
                          });
                        },
                        activeColor:
                            Provider.of<ChatProvider>(context, listen: false)
                                .mainColor,
                      ),
                      Text(
                        'Remember me',
                        style: TextStyle(
                            color: Provider.of<ChatProvider>(context).mainColor,
                            fontSize: 15),
                      ),
                    ],
                  ),
                ),
                Container(
                  margin: EdgeInsets.only(
                      right: MediaQuery.of(context).size.width * 0.08,
                      top: MediaQuery.of(context).size.height * 0.01),
                  child: Text(
                    'forgot password?',
                    style: TextStyle(
                        color: Provider.of<ChatProvider>(context).mainColor,
                        fontSize: 15),
                  ),
                ),
              ],
            ),
            InkWell(
              onTap: () async {
                if (formKey.currentState!.validate()) {
                  //* saving email and user photo in sharedprefs

                  try {
                    UserCredential userCredential = await FirebaseAuth.instance
                        .signInWithEmailAndPassword(
                            email: email.text, password: password.text);
                    print(userCredential);
                    print(userCredential.user!.uid);
                  } on FirebaseAuthException catch (e) {
                    if (e.code == 'user-not-found') {
                      print('No user found for that email.');
                    } else if (e.code == 'wrong-password') {
                      print('Wrong password provided for that user.');
                    }
                  }

                  Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(
                      builder: (context) => MainScreen(),
                    ),
                  );
                }
              },
              child: Container(
                margin: EdgeInsets.only(top: _height * 0.03),
                height: _height * 0.055,
                width: _width * 0.5,
                decoration: BoxDecoration(
                  borderRadius: const BorderRadius.all(
                    Radius.circular(40),
                  ),
                  color: Provider.of<ChatProvider>(context).mainColor,
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.2),
                      blurRadius: 2,
                      spreadRadius: 1,
                      offset: const Offset(0, 3),
                    ),
                  ],
                ),
                child: const Center(
                  child: Text(
                    'Sign in',
                    style: TextStyle(color: Colors.white),
                  ),
                ),
              ),
            ),
            InkWell(
              onTap: () async {
                UserCredential result = await signInWithGoogle();

                _addUser.setGoogleUser(
                  result.user!.displayName!,
                  result.user!.email!,
                  result.user!.photoURL!,
                );
                //*  Saving user name and email to shared preferences

                if (result.credential!.providerId == 'google.com') {
                  Navigator.pushReplacement(
                      context,
                      MaterialPageRoute(
                          builder: (context) => const MainScreen()));
                } else {
                  showDialog(
                      context: context,
                      builder: (context) {
                        return AlertDialog(
                          title: Text(
                            'Alert',
                            style: TextStyle(
                                color: Provider.of<ChatProvider>(context)
                                    .mainColor),
                          ),
                          content: const Text(
                              'it seems your email is not a google email!\ntry adding a google email'),
                          actions: <Widget>[
                            TextButton(
                              onPressed: () {
                                _dismissDialog();
                              },
                              child: Text(
                                'Ok',
                                style: TextStyle(
                                  color: Provider.of<ChatProvider>(context)
                                      .mainColor,
                                ),
                              ),
                            ),
                          ],
                        );
                      });
                }
              },
              child: Container(
                margin: EdgeInsets.only(
                  top: _height * 0.02,
                ),
                height: _height * 0.055,
                width: _width * 0.5,
                decoration: BoxDecoration(
                    borderRadius: const BorderRadius.all(
                      Radius.circular(40),
                    ),
                    color: Provider.of<ChatProvider>(context).darkMood == false
                        ? Colors.white
                        : const Color(0xff334756),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.2),
                        blurRadius: 2,
                        spreadRadius: 1,
                        offset: const Offset(0, 3),
                      ),
                    ]),
                child: Center(
                  child: Row(
                    children: [
                      Container(
                          padding: EdgeInsets.only(left: _width * 0.04),
                          height: _height * 0.035,
                          child: Image.asset('assets/images/google.png')),
                      SizedBox(
                        width: _width * 0.02,
                      ),
                      Text(
                        'Continue with Google',
                        style: TextStyle(
                            color:
                                Provider.of<ChatProvider>(context).mainColor),
                      ),
                    ],
                  ),
                ),
              ),
            ),
            Container(
              margin: EdgeInsets.only(
                top: _height * 0.03,
              ),
              child: Text(
                'or',
                style: TextStyle(
                    fontSize: 16, color: Colors.black.withOpacity(0.5)),
              ),
            ),
            Container(
              margin: EdgeInsets.only(
                top: _height * 0.03,
              ),
              child: InkWell(
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const SignUp(),
                    ),
                  );
                },
                child: SizedBox(
                  height: _height * 0.06,
                  width: _width * 0.25,
                  child: Text(
                    'Register now',
                    style: TextStyle(
                        fontSize: 16,
                        color: Provider.of<ChatProvider>(context).mainColor,
                        decoration: TextDecoration.underline),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  _dismissDialog() {
    Navigator.pop(context);
  }
}
