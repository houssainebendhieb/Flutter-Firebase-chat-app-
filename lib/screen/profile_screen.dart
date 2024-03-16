import 'package:chat_app/data/passdata.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:chat_app/data/user.dart';

class ProfileScreen extends StatefulWidget {
  ProfileScreen({super.key});

  State<ProfileScreen> createState() {
    return _ProfileScreen();
  }
}

class _ProfileScreen extends State<ProfileScreen> {
  Widget build(context) {
    String myMail = ModalRoute.of(context)!.settings.arguments as String;
    CollectionReference users = FirebaseFirestore.instance.collection('user');
    return StreamBuilder<QuerySnapshot>(
      stream: users.snapshots(),
      builder: (context, snapshot) {
        if (snapshot.hasError) {
          return Text("Something went wrong");
        }
        if (!snapshot.hasData) {
          return Text("Document does not exist");
        }
        List<Users> userList = [];
        for (int i = 0; i < snapshot.data!.docs.length; i++) {
          if (snapshot.data!.docs[i]["email"] != myMail)
            userList.add(Users(snapshot.data!.docs[i]["email"],
                snapshot.data!.docs[i]["password"]));
        }
        print(userList[0]);
        return SafeArea(
            child: Scaffold(
          appBar: AppBar(
            backgroundColor: const Color.fromARGB(255, 0, 57, 104),
            title: const Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(
                  Icons.message,
                  color: Colors.white,
                ),
                Text(
                  'Chat',
                  style: TextStyle(color: Colors.white, fontSize: 19),
                )
              ],
            ),
          ),
          body: Column(children: [
            Expanded(
                child: ListView.builder(
                    itemCount: userList.length,
                    itemBuilder: (context, index) {
                      final item = userList[index];
                      return ListTile(
                        title: new Text(item.email),
                        onTap: () {
                          Navigator.pushNamed(context, 'chatApp',
                              arguments: PassData(myMail, item.email));
                        },
                      );
                    })),
          ]),
        ));
      },
    );
  }
}
