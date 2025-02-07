import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:sivo_suppliers/constants/constants.dart';

Future<void> showDeleteConfirmationDialog({
  required BuildContext context,
  required VoidCallback onConfirm,
}) async {
  await Get.dialog(
    AlertDialog(
      title: const Text("Delete Confirmation"),
      content: const Text("Are you sure you want to delete this item?"),
      actions: [
        TextButton(
          onPressed: () {
            Get.back(); // Close the dialog
          },
          child: const Text(
            "Cancel",
            style: TextStyle(color: kGray),
          ),
        ),
        ElevatedButton(
          onPressed: () {
            Get.back();
            onConfirm();
          },
          style: ElevatedButton.styleFrom(backgroundColor: kRed),
          child: const Text(
            "Delete",
            style: TextStyle(color: kLightWhite),
          ),
        ),
      ],
    ),
  );
}
