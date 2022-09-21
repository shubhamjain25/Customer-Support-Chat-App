import 'package:customer_support_app/data/message_model.dart';
import 'package:http/http.dart' as http;
import 'dart:convert' as convert;

class FeedbackModel {
  // int userID;
  // List<Message> messages;
  //
  // FeedbackModel(
  //     {required this.userID,
  //       required this.messages});

  // FeedbackModel(
  //     {required this.userID,
  //     required this.timestamp,
  //     required this.messageBody});


  // FeedbackModel({required this.messageMap});

  Future<Map<int, List<Message>>> getFeedback() async {

    Map<int, List<Message>> messageMap = {};

    List<FeedbackModel> feedbackList = [];

    var raw = await http.get(
      Uri.parse(
          'https://script.google.com/macros/s/AKfycbzg7y_t6tE9-tdXWJNaAYguvGhgD_FucQz4S2Tg/exec'),
    );

    var jsonFeedback = convert.jsonDecode(raw.body);
    print(jsonFeedback);

    jsonFeedback.forEach((individualFeedback) {

      int userID = individualFeedback['userID'];
      Message message = Message(timestamp: individualFeedback['timestamp'].toString(), messageBody: individualFeedback['messageBody']);

      if(messageMap.containsKey(userID)){
        var messages = messageMap[userID];
        messages!.add(message);
        messageMap[userID]=messages;
      }
      else{
        messageMap[userID]=[message];
      }

    });

    print("MessageMap Length:>>>>>>>>>>>>>");
    print(messageMap.length);
    return messageMap;
  }

// factory FeedbackModel.fromJSON(dynamic json){
//   return FeedbackModel(
//     userID: json['userID'],
//     timestamp: "${json['timestamp']}",
//     messageBody: "${json['messageBody']}",
//   );
// }
//
// Map toJSON() => {
//   "userID": userID,
//   "timestamp": timestamp,
//   "messageBody": messageBody,
// };

}
