import 'package:chat_app_29_9_2015/fire_store/create_chat_room.dart';

import 'package:chat_app_29_9_2015/provider/chat_provider.dart';
import 'package:chat_app_29_9_2015/widgets/message_bubble.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'package:intl/intl.dart';

class ConversationScreen extends StatefulWidget {
  const ConversationScreen({Key? key}) : super(key: key);

  @override
  _ConversationScreenState createState() => _ConversationScreenState();
}

class _ConversationScreenState extends State<ConversationScreen> {
  String? sendby;

  //* an instance of firebase auth ;
  FirebaseAuth firebaseAuth = FirebaseAuth.instance;

  //*an instance of firestore ;
  FirebaseFirestore firebaseFirestore = FirebaseFirestore.instance;

//*an instance of create chat room class which contains create chat room method

  CreateChatRoom createChatRoom = CreateChatRoom();
  //*an instance of messageBubble class which is  responsable for showing message bubbles
  MessageBubble messageBubble = MessageBubble();
  bool? iCanSend;
  String photo = '';

  bool? isMe;

  Color? bubbleColor;

  double? left;

  double? right;

  Color? purple = const Color(0xff775fd3);

  Color? white = Colors.white;

  onFieldSubmited() {
    Provider.of<ChatProvider>(context, listen: false).sendMessages.clear();
  }

  @override
  void dispose() {
    finishChatingWith();

    super.dispose();
  }

  @override
  void initState() {
    gettingPhoto();
    isChatingWith();

    super.initState();
  }

//* this method is to update the chating with field in the fireStore
  finishChatingWith() async {
    await FirebaseFirestore.instance
        .collection('users')
        .doc(FirebaseAuth.instance.currentUser!.uid)
        .update(
      {'Chatting with': 'Nobody'},
    );
  }

//* this method is update the value of chating with field in the firestore
  isChatingWith() async {
    await FirebaseFirestore.instance
        .collection('users')
        .doc(FirebaseAuth.instance.currentUser!.uid)
        .set(
      {
        'Chatting with':
            Provider.of<ChatProvider>(context, listen: false).sender
      },
      SetOptions(merge: true),
    );
  }

