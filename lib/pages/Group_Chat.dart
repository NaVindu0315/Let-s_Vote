import 'package:flutter/material.dart';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:lets_vote/Colors/colors.dart';

import '../Colors/constants.dart';

late User loggedinuser;

class GroupChat extends StatefulWidget {
  static String id = 'chat_screen';
  @override
  _GroupChatState createState() => _GroupChatState();
}

class _GroupChatState extends State<GroupChat> {
  DateTime timestamp = DateTime.now();

  final messageTextController = TextEditingController();
  late var senttext;
  late var sentuser;
  final _firestore = FirebaseFirestore.instance;
  final _auth = FirebaseAuth.instance;
  //going to cutout loged in user
  //late User loggedinuser;
  late String messagetext;
  @override
  void initState() {
    super.initState();
    getcurrentuser();
  }

  void getcurrentuser() async {
    try {
      // final user = await _auth.currentUser();
      ///yata line eka chatgpt code ekk meka gatte uda line eke error ekk ena hinda hrytama scene eka terenne na
      User? user = FirebaseAuth.instance.currentUser;
      if (user != null) {
        loggedinuser = user;
        print(loggedinuser.email);
      }
    } catch (e) {
      print(e);
    }
  }

/*
  void getmesssages() async {
    ///angela's
    /*
    final messages = await _firestore.collection('messsages').get();
    for (var message in messages.docs) {
      print(message.data);
    }
*/
    ///angel's end
    ///
    ///chatgpt mycode
    ///this code works just fine
    _firestore.collection('messages').get().then((querySnapshot) {
      querySnapshot.docs.forEach((doc) {
        senttext = doc['text'];
        sentuser = doc['sender'];
        print(senttext);
        print(sentuser);
      });
    });

    ///chtgpt mycode end
  }
