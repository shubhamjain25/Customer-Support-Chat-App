import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:customer_support_app/data/feedback_model.dart';
import 'package:customer_support_app/data/message_model.dart';
import 'package:basic_utils/basic_utils.dart';

class DatabaseMethods{

  getUserByUsername(String username) async{
    await FirebaseFirestore.instance.collection("authorisedUsers").where("name", isEqualTo: username).get().then((value){
      var searchSnapshot = value;
      var documents = searchSnapshot.docs;
      documents.forEach((eachDocument) {
        var val1 = eachDocument.data()["email"];
        print(val1);
      });
    });
  }

  Future<Map<int, List<Message>>> getMessagesByUserID() async{

    Map<int, List<Message>> messageMap = {};

    List<FeedbackModel> feedbackList = [];

    await FirebaseFirestore.instance.collection("messageDB").orderBy("User ID").get().then((value){

      var searchSnapshot = value;
      var documents = searchSnapshot.docs;

      documents.forEach((eachDocument) {

        var individualFeedback = eachDocument.data();

        //Fetching Values
        int userID = individualFeedback['User ID'];

        String oldTimestamp = individualFeedback['Timestamp (UTC)'].toString();
        String changedTimeStamp = oldTimestamp.length==19?oldTimestamp:StringUtils.addCharAtPosition(oldTimestamp, "0", 12, repeat: true);

        Message message = Message(timestamp: changedTimeStamp, messageBody: individualFeedback['Message Body']);

        //Putting Data to Map
        if(messageMap.containsKey(userID)){
          var messages = messageMap[userID];
          messages!.add(message);
          messageMap[userID]=messages;
        }
        else{
          messageMap[userID]=[message];
        }

      });
    });

    return messageMap;
  }

  uploadUserInfo(userMap){
    FirebaseFirestore.instance.collection("authorisedUsers").add(userMap);
  }

}