import 'package:chat_app_29_9_2015/provider/chat_provider.dart';
import 'package:chat_app_29_9_2015/screen/search_for_friends.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:provider/provider.dart';

//*  this class contains a method to create a chatroom
class CreateChatRoom {
  FirebaseAuth firebaseUser = FirebaseAuth.instance;
  //! this chat room will be created when the user search for a nother user
  //! and clicks the send message button;
  createChatRoom(
    String user1,
    String user2,
  ) async {
    return await FirebaseFirestore.instance
        .collection('ChatRooms')
        .doc(user1.substring(0, 1).codeUnitAt(0) +
                    user1.substring(1, 2).codeUnitAt(0) +
                    user1.substring(2, 3).codeUnitAt(0) >
                user2.substring(0, 1).codeUnitAt(0) +
                    user2.substring(1, 2).codeUnitAt(0) +
                    user2.substring(2, 3).codeUnitAt(0)
            ? "$user2\_$user1"
            : "$user1\_$user2")
        .set({
      'users': FieldValue.arrayUnion([user1, user2]),
      'ChatRoomId': user1.substring(0, 1).codeUnitAt(0) +
                  user1.substring(1, 2).codeUnitAt(0) +
                  user1.substring(2, 3).codeUnitAt(0) >
              user2.substring(0, 1).codeUnitAt(0) +
                  user2.substring(1, 2).codeUnitAt(0) +
                  user2.substring(2, 3).codeUnitAt(0)
          ? "$user2\_$user1"
          : "$user1\_$user2"
    }, SetOptions(merge: true));
  }

  createSubCollection(String user1, String user2) async {
    return await FirebaseFirestore.instance
        .collection('ChatRooms')
        .doc(user1.substring(0, 1).codeUnitAt(0) +
                    user1.substring(1, 2).codeUnitAt(0) +
                    user1.substring(2, 3).codeUnitAt(0) >
                user2.substring(0, 1).codeUnitAt(0) +
                    user2.substring(1, 2).codeUnitAt(0) +
                    user2.substring(2, 3).codeUnitAt(0)
            ? "$user2\_$user1"
            : "$user1\_$user2")
        .collection('chats');
  }
}
