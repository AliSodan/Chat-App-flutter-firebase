import 'package:chat_app_29_9_2015/provider/chat_provider.dart';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class StatuesPage extends StatefulWidget {
  const StatuesPage({Key? key}) : super(key: key);

  @override
  _StatuesPageState createState() => _StatuesPageState();
}

class _StatuesPageState extends State<StatuesPage> {
  @override
  Widget build(BuildContext context) {
    dynamic _height = MediaQuery.of(context).size.height;
    dynamic _width = MediaQuery.of(context).size.width;
    return Scaffold(
      body: SizedBox(
          height: MediaQuery.of(context).size.height * 0.3,
          //!  here where the contants you can chat with will appear;
          child: StreamBuilder(
            stream: FirebaseFirestore.instance
                .collection('ChatRooms')
                .where('users',
                    arrayContains:
                        FirebaseAuth.instance.currentUser!.displayName)
                .snapshots(),
            builder:
                (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
              if (!snapshot.hasData) {
                return Center(
                  child: Text(
                    'No Friends to show ...',
                    style: TextStyle(
                        color: Provider.of<ChatProvider>(context).mainColor),
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
                        leading: GestureDetector(
                          child: SizedBox(
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
                                        AsyncSnapshot<QuerySnapshot> snapshot2) {
                                      if (snapshot2.hasData) {
                                        return ConnectionState !=
                                                ConnectionState.waiting
                                            ? Center(
                                                child: CircleAvatar(
                                                  radius: 28,
                                                  backgroundImage: NetworkImage(
                                                    snapshot2.data!.docs[0]
                                                        ['photo'],
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
                                        return const CircularProgressIndicator();
                                      }
                                    }),
                          ),
                        ),
                        title: StreamBuilder(
                          stream: FirebaseFirestore.instance
                              .collection('users')
                              .where(
                                'name',
                                isEqualTo: snapshot.data!.docs[i]['users'][1] ==
                                        FirebaseAuth
                                            .instance.currentUser!.displayName
                                    ? snapshot.data!.docs[i]['users'][0]
                                    : snapshot.data!.docs[i]['users'][1],
                              )
                              .snapshots(),
                          builder: (BuildContext context,
                              AsyncSnapshot<QuerySnapshot> snapshot3) {
                            if (snapshot3.hasData) {
                              return Text(
                                snapshot3.data!.docs[0]['status'],
                                style: TextStyle(
                                    color: Provider.of<ChatProvider>(context)
                                        .textColor),
                              );
                            } else {
                              return Text('No Statues available');
                            }
                          },
                        ),
                        subtitle: snapshot.data!.docs[i]['users'][1] ==
                                FirebaseAuth.instance.currentUser!.displayName
                            ? Text(
                                snapshot.data!.docs[i]['users'][0],
                                style: TextStyle(
                                    fontSize: 16,
                                    color: Provider.of<ChatProvider>(context)
                                                .darkMood ==
                                            true
                                        ? Colors.white
                                        : Colors.black38),
                              )
                            : Text(
                                snapshot.data!.docs[i]['users'][1],
                                style: TextStyle(
                                    fontSize: 16,
                                    color: Provider.of<ChatProvider>(context)
                                                .darkMood ==
                                            true
                                        ? Colors.white
                                        : Colors.black38),
                              ),
                      ),
                    ),
                  );
                },
              );
            },
          )),
    );
  }
}
