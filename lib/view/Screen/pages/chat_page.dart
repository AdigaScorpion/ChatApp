import 'package:get/get.dart';
import 'package:flutter/material.dart';
import 'package:chat_app/shared/constants.dart';
import 'package:chat_app/function/my_function.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:chat_app/services/database_service.dart';
import 'package:chat_app/view/Screen/pages/group_info.dart';

class ChatPage extends StatefulWidget {
  final String groupId;
  final String groupName;
  final String userName;

  const ChatPage(
      {Key? key,
      required this.groupId,
      required this.groupName,
      required this.userName})
      : super(key: key);

  @override
  State<ChatPage> createState() => _ChatPageState();
}

class _ChatPageState extends State<ChatPage> {
  String admin = "";
  Stream<QuerySnapshot>? chats;

  @override
  void initState() {
    getChatAndAdmin();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: CustomColors.primaryColor,
        title: Text(widget.groupName),
        centerTitle: true,
        actions: [
          IconButton(
              icon: const Icon(Icons.info),
              onPressed: () {
                Get.to(() => GroupInfo(
                    groupId: widget.groupId,
                    groupName: widget.groupName,
                    adminName: admin));
              })
        ],
      ),
    );
  }

  getChatAndAdmin() {
    DatabaseService().getGroupAdmin(widget.groupId).then((value) {
      setState(() {
        admin = getName(value);
      });
    });
    DatabaseService().getChat(widget.groupId).then((value) {
      setState(() {
        chats = value;
      });
    });
  }
}
