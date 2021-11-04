import 'package:chat_app_29_9_2015/fire_store/add_user.dart';
import 'package:chat_app_29_9_2015/provider/chat_provider.dart';

import 'package:chat_app_29_9_2015/screen/main_screen.dart';
import 'package:chat_app_29_9_2015/screen/verification_page.dart';
import 'package:chat_app_29_9_2015/widgets/clipper.dart';
import 'package:chat_app_29_9_2015/widgets/widgets.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';

import 'package:provider/provider.dart';
import 'login_page.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SignUp extends StatefulWidget {
  const SignUp({Key? key}) : super(key: key);

  @override
  _SignUpState createState() => _SignUpState();
}

class _SignUpState extends State<SignUp> {
  //* an instance of add user class
  final AddUser _addUser = AddUser();

  GoogleSignIn _googleSignIn = GoogleSignIn(scopes: ['email']);

  //TextEditingController userName = TextEditingController();
  // TextEditingController email = TextEditingController();
  TextEditingController password = TextEditingController();

  //*this key is to validate the formfields
  final formKey = GlobalKey<FormState>();

  bool isLoading = false;

  //* an instance of firebase auth
  FirebaseAuth auth = FirebaseAuth.instance;

  //* this method is to sign in with google
  Future<UserCredential> signInWithGoogle() async {
    var errorMessage; // Trigger the authentication flow

    final GoogleSignInAccount? googleUser = await GoogleSignIn().signIn();

    if (googleUser == null) {
      errorMessage = "CANCELLED_SIGN_IN";
      return Future.error(errorMessage);
    }
    // Obtain the auth details from the request
    final GoogleSignInAuthentication googleAuth =
        await googleUser.authentication;

    // Create a new credential
    final credential = GoogleAuthProvider.credential(
        accessToken: googleAuth.accessToken, idToken: googleAuth.idToken);

    // Once signed in, return the UserCredential
    return await FirebaseAuth.instance.signInWithCredential(credential);
  }

