import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AddUser {
  String? name;
  String? email;
  String? appUserName;
  String? userStatues;
  String? photoUrl;
  AddUser({this.name, this.email});

  CollectionReference users = FirebaseFirestore.instance.collection('users');

  //! this method is to add a user to firestore from sign up with email and password ;
  Future addUser(String name, String email) async {
    return users
        .doc(FirebaseAuth.instance.currentUser!.uid)
        .set({
          'name': name,
          'email': email,
          'app User Name': appUserName ?? name,
          'photo':
              'https://st3.depositphotos.com/13159112/17145/v/600/depositphotos_171453724-stock-illustration-default-avatar-profile-icon-grey.jpg',
          'status': photoUrl ?? 'Hey there! Im using Chat App',
          'isFriend': false,
        }, SetOptions(merge: true))
        .then((value) => print('signed in'))
        .catchError((error) => print('faild$error'));
  }

  //! this method is to add a google account to firestore;
  Future setGoogleUser(String name, String email, String photo) async {
    return FirebaseFirestore.instance
        .collection('users')
        .doc(FirebaseAuth.instance.currentUser!.uid)
        .set({
          'name': name,
          'email': email,
          'photo': photoUrl ?? photo,
          'status': userStatues ?? 'Hey there! Im using chatApp',
          'app User Name': appUserName ?? name,
          'isFriend': false,
        }, SetOptions(merge: true))
        .then((value) => print('signed in'))
        .catchError((error) => print('faild$error'));
  }

//! This method is to get Chat app user name from shared preferences
  getAppUserName() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    appUserName = prefs.getString('AppUserName');
  }

  //! This method is to get the statues from shared preferences
  getUserStatues() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();

    userStatues = prefs.getString('statues');
  }

  getUserUploadedPhotoUrlFromSharedPreferences() async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    photoUrl = preferences.getString('url');
  }
}
