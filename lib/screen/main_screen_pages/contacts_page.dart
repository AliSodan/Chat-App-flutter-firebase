import 'dart:ui';
import 'package:chat_app_29_9_2015/screen/main_screen_pages/hero_dialog_route.dart';
import 'package:chat_app_29_9_2015/screen/main_screen_pages/hero_image.dart';
import 'package:chat_app_29_9_2015/widgets/clipper.dart';
import 'package:intl/intl.dart';
import 'package:chat_app_29_9_2015/provider/chat_provider.dart';
import 'package:chat_app_29_9_2015/screen/search_for_friends.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:provider/provider.dart';
import '../conversation_screen.dart';

class ContactPage extends StatefulWidget {
  const ContactPage({Key? key}) : super(key: key);

  @override
  _ContactPageState createState() => _ContactPageState();
}

class _ContactPageState extends State<ContactPage> with WidgetsBindingObserver {
  @override
  void initState() {
    WidgetsBinding.instance!.addObserver(this);
    setStatues('Online');
    isChatingWith();

    super.initState();
  }

//* this method is update the value of chating with field in the firestore
  isChatingWith() async {
    await FirebaseFirestore.instance
        .collection('users')
        .doc(FirebaseAuth.instance.currentUser!.uid)
        .set(
      {'Chatting with': 'Nobody'},
      SetOptions(merge: true),
    );
  }

  @override
  void dispose() {
    WidgetsBinding.instance!.addObserver(this);
    setStatues(
      DateFormat('EEE').format(DateTime.now()).toString() +
          ' at ' +
          DateFormat('hh:mm a').format(
            DateTime.now(),
          ),
    );

    super.dispose();
  }

  void setStatues(String statues) async {
    await FirebaseFirestore.instance
        .collection('users')
        .doc(FirebaseAuth.instance.currentUser!.uid)
        .set({'last appearance': statues}, SetOptions(merge: true));
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (state == AppLifecycleState.resumed) {
      setStatues('Online');
    } else {
      setStatues(DateFormat('EEE').format(DateTime.now()).toString() +
          ' at ' +
          DateFormat('hh:mm a').format(DateTime.now()));
    }
    super.didChangeAppLifecycleState(state);
  }