  @override
  Widget build(BuildContext context) {
    dynamic _height = MediaQuery.of(context).size.height;
    dynamic _width = MediaQuery.of(context).size.width;

    return Scaffold(
      backgroundColor: Provider.of<ChatProvider>(context).backGroundColor,
      appBar: AppBar(
        automaticallyImplyLeading: true,
        title: Row(
          children: [
            photo != ''
                ? CircleAvatar(
                    backgroundImage: NetworkImage(photo),
                  )
                : const CircularProgressIndicator(
                    color: Colors.white,
                    strokeWidth: 1,
                  ),
            SizedBox(
              width: _width * 0.01,
            ),
            Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
              Text(
                Provider.of<ChatProvider>(context).sender,
                style: const TextStyle(color: Colors.white, fontSize: 20),
              ),
              SizedBox(
                height: _height * 0.002,
              ),
              StreamBuilder<QuerySnapshot>(
                stream: FirebaseFirestore.instance
                    .collection('users')
                    .where('name',
                        isEqualTo: Provider.of<ChatProvider>(context).sender)
                    .snapshots(),
                builder: (BuildContext context, snapshot) {
                  if (snapshot.hasData) {
                    return Text(
                      snapshot.data!.docs[0]['last appearance'],
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 13,
                      ),
                    );
                  } else {
                    return Text('hidden appearance');
                  }
                },
              ),
            ]),
          ],
        ),
        backgroundColor: Provider.of<ChatProvider>(context).mainColor,
      ),
      body: SingleChildScrollView(
        child: Container(
          height: _height * 0.9,
          width: _width * 1,
          decoration: BoxDecoration(
            image: DecorationImage(
                image: Provider.of<ChatProvider>(context).darkMood == false
                    ? const AssetImage('assets/images/123.jpg')
                    : const AssetImage('assets/images/darkmode.jpg'),
                fit: BoxFit.fill),
          ),
          child: Container(
            width: MediaQuery.of(context).size.width * 1,
            height: _height * 0.9,
            child: Column(
              crossAxisAlignment: messageBubble.isMe == true
                  ? CrossAxisAlignment.end
                  : CrossAxisAlignment.start,
              children: [
                SizedBox(
                  height: _height * 0.84,
                  width: _width * 1,
                  child: Container(
                    margin: const EdgeInsets.only(right: 10),
                    width: _width * 0.4,
                    child: Provider.of<ChatProvider>(context, listen: false).sender !=
                            ''
                        ? StreamBuilder(
                            stream: firebaseFirestore
                                .collection('ChatRooms')
                                .doc(Provider.of<ChatProvider>(context, listen: false)
                                                .sender
                                                .substring(0, 1)
                                                .codeUnitAt(0) +
                                            Provider.of<ChatProvider>(context, listen: false)
                                                .sender
                                                .substring(1, 2)
                                                .codeUnitAt(0) +
                                            Provider.of<ChatProvider>(context, listen: false)
                                                .sender
                                                .substring(2, 3)
                                                .codeUnitAt(0) >
                                        FirebaseAuth.instance.currentUser!.displayName!
                                                .substring(0, 1)
                                                .codeUnitAt(0) +
                                            FirebaseAuth.instance.currentUser!
                                                .displayName!
                                                .substring(1, 2)
                                                .codeUnitAt(0) +
                                            FirebaseAuth.instance.currentUser!.displayName!.substring(2, 3).codeUnitAt(0)
                                    ? "${FirebaseAuth.instance.currentUser!.displayName}\_${Provider.of<ChatProvider>(context).sender}"
                                    : "${Provider.of<ChatProvider>(context, listen: false).sender}\_${FirebaseAuth.instance.currentUser!.displayName}")
                                .collection('chats')
                                .orderBy('createdAt', descending: true)
                                .snapshots(),
                            builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
                              if (snapshot.hasData) {
                                return SizedBox(
                                  width: _width * 1,
                                  child: ListView.builder(
                                      padding: const EdgeInsets.all(15),
                                      shrinkWrap: true,
                                      reverse: true,
                                      itemCount: snapshot.data!.docs.length,
                                      itemBuilder: (context, i) {
                                        return Container(
                                          margin: EdgeInsets.only(
                                              top: _height * 0.01),
                                          child: MessageBubble(
                                            isMe: snapshot.data!.docs[i]
                                                        ['send by'] ==
                                                    firebaseAuth.currentUser!
                                                        .displayName
                                                ? isMe = true
                                                : isMe = false,
                                            content: snapshot
                                                .data!.docs[i]['Message']
                                                .toString(),
                                          ),
                                        );
                                      }),
                                );
                              } else {
                                return const Center(
                                  child: CircularProgressIndicator(),
                                );
                              }
                            })
                        : const Center(child: CircularProgressIndicator()),
                  ),
                ),
                Row(
                  children: [
                    Container(
                      width: _width * 0.83,
                      margin: EdgeInsets.only(left: _width * 0.03),
                      padding: EdgeInsets.only(
                          left: _width * 0.03, right: _width * 0.03),
                      child: TextFormField(
                        controller:
                            Provider.of<ChatProvider>(context).sendMessages,
                        style: TextStyle(
                            color:
                                Provider.of<ChatProvider>(context).darkMood ==
                                        true
                                    ? Colors.white
                                    : const Color(0xff775fd3)),
                        textInputAction: TextInputAction.newline,
                        decoration: const InputDecoration(
                          hintText: ' Message ...',
                          border: InputBorder.none,
                          focusedBorder: InputBorder.none,
                          enabledBorder: InputBorder.none,
                          errorBorder: InputBorder.none,
                          disabledBorder: InputBorder.none,
                        ),
                        onChanged: (val) {
                          val.isEmpty || val == null || val == ''
                              ? setState(() {
                                  iCanSend = false;
                                })
                              : setState(() {
                                  iCanSend = true;
                                });
                        },
                      ),
                      decoration: BoxDecoration(
                        color:
                            Provider.of<ChatProvider>(context).darkMood == true
                                ? const Color(0xff5d7274)
                                : Colors.white,
                        borderRadius: const BorderRadius.all(
                          Radius.circular(30),
                        ),
                      ),
                    ),
                    SizedBox(
                      width: _width * 0.01,
                    ),
                    CircleAvatar(
                      radius: 25,
                      backgroundColor:
                          Provider.of<ChatProvider>(context).mainColor,
                      child: Center(
                        child: IconButton(
                          onPressed: () async {
                            iCanSend == true
                                ? await FirebaseFirestore.instance
                                    .collection('ChatRooms')
                                    .doc(Provider.of<ChatProvider>(context, listen: false)
                                                    .sender
                                                    .substring(0, 1)
                                                    .codeUnitAt(0) +
                                                Provider.of<ChatProvider>(context, listen: false)
                                                    .sender
                                                    .substring(1, 2)
                                                    .codeUnitAt(0) +
                                                Provider.of<ChatProvider>(
                                                        context,
                                                        listen: false)
                                                    .sender
                                                    .substring(2, 3)
                                                    .codeUnitAt(0) >
                                            FirebaseAuth.instance.currentUser!
                                                    .displayName!
                                                    .substring(0, 1)
                                                    .codeUnitAt(0) +
                                                FirebaseAuth.instance
                                                    .currentUser!.displayName!
                                                    .substring(1, 2)
                                                    .codeUnitAt(0) +
                                                FirebaseAuth.instance
                                                    .currentUser!.displayName!
                                                    .substring(2, 3)
                                                    .codeUnitAt(0)
                                        ? "${FirebaseAuth.instance.currentUser!.displayName}\_${Provider.of<ChatProvider>(context, listen: false).sender}"
                                        : "${Provider.of<ChatProvider>(context, listen: false).sender}\_${FirebaseAuth.instance.currentUser!.displayName}")
                                    .collection('chats')
                                    .add({
                                    'Message': Provider.of<ChatProvider>(
                                            context,
                                            listen: false)
                                        .sendMessages
                                        .text,
                                    'send by':
                                        firebaseAuth.currentUser!.displayName,
                                    'createdAt': Timestamp.now(),
                                    'specificDate':
                                        DateFormat('hh:mm a').format(
                                      DateTime.now(),
                                    ),
                                  })
                                : null;

                            onFieldSubmited();
                          },
                          icon: Icon(
                            Icons.send,
                            color:
                                iCanSend == true ? Colors.white : Colors.grey,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

//*  this method is to get the user photo from fire store
  gettingPhoto() async {
    return await FirebaseFirestore.instance
        .collection('users')
        .where('name',
            isEqualTo: Provider.of<ChatProvider>(context, listen: false).sender)
        .get()
        .then(
          (value) => value.docs.forEach(
            (element) {
              setState(
                () {
                  photo = element.data()['photo'];
                },
              );
            },
          ),
        );
  }
}
