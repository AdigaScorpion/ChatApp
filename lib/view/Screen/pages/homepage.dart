import 'package:chat_app/function/my_function.dart';
import 'package:chat_app/services/auth_service.dart';
import 'package:chat_app/services/database_service.dart';
import 'package:chat_app/shared/constants.dart';
import 'package:chat_app/view/Screen/pages/auth/login_page.dart';
import 'package:chat_app/view/Screen/pages/groups_page.dart';
import 'package:chat_app/view/Screen/pages/profile_page.dart';
import 'package:chat_app/view/Screen/pages/search_page.dart';
import 'package:chat_app/view/widget/group_tile.dart';
import 'package:chat_app/view/widget/text_input_decoration.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  AuthService authService = AuthService();
  String userName = "";
  String email = "";
  Stream? groups;
  bool isLoading = false;
  String groupName = "";

  @override
  void initState() {
    getUserData();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
          elevation: 0,
          backgroundColor: Theme.of(context).primaryColor,
          centerTitle: true,
          title: const Text(" Groups ",
              style: TextStyle(fontSize: 30, fontWeight: FontWeight.bold)),
          actions: [
            IconButton(
                onPressed: () {
                  nextScreen(context, const SearchPage());
                },
                icon: const Icon(Icons.search))
          ]),
      drawer: Drawer(
        child: ListView(
          padding: const EdgeInsets.symmetric(vertical: 50, horizontal: 10),
          children: <Widget>[
            Icon(Icons.account_circle,
                size: 120, color: CustomColors.primaryTextColor.withAlpha(50)),
            const SizedBox(height: 5),
            Text(userName,
                style: const TextStyle(
                    fontSize: 25,
                    color: CustomColors.primaryTextColor,
                    fontWeight: FontWeight.bold,
                    height: 1.5),
                textAlign: TextAlign.center),
            Divider(
                height: 1, color: CustomColors.primaryTextColor.withAlpha(10)),
            const SizedBox(height: 10),
            ListTile(
              onTap: () {
                nextScreen(context, const GroupsPage());
              },
              contentPadding:
                  const EdgeInsets.symmetric(horizontal: 20, vertical: 5),
              leading:
                  const Icon(Icons.group, color: CustomColors.primaryColor),
              title: const Text(" Groups ",
                  style: TextStyle(color: CustomColors.primaryTextColor)),
            ),
            const SizedBox(height: 5),
            ListTile(
              onTap: () {
                nextScreen(context, ProfilePage(userName: userName, userEmail: email));
              },
              contentPadding:
                  const EdgeInsets.symmetric(horizontal: 20, vertical: 5),
              leading:
                  const Icon(Icons.person, color: CustomColors.primaryColor),
              title: const Text(" Profile ",
                  style: TextStyle(color: CustomColors.primaryTextColor)),
            ),
            const SizedBox(height: 120),
            ListTile(
              onTap: () async {
                showDialog(
                    barrierDismissible: false,
                    context: context,
                    builder: (context) {
                      return AlertDialog(
                        title: const Text(" Log Out "),
                        content:
                            const Text(" Are you sure you want to log out? "),
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
                              await authService.signOut().whenComplete(() {
                                nextScreenReplace(context, const LoginPage());
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
              contentPadding:
                  const EdgeInsets.symmetric(horizontal: 20, vertical: 5),
              leading: const Icon(Icons.exit_to_app,
                  color: CustomColors.primaryColor),
              title: const Text(" Log out ",
                  style: TextStyle(color: CustomColors.primaryTextColor)),
            ),
          ],
        ),
      ),
      body: groupList(),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          popUpDialog(context);
        },
        elevation: 0,
        backgroundColor: CustomColors.primaryColor,
        child: const Icon(Icons.add, size: 40),
      ),
    );
  }

  getUserData() async {
    await MyFunctions.getUserNameFromSP().then((value) {
      setState(() {
        userName = value!;
      });
    });
    await MyFunctions.getUserEmailFromSP().then((value) {
      setState(() {
        email = value!;
      });
    });
    // getting the list of snapshots in our stream
    await DatabaseService(uid: FirebaseAuth.instance.currentUser!.uid)
        .getUserGroup()
        .then((snapshot) {
      setState(() {
        groups = snapshot;
      });
    });
  }

  groupList() {
    return StreamBuilder(
      stream: groups,
      builder: (context, AsyncSnapshot snapshot) {
        //   make some checks
        if (snapshot.hasData) {
          if (snapshot.data['groups'] != null) {
            if (snapshot.data['groups'].length != 0) {
              return ListView.builder(
                  itemCount: snapshot.data['groups'].length,
                  itemBuilder: (context, index) {
                    return GroupTile(
                      userName: snapshot.data['fullName'],
                      groupName: getName(snapshot.data['groups'][index]),
                      groupId: getId(snapshot.data['groups'][index]),
                    );
                  });
            } else {
              return noGroupWidget();
            }
          } else {
            return noGroupWidget();
          }
        } else {
          return const Center(
              child:
                  CircularProgressIndicator(color: CustomColors.primaryColor));
        }
      },
    );
  }

  popUpDialog(BuildContext context) {
    showDialog(
        barrierDismissible: false,
        context: context,
        builder: (context) {
          return AlertDialog(
            title: const Text(" Create Group ",
                style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: CustomColors.primaryTextColor)),
            content: Column(
              mainAxisSize: MainAxisSize.min,
              children: <Widget>[
                isLoading == true
                    ? const Center(
                        child: CircularProgressIndicator(
                            color: CustomColors.primaryColor))
                    : TextField(
                        decoration: textInputDecoration,
                        onChanged: (val) {
                          setState(() {
                            groupName = val;
                          });
                        },
                      ),
              ],
            ),
            actions: [
              IconButton(
                  onPressed: () {
                    Navigator.pop(context);
                  },
                  icon: Icon(Icons.cancel_sharp,
                      color: CustomColors.primaryTextColor.withAlpha(50)),
                  highlightColor: CustomColors.primaryColor),
              const SizedBox(width: 15),
              IconButton(
                  onPressed: () async {
                    if (groupName.isNotEmpty) {
                      setState(() {
                        isLoading = true;
                      });
                      DatabaseService(
                              uid: FirebaseAuth.instance.currentUser!.uid)
                          .createGroup(userName,
                              FirebaseAuth.instance.currentUser!.uid, groupName)
                          .whenComplete(() {
                        isLoading = false;
                      });
                      nextScreenReplace(context,const HomePage());
                      showSnackBar(context, Colors.green.withAlpha(100),
                          " Group Created Successfully");
                    } else {
                      showSnackBar(context, Colors.red.withAlpha(100),
                          "Group Name Can Not Be Empty");
                    }
                  },
                  icon: const Icon(Icons.done_sharp),
                  color: CustomColors.primaryTextColor.withAlpha(50),
                  highlightColor: CustomColors.primaryColor)
            ],
          );
        });
  }

  noGroupWidget() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 25),
      child: Center(
        child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: <Widget>[
              GestureDetector(
                  onTap: () {
                    popUpDialog(context);
                  },
                  child: const Icon(Icons.add_circle,
                      color: CustomColors.primaryColor, size: 75)),
              const Text(
                  " Create a Group or search for groups \n to chat with friends ",
                  style: TextStyle(
                    fontSize: 18,
                    color: CustomColors.primaryTextColor,
                  ),
                  textAlign: TextAlign.center)
            ]),
      ),
    );
  }
}
