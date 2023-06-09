import 'package:flutter/material.dart';
import 'package:chat_app/shared/constants.dart';
import 'package:chat_app/function/my_function.dart';
import 'package:chat_app/view/Screen/pages/chat_page.dart';

class GroupTile extends StatefulWidget {
  final String userName;
  final String groupName;
  final String groupId;

  const GroupTile(
      {Key? key,
      required this.userName,
      required this.groupName,
      required this.groupId})
      : super(key: key);

  @override
  State<GroupTile> createState() => _GroupTileState();
}

class _GroupTileState extends State<GroupTile> {
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        nextScreen(context, ChatPage(
          groupName: widget.groupName,
          userName: widget.userName,
          groupId: widget.groupId,
        ));
      },
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 5),
        child: ListTile(
          leading: CircleAvatar(
            radius: 30,
            backgroundColor: CustomColors.primaryColor,
            child: Text(widget.groupName.substring(0, 1).toUpperCase(),
                textAlign: TextAlign.center,
                style: const TextStyle(
                    color: CustomColors.primaryBackgroundColor,
                    fontWeight: FontWeight.w500)),
          ),
          title: Text(widget.groupName,
              style: const TextStyle(fontWeight: FontWeight.bold)),
          subtitle: Text("Join The Conversation as ${widget.userName}",
              style: TextStyle(
                  fontSize: 12,
                  color: CustomColors.primaryTextColor.withAlpha(75))),
        ),
      ),
    );
  }
}
