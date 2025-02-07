import 'package:sivo_suppliers/common/entities/message.dart';
import 'package:sivo_suppliers/common/utils/date.dart';
import 'package:sivo_suppliers/main.dart';
import 'package:sivo_suppliers/views/message/chat/index.dart';
import 'package:sivo_suppliers/views/message/controller.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:cached_network_image/cached_network_image.dart';

import '../../../../common/entities/msg.dart';
import '../../../../common/values/colors.dart';

class MessageList extends GetView<MessageController> {
  const MessageList({Key? key}) : super(key: key);

  Widget messageListItem(Message item) {
    return InkWell(
      onTap: () {
        // Pass the selected message details to ChatPage
        controller.selectChat(item);
      },
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: 15.w, vertical: 10.w.clamp(10, 10)),
        child: Row(
          children: [
            CircleAvatar(
              radius: 27.w.clamp(27, 40),
              backgroundImage: CachedNetworkImageProvider(item.avatar!),
              backgroundColor: Colors.grey[300],
            ),
            SizedBox(width: 10.w),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    item.name!,
                    style: TextStyle(
                      fontSize: 16.sp.clamp(14, 20),
                      fontWeight: FontWeight.bold,
                      color: AppColors.thirdElement,
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                  Text(
                    item.last_msg ?? "",
                    style: TextStyle(
                      fontSize: 14.sp.clamp(14, 20),
                      color: AppColors.thirdElementText,
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                ],
              ),
            ),
            SizedBox(width: 10.w),
            Text(
              duTimeLineFormat((item.last_time as Timestamp).toDate()),
              style: TextStyle(
                fontSize: 12.sp.clamp(14, 20),
                color: AppColors.thirdElementText,
              ),
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        // Check if the screen width is wide enough for a desktop view
        bool isDesktop = constraints.maxWidth > 800;

        return Obx(() {
          var messageList = controller.state.msgList;

          return isDesktop
              ? Row(
              children: [
              // Message List on the left
              Expanded(
                flex: 3,
                child: ListView.builder(
                  itemCount: messageList.length,
                  itemBuilder: (context, index) {
                    var item = messageList[index];
                    return messageListItem(item);
                  },
                ),
              ),
              // Chat Page on the right
              Expanded(
                flex: 5,
                child: Obx(() {
                  final selectedChat = controller.selectedChat.value;

                  if (selectedChat == null) {
                    return Center(
                      child: Text(
                        "Select a chat to start messaging",
                        style: TextStyle(fontSize: 22),
                      ),
                    );
                  }
                  return ChatPage(
                    chatDetails: selectedChat,
                  );
                }),
              ),
            ],
          )
              : ListView.builder(
            itemCount: messageList.length,
            itemBuilder: (context, index) {
              var item = messageList[index];
              return messageListItem(item);
            },
          );
        });
      },
    );
  }
}
