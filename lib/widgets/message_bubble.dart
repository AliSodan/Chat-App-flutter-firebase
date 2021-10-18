import 'package:chat_app_29_9_2015/provider/chat_provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class MessageBubble extends StatelessWidget {
  MessageBubble({
    Key? key,
    this.bubbleColor,
    this.isMe,
    this.textColor,
    this.content,
  }) : super(key: key);
  Color? textColor;

  Color? bubbleColor;
  bool? isMe;

  String? content;

  double? left;
  double? right;
  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Container(
          width: MediaQuery.of(context).size.width * 1,
          child: Row(
            mainAxisAlignment:
                isMe == true ? MainAxisAlignment.end : MainAxisAlignment.start,
            children: [
              Container(
                height: content!.length > 30
                    ? MediaQuery.of(context).size.height * 0.25
                    : MediaQuery.of(context).size.height * 0.1,
                width: content!.length > 10
                    ? MediaQuery.of(context).size.width * 0.4
                    : MediaQuery.of(context).size.width * 0.3,
                decoration: BoxDecoration(
                    color: isMe == false
                        ? bubbleColor =
                            Provider.of<ChatProvider>(context).mainColor
                        : bubbleColor = Colors.grey[200],
                    borderRadius: BorderRadius.only(
                      topLeft: const Radius.circular(40),
                      topRight: const Radius.circular(40),
                      bottomLeft: Radius.circular(
                        isMe == true ? left = 40 : left = 0,
                      ),
                      bottomRight: Radius.circular(
                          isMe == false ? right = 40 : right = 0),
                    )),
                child: Center(
                    child: Text(
                  content!,
                  style: TextStyle(
                      color: isMe == true
                          ? textColor =
                              Provider.of<ChatProvider>(context).mainColor
                          : textColor = Colors.white,
                      fontWeight: FontWeight.w500),
                )),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
