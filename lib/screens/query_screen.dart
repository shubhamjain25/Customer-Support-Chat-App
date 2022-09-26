import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:customer_support_app/data/feedback_model.dart';
import 'package:customer_support_app/data/message_model.dart';
import 'package:customer_support_app/data/user_model.dart';
import 'package:customer_support_app/screens/blank_screen.dart';
import 'package:customer_support_app/screens/chat_screen.dart';
import 'package:customer_support_app/services/database.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert' as convert;
import 'chat_screen2.dart';
import 'package:loading_animations/loading_animations.dart';
import 'package:loading_animations/loading_animations.dart';

class QueriesScreen extends StatefulWidget {
  @override
  State<QueriesScreen> createState() => _QueriesScreenState();
}

class _QueriesScreenState extends State<QueriesScreen> {

  List<CustomUser> allUserList = []; // to store all users with their corresponding mapped messages.
  List<CustomUser> requiredUserList = [];
  Map<int, List<Message>> messageMap = {}; // to get mapped messages from sheet, mapped to user ids.
  List<int> roomIDList = [];
  final fieldText = TextEditingController();

  String searchString = "";
  bool isLoading = false;

  getFeedbackFromSheet() async {
    setState(() {
      isLoading = true;
    });

    messageMap = await FeedbackModel().getFeedback();

    messageMap.forEach((userId, messageList) {
      allUserList.add(CustomUser(userId: userId, messageList: messageList));

      print('$userId');
      messageList.forEach((element) {
        print(element.messageBody);
      });
    });

    setState(() {
      isLoading = false;
    });
  }

  getFeedbackFromDB() async {
    setState(() {
      isLoading = true;
    });

    roomIDList = await DatabaseMethods().getChatRoomsID();
    print("<HAVE ROOM ID LIST>");
    messageMap = await DatabaseMethods().getMessagesByUserID();
    print("<HAVE MESSAGE MAP>");

    messageMap.forEach((userId, messageList) {
      messageList.sort((a, b) => a.timestamp
          .compareTo(b.timestamp)); // to sort messages based on timestamp
      if (roomIDList.contains(userId)) {
        allUserList.add(CustomUser(
            userId: userId, messageList: messageList, chatRoomExists: true));
      } else {
        allUserList.add(CustomUser(userId: userId, messageList: messageList));
      }

      print('$userId');
      messageList.forEach((element) {
        print(element.messageBody);
      });
    });

    requiredUserList = allUserList;

    setState(() {
      isLoading = false;
    });
  }

  void searchBtnTapped() {
    print("SearchButtonTapped for: " + searchString);
    List<CustomUser> searchedList = [];
    for (var element in allUserList) {
      if (element.userId.toString().contains(searchString)) {
        searchedList.add(element);
      }
    }
    requiredUserList = searchedList;
    setState(() {});
    print("After");
  }

  void crossBtnTapped() async {
    fieldText.clear();

    print("CrossBtnTapped");

    requiredUserList = allUserList;

    setState(() {});
    print("After");
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    // getFeedbackFromSheet();
    getFeedbackFromDB();
  }

  @override
  Widget build(BuildContext context) {
    return isLoading
        ? Scaffold(
            body: Center(
              child: Container(
                child: LoadingBouncingGrid.square(
                  size: 50,
                  backgroundColor: Colors.blue,
                  inverted: true,
                ),
              ),
            ),
          )
        : Scaffold(
            appBar: AppBar(
              title: Text("Feedback Model"),
            ),
            body: ListView(
              shrinkWrap: true,
              scrollDirection: Axis.vertical,
              physics: BouncingScrollPhysics(),
              children: <Widget>[
                Padding(
                  padding: const EdgeInsets.all(15.0),
                  child: TextField(
                    controller: fieldText,
                    onChanged: (value) {
                      searchString = value;
                    },
                    decoration: InputDecoration(
                      fillColor: Colors.white,
                      filled: true,
                      contentPadding: EdgeInsets.symmetric(vertical: 15.0),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(25.0),
                        borderSide: BorderSide(width: 0.8),
                      ),
                      enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(25.0),
                        borderSide: BorderSide(
                            width: 2.8, color: Theme.of(context).primaryColor),
                      ),
                      hintText: 'Search By Uid',
                      prefixIcon: IconButton(
                        icon: const Icon(
                          Icons.search,
                          size: 30.0,
                        ),
                        onPressed: () {
                          searchBtnTapped();
                        },
                      ),
                      suffixIcon: IconButton(
                        icon: const Icon(
                          Icons.clear,
                          size: 30.0,
                        ),
                        onPressed: () {
                          crossBtnTapped();
                        },
                      ),
                    ),
                  ),
                ),
                Container(
                  child: buildRowContainers(requiredUserList),
                ),
                // Container(
                //   // margin: const EdgeInsets.symmetric(vertical: 15),
                //   child: userList.isNotEmpty
                //       ? ListView.builder(
                //           shrinkWrap: true,
                //           itemCount: userList.length,
                //           physics: BouncingScrollPhysics(),
                //           itemBuilder: (context, index) {
                //             return FeedbackTile(
                //               userID: userList[index].userId,
                //               messageBody: userList[index].messageList,
                //               chatRoomExists: userList[index].chatRoomExists,
                //             );
                //           })
                //       : const Center(
                //           child: Text(
                //             "No such record exist",
                //             style:
                //                 TextStyle(color: Colors.blue, fontSize: 20.0),
                //           ),
                //         ),
                // ),
              ],
            ),
          );
  }

  Widget buildRowContainers(List<CustomUser> userList) {
    return userList.isNotEmpty
        ? ListView.builder(
            shrinkWrap: true,
            itemCount: userList.length,
            physics: BouncingScrollPhysics(),
            itemBuilder: (context, index) {
              return FeedbackTile(
                userID: userList[index].userId,
                messageBody: userList[index].messageList,
                chatRoomExists: userList[index].chatRoomExists,
              );
            })
        : Container(
            width: double.infinity,
            height: 300,
            child: const Center(
              child: Text(
                "No such records exist",
                style: TextStyle(color: Colors.blue, fontSize: 20.0),
              ),
            ),
          );
  }
}

