import 'package:chat_app/function/my_function.dart';
import 'package:chat_app/services/database_service.dart';
import 'package:chat_app/shared/constants.dart';
import 'package:chat_app/view/Screen/pages/group_info.dart';
import 'package:chat_app/view/widget/message_tile.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

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
  TextEditingController controller = TextEditingController();
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
                nextScreen(
                    context,
                    GroupInfo(
                        groupId: widget.groupId,
                        groupName: widget.groupName,
                        adminName: admin));
              })
        ],
      ),
      body: Stack(
        children: <Widget>[
          chatMessage(),
          Container(
            alignment: Alignment.bottomCenter,
            width: MediaQuery.of(context).size.width,
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
              width: MediaQuery.of(context).size.width,
              color: CustomColors.secondaryBackGround.withAlpha(75),
              child: Row(
                children: <Widget>[
                  Expanded(
                      child: TextFormField(
                    controller: controller,
                    style: const TextStyle(
                        color: CustomColors.black, letterSpacing: 1.1),
                    decoration: InputDecoration(
                        hintText: "Write your Message here..",
                        hintStyle:
                            TextStyle(color: CustomColors.black.withAlpha(50), fontSize: 16),
                        border: InputBorder.none),
                  )),
                  const SizedBox(width: 12),
                  GestureDetector(
                    onTap: () {
                      sendMessage();
                    },
                    child: Container(
                      height: 50,
                      width: 50,
                      decoration: BoxDecoration(
                          color: CustomColors.primaryColor,
                          borderRadius: BorderRadius.circular(25)),
                      child: const Icon(Icons.send, color: CustomColors.white),
                    ),
                  )
                ],
              ),
            ),
          )
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

  chatMessage() {
    return StreamBuilder(
        stream: chats,
        builder: (context, AsyncSnapshot snapshot) {
          return snapshot.hasData
              ? ListView.builder(
                  itemCount: snapshot.data.docs.length,
                  itemBuilder: (context, index) {
                    return MessageTile(
                        message: snapshot.data.docs[index]['message'],
                        sender: snapshot.data.docs[index]['sender'],
                        sentByMe: widget.userName ==
                                snapshot.data.docs[index]['sender']);
                  })
              : Container();
        });
  }

  sendMessage() {
    if(controller.text.isNotEmpty){
      Map<String,dynamic> chatMessageMap = {
        "message": controller.text,
        "sender": widget.userName,
        "time": DateTime
            .now()
            .millisecondsSinceEpoch
      };
      DatabaseService().sendMessage(widget.groupId,chatMessageMap);
      controller.clear();
    }
  }
}
