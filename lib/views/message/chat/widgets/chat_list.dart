import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:sivo_suppliers/common/values/colors.dart';
import 'package:sivo_suppliers/views/message/chat/controller.dart';
import 'package:sivo_suppliers/views/message/chat/widgets/chat_right_item.dart';
import 'package:sivo_suppliers/views/message/chat/widgets/chat_left_item.dart';

class ChatList extends GetView<ChatController> {
  const ChatList({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Obx(() => Container(
      color: AppColors.chatbg,
      child: ListView.builder(
        reverse: true,
        controller: controller.msgScrolling,
        itemCount: controller.state.msgcontentList.length,
        itemBuilder: (context, index) {
          var item = controller.state.msgcontentList[index];
          return Padding(
            padding: EdgeInsets.symmetric(vertical: 10.h),
            child: controller.user_id == item.uid
                ? ChatRightItem(item)
                : ChatLeftItem(item),
          );
        },
      ),
    ));
  }
}