class FeedbackTile extends StatefulWidget {
  int userID;
  List<Message> messageBody;
  bool chatRoomExists;

  FeedbackTile(
      {required this.userID,
      required this.messageBody,
      this.chatRoomExists = false});

  @override
  State<FeedbackTile> createState() => _FeedbackTileState();
}

class _FeedbackTileState extends State<FeedbackTile> {
  bool isMessageLoading = false;

  messageBtnTapped() async {
    widget.chatRoomExists = true;
    isMessageLoading = true;
    setState(() {});

    String? currEmail = FirebaseAuth.instance.currentUser?.email;
    print(currEmail);

    await DatabaseMethods()
        .enterChatRoom(widget.userID, currEmail!, widget.messageBody);

    setState(() {});
    isMessageLoading = false;
  }

  @override
  Widget build(BuildContext context) {
    CustomUser selectedUser =
        CustomUser(userId: widget.userID, messageList: widget.messageBody);

    print("In Feedback Tile");
    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
              builder: (context) => ChatScreen2(selectedUser: selectedUser)),
        );
      },
      child: Container(
        margin: const EdgeInsets.only(bottom: 20, right: 15, left: 15),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(16),
          color: Colors.blue,
        ),
        padding: EdgeInsets.all(16),
        child: Column(
          children: <Widget>[
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                Row(
                  children: <Widget>[
                    Container(
                      height: 40,
                      width: 40,
                      child: ClipRRect(
                        borderRadius: BorderRadius.all(Radius.circular(16)),
                        // child: Image.network('https://cdn-icons-png.flaticon.com/512/2102/2102633.png'),
                        child: Image.asset("assets/images/user.png"),
                      ),
                    ),
                    SizedBox(
                      width: 20,
                    ),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(widget.userID.toString()),
                      ],
                    ),
                  ],
                ),
                isMessageLoading
                    ? LoadingBouncingGrid.square(
                        size: 20,
                        backgroundColor: Colors.white,
                        inverted: true,
                      )
                    : Row(
                        children: [
                          Container(
                            width: 20.0,
                            height: 20.0,
                            decoration: BoxDecoration(
                              color: widget.chatRoomExists
                                  ? Colors.green
                                  : Colors.red,
                              shape: BoxShape.circle,
                            ),
                          ),
                          SizedBox(
                            width: 20,
                          ),
                          GestureDetector(
                            onTap: () {
                              messageBtnTapped();
                            },
                            child: Container(
                              height: 40,
                              width: 100,
                              margin: EdgeInsets.only(right: 10),
                              decoration: BoxDecoration(
                                color: Colors.white,
                                borderRadius: BorderRadius.circular(16),
                              ),
                              alignment: Alignment.center,
                              child: const Text(
                                "Message",
                                style: TextStyle(fontWeight: FontWeight.w500),
                              ),
                            ),
                          ),
                        ],
                      ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
// var raw = await http.get(Uri.parse(
//     'https://script.google.com/macros/s/AKfycbzg7y_t6tE9-tdXWJNaAYguvGhgD_FucQz4S2Tg/exec'));
//
// var jsonFeedback = convert.jsonDecode(raw.body);
// print(jsonFeedback);
//
// jsonFeedback.forEach((individualFeedback) {
//   FeedbackModel feedback = FeedbackModel(
//       userID: individualFeedback['userID'],
//       timestamp: individualFeedback['timestamp'].toString(),
//       messageBody: individualFeedback['messageBody']);
//   feedbackList.add(feedback);
// });
//
// print(feedbackList.length);
