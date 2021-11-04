import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import 'package:flutter/cupertino.dart';

class ChatProvider extends ChangeNotifier {
  //* this int is to an id for hero widget
  int i = 0;
  //*this string is to handle the name of the image in the hero widget
  String heroImage = '';
  //*this text editing controller is to handle the sign up userName to the verification page
  TextEditingController userName = TextEditingController();
  //*this text editing controller is to handle the sign up email to the verification page
  TextEditingController email = TextEditingController();

  double clipperHeight = 0;
  String searchResult1 = '';
  double clipperHeight2 = 0;

  String photo = '';
  //* sender string is to handle the name of the user from contacts and show it in the conversation screen
  String sender = '';

  //* send messages is the text editing controller in the conversation screen
  TextEditingController sendMessages = TextEditingController();

  // *the bool of the switch widget
  bool darkMood = false;

  //*search for friends controller
  TextEditingController searchController = TextEditingController();

//* these variables are to change color according to the darkmode state
  Color textColor = Colors.black;
  Color backGroundColor = const Color(0xfffafafa);
  Color mainColor = const Color(0xff775fd3);

  //* this method is to change color
  changeColor() {
    if (darkMood == true) {
      mainColor = const Color(0xff00a884);
    } else if (darkMood == false) {
      mainColor = const Color(0xff775fd3);
    }
    notifyListeners();
  }

  //* this method is to change color
  changeScaffoldColor() {
    if (darkMood == true) {
      backGroundColor = const Color(0xff1f2c34);
    } else if (darkMood == false) {
      backGroundColor = const Color(0xfffafafa);
    }
    notifyListeners();
  }

  //*  this method is to change color
  changingTextColor() {
    if (darkMood == true) {
      textColor = Colors.white;
    } else if (darkMood == false) {
      textColor = Colors.black;
    }
    notifyListeners();
  }

//* this method is to search for a friend by his name
  searchForUserByName(String userName) async {
    return await FirebaseFirestore.instance
        .collection('users')
        .where('name', isEqualTo: userName)
        .get()
        .then((result) =>
            userName == FirebaseAuth.instance.currentUser!.displayName
                ? searchResult1 = 'The user doesn\'t exist'
                : result.docs.isNotEmpty
                    ? result.docs.forEach(
                        (snapshot) {
                          if (snapshot.exists) {
                            searchResult1 = snapshot.data()['name'];
                            photo = snapshot.data()['photo'];
                            notifyListeners();
                          } else {
                            searchResult1 = 'The user doesn\'t exist';
                            photo =
                                'https://st3.depositphotos.com/13159112/17145/v/600/depositphotos_171453724-stock-illustration-default-avatar-profile-icon-grey.jpg';
                            notifyListeners();
                          }
                        },
                      )
                    : searchResult1 = 'The user doesn\'t exist');
  }

  //! this method is to open and close the search bar
  openSearchBar() {
    if (clipperHeight == 0) {
      clipperHeight = 0.3;
      clipperHeight2 = 0.33;
      notifyListeners();
    } else if (clipperHeight == 0.3) {
      clipperHeight = 0;
      clipperHeight2 = 0;
      notifyListeners();
    }
  }
}
