import 'package:flutter/material.dart';
import 'package:chat_app/shared/constants.dart';
import 'package:chat_app/function/my_function.dart';
import 'package:chat_app/services/auth_service.dart';
import 'package:chat_app/view/Screen/pages/homepage.dart';
import 'package:chat_app/view/Screen/pages/groups_page.dart';

class ProfilePage extends StatefulWidget {
  final String userName;
  final String userEmail;

  const ProfilePage({Key? key, required this.userName, required this.userEmail})
      : super(key: key);

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  AuthService authService = AuthService();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
          backgroundColor: CustomColors.primaryColor,
          elevation: 0,
          title: const Text(" Profile "),
          centerTitle: true),
      drawer: Drawer(
        child: ListView(
          padding: const EdgeInsets.symmetric(vertical: 50, horizontal: 10),
          children: <Widget>[
            Icon(Icons.account_circle,
                size: 120, color: CustomColors.primaryTextColor.withAlpha(20)),
            const SizedBox(height: 10),
            Text(widget.userName,
                style: const TextStyle(
                    fontSize: 20,
                    color: CustomColors.primaryTextColor,
                    fontWeight: FontWeight.bold,
                    height: 1.5),
                textAlign: TextAlign.center),
            const SizedBox(height: 15),
            Divider(
                height: 1, color: CustomColors.primaryTextColor.withAlpha(10)),
            const SizedBox(height: 15),
            ListTile(
              onTap: () {
                nextScreen(context,const GroupsPage());
              },
              contentPadding:
                  const EdgeInsets.symmetric(horizontal: 20, vertical: 5),
              leading:
                  const Icon(Icons.group, color: CustomColors.primaryColor),
              title: const Text(" Groups ",
                  style: TextStyle(color: CustomColors.primaryTextColor)),
            ),
            const SizedBox(height: 370),
            ListTile(
              onTap: () {
                nextScreenReplace(context, const HomePage());
              },
              contentPadding:
                  const EdgeInsets.symmetric(horizontal: 20, vertical: 5),
              leading: const Icon(Icons.exit_to_app,
                  color: CustomColors.primaryColor),
              title: const Text(" Back to Home ",
                  style: TextStyle(color: CustomColors.primaryTextColor)),
            ),
          ],
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal:30, vertical: 30),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: <Widget>[
            Icon(Icons.account_circle,
                size: 180, color: CustomColors.primaryTextColor.withAlpha(40)),
            Divider(
                thickness: 1,
                color: CustomColors.primaryTextColor.withAlpha(10)),
            const SizedBox(height: 15),
            Container(
              padding: const EdgeInsets.symmetric(vertical: 5, horizontal: 15),
              height: 50,
              color: CustomColors.primaryTextColor.withAlpha(5),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  const Text("User name : ",
                      style: TextStyle(color: CustomColors.primaryColor)),
                  Text(widget.userName),
                ],
              ),
            ),
            const SizedBox(height: 20),
            Container(
              padding: const EdgeInsets.symmetric(vertical: 5, horizontal: 15),
              height: 50,
              color: CustomColors.primaryTextColor.withAlpha(5),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  const Text("User E-mail : ",
                      style: TextStyle(color: CustomColors.primaryColor)),
                  SizedBox(width: 200,child: Text(widget.userEmail, softWrap: true)),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
