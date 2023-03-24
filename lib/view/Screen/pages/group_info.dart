import 'package:chat_app/function/my_function.dart';
import 'package:chat_app/services/auth_service.dart';
import 'package:chat_app/services/database_service.dart';
import 'package:chat_app/shared/constants.dart';
import 'package:chat_app/view/Screen/pages/homepage.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class GroupInfo extends StatefulWidget {
  final String groupId;
  final String groupName;
  final String adminName;

  const GroupInfo(
      {Key? key,
      required this.groupId,
      required this.groupName,
      required this.adminName})
      : super(key: key);

  @override
  State<GroupInfo> createState() => _GroupInfoState();
}

class _GroupInfoState extends State<GroupInfo> {
  AuthService authService = AuthService();
  Stream? member;

  @override
  void initState() {
    getMembers();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: CustomColors.primaryColor,
        title: const Text(' Group Info. '),
        centerTitle: true,
        actions: [
          IconButton(
              onPressed: () {
                showDialog(
                    barrierDismissible: false,
                    context: context,
                    builder: (context) {
                      return AlertDialog(
                        title: const Text(" Exit Group "),
                        content: const Text(" Are you sure? "),
                        actions: [
                          IconButton(
                            highlightColor: CustomColors.primaryColor,
                            onPressed: () {
                              Navigator.pop(context);
                            },
                            icon: Icon(
                              Icons.cancel_sharp,
                              color:
                                  CustomColors.primaryTextColor.withAlpha(50),
                            ),
                          ),
                          const SizedBox(width: 15),
                          IconButton(
                            highlightColor: CustomColors.primaryColor,
                            onPressed: () async {
                              await DatabaseService(uid: FirebaseAuth.instance.currentUser!.uid)
                                  .exitGroup(widget.groupName, widget.groupId,
                                  FirebaseAuth.instance.currentUser.toString())
                                  .whenComplete(() {
                                nextScreenReplace(context, const HomePage());
                              });
                            },
                            icon: Icon(
                              Icons.exit_to_app_sharp,
                              color:
                                  CustomColors.primaryTextColor.withAlpha(50),
                            ),
                          ),
                        ],
                      );
                    });
              },
              icon: const Icon(Icons.exit_to_app_sharp))
        ],
      ),
      body: Container(
        padding: const EdgeInsets.all(20),
        child: Column(mainAxisAlignment: MainAxisAlignment.start, children: [
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(20),
              color: CustomColors.primaryColor.withOpacity(0.1),
            ),
            child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  CircleAvatar(
                      backgroundColor: CustomColors.primaryColor,
                      radius: 30,
                      child: Text(
                          widget.groupName.substring(0, 1).toUpperCase(),
                          style: const TextStyle(
                              fontSize: 28,
                              fontWeight: FontWeight.bold,
                              color: CustomColors.primaryBackgroundColor))),
                  const SizedBox(width: 20),
                  Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        Text("Group:  ${widget.groupName}",
                            style:
                                const TextStyle(fontWeight: FontWeight.bold)),
                        // const SizedBox(height: 5),
                        // Text("Admin:  ${widget.adminName}",
                        //     style: const TextStyle(fontSize: 12)),
                      ])
                ]),
          ),
          const SizedBox(height: 10),
          memberList(),
        ]),
      ),
    );
  }

  getMembers() async {
    DatabaseService(uid: FirebaseAuth.instance.currentUser!.uid)
        .getGroupMembers(widget.groupId)
        .then((value) {
      setState(() {
        member = value;
      });
    });
  }

  memberList() {
    return Container(
      padding: const EdgeInsets.all(10),
      decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(20),
          color: CustomColors.primaryColor.withAlpha(10)),
      child: StreamBuilder(
          stream: member,
          builder: (context, AsyncSnapshot snapshot) {
            if (snapshot.hasData) {
              if (snapshot.data['member'] != null) {
                if (snapshot.data['member'].length != 0) {
                  return ListView.builder(
                      itemCount: snapshot.data['member'].length,
                      shrinkWrap: true,
                      itemBuilder: (context, index) {
                        return Container(
                          padding: const EdgeInsets.symmetric(
                              vertical: 10, horizontal: 5),
                          child: ListTile(
                            leading: CircleAvatar(
                                backgroundColor: CustomColors.primaryColor,
                                radius: 25,
                                child: Text(
                                    getName(snapshot.data['member'][index])
                                        .substring(0, 1)
                                        .toUpperCase(),
                                    style: const TextStyle(
                                        fontWeight: FontWeight.w500,
                                        color: CustomColors
                                            .primaryBackgroundColor))),
                            title:
                                Text(getName(snapshot.data['member'][index])),
                            trailing:
                                (getName(snapshot.data['member'][index]) ==
                                        (widget.adminName)
                                    ? Text('admin',
                                        style: TextStyle(
                                            fontSize: 12,
                                            color: CustomColors.primaryTextColor
                                                .withAlpha(75)))
                                    : null),
                          ),
                        );
                      });
                } else {
                  return const Center(child: Text(' No Members '));
                }
              } else {
                return const Center(child: Text(' No Members '));
              }
            } else {
              return const Center(
                  child: CircularProgressIndicator(
                      color: CustomColors.primaryColor));
            }
          }),
    );
  }
}
