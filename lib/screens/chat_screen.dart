import 'package:customer_support_app/data/message_model.dart';
import 'package:customer_support_app/data/user_model.dart';
import 'package:customer_support_app/services/database.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:chat_bubbles/chat_bubbles.dart';

class ChatScreen extends StatefulWidget {

  CustomUser selectedUser;

  ChatScreen({required this.selectedUser});

  @override
  _ChatScreenState createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {

  late CustomUser user;
  List<Widget> messages1 = [];
  List<Message> _messages = [];
  String messagesString = "";
  TextEditingController messageController = TextEditingController();
  ScrollController _scrollController = ScrollController();


  void showMessages() {
    user.messageList.forEach((message) {

      messagesString = messagesString + "\n" + message.messageBody;

      var messageBubble = BubbleSpecialThree(
        text: message.messageBody,
        color: Color(0xFF1B97F3),
        tail: true,
        textStyle: TextStyle(color: Colors.white, fontSize: 16),
        isSender: false,
      );

      var now = DateTime.now();

      var dateBubble = DateChip(date: now);

      messages1 = List.from(messages1)..add(messageBubble);
      messages1 = List.from(messages1)..add(dateBubble);

    });
  }

  void addMessage(String message) {


    String? currEmail = FirebaseAuth.instance.currentUser?.email;
    Message messageObj = Message(timestamp: DateTime.now().toString().substring(0,19), messageBody: message);
    DatabaseMethods().uploadMessagesToDB(user.userId, currEmail!, messageObj);

    var messageBox = BubbleSpecialThree(
      text: message,
      isSender: true,
      color: Color(0xFFE8E8EE),
      seen: true,
    );

    var now = DateTime.now();

    var dateBubble = DateChip(date: now);

    setState(() {
      messages1 = List.from(messages1)..add(messageBox);
      messages1 = List.from(messages1)..add(dateBubble);
      messageController.clear();
    });

  }

  _sendMessageArea() {
    return Padding(
      padding: const EdgeInsets.only(left: 8.0, right: 8.0, bottom: 8.0),
      child: Container(
        margin: EdgeInsets.symmetric(vertical: 0.0),
        padding: EdgeInsets.symmetric(horizontal: 8),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(20),
          color: Color(0xFFE8E8EE),
        ),
        height: 50,
        child: Row(
          children: <Widget>[
            IconButton(
              icon: Icon(Icons.photo),
              iconSize: 25,
              color: Theme.of(context).primaryColor,
              onPressed: () {},
            ),
            Expanded(
              child: TextField(
                controller: messageController,
                decoration: InputDecoration.collapsed(
                  hintText: 'Send a message..',
                ),
                textCapitalization: TextCapitalization.sentences,
              ),
            ),
            IconButton(
              icon: Icon(Icons.send),
              iconSize: 25,
              color: Theme.of(context).primaryColor,
              onPressed: () {
                print("<---------------------->");
                print(messageController.text);
                addMessage(messageController.text);
              },
            ),
          ],
        ),
      ),
    );
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    user = widget.selectedUser;
    showMessages();
  }

  void push(Widget page) {
    Navigator.of(context).push(
      MaterialPageRoute<String>(
        builder: (BuildContext context) {
          return page;
        },
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.blueAccent,
        ),
        body: Center(
          child: Column(
            children: [
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.symmetric(vertical: 8.0),
                  child: SingleChildScrollView(
                    controller: _scrollController,
                    reverse: true,
                    physics: BouncingScrollPhysics(),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: messages1,
                      // children: <Widget>[
                      //   BubbleSpecialThree(
                      //     text: 'bubble special tow with tail',
                      //     isSender: true,
                      //     color: Color(0xFFE8E8EE),
                      //     seen: true,
                      //   ),
                      //   DateChip(
                      //     date: new DateTime(now.year, now.month, now.day - 2),
                      //   ),
                      //   BubbleSpecialThree(
                      //     text: 'bubble special tow with tail',
                      //     isSender: true,
                      //     color: Color(0xFFE8E8EE),
                      //     seen: true,
                      //   ),
                      //   BubbleSpecialThree(
                      //     text: 'bubble special three without tail',
                      //     color: Color(0xFF1B97F3),
                      //     tail: true,
                      //     textStyle: TextStyle(color: Colors.white, fontSize: 16),
                      //     isSender: false,
                      //   ),
                      //   DateChip(
                      //     date: new DateTime(now.year, now.month, now.day - 1),
                      //   ),
                      //   BubbleSpecialThree(
                      //     isSender: false,
                      //     text: 'bubble special three with tail',
                      //     color: Color(0xFF1B97F3),
                      //     tail: true,
                      //     textStyle: TextStyle(color: Colors.white, fontSize: 16),
                      //   ),
                      //   DateChip(
                      //     date: now,
                      //   ),
                      //   BubbleSpecialThree(
                      //     isSender: false,
                      //     text: 'bubble special three with tail',
                      //     color: Color(0xFF1B97F3),
                      //     tail: true,
                      //     textStyle: TextStyle(color: Colors.white, fontSize: 16),
                      //   ),
                      //   BubbleSpecialThree(
                      //     text: "bubble special three without tail",
                      //     color: Color(0xFFE8E8EE),
                      //     tail: true,
                      //     delivered: true,
                      //   ),
                      //   BubbleSpecialThree(
                      //     text: "bubble special three with tail",
                      //     color: Color(0xFFE8E8EE),
                      //     tail: true,
                      //     delivered: true,
                      //   ),
                      // ],
                    ),
                  ),
                ),
              ),
              _sendMessageArea()
            ],
          ),
        ),
      ),
    );
  }

}

