import 'package:customer_support_app/data/message_model.dart';

class CustomUser{
  int userId;
  List<Message> messageList;
  bool chatRoomExists;

  CustomUser({required this.userId, required this.messageList, this.chatRoomExists=false});
}