  @override
  void initState() {
    getSwitchValues();

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    dynamic _height = MediaQuery.of(context).size.height;
    dynamic _width = MediaQuery.of(context).size.width;

    return Scaffold(
      backgroundColor: Provider.of<ChatProvider>(context).backGroundColor,
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              margin: EdgeInsets.only(
                top: MediaQuery.of(context).size.height * 0.15,
                left: MediaQuery.of(context).size.width * 0.1,
              ),
              child: Text(
                'Welcome ',
                style: TextStyle(
                  fontSize: 35,
                  fontWeight: FontWeight.w500,
                  color: Provider.of<ChatProvider>(context).mainColor,
                ),
              ),
            ),
            Container(
              margin: EdgeInsets.only(
                top: MediaQuery.of(context).size.height * 0.015,
                left: MediaQuery.of(context).size.width * 0.1,
              ),
              child: Text(
                'Welcome to my chat app .',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w500,
                  color: Provider.of<ChatProvider>(context)
                      .mainColor
                      .withOpacity(0.7),
                ),
              ),
            ),
            Stack(
              children: [
                ClipPath(
                  clipper: SignUpClip(),
                  child: Container(
                    height: MediaQuery.of(context).size.height * 0.2,
                    color: Provider.of<ChatProvider>(context).mainColor,
                  ),
                ),
                ClipPath(
                  clipper: SignUpClip(),
                  child: Container(
                    height: _height * 0.23,
                    color: Provider.of<ChatProvider>(context)
                        .mainColor
                        .withOpacity(0.4),
                  ),
                ),
              ],
            ),
            SizedBox(
              child: Form(
                key: formKey,
                child: Column(
                  children: [
                    containerFeilds(
                      _height * 0.066,
                      _width * 0.85,
                      EdgeInsets.only(left: _width * 0.06),
                      Provider.of<ChatProvider>(context).darkMood == true
                          ? const Color(0xff334756)
                          : Colors.grey[100],
                      Padding(
                        padding: EdgeInsets.only(
                          left: _width * 0.05,
                        ),
                        child: TextFormField(
                          controller:
                              Provider.of<ChatProvider>(context).userName,
                          style: TextStyle(
                              color:
                                  Provider.of<ChatProvider>(context).darkMood ==
                                          true
                                      ? Colors.white
                                      : const Color(0xff775fd3)),
                          textInputAction: TextInputAction.next,
                          decoration: InputDecoration(
                            hintText: 'User Name',
                            hintStyle: TextStyle(color: Colors.grey[500]),
                            border: InputBorder.none,
                            focusedBorder: InputBorder.none,
                            enabledBorder: InputBorder.none,
                            errorBorder: InputBorder.none,
                            disabledBorder: InputBorder.none,
                          ),
                          validator: (val) {
                            if (val!.isEmpty) {
                              return 'Please fill out the user Name field';
                            }

                            if (val.length < 2) {
                              return 'user name should be greater than 2 characters';
                            }
                            return null;
                          },
                        ),
                      ),
                    ),
                    containerFeilds(
                      _height * 0.066,
                      _width * 0.85,
                      EdgeInsets.only(top: _height * 0.03, left: _width * 0.06),
                      Provider.of<ChatProvider>(context).darkMood == true
                          ? const Color(0xff334756)
                          : Colors.grey[100],
                      Padding(
                        padding: EdgeInsets.only(
                          left: _width * 0.05,
                        ),
                        child: TextFormField(
                          textInputAction: TextInputAction.next,
                          controller: Provider.of<ChatProvider>(context).email,
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
                            return null;
                          },
                        ),
                      ),
                    ),
                    containerFeilds(
                      _height * 0.066,
                      _width * 0.85,
                      EdgeInsets.only(top: _height * 0.03, left: _width * 0.06),
                      Provider.of<ChatProvider>(context).darkMood == true
                          ? const Color(0xff334756)
                          : Colors.grey[100],
                      Padding(
                        padding: EdgeInsets.only(
                          left: _width * 0.05,
                        ),
                        child: TextFormField(
                          controller: password,
                          obscureText: true,
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
                            return null;
                          },
                        ),
                      ),
                    )
                  ],
                ),
              ),
            ),
            SizedBox(
              height: _height * 0.04,
            ),
            InkWell(
              onTap: () async {
                await signMeUp();
              },
              child: Container(
                margin: EdgeInsets.only(left: _width * 0.23),
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
                    ]),
                child: Center(
                  child: isLoading == true
                      ? const Center(
                          child: CircularProgressIndicator(
                            color: Colors.white,
                          ),
                        )
                      : const Text(
                          'Sign up',
                          style: TextStyle(color: Colors.white),
                        ),
                ),
              ),
            ),
            InkWell(
              onTap: () async {
                UserCredential result = await signInWithGoogle();
                //* _add user is an instance of add usere class
                //*set google user is  a method from add user class to set the user information in firestore
                _addUser.setGoogleUser(
                  //* I want take the user name
                  result.user!.displayName!,
                  //*  I want to take his email
                  result.user!.email!,
                  //* I want to take his email photo url
                  result.user!.photoURL!,
                );
                //* After setting the user information i save the email in shared preferences to make it easy to skip signing up everytime the user opens the app

                SharedPreferences prefs = await SharedPreferences.getInstance();
                prefs.setString(
                    'userEmailSharedPreferences', result.user!.email!);

                // await saveUserEmailInSharedPrefernces('result.user!.email!');

                if (result.credential!.providerId == 'google.com') {
                  ConnectionState == ConnectionState.waiting
                      ? showDialog(
                          context: context,
                          builder: (context) => CircularProgressIndicator(
                            color: Provider.of<ChatProvider>(context).mainColor,
                          ),
                        )
                      : Navigator.pushReplacement(
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
                margin:
                    EdgeInsets.only(top: _height * 0.02, left: _width * 0.23),
                height: _height * 0.055,
                width: _width * 0.5,
                decoration: BoxDecoration(
                    borderRadius: const BorderRadius.all(
                      Radius.circular(40),
                    ),
                    color: Provider.of<ChatProvider>(context).darkMood == false
                        ? Colors.white
                        : Color(0xff334756),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.2),
                        blurRadius: 2,
                        spreadRadius: 1,
                        offset: const Offset(0, 2.9),
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
            InkWell(
              onTap: () {
                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const LoginPage(),
                  ),
                );
              },
              child: Container(
                margin:
                    EdgeInsets.only(left: _width * 0.24, top: _height * 0.03),
                height: _height * 0.02,
                width: _width * 0.5,
                child: Center(
                  child: Text(
                    'Already have an account ?',
                    style: TextStyle(
                      fontSize: 16,
                      color: Provider.of<ChatProvider>(context).mainColor,
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  signMeUp() async {
    if (formKey.currentState!.validate()) {
      setState(() {
        isLoading = true;
      });
      try {
        UserCredential userCredential =
            await FirebaseAuth.instance.createUserWithEmailAndPassword(
          email: Provider.of<ChatProvider>(context, listen: false).email.text,
          password: password.text,
        );

        SharedPreferences prefs = await SharedPreferences.getInstance();
        prefs.setString('userEmailSharedPreferences',
            Provider.of<ChatProvider>(context, listen: false).email.text);
        User? user = FirebaseAuth.instance.currentUser;
        if (userCredential.user!.emailVerified == true) {
          _addUser.addUser(
            Provider.of<ChatProvider>(context, listen: false).userName.text,
            Provider.of<ChatProvider>(context, listen: false).email.text,
          );
          await FirebaseAuth.instance.currentUser!.updateDisplayName(
              Provider.of<ChatProvider>(context, listen: false).userName.text);
          Navigator.of(context).push(
            MaterialPageRoute(
              builder: (context) => const MainScreen(),
            ),
          );
        } else if (user != null && !user.emailVerified) {
          await user.sendEmailVerification();
          await FirebaseAuth.instance.currentUser!.updateDisplayName(
              Provider.of<ChatProvider>(context, listen: false).userName.text);
          Navigator.of(context).push(
            MaterialPageRoute(
              builder: (context) => const VerificationPage(),
            ),
          );
        } else if (userCredential.user!.emailVerified == false) {
          await FirebaseAuth.instance.currentUser!.updateDisplayName(
              Provider.of<ChatProvider>(context, listen: false).userName.text);
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => const VerificationPage(),
            ),
          );
        }
      } on FirebaseAuthException catch (e) {
        if (e.code == 'weak-password') {
          showDialog(
              context: context,
              builder: (BuildContext context) {
                return AlertDialog(
                  title: const Text('Alert'),
                  content: const Text('The password provided is too weak.'),
                  actions: [
                    TextButton(
                        onPressed: () async {
                          SharedPreferences prefs =
                              await SharedPreferences.getInstance();
                          prefs.remove('userEmailSharedPreferences');

                          password.clear();

                          setState(() {
                            isLoading = false;
                          });
                          _dismissDialog();
                        },
                        child: const Text('ok'))
                  ],
                );
              });
        } else if (e.code == 'email-already-in-use') {
          showDialog(
              context: context,
              builder: (BuildContext context) {
                return AlertDialog(
                  title: const Text('Alert'),
                  content:
                      const Text('The account already exists for that email.'),
                  actions: [
                    TextButton(
                        onPressed: () async {
                          Provider.of<ChatProvider>(context, listen: false)
                              .userName
                              .clear();
                          SharedPreferences prefs =
                              await SharedPreferences.getInstance();
                          prefs.remove('userEmailSharedPreferences');

                          password.clear();
                          Provider.of<ChatProvider>(context, listen: false)
                              .email
                              .clear();
                          setState(() {
                            isLoading = false;
                          });
                          _dismissDialog();
                        },
                        child: const Text('ok'))
                  ],
                );
              });
        }
      } catch (e) {
        showDialog(
            context: context,
            builder: (BuildContext context) {
              return AlertDialog(
                title: const Text('Alert'),
                content: const Text('Sign up failed, '),
                actions: [
                  TextButton(
                      onPressed: () async {
                        Provider.of<ChatProvider>(context, listen: false)
                            .userName
                            .clear();
                        SharedPreferences prefs =
                            await SharedPreferences.getInstance();
                        prefs.remove('userEmailSharedPreferences');

                        password.clear();
                        Provider.of<ChatProvider>(context, listen: false)
                            .email
                            .clear();
                        setState(() {
                          isLoading = false;
                        });
                        _dismissDialog();
                      },
                      child: const Text('ok'))
                ],
              );
            });
      }
    } else {
      return null;
    }
  }

  _dismissDialog() {
    Navigator.pop(context);
  }

//* this method is to get the switch widget value from shared preferences
  getDataFromSharedPreferences() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();

    var result = prefs.getBool('darkMood') ?? false;
    return result;
  }

  //* This method is to handle the value from shared preferences
  getSwitchValues() async {
    Provider.of<ChatProvider>(context, listen: false).darkMood =
        await getDataFromSharedPreferences();
    Provider.of<ChatProvider>(context, listen: false).changeColor();
    Provider.of<ChatProvider>(context, listen: false).changeScaffoldColor();
    Provider.of<ChatProvider>(context, listen: false).changingTextColor();
    setState(() {});
  }

  //* This method is to save the user email in shared preferences
  Future<String?> saveUserEmailInSharedPrefernces(
      String emailSharedPreferences) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();

    var result =
        prefs.setString('userEmailSharedPreferences', emailSharedPreferences);
  }
}
