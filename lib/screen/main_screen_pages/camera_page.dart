import 'package:chat_app_29_9_2015/provider/chat_provider.dart';
import 'package:chat_app_29_9_2015/screen/main_screen.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';
import 'package:path/path.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

class CameraPage extends StatefulWidget {
  const CameraPage({Key? key}) : super(key: key);

  @override
  _CameraPageState createState() => _CameraPageState();
}

class _CameraPageState extends State<CameraPage> {
  var imagename;
  File? image;
  final ImagePicker imagePicker = ImagePicker();
  uploadImagefromCamera() async {
    var picker = await imagePicker.pickImage(source: ImageSource.camera);
    if (picker != null) {
      setState(() {
        image = File(picker.path);
        imagename = basename(image!.path);
      });
    } else {}
  }

  @override
  void initState() {
    uploadImagefromCamera();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return image != null
        ? Column(
            children: [
              Container(
                height: MediaQuery.of(context).size.height * 0.7,
                decoration: BoxDecoration(
                  image: DecorationImage(image: FileImage(image!)),
                ),
              ),
              InkWell(
                onTap: () async {
                  await uploadImagetoFireStorage();
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => const MainScreen()));
                },
                child: Container(
                  height: MediaQuery.of(context).size.height * 0.055,
                  width: MediaQuery.of(context).size.width * 0.5,
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
                  child: const Center(
                    child: Text(
                      'Set as a profile image',
                      style: TextStyle(color: Colors.white),
                    ),
                  ),
                ),
              ),
            ],
          )
        : Container();
  }

  uploadImagetoFireStorage() async {
    var refStorage = FirebaseStorage.instance.ref('Profile images/$imagename');
    await refStorage.putFile(image!);
    var url = await refStorage.getDownloadURL();
    SharedPreferences preferences = await SharedPreferences.getInstance();
    var result = await preferences.setString('url', url.toString());

    FirebaseFirestore.instance
        .collection('users')
        .doc(FirebaseAuth.instance.currentUser!.uid)
        .update({'photo': url.toString()});
  }
}
