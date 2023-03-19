import 'package:chat_app/function/my_function.dart';
import 'package:chat_app/services/auth_service.dart';
import 'package:chat_app/shared/constants.dart';
import 'package:chat_app/view/Screen/pages/groups_Page.dart';
import 'package:chat_app/view/Screen/pages/auth/login_page.dart';
import 'package:chat_app/view/Screen/pages/profile_page.dart';
import 'package:chat_app/view/Screen/pages/search_page.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  AuthService authService = AuthService();
  String userName = "";
  String email = "";

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
          title: const Text("Groups",
              style: TextStyle(fontSize: 30, fontWeight: FontWeight.bold)),
          actions: [
            IconButton(
                onPressed: () {
                  Get.to(const SearchPage());
                },
                icon: const Icon(Icons.search))
          ]),
      drawer: Drawer(
        child: ListView(
          padding: const EdgeInsets.symmetric(vertical: 50, horizontal: 10),
          children: <Widget>[
            Icon(Icons.account_circle,
                size: 120, color: CustomColors.primaryTextColor.withAlpha(100)),
            const SizedBox(height: 10),
            Text(userName,
                style: const TextStyle(
                    fontSize: 20,
                    color: CustomColors.primaryTextColor,
                    fontWeight: FontWeight.bold,
                    height: 1.5),
                textAlign: TextAlign.center),
            const SizedBox(height: 15),
            Divider(
                height: 2, color: CustomColors.primaryTextColor.withAlpha(30)),
            const SizedBox(height: 15),
            ListTile(
                onTap: () {
                  Get.to(const GroupsPage());
                },
                contentPadding:
                    const EdgeInsets.symmetric(horizontal: 20, vertical: 5),
                leading: const Icon(Icons.group),
                title: const Text(" Groups ",
                    style: TextStyle(color: CustomColors.primaryTextColor)),
              ),
            ListTile(
                onTap: () {
                  Get.to(const ProfilePage());
                },
                contentPadding:
                    const EdgeInsets.symmetric(horizontal: 20, vertical: 5),
                leading: const Icon(Icons.person),
                title: const Text(" Profile ",
                    style: TextStyle(color: CustomColors.primaryTextColor)),
              ),
            const SizedBox(height: 400),
            ListTile(

                onTap: () {
                  authService.signOut().whenComplete(() {
                    Get.offAll(const LoginPage());
                  });
                },
                contentPadding:
                    const EdgeInsets.symmetric(horizontal: 20, vertical: 5),
                leading: const Icon(Icons.exit_to_app),
                title: const Text(" Log out ",
                    style: TextStyle(color: CustomColors.primaryTextColor)),
              ),
          ],
        ),
      ),
      body: const Center(
        child: Text("HomePage"),
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
  }
}
