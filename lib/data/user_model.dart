import 'package:customer_support_app/data/message_model.dart';

class CustomUser{
  int userId;
  List<Message> messageList;

  CustomUser({required this.userId, required this.messageList});
}