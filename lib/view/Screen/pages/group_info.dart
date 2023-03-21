import 'package:chat_app/services/database_service.dart';
import 'package:chat_app/shared/constants.dart';
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
  Stream? members;

  // @override
  // void initState() {
  //   getMembers();
  //   super.initState();
  // }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: CustomColors.primaryColor,
        title: const Text(' Group Info. '),
        centerTitle: true,
        actions: [
          IconButton(
              onPressed: () {}, icon: const Icon(Icons.exit_to_app_sharp))
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
                mainAxisAlignment: MainAxisAlignment.start,
                children: <Widget>[
                  CircleAvatar(
                      backgroundColor: CustomColors.primaryColor,
                      radius: 30,
                      child: Text(
                          widget.groupName.substring(0, 1).toUpperCase(),
                          style: const TextStyle(
                              fontWeight: FontWeight.w500,
                              color: CustomColors.primaryBackgroundColor))),
                  const SizedBox(width: 20),
                  Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: <Widget>[
                        Text("Group:  ${widget.groupName}",
                            style:
                                const TextStyle(fontWeight: FontWeight.bold)),
                        const SizedBox(height: 5),
                        Text("Admin:  ${widget.adminName}",
                            style: const TextStyle(fontSize: 12)),
                      ])
                ]),
          ),
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
        members = value;
      });
    });
  }

  memberList() {
    return StreamBuilder(
        stream: members,
        builder: (context, AsyncSnapshot snapshot) {
          if (snapshot.hasData) {
            if (snapshot.data['members'] != null) {
              if (snapshot.data['members'].legnth != 0) {
                return ListView.builder(
                    itemCount: snapshot.data['members'].length,
                    shrinkWrap: true,
                    itemBuilder: (context, index) {
                      return Container(
                        padding: const EdgeInsets.symmetric(
                            vertical: 10, horizontal: 5),
                        child: ListTile(
                          leading: CircleAvatar(
                              backgroundColor: CustomColors.primaryColor,
                              radius: 30,
                              child: Text(
                                  widget.groupName
                                      .substring(0, 1)
                                      .toUpperCase(),
                                  style: const TextStyle(
                                      fontWeight: FontWeight.w500,
                                      color: CustomColors
                                          .primaryBackgroundColor))),
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
        });
  }
}
