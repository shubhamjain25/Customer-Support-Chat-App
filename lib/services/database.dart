import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:customer_support_app/data/feedback_model.dart';
import 'package:customer_support_app/data/message_model.dart';
import 'package:basic_utils/basic_utils.dart';

class DatabaseMethods {
  getUserByUsername(String username) async {
    await FirebaseFirestore.instance
        .collection("authorisedUsers")
        .where("name", isEqualTo: username)
        .get()
        .then((value) {
      var searchSnapshot = value;
      var documents = searchSnapshot.docs;
      documents.forEach((eachDocument) {
        var val1 = eachDocument.data()["email"];
        print(val1);
      });
    });
  }

  Future<Map<int, List<Message>>> getMessagesByUserID() async {
    Map<int, List<Message>> messageMap = {};

    List<FeedbackModel> feedbackList = [];

    await FirebaseFirestore.instance
        .collection("messageDB")
        .orderBy("User ID")
        .get()
        .then((value) {
      var searchSnapshot = value;
      var documents = searchSnapshot.docs;

      documents.forEach((eachDocument) {
        var individualFeedback = eachDocument.data();

        //Fetching Values
        int userID = individualFeedback['User ID'];

        String oldTimestamp = individualFeedback['Timestamp (UTC)'].toString();
        String changedTimeStamp = oldTimestamp.length == 19
            ? oldTimestamp
            : StringUtils.addCharAtPosition(oldTimestamp, "0", 11,
            repeat: true);

        Message message = Message(
            timestamp: changedTimeStamp,
            messageBody: individualFeedback['Message Body']);

        //Putting Data to Map
        if (messageMap.containsKey(userID)) {
          var messages = messageMap[userID];
          messages!.add(message);
          messageMap[userID] = messages;
        } else {
          messageMap[userID] = [message];
        }
      });
    });

    return messageMap;
  }

  createChatRoom(int roomID, chatRoomMap) {
    FirebaseFirestore.instance
        .collection("ChatRoom")
        .doc(roomID.toString())
        .set(chatRoomMap)
        .catchError((error) {
      print(error.toString());
    });
  }

  enterChatRoom(int roomID, String newUser, List<Message> messageBody) async {
    // check if chat room exists
    var existingUserList = [];
    await FirebaseFirestore.instance
        .collection("ChatRoom")
        .where("roomID", isEqualTo: roomID)
        .get()
        .then((value) {
      var searchSnapshot = value;
      var documents = searchSnapshot.docs;
      documents.forEach((eachDocument) {
        existingUserList = eachDocument.data()["users"];
      });
    });

    if (existingUserList.isEmpty) {
      //chat room does not exist, so uploading all messages to chat room.
      await uploadMessagesOfDB(roomID, messageBody);
      print("HERE:");
    }

    if ((existingUserList.isEmpty) || (existingUserList.isNotEmpty && existingUserList.contains(newUser) == false)) {

      existingUserList = existingUserList..add(newUser);

      Map<String, dynamic> userInfoMap = {
        "roomID": roomID,
        "users": existingUserList
      };

      FirebaseFirestore.instance.collection("ChatRoom").doc(roomID.toString()).set(userInfoMap).catchError((error) {
        print(error.toString());
      });
    }

    // if (existingUserList == null) {
    //   //chat room does not exist, so uploading all messages to chat room.
    //   await uploadMessagesOfDB(roomID, messageBody);
    // } else {
    //   bool exists = false;
    //   if (existingUserList.contains(newUser)) {
    //     print("<--------Element Already Present---->");
    //   } else {
    //     existingUserList = existingUserList..add(newUser);
    //     Map<String, dynamic> userInfoMap = {
    //       "roomID": roomID,
    //       "users": existingUserList
    //     };
    //   }
    // }
  }

  uploadMessagesOfDB(int roomID, List<Message> messagesList) async {
    messagesList.forEach((message) async {
      var messageMap = {
        "Timestamp (UTC)": message.timestamp,
        "Message Body": message.messageBody,
        "Sender": "@" + roomID.toString()
      };
      await FirebaseFirestore.instance.collection("ChatRoom").doc(roomID.toString()).collection("chats").add(messageMap).catchError((error) {
        print(error.toString());
      });
    });
  }

  uploadMessagesToDB(int roomID, String respondingUser, Message message) async{
    var messageMap = {
      "Timestamp (UTC)": message.timestamp,
      "Message Body": message.messageBody,
      "Sender": respondingUser
    };
    await FirebaseFirestore.instance.collection("ChatRoom").doc(roomID.toString()).collection("chats").add(messageMap).catchError((error) {
      print(error.toString());
    });
  }

  Future<List<int>> getChatRoomsID() async{
    List<int> roomIDList = [];

    await FirebaseFirestore.instance
        .collection("ChatRoom")
        .get()
        .then((value) {
      var searchSnapshot = value;
      var documents = searchSnapshot.docs;
      documents.forEach((eachDocument) {
        int roomID = eachDocument.data()["roomID"];
        roomIDList.add(roomID);
      });
    });

    // await FirebaseFirestore.instance.collection("ChatRoom").snapshots().forEach((snapshot) {
    //   final qs = snapshot;
    //   print("Printing Stuff---> ");
    //   print(qs.docs);
    //   qs.docs.forEach((query) {
    //     print(query.data()["roomID"]);
    //     int roomID = query.data()["roomID"];
    //     roomIDList.add(roomID);
    //   });
    // });
    print("<---Returning Stuff-->>");
    return roomIDList;
  }

  changeConversationMessages() {}

  uploadUserInfo(userMap) {
    FirebaseFirestore.instance.collection("authorisedUsers").add(userMap);
  }
}
