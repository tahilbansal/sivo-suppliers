import 'package:sivo_suppliers/common/entities/message.dart';
import 'package:sivo_suppliers/common/entities/msg.dart';
import 'package:get/get.dart';

import 'package:cloud_firestore/cloud_firestore.dart';

class MessageState {
  RxList<Message> msgList = <Message>[].obs;
  //RxList<QueryDocumentSnapshot<Msg>> msgList = <QueryDocumentSnapshot<Msg>>[].obs;
}
