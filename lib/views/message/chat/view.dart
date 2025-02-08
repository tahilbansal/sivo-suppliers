import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:sivo_suppliers/common/common_appbar.dart';
import 'package:sivo_suppliers/common/entities/message.dart';
import 'package:sivo_suppliers/common/values/colors.dart';
import 'package:sivo_suppliers/constants/constants.dart';
import 'package:sivo_suppliers/controllers/login_controller.dart';
import 'package:sivo_suppliers/views/message/chat/widgets/chat_list.dart';
import 'controller.dart';

class ChatPage extends GetView<ChatController> {
  final Message? chatDetails;
  const ChatPage({Key? key, this.chatDetails}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    Get.lazyPut(() => ChatController());
    Get.lazyPut(() => LoginController());

    return Scaffold(
      appBar: _buildAppBar(),
      body: SafeArea(
        child: Column(
          children: [
            Expanded(child: ChatList()),
            _buildMessageInput(),
          ],
        ),
      ),
    );
  }

  AppBar _buildAppBar() {
    return CommonAppBar(
      appBarChild:
      Container(
          padding: EdgeInsets.only(top: 0.w, bottom: 0.w, right: 0.w),
          child: Row(
        children: [
          _buildAvatar(),
          SizedBox(width: 15.w),
          Expanded(child: _buildUserInfo()),
        ],
      ),
      ),
    );
  }

  Widget _buildAvatar() {
    return Container(
      width: 44.w,
      height: 44.w,
      child: CachedNetworkImage(
        imageUrl: controller.state.to_avatar.value,
        imageBuilder: (context, imageProvider) => CircleAvatar(
          backgroundImage: imageProvider,
        ),
        errorWidget: (context, url, error) => CircleAvatar(
          backgroundImage: AssetImage('assets/images/profile-photo.png'),
        ),
      ),
    );
  }

  Widget _buildUserInfo() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Text(
          controller.state.to_name.value,
          style: TextStyle(
            fontWeight: FontWeight.bold,
            color: AppColors.primaryBackground,
            fontSize: 16.sp,
          ),
          overflow: TextOverflow.ellipsis,
        ),
        Obx(() => Text(
          controller.state.to_location.value,
          style: TextStyle(
            color: AppColors.primaryBackground,
            fontSize: 14.sp,
          ),
          overflow: TextOverflow.ellipsis,
        )),
      ],
    );
  }

  Widget _buildMessageInput() {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 15.w, vertical: 10.h),
      decoration: BoxDecoration(
        color: AppColors.primaryBackground,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 5,
            offset: Offset(0, -1),
          ),
        ],
      ),
      child: Row(
        children: [
          Expanded(
            child: TextField(
              controller: controller.textController,
              focusNode: controller.contentNode,
              maxLines: null,
              keyboardType: TextInputType.multiline,
              decoration: InputDecoration(
                hintText: "Send messages...",
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(20),
                  borderSide: BorderSide.none,
                ),
                filled: true,
                fillColor: Colors.grey[200],
                contentPadding: EdgeInsets.symmetric(horizontal: 15.w, vertical: 10.h),
              ),
            ),
          ),
          SizedBox(width: 10.w),
          _buildSendButton(),
        ],
      ),
    );
  }

  Widget _buildSendButton() {
    return ElevatedButton(
      onPressed: controller.sendMessage,
      child: Text("Send"),
      style: ElevatedButton.styleFrom(
        backgroundColor: kPrimary,
        foregroundColor: kOffWhite,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20),
        ),
        padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 10.h),
      ),
    );
  }

  void _showPicker(context) {
    showModalBottomSheet(
      context: context,
      builder: (BuildContext bc) {
        return SafeArea(
          child: Wrap(
            children: [
              ListTile(
                leading: Icon(Icons.photo_library),
                title: Text("Gallery"),
                onTap: () {
                  controller.imgFromGallery();
                  Get.back();
                },
              ),
              ListTile(
                leading: Icon(Icons.photo_camera),
                title: Text("Camera"),
                onTap: () {
                  controller.imgFromCamera();
                  Get.back();
                },
              ),
            ],
          ),
        );
      },
    );
  }
}

