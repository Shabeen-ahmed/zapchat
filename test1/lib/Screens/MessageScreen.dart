// @dart=2.9

import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:firebase_core/firebase_core.dart';

class messagepage extends StatefulWidget {
  @override
  _messagepageState createState() => _messagepageState();
}

class _messagepageState extends State<messagepage> {
  final _auth = FirebaseAuth.instance;
  final _firestore = FirebaseFirestore.instance;
  String messageText;
  User loggedinUser;
  final messageTextController = TextEditingController();

  @override
  void initState() {
    getCurrentUser();
    super.initState();
    print(Timestamp.now());

    // messagestream();
  }

  // void messagestream() async {
  //   await for (var snapshot in _firestore.collection('messages').snapshots()) {
  //     // print(snapshot.docs);
  //     for (var message in snapshot.docs) {
  //       print(message.data());
  //     }
  //   }
  // }

  Future<String> getCurrentUser() async {
    try {
      final user = await _auth.currentUser;
      if (user != null) {
        loggedinUser = user;
      }
    } catch (e) {
      print(e);
    }
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
          appBar: AppBar(
            backgroundColor: Colors.red,
            centerTitle: true,
            title: Text(
              'Zap Chat',
              style: TextStyle(
                color: Colors.white70,
                fontSize: 20,
              ),
            ),
          ),
          body: Column(
            children: [
              StreamBuilder<QuerySnapshot>(
                stream: _firestore
                    .collection('messages')
                    .orderBy('time', descending: false)
                    // .where("sender",isEqualTo: "batman@bat.co")
                    .snapshots(),
                builder: (context, snapshot) {
                  if (!snapshot.hasData) {
                    return Center(
                      child: CircularProgressIndicator(
                        backgroundColor: Colors.red,
                      ),
                    );
                  }
                  final messages = snapshot.data.docs.reversed;
                  List<MessageBubble> messageBubbles = [];
                  for (var message in messages) {
                    final messageText = (message.data() as dynamic)['text'];
                    final messageSender = (message.data() as dynamic)['sender'];

                    final currentUser = loggedinUser.email;

                    final messageBubble = MessageBubble(
                      sender: messageSender,
                      text: messageText,
                      isMe: currentUser == messageSender,
                    );
                    messageBubbles.add(messageBubble);
                  }
                  return Expanded(
                    flex: 9,
                    child: ListView(
                      reverse: true,
                      padding:
                          EdgeInsets.symmetric(horizontal: 10.0, vertical: 20.0),
                      children: messageBubbles,
                    ),
                  );
                },
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Container(
                  height: 50,
                  child : Row(
                    children: [
                    Expanded(
                      flex : 6,
                      child: Padding(
                        padding: const EdgeInsets.all(4.0),
                        child: TextField(
                          textAlignVertical: TextAlignVertical.top,
                        controller: messageTextController,
                        decoration: InputDecoration(
                        border: OutlineInputBorder(
                          gapPadding: 15,
                        borderRadius: BorderRadius.circular(18))),
                        onChanged: (value) {
                        messageText = value;
                        },
                        ),
                      ),
                    ),

                      Expanded(
                        flex:2,
                        child: Container(
                          height: 40,
                          width: 40,
                          decoration: BoxDecoration(
                            color: Colors.redAccent,
                            borderRadius: BorderRadius.circular(18),
                          ),
                          child: GestureDetector(
                              child: Container(
                                child: Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: Text('Send',
                                      textAlign: TextAlign.center,
                                      style: GoogleFonts.poppins(
                                          fontSize: 15, color: Colors.white70)),
                                ),
                              ),
                              onTap: () {
                                messageTextController.clear();
                                _firestore.collection('messages').add({
                                  'time': Timestamp.now(),
                                  'text': messageText,
                                  'sender': loggedinUser.email,
                                });
                              }),
                        ),
                      )

                    ],
                  )


                ),
              ),

            ],
          )),
    );
  }
}

class MessageBubble extends StatelessWidget {
  MessageBubble({this.sender, this.text, this.isMe});

  final String sender;
  final String text;
  final bool isMe;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.all(10.0),
      child: Column(
        crossAxisAlignment:
            isMe ? CrossAxisAlignment.end : CrossAxisAlignment.start,
        children: <Widget>[
          Text(
            sender,
            style: TextStyle(
              fontSize: 12.0,
              color: Colors.black54,
            ),
          ),
          Material(
            borderRadius: isMe
                ? BorderRadius.only(
                    topLeft: Radius.circular(30.0),
                    bottomLeft: Radius.circular(30.0),
                    bottomRight: Radius.circular(30.0))
                : BorderRadius.only(
                    bottomLeft: Radius.circular(30.0),
                    bottomRight: Radius.circular(30.0),
                    topRight: Radius.circular(30.0),
                  ),
            elevation: 5.0,
            color: isMe ? Colors.redAccent : Colors.white,
            child: Padding(
              padding: EdgeInsets.symmetric(vertical: 10.0, horizontal: 20.0),
              child: Text(
                text,
                style: TextStyle(
                  color: isMe ? Colors.white : Colors.black54,
                  fontSize: 15.0,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