  @override
  Widget build(BuildContext context) {
    dynamic _height = MediaQuery.of(context).size.height;

    dynamic _width = MediaQuery.of(context).size.width;

    return Scaffold(
      backgroundColor: Provider.of<ChatProvider>(context).backGroundColor,
      body: Stack(
        children: [
          Column(
            children: [
              SizedBox(
                  height: MediaQuery.of(context).size.height * 0.3,
                  //!  here where the contants you can chat with will appear
                  child: StreamBuilder(
                    stream: FirebaseFirestore.instance
                        .collection('ChatRooms')
                        .orderBy('chatTime', descending: true)
                        .where('users',
                            arrayContains:
                                FirebaseAuth.instance.currentUser!.displayName)
                        .snapshots(),
                    builder: (BuildContext context,
                        AsyncSnapshot<QuerySnapshot> snapshot) {
                      if (!snapshot.hasData) {
                        return Center(
                          child: Text(
                            'No Friends to show ...',
                            style: TextStyle(
                                color: Provider.of<ChatProvider>(context)
                                    .mainColor),
                          ),
                        );
                      }
                      return ListView.builder(
                        shrinkWrap: true,
                        itemCount: snapshot.data!.docs.length,
                        itemBuilder: (context, i) {
                          return SizedBox(
                            height: _height * 0.1,
                            child: Center(
                              child: ListTile(
                                onTap: () {
                                  snapshot.data!.docs[i]['users'][0] ==
                                          FirebaseAuth
                                              .instance.currentUser!.displayName
                                      ? Provider.of<ChatProvider>(context,
                                                  listen: false)
                                              .sender =
                                          snapshot.data!.docs[i]['users'][1]
                                      : Provider.of<ChatProvider>(context,
                                                  listen: false)
                                              .sender =
                                          snapshot.data!.docs[i]['users'][0];

                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) =>
                                          const ConversationScreen(),
                                    ),
                                  );
                                },
                                leading: SizedBox(
                                  width: _width * 0.15,
                                  height: _height * 0.1,
                                  child:
                                      //!this streamBuilder is to fetch the users photos;
                                      StreamBuilder(
                                    stream: FirebaseFirestore.instance
                                        .collection('users')
                                        .where('name',
                                            isEqualTo: snapshot.data!.docs[i]
                                                        ['users'][0] ==
                                                    FirebaseAuth
                                                        .instance
                                                        .currentUser!
                                                        .displayName
                                                ? snapshot.data!.docs[i]
                                                    ['users'][1]
                                                : snapshot.data!.docs[i]
                                                    ['users'][0])
                                        .snapshots(),
                                    builder: (context,
                                        AsyncSnapshot<QuerySnapshot>
                                            snapshot2) {
                                      if (snapshot2.hasData) {
                                        return ConnectionState !=
                                                ConnectionState.waiting
                                            ? Center(
                                                child: GestureDetector(
                                                  onTap: () {
                                                    Provider.of<ChatProvider>(
                                                            context,
                                                            listen: false)
                                                        .i = i;
                                                    Provider.of<ChatProvider>(
                                                                context,
                                                                listen: false)
                                                            .heroImage =
                                                        snapshot2.data!.docs[0]
                                                            ['photo'];
                                                    Navigator.of(context).push(
                                                      HeroDialogRoute(
                                                        builder: (context) {
                                                          return const PopsUp();
                                                        },
                                                      ),
                                                    );
                                                  },
                                                  child: Hero(
                                                    tag: '$i',
                                                    child: Container(
                                                      child: CircleAvatar(
                                                        radius: 28,
                                                        backgroundColor:
                                                            Colors.transparent,
                                                        backgroundImage:
                                                            NetworkImage(
                                                          snapshot2.data!
                                                              .docs[0]['photo'],
                                                        ),
                                                      ),
                                                    ),
                                                  ),
                                                ),
                                              )
                                            : CircularProgressIndicator(
                                                strokeWidth: 1,
                                                color:
                                                    Provider.of<ChatProvider>(
                                                            context)
                                                        .mainColor,
                                              );
                                      } else {
                                        return CircularProgressIndicator();
                                      }
                                    },
                                  ),
                                ),
                                title: snapshot.data!.docs[i]['users'][1] ==
                                        FirebaseAuth
                                            .instance.currentUser!.displayName
                                    ? Text(
                                        snapshot.data!.docs[i]['users'][0],
                                        style: TextStyle(
                                            fontSize: 20,
                                            color: Provider.of<ChatProvider>(
                                                    context)
                                                .textColor),
                                      )
                                    : Text(
                                        snapshot.data!.docs[i]['users'][1],
                                        style: TextStyle(
                                            fontSize: 20,
                                            color: Provider.of<ChatProvider>(
                                                    context)
                                                .textColor),
                                      ),
                                //* here where the last message of the conversation will appear
                                subtitle: StreamBuilder<QuerySnapshot>(
                                  stream: FirebaseFirestore.instance
                                      .collection('ChatRooms')
                                      .doc(snapshot.data!.docs[i]['users'][1]
                                                      .substring(0, 1)
                                                      .codeUnitAt(0) +
                                                  snapshot
                                                      .data!.docs[i]['users'][1]
                                                      .substring(1, 2)
                                                      .codeUnitAt(0) +
                                                  snapshot
                                                      .data!.docs[i]['users'][1]
                                                      .substring(2, 3)
                                                      .codeUnitAt(0) >
                                              snapshot.data!.docs[i]['users'][0]
                                                      .substring(0, 1)
                                                      .codeUnitAt(0) +
                                                  snapshot
                                                      .data!.docs[i]['users'][0]
                                                      .substring(1, 2)
                                                      .codeUnitAt(0) +
                                                  snapshot
                                                      .data!.docs[i]['users'][0]
                                                      .substring(2, 3)
                                                      .codeUnitAt(0)
                                          ? "${snapshot.data!.docs[i]['users'][0]}\_${snapshot.data!.docs[i]['users'][1]}"
                                          : "${snapshot.data!.docs[i]['users'][1]}\_${snapshot.data!.docs[i]['users'][0]}")
                                      .collection('chats')
                                      .orderBy('createdAt', descending: true)
                                      .snapshots(),
                                  builder: (context,
                                      AsyncSnapshot<QuerySnapshot> snapshot3) {
                                    if (snapshot3.hasData &&
                                        !snapshot3.hasError) {
                                      return Row(
                                        children: [
                                          snapshot3.data!.docs.isEmpty
                                              ? const Text(' ')
                                              : Text(
                                                  snapshot3.data!.docs.first[
                                                              'send by'] ==
                                                          FirebaseAuth
                                                              .instance
                                                              .currentUser!
                                                              .displayName
                                                      ? 'You'
                                                      : snapshot3.data!.docs
                                                          .first['send by'],
                                                  style: TextStyle(
                                                      color: Provider.of<ChatProvider>(
                                                                      context)
                                                                  .darkMood ==
                                                              true
                                                          ? Colors.white
                                                          : Colors.black38),
                                                ),
                                          Text(
                                            '  :  ',
                                            style: TextStyle(
                                              color: Provider.of<ChatProvider>(
                                                              context)
                                                          .darkMood ==
                                                      true
                                                  ? Colors.white
                                                  : Colors.black38,
                                            ),
                                          ),
                                          snapshot3.data!.docs.isNotEmpty
                                              ? snapshot3
                                                          .data!
                                                          .docs
                                                          .first['Message']
                                                          .length >
                                                      30
                                                  ? Text(
                                                      snapshot3.data!.docs
                                                              .first['Message']
                                                              .substring(
                                                                  0, 19) +
                                                          '...',
                                                      style: TextStyle(
                                                        color: Provider.of<ChatProvider>(
                                                                        context)
                                                                    .darkMood ==
                                                                true
                                                            ? Colors.white
                                                            : Colors.black38,
                                                      ),
                                                    )
                                                  : Text(
                                                      snapshot3.data!.docs
                                                          .first['Message'],
                                                      style: TextStyle(
                                                        color: Provider.of<ChatProvider>(
                                                                        context)
                                                                    .darkMood ==
                                                                true
                                                            ? Colors.white
                                                            : Colors.black38,
                                                      ),
                                                    )
                                              : Text(
                                                  'No messages yet',
                                                  style: TextStyle(
                                                    color:
                                                        Provider.of<ChatProvider>(
                                                                        context)
                                                                    .darkMood ==
                                                                true
                                                            ? Colors.white
                                                            : Colors.black38,
                                                  ),
                                                ),
                                        ],
                                      );
                                    } else {
                                      return Text(
                                        'No messages yet',
                                        style: TextStyle(
                                          color:
                                              Provider.of<ChatProvider>(context)
                                                          .darkMood ==
                                                      true
                                                  ? Colors.white
                                                  : Colors.black38,
                                        ),
                                      );
                                    }
                                  },
                                ), //*here is where the time of the last message will appear
                                trailing: StreamBuilder(
                                  stream: FirebaseFirestore.instance
                                      .collection('ChatRooms')
                                      .doc(snapshot.data!.docs[i]['users'][1]
                                                      .substring(0, 1)
                                                      .codeUnitAt(0) +
                                                  snapshot
                                                      .data!.docs[i]['users'][1]
                                                      .substring(1, 2)
                                                      .codeUnitAt(0) +
                                                  snapshot
                                                      .data!.docs[i]['users'][1]
                                                      .substring(2, 3)
                                                      .codeUnitAt(0) >
                                              snapshot.data!.docs[i]['users'][0]
                                                      .substring(0, 1)
                                                      .codeUnitAt(0) +
                                                  snapshot
                                                      .data!.docs[i]['users'][0]
                                                      .substring(1, 2)
                                                      .codeUnitAt(0) +
                                                  snapshot
                                                      .data!.docs[i]['users'][0]
                                                      .substring(2, 3)
                                                      .codeUnitAt(0)
                                          ? "${snapshot.data!.docs[i]['users'][0]}\_${snapshot.data!.docs[i]['users'][1]}"
                                          : "${snapshot.data!.docs[i]['users'][1]}\_${snapshot.data!.docs[i]['users'][0]}")
                                      .collection('chats')
                                      .orderBy('createdAt', descending: true)
                                      .snapshots(),
                                  builder: (BuildContext context,
                                      AsyncSnapshot<QuerySnapshot> snapshott) {
                                    if (snapshott.hasData) {
                                      return snapshott.data!.docs.isNotEmpty
                                          ? Text(
                                              snapshott.data!.docs[0]
                                                  ['specificDate'],
                                              style: TextStyle(
                                                  color:
                                                      Provider.of<ChatProvider>(
                                                                      context)
                                                                  .darkMood ==
                                                              true
                                                          ? Colors.white
                                                          : Colors.black38),
                                            )
                                          : Text(' ');
                                    } else {
                                      return Text('No Time provided');
                                    }
                                  },
                                ),
                              ),
                            ),
                          );
                        },
                      );
                    },
                  )),
            ],
          ),
          //* here where the search result will appear
          ClipPath(
            clipper: WaveClipper(),
            child: AnimatedContainer(
              duration: const Duration(milliseconds: 700),
              height: MediaQuery.of(context).size.height *
                  Provider.of<ChatProvider>(context).clipperHeight2,
              width: MediaQuery.of(context).size.width * 1,
              color:
                  Provider.of<ChatProvider>(context).mainColor.withOpacity(0.3),
              alignment: Alignment.bottomCenter,
              child: Row(
                children: [
                  SizedBox(
                    width: _width * 0.6,
                  ),
                  IconButton(
                    onPressed: () {
                      Provider.of<ChatProvider>(context, listen: false)
                          .openSearchBar();
                    },
                    icon: const Icon(Icons.keyboard_arrow_up_outlined),
                    color: Colors.white,
                    iconSize: 30,
                  ),
                ],
              ),
            ),
          ),

          ClipPath(
            clipper: WaveClipper(),
            child: AnimatedContainer(
              duration: const Duration(milliseconds: 700),
              height: MediaQuery.of(context).size.height *
                  Provider.of<ChatProvider>(context).clipperHeight,
              width: MediaQuery.of(context).size.width * 1,
              color: Provider.of<ChatProvider>(context).mainColor,
              child: const SearchScreen(),
            ),
          ),
        ],
      ),
    );
  }
}


// '⬤'
                                    