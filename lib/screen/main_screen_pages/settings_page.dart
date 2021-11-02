import 'dart:async';

import 'dart:math';
import 'dart:io';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:path/path.dart';
import 'package:chat_app_29_9_2015/screen/main_screen_pages/camera_page.dart';
import 'package:chat_app_29_9_2015/screen/sign_up.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:chat_app_29_9_2015/provider/chat_provider.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:image_picker/image_picker.dart';
import 'package:firebase_storage/firebase_storage.dart';

class SettingPage extends StatefulWidget {
  const SettingPage({Key? key}) : super(key: key);

  @override
  _SettingPageState createState() => _SettingPageState();
}

class _SettingPageState extends State<SettingPage> {
  CollectionReference users = FirebaseFirestore.instance.collection('users');

  String? firestorageImage;

  File? galleryImage;

  String? imageName;

  ImagePicker imagePicker = ImagePicker();

  bool open = false;

  bool openStatues = false;

  double height = 0.1;

  double statuesHeight = 0.1;

  double cameraHeight = 0.1;

  bool openCamera = false;

  TextEditingController changeName = TextEditingController();
  TextEditingController changeStatues = TextEditingController();

  uploadImagefromGallery() async {
    var picker = await imagePicker.pickImage(source: ImageSource.gallery);
    if (picker != null) {
      setState(() {
        galleryImage = File(picker.path);
        imageName = basename(galleryImage!.path);
      });
      var refStorage =
          FirebaseStorage.instance.ref('Profile images/$imageName');
      await refStorage.putFile(galleryImage!);
      var url = await refStorage.getDownloadURL();
      SharedPreferences preferences = await SharedPreferences.getInstance();
      var result = await preferences.setString('url', url.toString());

      FirebaseFirestore.instance
          .collection('users')
          .doc(FirebaseAuth.instance.currentUser!.uid)
          .update({'photo': url.toString()});
    } else {}
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Container(
            height: MediaQuery.of(context).size.height * 0.1,
            margin:
                EdgeInsets.only(top: MediaQuery.of(context).size.height * 0.01),
            child: Center(
              child: StreamBuilder<QuerySnapshot>(
                stream: FirebaseFirestore.instance
                    .collection('users')
                    .where('name',
                        isEqualTo:
                            FirebaseAuth.instance.currentUser!.displayName)
                    .snapshots(),
                builder: (context, snapshot) {
                  if (!snapshot.hasData) {
                    return CircularProgressIndicator(
                      color: Provider.of<ChatProvider>(context).mainColor,
                    );
                  }
                  var x = snapshot.data!.docs;

                  return snapshot.hasData && !snapshot.hasError
                      ? ListTile(
                          leading: CircleAvatar(
                            radius: 40.00,
                            backgroundColor: Colors.transparent,
                            backgroundImage: NetworkImage(
                              ConnectionState == ConnectionState.waiting
                                  ? CircularProgressIndicator()
                                  : firestorageImage ?? x[0]['photo'],
                            ),
                            child: ConnectionState == ConnectionState.waiting
                                ? const CircularProgressIndicator()
                                : Container(),
                          ),
                          title: Text(
                            x[0]['app User Name'],
                            style: TextStyle(
                                fontSize: 22,
                                color: Provider.of<ChatProvider>(context)
                                    .textColor),
                          ),
                          subtitle: Text(
                            x[0]['status'],
                            style: TextStyle(
                                color: Provider.of<ChatProvider>(context)
                                    .textColor),
                          ),
                          trailing: Switch(
                            activeColor: const Color(0xff00AEAE),
                            value: Provider.of<ChatProvider>(context).darkMood,
                            onChanged: (value) {
                              setState(() {
                                Provider.of<ChatProvider>(context,
                                        listen: false)
                                    .darkMood = value;
                                setData(value);
                              });

                              Provider.of<ChatProvider>(context, listen: false)
                                  .changeColor();
                              Provider.of<ChatProvider>(context, listen: false)
                                  .changeScaffoldColor();
                              Provider.of<ChatProvider>(context, listen: false)
                                  .changingTextColor();
                            },
                          ),
                        )
                      : CircularProgressIndicator(
                          color: Provider.of<ChatProvider>(context).mainColor,
                        );
                },
              ),
            ),
          ),
          SizedBox(
            height: MediaQuery.of(context).size.height * 0.6,
            width: MediaQuery.of(context).size.width * 1,
            child: ListView(
              children: [
                SizedBox(
                  height: MediaQuery.of(context).size.height * 0.02,
                ),
                AnimatedContainer(
                  duration: const Duration(milliseconds: 500),
                  margin: EdgeInsets.only(
                      top: MediaQuery.of(context).size.height * 0.01,
                      left: MediaQuery.of(context).size.width * 0.075),
                  height: MediaQuery.of(context).size.height * cameraHeight,
                  child: Column(
                    children: [
                      ListTile(
                        leading: Icon(
                          Icons.camera,
                          color: Provider.of<ChatProvider>(context).mainColor,
                        ),
                        title: Text('Change photo',
                            style: TextStyle(
                                color: Provider.of<ChatProvider>(context)
                                    .mainColor)),
                        subtitle: Text(
                          'Tap to change your profile photo',
                          style: TextStyle(
                              color:
                                  Provider.of<ChatProvider>(context).textColor),
                        ),
                        trailing: Transform.rotate(
                          angle: openCamera == true
                              ? 180 * pi / 180
                              : 180 * pi / 10,
                          child: IconButton(
                            icon: Icon(
                              Icons.keyboard_arrow_down_sharp,
                              size: 30,
                              color:
                                  Provider.of<ChatProvider>(context).mainColor,
                            ),
                            onPressed: () {
                              setState(() {
                                if (cameraHeight == 0.1) {
                                  cameraHeight = 0.2;
                                } else if (cameraHeight == 0.2) {
                                  cameraHeight = 0.1;
                                }
                                if (openCamera == false) {
                                  openCamera = true;
                                } else if (openCamera == true) {
                                  openCamera = false;
                                }
                              });
                            },
                          ),
                        ),
                      ),
                      cameraHeight >= 0.19
                          ? Expanded(
                              child: Row(
                                children: [
                                  SizedBox(
                                      width: MediaQuery.of(context).size.width *
                                          0.17),
                                  InkWell(
                                    onTap: () {
                                      Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                          builder: (context) =>
                                              const CameraPage(),
                                        ),
                                      );
                                    },
                                    child: Container(
                                      height:
                                          MediaQuery.of(context).size.height *
                                              0.04,
                                      width: MediaQuery.of(context).size.width *
                                          0.17,
                                      decoration: BoxDecoration(
                                          color:
                                              Provider.of<ChatProvider>(context)
                                                  .mainColor,
                                          boxShadow: [
                                            BoxShadow(
                                              color:
                                                  Colors.black.withOpacity(0.3),
                                              blurRadius: 10,
                                              spreadRadius: 3,
                                              offset: Offset(1, 1),
                                            )
                                          ]),
                                      child: const Center(
                                        child: Text(
                                          'Camera',
                                          style: TextStyle(color: Colors.white),
                                        ),
                                      ),
                                    ),
                                  ),
                                  SizedBox(
                                    width:
                                        MediaQuery.of(context).size.width * 0.2,
                                  ),
                                  InkWell(
                                    onTap: uploadImagefromGallery,
                                    child: Container(
                                      height:
                                          MediaQuery.of(context).size.height *
                                              0.04,
                                      width: MediaQuery.of(context).size.width *
                                          0.17,
                                      decoration: BoxDecoration(
                                          color:
                                              Provider.of<ChatProvider>(context)
                                                  .mainColor,
                                          boxShadow: [
                                            BoxShadow(
                                              color:
                                                  Colors.black.withOpacity(0.3),
                                              blurRadius: 10,
                                              spreadRadius: 3,
                                              offset: Offset(1, 1),
                                            )
                                          ]),
                                      child: const Center(
                                        child: Text(
                                          'Gallery',
                                          style: TextStyle(color: Colors.white),
                                        ),
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            )
                          : Container(),
                    ],
                  ),
                ),
                Padding(
                  padding: EdgeInsets.only(
                      left: MediaQuery.of(context).size.width * 0.13,
                      right: MediaQuery.of(context).size.width * 0.08),
                  child: Divider(
                    color: Provider.of<ChatProvider>(context).mainColor,
                  ),
                ),
                AnimatedContainer(
                  duration: const Duration(milliseconds: 600),
                  height: MediaQuery.of(context).size.height * height,
                  margin: EdgeInsets.only(
                      top: MediaQuery.of(context).size.height * 0.01,
                      left: MediaQuery.of(context).size.width * 0.075),
                  child: Column(
                    children: [
                      ListTile(
                        leading: Icon(
                          Icons.perm_contact_calendar_outlined,
                          color: Provider.of<ChatProvider>(context).mainColor,
                        ),
                        title: Text('Change User Name',
                            style: TextStyle(
                                color: Provider.of<ChatProvider>(context)
                                    .mainColor)),
                        subtitle: Text(
                          'Tap to change your Name',
                          style: TextStyle(
                              color:
                                  Provider.of<ChatProvider>(context).textColor),
                        ),
                        trailing: Transform.rotate(
                          angle: open == true ? 180 * pi / 180 : 180 * pi / 10,
                          child: IconButton(
                            icon: Icon(
                              Icons.keyboard_arrow_down_sharp,
                              size: 30,
                              color:
                                  Provider.of<ChatProvider>(context).mainColor,
                            ),
                            onPressed: () {
                              setState(() {
                                if (height == 0.1) {
                                  height = 0.2;
                                } else if (height == 0.2) {
                                  height = 0.1;
                                }
                                if (open == false) {
                                  open = true;
                                } else if (open == true) {
                                  open = false;
                                }
                              });
                            },
                          ),
                        ),
                      ),
                      height >= 0.19
                          ? Expanded(
                              child: Padding(
                                padding: EdgeInsets.only(
                                  left: MediaQuery.of(context).size.width * 0.1,
                                  right:
                                      MediaQuery.of(context).size.width * 0.4,
                                ),
                                child: TextFormField(
                                  controller: changeName,
                                  style: TextStyle(
                                      color: Provider.of<ChatProvider>(context)
                                          .mainColor),
                                  decoration: InputDecoration(
                                    border: UnderlineInputBorder(
                                        borderSide: BorderSide(
                                            color: Provider.of<ChatProvider>(
                                                    context)
                                                .mainColor)),
                                    enabledBorder: UnderlineInputBorder(
                                      borderSide: BorderSide(
                                          color:
                                              Provider.of<ChatProvider>(context)
                                                  .mainColor),
                                    ),
                                    focusedBorder: UnderlineInputBorder(
                                      borderSide: BorderSide(
                                          color:
                                              Provider.of<ChatProvider>(context)
                                                  .mainColor),
                                    ),
                                    hintText: 'New Name',
                                    hintStyle: TextStyle(
                                        color:
                                            Provider.of<ChatProvider>(context)
                                                .textColor),
                                  ),
                                ),
                              ),
                            )
                          : Container(),
                      height >= 0.19
                          ? Expanded(
                              child: Row(
                                children: [
                                  SizedBox(
                                    width: MediaQuery.of(context).size.width *
                                        0.65,
                                  ),
                                  InkWell(
                                    onTap: () async {
                                      await FirebaseFirestore.instance
                                          .collection('users')
                                          .doc(FirebaseAuth
                                              .instance.currentUser!.uid)
                                          .update({
                                        'app User Name': changeName.text
                                      });
                                      changeName.clear();
                                    },
                                    child: Container(
                                        height:
                                            MediaQuery.of(context).size.height *
                                                0.04,
                                        width:
                                            MediaQuery.of(context).size.width *
                                                0.17,
                                        decoration: BoxDecoration(
                                            color: Provider.of<ChatProvider>(
                                                    context)
                                                .mainColor,
                                            boxShadow: [
                                              BoxShadow(
                                                color: Colors.black
                                                    .withOpacity(0.3),
                                                blurRadius: 10,
                                                spreadRadius: 3,
                                                offset: Offset(1, 1),
                                              )
                                            ]),
                                        child: Center(
                                          child: Text(
                                            'Confirm',
                                            style:
                                                TextStyle(color: Colors.white),
                                          ),
                                        )),
                                  ),
                                ],
                              ),
                            )
                          : Container(),
                    ],
                  ),
                ),
                Padding(
                  padding: EdgeInsets.only(
                      left: MediaQuery.of(context).size.width * 0.13,
                      right: MediaQuery.of(context).size.width * 0.08),
                  child: Divider(
                    color: Provider.of<ChatProvider>(context).mainColor,
                  ),
                ),
                AnimatedContainer(
                  duration: Duration(milliseconds: 600),
                  height: MediaQuery.of(context).size.height * statuesHeight,
                  margin: EdgeInsets.only(
                      top: MediaQuery.of(context).size.height * 0.01,
                      left: MediaQuery.of(context).size.width * 0.075),
                  child: Column(
                    children: [
                      ListTile(
                        leading: Icon(
                          Icons.edit,
                          color: Provider.of<ChatProvider>(context).mainColor,
                        ),
                        title: Text('Change your statues',
                            style: TextStyle(
                                color: Provider.of<ChatProvider>(context)
                                    .mainColor)),
                        subtitle: Text(
                          'Tap to change your statues',
                          style: TextStyle(
                              color:
                                  Provider.of<ChatProvider>(context).textColor),
                        ),
                        trailing: Transform.rotate(
                          angle: openStatues == true
                              ? 180 * pi / 180
                              : 180 * pi / 10,
                          child: IconButton(
                            icon: Icon(
                              Icons.keyboard_arrow_down_sharp,
                              size: 30,
                              color:
                                  Provider.of<ChatProvider>(context).mainColor,
                            ),
                            onPressed: () {
                              setState(() {
                                if (statuesHeight == 0.1) {
                                  statuesHeight = 0.2;
                                } else if (statuesHeight == 0.2) {
                                  statuesHeight = 0.1;
                                }
                                if (openStatues == false) {
                                  openStatues = true;
                                } else if (openStatues == true) {
                                  openStatues = false;
                                }
                              });
                            },
                          ),
                        ),
                      ),
                      statuesHeight >= 0.19
                          ? Expanded(
                              child: Padding(
                                padding: EdgeInsets.only(
                                  left: MediaQuery.of(context).size.width * 0.1,
                                  right:
                                      MediaQuery.of(context).size.width * 0.4,
                                ),
                                child: TextFormField(
                                  controller: changeStatues,
                                  style: TextStyle(
                                      color: Provider.of<ChatProvider>(context)
                                          .mainColor),
                                  decoration: InputDecoration(
                                    border: UnderlineInputBorder(
                                        borderSide: BorderSide(
                                            color: Provider.of<ChatProvider>(
                                                    context)
                                                .mainColor)),
                                    enabledBorder: UnderlineInputBorder(
                                      borderSide: BorderSide(
                                          color:
                                              Provider.of<ChatProvider>(context)
                                                  .mainColor),
                                    ),
                                    focusedBorder: UnderlineInputBorder(
                                      borderSide: BorderSide(
                                          color:
                                              Provider.of<ChatProvider>(context)
                                                  .mainColor),
                                    ),
                                    hintText: 'New Statues',
                                    hintStyle: TextStyle(
                                        color:
                                            Provider.of<ChatProvider>(context)
                                                .mainColor),
                                  ),
                                ),
                              ),
                            )
                          : Container(),
                      statuesHeight >= 0.19
                          ? Expanded(
                              child: Row(
                                children: [
                                  SizedBox(
                                    width: MediaQuery.of(context).size.width *
                                        0.65,
                                  ),
                                  InkWell(
                                    onTap: () async {
                                      await FirebaseFirestore.instance
                                          .collection('users')
                                          .doc(FirebaseAuth
                                              .instance.currentUser!.uid)
                                          .update(
                                              {'status': changeStatues.text});
                                      changeStatues.clear();
                                    },
                                    child: Container(
                                        height:
                                            MediaQuery.of(context).size.height *
                                                0.04,
                                        width:
                                            MediaQuery.of(context).size.width *
                                                0.17,
                                        decoration: BoxDecoration(
                                            color: Provider.of<ChatProvider>(
                                                    context)
                                                .mainColor,
                                            boxShadow: [
                                              BoxShadow(
                                                color: Colors.black
                                                    .withOpacity(0.3),
                                                blurRadius: 10,
                                                spreadRadius: 3,
                                                offset: const Offset(1, 1),
                                              )
                                            ]),
                                        child: const Center(
                                          child: Text(
                                            'Confirm',
                                            style:
                                                TextStyle(color: Colors.white),
                                          ),
                                        )),
                                  ),
                                ],
                              ),
                            )
                          : Container(),
                    ],
                  ),
                ),
                Padding(
                  padding: EdgeInsets.only(
                      left: MediaQuery.of(context).size.width * 0.13,
                      right: MediaQuery.of(context).size.width * 0.08),
                  child: Divider(
                    color: Provider.of<ChatProvider>(context).mainColor,
                  ),
                ),
                Container(
                  margin: EdgeInsets.only(
                      top: MediaQuery.of(context).size.height * 0.01,
                      left: MediaQuery.of(context).size.width * 0.075),
                  child: ListTile(
                    onTap: () {},
                    leading: Icon(
                      Icons.image_outlined,
                      color: Provider.of<ChatProvider>(context).mainColor,
                    ),
                    title: Text('Change Chat background',
                        style: TextStyle(
                            color:
                                Provider.of<ChatProvider>(context).mainColor)),
                    subtitle: Text(
                      'Tap to change your Chat background',
                      style: TextStyle(
                          color: Provider.of<ChatProvider>(context).textColor),
                    ),
                  ),
                ),
                Padding(
                  padding: EdgeInsets.only(
                      left: MediaQuery.of(context).size.width * 0.13,
                      right: MediaQuery.of(context).size.width * 0.08),
                  child: Divider(
                    color: Provider.of<ChatProvider>(context).mainColor,
                  ),
                ),
                Container(
                  margin: EdgeInsets.only(
                      top: MediaQuery.of(context).size.height * 0.01,
                      left: MediaQuery.of(context).size.width * 0.075),
                  child: ListTile(
                    onTap: () async {
                      signingOutmethod().then((value) {
                        Navigator.pushReplacement(
                          context,
                          MaterialPageRoute(
                            builder: (context) => const SignUp(),
                          ),
                        );
                      });

                      await removeSigningInFromSharedPreferences();
                    },
                    leading: Icon(
                      Icons.exit_to_app,
                      color: Provider.of<ChatProvider>(context).mainColor,
                    ),
                    title: Text('Sign out',
                        style: TextStyle(
                            color:
                                Provider.of<ChatProvider>(context).mainColor)),
                    subtitle: Text(
                      'Tap to Sign Out',
                      style: TextStyle(
                          color: Provider.of<ChatProvider>(context).textColor),
                    ),
                  ),
                ),
                Padding(
                  padding: EdgeInsets.only(
                      left: MediaQuery.of(context).size.width * 0.13,
                      right: MediaQuery.of(context).size.width * 0.08),
                  child: Divider(
                    color: Provider.of<ChatProvider>(context).mainColor,
                  ),
                ),
              ],
            ),
          ),
          Text(
            'Made by',
            style: TextStyle(
              color: Provider.of<ChatProvider>(context).textColor,
              fontSize: 20,
            ),
          ),
          SizedBox(
            height: MediaQuery.of(context).size.height * 0.005,
          ),
          Text(
            'F/D Ali Sodan',
            style: TextStyle(
              color: Provider.of<ChatProvider>(context).textColor,
              fontSize: 30,
            ),
          ),
        ],
      ),
    );
  }

//* This method is to save the value returning from switch widget to save the darkmode in shared preferences
  setData(bool value) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();

    prefs.setBool('darkMood', value);
    return prefs.setBool('darkMood', value);
  }

  //* this method is to save the app user name in shared preferences
  setAppUserName() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setString('AppUserName', changeName.text);
    // return prefs.setString('AppUserName', changeName.text);
  }

//* this method is to save the updated statues in SharedPreferences
  setStatues() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setString('statues', changeStatues.text);
    //  return prefs.setString('statues', changeStatues.text);
  }

  //* this method is to remove the signing in email when the user signs out
  removeSigningInFromSharedPreferences() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.remove('userEmailSharedPreferences');
  }

  Future signingOutmethod() async {
    await FirebaseAuth.instance.signOut();
    await GoogleSignIn().signOut();
  }

  getTheImageUrlFromFireStorage() async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    firestorageImage = preferences.getString('url');
  }
}
