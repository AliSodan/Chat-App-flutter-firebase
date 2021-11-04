import 'package:chat_app_29_9_2015/fire_store/add_user.dart';
import 'package:chat_app_29_9_2015/fire_store/create_chat_room.dart';
import 'package:chat_app_29_9_2015/provider/chat_provider.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:provider/provider.dart';

class SearchScreen extends StatefulWidget {
  const SearchScreen({Key? key}) : super(key: key);

  @override
  _SearchScreenState createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {
  //* the icon color in the search bar
  Color iconColor = Colors.grey;
  CollectionReference users = FirebaseFirestore.instance.collection('users');
//*text controller for the search bar;

//* an instance of create chat room class
  CreateChatRoom createChatRoom = CreateChatRoom();
  //* an instance of add user class;
  AddUser addUser = AddUser();
  //* an instance of firebase auth package;
  FirebaseAuth user = FirebaseAuth.instance;

  @override
  Widget build(BuildContext context) {
    dynamic _height = MediaQuery.of(context).size.height;

    dynamic _width = MediaQuery.of(context).size.width;

    return Container(
      height: MediaQuery.of(context).size.height * 0.3,
      width: MediaQuery.of(context).size.width * 0.85,
      color: Provider.of<ChatProvider>(context).mainColor,
      child: SingleChildScrollView(
        child: Column(
          children: [
            Container(
              margin: EdgeInsets.only(
                top: MediaQuery.of(context).size.height * 0.05,
              ),
              height: _height * 0.13,
              width: _width,
              child: Center(
                child: Provider.of<ChatProvider>(context).searchResult1 != ''
                    ? ListView.builder(
                        itemCount: 1,
                        itemBuilder: (context, i) => SizedBox(
                          height: _height * 0.1,
                          child: ConnectionState == ConnectionState.waiting
                              ? const CircularProgressIndicator(
                                  color: Colors.white,
                                )
                              : ListTile(
                                  leading: Provider.of<ChatProvider>(context)
                                                  .searchResult1 ==
                                              'The user doesn\'t exist' ||
                                          Provider.of<ChatProvider>(context)
                                                  .searchResult1 ==
                                              '' ||
                                          ConnectionState ==
                                              ConnectionState.waiting
                                      ? const Text(' ')
                                      : DecoratedBox(
                                          decoration: BoxDecoration(
                                            color: Colors.white,
                                            border: Border.all(width: 0.5),
                                            borderRadius:
                                                BorderRadius.circular(30),
                                          ),
                                          child: Provider.of<ChatProvider>(context)
                                                          .photo !=
                                                      null &&
                                                  Provider.of<ChatProvider>(context)
                                                      .photo
                                                      .isNotEmpty &&
                                                  Provider.of<ChatProvider>(context)
                                                          .photo !=
                                                      ''
                                              ? Image.network(
                                                  Provider.of<ChatProvider>(
                                                          context)
                                                      .photo,
                                                  fit: BoxFit.contain,
                                                )
                                              : Provider.of<ChatProvider>(context)
                                                              .searchResult1 !=
                                                          null &&
                                                      Provider.of<ChatProvider>(
                                                                  context)
                                                              .searchResult1 !=
                                                          ''
                                                  ? Text(
                                                      Provider.of<ChatProvider>(
                                                              context)
                                                          .searchResult1[0]
                                                          .toUpperCase())
                                                  : const Text(''),
                                        ),
                                  title: Text(
                                    Provider.of<ChatProvider>(context)
                                        .searchResult1,
                                    style: const TextStyle(
                                        color: Colors.white, fontSize: 18),
                                  ),
                                  trailing: Provider.of<ChatProvider>(context)
                                                  .searchResult1 ==
                                              'The user doesn\'t exist' ||
                                          Provider.of<ChatProvider>(context)
                                                  .searchResult1 ==
                                              ''
                                      ? const Text(' ')
                                      : Provider.of<ChatProvider>(context)
                                                  .searchResult1 ==
                                              'The user doesn\'t exist'
                                          ? Container()
                                          : IconButton(
                                              //!  here the user will be able to create a chat room after clicking on the send message
                                              onPressed: () async {
                                                //*creating a collection
                                                await createChatRoom
                                                    .createChatRoom(
                                                  user.currentUser!
                                                      .displayName!,
                                                  Provider.of<ChatProvider>(
                                                          context,
                                                          listen: false)
                                                      .searchResult1,
                                                );
                                                //* creating a sub collection for chatting
                                                createChatRoom
                                                    .createSubCollection(
                                                  user.currentUser!
                                                      .displayName!,
                                                  Provider.of<ChatProvider>(
                                                          context,
                                                          listen: false)
                                                      .searchResult1,
                                                );

                                                //*closing the search bar
                                                Provider.of<ChatProvider>(
                                                        context,
                                                        listen: false)
                                                    .clipperHeight = 0;
                                              },
                                              icon: Icon(
                                                Icons.group_add_sharp,
                                                color: iconColor,
                                              ),
                                            ),
                                ),
                        ),
                      )
                    : Container(),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
