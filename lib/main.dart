import 'package:chat_app_29_9_2015/provider/chat_provider.dart';

import 'package:chat_app_29_9_2015/screen/main_screen.dart';
import 'package:chat_app_29_9_2015/screen/sign_up.dart';
import 'package:awesome_notifications/awesome_notifications.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:shared_preferences/shared_preferences.dart';

bool? emailb;
Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  AwesomeNotifications().initialize('resource://drawable/res_icon', [
    NotificationChannel(
      channelKey: 'basic_channel',
      channelName: 'Basic Notifications',
      defaultColor: Colors.teal,
      importance: NotificationImportance.High,
      channelShowBadge: true,
    ),
  ]);
  SharedPreferences prefs = await SharedPreferences.getInstance();
  var email = prefs.getString('userEmailSharedPreferences');
  if (email == null) {
    emailb = false;
  } else {
    emailb = true;
  }
  runApp(
    ChangeNotifierProvider(
      create: (context) => ChatProvider(),
      child: const MyApp(),
    ),
  );
} //* This method is to get the user email from sharedPrefernces and check if the val

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        FocusScopeNode currentFocus = FocusScope.of(context);
        if (!currentFocus.hasPrimaryFocus &&
            currentFocus.focusedChild != null) {
          currentFocus.focusedChild!.unfocus();
        }
      },
      child: MaterialApp(
          debugShowCheckedModeBanner: false,
          theme: ThemeData(
            scaffoldBackgroundColor:
                Provider.of<ChatProvider>(context).backGroundColor,
          ),
          home: emailb == false ? const SignUp() : const MainScreen()),
    );
  }
}
