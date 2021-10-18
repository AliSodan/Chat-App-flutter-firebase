import 'dart:ui';

import 'package:chat_app_29_9_2015/provider/chat_provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class PopsUp extends StatefulWidget {
  const PopsUp({Key? key}) : super(key: key);
  @override
  _PopsUpState createState() => _PopsUpState();
}

class _PopsUpState extends State<PopsUp> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: Alignment.topCenter,
      child: Hero(
        tag: '${Provider.of<ChatProvider>(context).i}',
        child: Container(
          margin:
              EdgeInsets.only(top: MediaQuery.of(context).size.height * 0.2),
          height: MediaQuery.of(context).size.height * 0.3,
          width: MediaQuery.of(context).size.width * 0.7,
          decoration: BoxDecoration(
            image: DecorationImage(
              fit: BoxFit.cover,
              image: NetworkImage(Provider.of<ChatProvider>(context).heroImage),
            ),
          ),
        ),
      ),
    );
  }
}
