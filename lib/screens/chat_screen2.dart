import 'dart:async';
import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:customer_support_app/data/message_model.dart';
import 'package:customer_support_app/data/user_model.dart';
import 'package:customer_support_app/services/database.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:dash_chat/dash_chat.dart';

class ChatScreen2 extends StatefulWidget {
  CustomUser selectedUser;

  ChatScreen2({required this.selectedUser});

  @override
  _ChatScreen2State createState() => _ChatScreen2State();
}

class _ChatScreen2State extends State<ChatScreen2> {
  final GlobalKey<DashChatState> _chatViewKey = GlobalKey<DashChatState>();

  final ChatUser user = ChatUser(
    name: "Fayeed",
    firstName: "Fayeed",
    lastName: "Pawaskar",
    uid: "12345678",
    avatar: "https://www.wrappixel.com/ampleadmin/assets/images/users/4.jpg",
  );

  final ChatUser otherUser = ChatUser(
    name: "Mrfatty",
    uid: "25649654",
  );

  String emailID = "";


  @override
  void initState() {
    super.initState();
  }

  // void systemMessage() {
  //   Timer(Duration(milliseconds: 300), () {
  //     if (i < 6) {
  //       setState(() {
  //         messages = [...messages, m[i]];
  //       });
  //       i++;
  //     }
  //     Timer(Duration(milliseconds: 300), () {
  //       _chatViewKey.currentState.scrollController
  //         ..animateTo(
  //           _chatViewKey.currentState.scrollController.position.maxScrollExtent,
  //           curve: Curves.easeOut,
  //           duration: const Duration(milliseconds: 300),
  //         );
  //     });
  //   });
  // }

  void onSend(ChatMessage message) async {

    String? currEmail = FirebaseAuth.instance.currentUser?.email;
    emailID = currEmail as String;
    String currMessage = message.text as String;
    Message messageObj = Message(timestamp: DateTime.now().toString().substring(0,19), messageBody: currMessage);
    DatabaseMethods().uploadMessagesToDB(widget.selectedUser.userId, emailID, messageObj);

    print(message.toJson());

    // setState(() {
    //   messagesList2 = messagesList2..add(message);
    //   print(messagesList2.length);
    // });

  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Chatting with uid: "+widget.selectedUser.userId.toString()),
      ),
      body: StreamBuilder(
          // stream: FirebaseFirestore.instance.collection('messages').snapshots(),
          stream: FirebaseFirestore.instance
              .collection("ChatRoom")
              .doc(widget.selectedUser.userId.toString())
              .collection("chats")
              .orderBy("Timestamp (UTC)")
              .snapshots(),
          builder: (context, snapshot) {
            if (!snapshot.hasData) {
              return Center(
                child: CircularProgressIndicator(
                  valueColor: AlwaysStoppedAnimation<Color>(
                    Theme.of(context).primaryColor,
                  ),
                ),
              );
            } else {
              List<ChatMessage> messagesList2 = [];
              final qs = snapshot.data as QuerySnapshot;
              print("Printing Stuff---> " +
                  widget.selectedUser.userId.toString());
              print(qs.docs);
              qs.docs.forEach((query) {
                var data = query.data();
                print(data["Message Body"]);
                messagesList2.add(ChatMessage(text: data["Message Body"], user: ChatUser(name: data["Sender"]), createdAt: DateTime.parse(data["Timestamp (UTC)"])));
              });
              // list.forEach((element) {
              //   print(element);
              // });
              // return Container(
              //   color: Colors.indigo,
              //   child: Text(widget.selectedUser.userId.toString()),
              // );
              // var document = snapshot?.data;
              // Object? items = snapshot.data.docs[0].data["message"];
              return DashChat(
                key: _chatViewKey,
                inverted: false,
                onSend: onSend,
                sendOnEnter: true,
                textInputAction: TextInputAction.send,
                user: ChatUser(name: emailID),
                inputDecoration:
                InputDecoration.collapsed(hintText: "Add message here..."),
                dateFormat: DateFormat('yyyy-MMM-dd'),
                timeFormat: DateFormat('HH:mm'),
                messages: messagesList2,
                showUserAvatar: true,
                showAvatarForEveryMessage: false,
                scrollToBottom: true,
                onPressAvatar: (ChatUser user) {
                  print("OnPressAvatar: ${user.name}");
                },
                onLongPressAvatar: (ChatUser user) {
                  print("OnLongPressAvatar: ${user.name}");
                },
                inputMaxLines: 5,
                messageContainerPadding: EdgeInsets.only(left: 5.0, right: 5.0),
                alwaysShowSend: true,
                inputTextStyle: TextStyle(fontSize: 16.0),
                inputContainerStyle: BoxDecoration(
                  border: Border.all(width: 0.0),
                  borderRadius: BorderRadius.circular(12),
                  color: Colors.white,
                ),
                // messageDecorationBuilder: (ChatMessage msg, bool? isUser){
                //   return BoxDecoration(
                //
                //     color: msg.user.name?[0]!='@'?Colors.black:Colors.indigo // example
                //   );
                // },
                // onQuickReply: (Reply reply) {
                //   setState(() {
                //     messages.add(ChatMessage(
                //         text: reply.value,
                //         createdAt: DateTime.now(),
                //         user: user));
                //
                //     messages = [...messages];
                //   });
                //
                //   Timer(Duration(milliseconds: 300), () {
                //     _chatViewKey.currentState.scrollController!
                //       .animateTo(
                //         _chatViewKey.currentState?.scrollController.position
                //             .maxScrollExtent,
                //         curve: Curves.easeOut,
                //         duration: const Duration(milliseconds: 300),
                //       );
                //
                //     if (i == 0) {
                //       systemMessage();
                //       Timer(Duration(milliseconds: 600), () {
                //         systemMessage();
                //       });
                //     } else {
                //       systemMessage();
                //     }
                //   });
                // },
                onLoadEarlier: () {
                  print("laoding...");
                },
                shouldShowLoadEarlier: false,
                showTraillingBeforeSend: true,
                trailing: <Widget>[],
              );
            }
          }),
    );
  }
}
