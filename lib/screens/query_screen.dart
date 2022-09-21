import 'package:customer_support_app/data/feedback_model.dart';
import 'package:customer_support_app/data/message_model.dart';
import 'package:customer_support_app/data/user_model.dart';
import 'package:customer_support_app/screens/chat_screen.dart';
import 'package:customer_support_app/services/database.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert' as convert;

class QueriesScreen extends StatefulWidget {
  @override
  State<QueriesScreen> createState() => _QueriesScreenState();
}

class _QueriesScreenState extends State<QueriesScreen> {

  List<CustomUser> userList = [];     // to store users with their corresponding mapped messages.
  Map<int, List<Message>> messageMap = {};  // to get mapped messages from sheet, mapped to user ids.

  String searchString = "";
  bool isLoading = false;

  getFeedbackFromSheet() async {
    setState(() {
      isLoading = true;
    });

    messageMap = await FeedbackModel().getFeedback();

    messageMap.forEach((userId, messageList) {

      userList.add(CustomUser(userId: userId, messageList: messageList));

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

    messageMap = await DatabaseMethods().getMessagesByUserID();

    messageMap.forEach((userId, messageList) {


      userList.add(CustomUser(userId: userId, messageList: messageList));

      print('$userId');
      messageList.forEach((element) {
        print(element.messageBody);
      });

    });

    setState(() {
      isLoading = false;
    });
  }

  void searchBtnTapped() async {
    print("SearchButtonTapped for: " + searchString);
    await DatabaseMethods().getUserByUsername(searchString);
    // DatabaseMethods().getUserByUsername(searchString).get().then((val){
    //   print(val.toString());
    // });
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
                child: CircularProgressIndicator(
                  color: Colors.deepOrangeAccent,
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

                        },
                      ),
                    ),
                  ),
                ),
                Container(
                  // margin: const EdgeInsets.symmetric(vertical: 15),
                  child: ListView.builder(
                      shrinkWrap: true,
                      itemCount: userList.length,
                      physics: BouncingScrollPhysics(),
                      itemBuilder: (context, index) {
                        return FeedbackTile(
                            userID: userList[index].userId,
                            messageBody: userList[index].messageList);
                      }),
                ),
              ],
            ),
          );
  }
}

class FeedbackTile extends StatelessWidget {
  int userID;
  List<Message> messageBody;

  FeedbackTile({required this.userID, required this.messageBody});

  @override
  Widget build(BuildContext context) {
    CustomUser selectedUser =
        CustomUser(userId: userID, messageList: messageBody);

    print("In Feedback Tile");
    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
              builder: (context) => ChatScreen(selectedUser: selectedUser)),
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
                    Text(userID.toString()),
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
