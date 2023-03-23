import 'package:flutter/material.dart';
import 'package:chat_app/shared/constants.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:chat_app/function/my_function.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:chat_app/services/database_service.dart';

class SearchPage extends StatefulWidget {
  const SearchPage({Key? key}) : super(key: key);

  @override
  State<SearchPage> createState() => _SearchPageState();
}

class _SearchPageState extends State<SearchPage> {
  TextEditingController searchController = TextEditingController();
  bool _isLoading = false;
  QuerySnapshot? searchSnapShot;
  bool hasUserSearched = false;
  bool _isJoined = false;
  String userName = "";
  User? user;

  @override
  void initState() {
    getCurrentUserIdAndName();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
            elevation: 0,
            backgroundColor: CustomColors.primaryColor,
            title: const Text(" Search ",
                style: TextStyle(fontSize: 27, fontWeight: FontWeight.bold)),
            centerTitle: true),
        body: Column(
          children: <Widget>[
            Container(
              color: CustomColors.primaryColor,
              padding: const EdgeInsets.only(
                  bottom: 15, left: 10, right: 10, top: 0),
              child: Row(
                children: <Widget>[
                  Expanded(
                      child: TextField(
                    controller: searchController,
                    style: const TextStyle(
                        color: CustomColors.primaryBackgroundColor),
                    decoration: const InputDecoration(
                        border: InputBorder.none,
                        hintText: " Search Groups ..... ",
                        hintStyle: TextStyle(
                            color: CustomColors.primaryBackgroundColor,
                            fontSize: 16)),
                  )),
                  GestureDetector(
                    onTap: () {
                      initiateSearchMethod();
                    },
                    child: Container(
                      width: 40,
                      height: 40,
                      decoration: BoxDecoration(
                          color:
                              CustomColors.primaryBackgroundColor.withAlpha(30),
                          borderRadius: BorderRadius.circular(40)),
                      child: const Icon(Icons.search,
                          color: CustomColors.primaryBackgroundColor),
                    ),
                  )
                ],
              ),
            ),
            _isLoading
                ? const Center(
                    child: CircularProgressIndicator(
                        color: CustomColors.primaryColor))
                : groupList(),
          ],
        ));
  }

  initiateSearchMethod() async {
    if (searchController.text.isNotEmpty) {
      setState(() {
        _isLoading = true;
      });
      await DatabaseService()
          .searchByName(searchController.text)
          .then((snapshot) {
        setState(() {
          searchSnapShot = snapshot;
          _isLoading = false;
          hasUserSearched = true;
        });
      });
    }
  }

  groupList() {
    return hasUserSearched
        ? ListView.builder(
            shrinkWrap: true,
            itemCount: searchSnapShot!.docs.length,
            itemBuilder: (context, index) {
              return groupTile(
                userName,
                searchSnapShot!.docs[index]['groupId'],
                searchSnapShot!.docs[index]['groupName'],
                searchSnapShot!.docs[index]['admin'],
              );
            },
          )
        : Container();
  }

  // function whether user is joined or not
  joinedOrNot(
      String userName, String groupId, String groupName, String admin) async {
    await DatabaseService(uid: user!.uid)
        .isUserJoined(groupName, groupId, userName)
        .then((value) {
      setState(() {
        _isJoined = value;
      });
    });

  }

  Widget groupTile(
      String userName, String groupId, String groupName, String admin) {
    joinedOrNot(userName, groupId, groupName, admin);
    return ListTile(
      contentPadding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
      leading: CircleAvatar(
          backgroundColor: CustomColors.primaryColor,
          radius: 30,
          child: Text(groupName.substring(0, 1).toUpperCase(),
              style: const TextStyle(
                  fontSize: 28,
                  fontWeight: FontWeight.bold,
                  color: CustomColors.primaryBackgroundColor))),
      title:
          Text(groupName, style: const TextStyle(fontWeight: FontWeight.w600)),
      subtitle: Text("Admin :  ${getName(admin)}"),
      trailing: InkWell(
        onTap: () async {
          _isJoined ? null :DatabaseService(uid: user!.uid).joinGroup(groupName, groupId, userName);
        },
        child: _isJoined
            ? Container(
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(10),
                    color: CustomColors.black,
                    border: Border.all(
                        color: CustomColors.white)),
                padding:
                    const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                child: const Text(" Joined ",
                    style: TextStyle(color: CustomColors.white)),
              )
            : Container(
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(10),
                    color: CustomColors.primaryColor),
                padding:
                    const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                child: const Text(" Join ",
                    style: TextStyle(color: CustomColors.white)),
              ),
      ),
    );
  }

  getCurrentUserIdAndName() async {
    await MyFunctions.getUserNameFromSP().then((value) {
      setState(() {
        userName = value!;
      });
    });
    user = FirebaseAuth.instance.currentUser;
  }
}