*/
  ///msg streaming method begin
  ///with the chatgpt code this works

  void messagesstream() async {
    await for (var snapeshot
        in _firestore.collection('messages').orderBy('timestamp').snapshots()) {
      for (var doc in snapeshot.docs) {
        var data = doc.data();

        print(data);
      }
    }
  }

  ///msg streaming method end

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.purple.shade50,
      appBar: AppBar(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.only(
            bottomLeft: Radius.circular(30.0),
            bottomRight: Radius.circular(30.0),
          ),
        ),
        leading: null,
        actions: <Widget>[
          IconButton(
              icon: Icon(
                Icons.logout_outlined,
                color: Colors.white,
              ),
              onPressed: () {
                _auth.signOut();
                Navigator.pop(context);

                //Implement logout functionality
              }),
        ],
        title: Text(
          '    Group Chat',
          style: TextStyle(
              fontSize: 30.0, fontWeight: FontWeight.bold, color: Colors.white),
        ),
        backgroundColor: AppColors.backgroundcolor,
      ),
      body: SafeArea(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: <Widget>[
            ///chatgpt code
            ///this is workingg
            StreamBuilder<QuerySnapshot>(
              stream: _firestore
                  .collection('messages')
                  .orderBy('timestamp')
                  .snapshots(),
              builder: (context, snapshot) {
                if (snapshot.hasData) {
                  //below is the chatgpt code
                  /*     final messages =
                      snapshot.data!.docs.map((doc) => doc.data()).toList();
                  messages
                      .sort((a, b) => a!['timestamp']??.compareTo(b['timestamp']));*/
                  //below is the working code going to comment try chatgpt code
                  ///my working code begin
                  //ccfinal messages = snapshot.data!.docs.toList();
                  ///onelast try
                  //final messages = snapshot.data!.docs;
                  final messages = snapshot.data!.docs.reversed;

/*
                  List<messagebuble> messagebubbless = [];
                  for (var message in messages) {
                    final messageText = message['text'];
                    final messageSender = message['sender'];
                    final currentuser = loggedinuser.email;

                    final messagebube = messagebuble(
                      mtext: messageText,
                      msender: messageSender,
                      isme: currentuser == messageSender,
                    );
                    messagebubbless.insert(0, messagebube);
                  }*/

                  ///my working code end

                  ///chat gpt code begin
                  //final messages = snapshot.data!.docs.reversed;
                  List<messagebuble> messageBubbles = [];
                  for (var message in messages) {
                    final messageText = message['text'];
                    final messageSender = message['sender'];
                    //   final time = message['timestamp'].toString();
                    final currentUser = loggedinuser.email;

                    final messageBubble = messagebuble(
                      msender: messageSender,
                      mtext: messageText,
                      isme: currentUser == messageSender,
                      //time: time,
                    );

                    messageBubbles.add(messageBubble);
                  }

                  ///chatgpt code end

                  return Expanded(
                    child: ListView(
                      reverse: true,
                      padding: EdgeInsets.symmetric(
                          horizontal: 10.0, vertical: 20.0),
                      children: messageBubbles,
                    ),
                  );
                } else if (snapshot.hasError) {
                  return Text('Error fetching messages');
                } else {
                  return Center(
                    child: CircularProgressIndicator(),
                  );
                }
              },
            ),

            ///chat gpt code end
            ///angels code begin
            /*
            StreamBuilder(
                stream: _firestore.collection('messages').snapshots(),
                builder: (context, snapshot) {
                  if (snapshot.hasData) {
                    final messages = snapshot.data?.docs;
                    List<Text> messagewidgets = [];
                    for (var message in messages!) {
                      final messagetext = message.data['text'];
                      final messagesender = message.data['sender'];
                      final messagewidget =
                          Text('$messagetext from $messagesender');
                      messagewidgets.add(messagewidget);
                    }
                    return Column(
                      children: messagewidgets,
                    );
                  }
                }),
            */
            ///angels code end
            Container(
              decoration: kMessageContainerDecoration,
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: <Widget>[
                  Expanded(
                    child: TextField(
                      controller: messageTextController,
                      onChanged: (value) {
                        messagetext = value;
                        //Do something with the user input.
                      },
                      decoration: kMessageTextFieldDecoration.copyWith(),
                    ),
                  ),
                  TextButton(
                    onPressed: () {
                      _firestore.collection('messages').add({
                        'text': messagetext,
                        'sender': loggedinuser.email,
                        'timestamp': FieldValue.serverTimestamp(),
                      });
                      messageTextController.clear();
                      //Implement send functionality.
                    },
                    child: Text(
                      'Send',
                      style: kSendButtonTextStyle,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class messagebuble extends StatelessWidget {
  messagebuble({
    required this.mtext,
    required this.msender,
    required this.isme,
  });
  final String msender;
  final String mtext;
  final bool isme;
  //final String time;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.all(10.0),
      child: Column(
        crossAxisAlignment:
            isme ? CrossAxisAlignment.end : CrossAxisAlignment.start,
        children: [
          Text(
            msender,
            style: TextStyle(
              fontSize: 11.0,
              color: Colors.black54,
            ),
          ),
          Material(
            elevation: 5.0,
            borderRadius: isme
                ? BorderRadius.only(
                    topLeft: Radius.circular(30.0),
                    bottomLeft: Radius.circular(30.0),
                    bottomRight: Radius.circular(30.0))
                : BorderRadius.only(
                    topRight: Radius.circular(30.0),
                    bottomLeft: Radius.circular(30.0),
                    bottomRight: Radius.circular(30.0)),
            color: isme ? kSenderChatBubbleColor : kReceiverChatBubbleColor,
            child: Padding(
              padding: EdgeInsets.symmetric(vertical: 10.0, horizontal: 20.0),
              child: Text(
                '$mtext ',

                ///adding style to text field
                style: TextStyle(
                  color: isme ? Colors.white : Colors.black,
                  fontWeight: FontWeight.bold,
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

/////////////////////////////////////////////
/*

final _firestore = FirebaseFirestore.instance;
late User loggedInUser;

class ChatScreen extends StatefulWidget {
  static const String id = 'chat_screen';
  @override
  _ChatScreenState createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  final messageTextController = TextEditingController();
  final _auth = FirebaseAuth.instance;

  String messageText = '';

  @override
  void initState() {
    super.initState();
    getCurrentUser();
  }

  void getCurrentUser() async {
    try {
      final user = _auth.currentUser;
      if (user != null) {
        loggedInUser = user;
      }
    } catch (e) {
      print(e);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: null,
        actions: <Widget>[
          IconButton(
            icon: Icon(Icons.close),
            onPressed: () {
              _auth.signOut();
              Navigator.pop(context);
            },
          ),
        ],
        title: Text('⚡️Chat'),
        backgroundColor: Colors.lightBlueAccent,
      ),
      body: SafeArea(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: <Widget>[
            Expanded(
              child: MessagesStream(),
            ),
            Container(
              decoration: kMessageContainerDecoration,
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: <Widget>[
                  Expanded(
                    child: TextField(
                      controller: messageTextController,
                      onChanged: (value) {
                        messageText = value;
                      },
                      decoration: kMessageTextFieldDecoration,
                    ),
                  ),
                  TextButton(
                    onPressed: () {
                      messageTextController.clear();
                      _firestore.collection('messages').add({
                        'text': messageText,
                        'sender': loggedInUser.email,
                      });
                      messageText = '';
                    },
                    child: Text(
                      'Send',
                      style: kSendButtonTextStyle,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class MessagesStream extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return StreamBuilder<QuerySnapshot>(
      stream:
          _firestore.collection('messages').orderBy('timestamp').snapshots(),
      builder: (context, snapshot) {
        if (!snapshot.hasData) {
          return Center(
            child: CircularProgressIndicator(
              backgroundColor: Colors.lightBlueAccent,
            ),
          );
        }
        final messages = snapshot.data!.docs.reversed;
        List<MessageBubble> messageBubbles = [];
        for (var message in messages) {
          final messageText = message['text'];
          final messageSender = message['sender'];

          final currentUser = loggedInUser.email;

          final messageBubble = MessageBubble(
            sender: messageSender,
            text: messageText,
            isMe: currentUser == messageSender,
          );

          messageBubbles.add(messageBubble);
        }
        return ListView(
          reverse: true,
          padding: EdgeInsets.symmetric(horizontal: 10.0, vertical: 20.0),
          children: messageBubbles,
        );
      },
    );
  }
}

class MessageBubble extends StatelessWidget {
  MessageBubble({required this.sender, required this.text, required this.isMe});

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
            color: isMe ? Colors.lightBlueAccent : Colors.white,
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
*/
