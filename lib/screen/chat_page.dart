import 'package:chat_app/data/message.dart';
import 'package:chat_app/data/passdata.dart';
import 'package:chat_app/widgets/messageBubble.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class ChatPage extends StatefulWidget {
  ChatPage({super.key});

  @override
  State<ChatPage> createState() {
    return _ChatPage();
  }
}

class _ChatPage extends State<ChatPage> {
  CollectionReference messages =
      FirebaseFirestore.instance.collection('messages');
  ScrollController _scrollController = new ScrollController();

  Widget build(context) {
    PassData email = ModalRoute.of(context)!.settings.arguments as PassData;

    return StreamBuilder<QuerySnapshot>(
      stream: messages.orderBy('creatAt', descending: true).snapshots(),
      builder: (context, snapshot) {
        if (snapshot.hasError) {
          return Text("Something went wrong");
        }

        if (!snapshot.hasData) {
          return Text("Document does not exist");
        }

        List<Message> messagesList = [];
        for (int i = 0; i < snapshot.data!.docs.length; i++) {
          if (snapshot.data!.docs[i]['from'] == email.from &&
                  snapshot.data!.docs[i]['to'] == email.to ||
              snapshot.data!.docs[i]['from'] == email.to &&
                  snapshot.data!.docs[i]['to'] == email.from)
            messagesList.add(Message.fromJson(snapshot.data!.docs[i]));
        }
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
                    reverse: true,
                    controller: _scrollController,
                    itemCount: messagesList.length,
                    itemBuilder: (context, index) {
                      final item = messagesList[index];
                      return messageBubble(
                          message: item,
                          isMe: item.from == email.from && item.to == email.to);
                    })),
            Container(
              width: MediaQuery.sizeOf(context).width,
              height: 70,
              padding: EdgeInsets.symmetric(horizontal: 10, vertical: 10),
              child: Container(
                decoration: BoxDecoration(
                    border: Border.all(
                      color: Colors.black54, // Border color
                      width: 2, // Border width
                    ),
                    color: Colors.white30,
                    borderRadius: BorderRadius.circular(20)),
                child: Row(children: [
                  Container(
                    width: 330,
                    height: 50,
                    decoration: BoxDecoration(),
                    padding: EdgeInsets.symmetric(horizontal: 15, vertical: 0),
                    child: TextField(
                      onSubmitted: (data) {
                        print(data);
                        messages.add({
                          'message': data,
                          'creatAt': DateTime.now(),
                          'from': email.from,
                          'to': email.to,
                        });
                        _scrollController.animateTo(0,
                            duration: Duration(milliseconds: 500),
                            curve: Curves.easeIn);
                      },
                      decoration: const InputDecoration(
                        hintText: 'Ecrire votre message',
                        border: InputBorder.none,
                      ),
                    ),
                  ),
                  const Icon(Icons.send, color: Colors.black),
                ]),
              ),
            ),
          ]),
        ));
      },
    );
  }
}
