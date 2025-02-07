import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_vector_icons/flutter_vector_icons.dart';
import 'package:get/get.dart';
import 'package:sivo_suppliers/common/custom_btn.dart';
import 'package:sivo_suppliers/constants/constants.dart';
import 'package:sivo_suppliers/controllers/items_controller.dart';
import 'package:sivo_suppliers/models/items.dart';

class EditItemPage extends StatefulWidget {
  const EditItemPage({Key? key, required this.item}) : super(key: key);

  final Item item;

  @override
  State<EditItemPage> createState() => _EditItemPageState();
}

class _EditItemPageState extends State<EditItemPage> {
  late TextEditingController _titleController;
  late TextEditingController _priceController;
  late TextEditingController _descriptionController;
  late TextEditingController _unitController;

  @override
  void initState() {
    super.initState();
    _titleController = TextEditingController(text: widget.item.title ?? '');
    _priceController = TextEditingController(
        text: widget.item.price == null ? '' : widget.item.price.toString());
    _descriptionController =
        TextEditingController(text: widget.item.description ?? '');
    _unitController = TextEditingController(text: widget.item.unit ?? '');
  }

  @override
  void dispose() {
    _titleController.dispose();
    _priceController.dispose();
    _descriptionController.dispose();
    _unitController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final itemController = Get.put(ItemsController());

    return Scaffold(
      backgroundColor: kLightWhite,
      body: ListView(
        padding: EdgeInsets.zero,
        physics: const NeverScrollableScrollPhysics(),
        children: [
          Stack(
            children: [
              SizedBox(height: 100.h),
              // Your image gallery
              // For simplicity, I'm omitting this part since it's not part of the edit functionality
              // Container(
              //   height: 200,
              //   width: double.infinity,
              //   color: Colors.blue,
              // ),
              // Back button
              Positioned(
                top: 40.h,
                left: 12,
                right: 12,
                child: GestureDetector(
                  onTap: () {
                    Get.back();
                  },
                  child: const Icon(
                    Ionicons.chevron_back_circle,
                    color: kPrimary,
                    size: 28,
                  ),
                ),
              ),
            ],
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Editable title
                TextFormField(
                  controller: _titleController,
                  decoration: InputDecoration(
                    labelText: 'Title',
                    border: OutlineInputBorder(),
                  ),
                ),
                SizedBox(height: 10.h),
                // Editable price
                TextFormField(
                  controller: _priceController,
                  keyboardType: TextInputType.number,
                  decoration: InputDecoration(
                    labelText: 'Price',
                    border: OutlineInputBorder(),
                  ),
                ),
                SizedBox(height: 10.h),
                // Editable description
                TextFormField(
                  controller: _descriptionController,
                  maxLines: 4,
                  decoration: InputDecoration(
                    labelText: 'Description',
                    border: OutlineInputBorder(),
                  ),
                ),
                SizedBox(height: 10.h),
                TextFormField(
                  controller: _unitController,
                  decoration: InputDecoration(
                    labelText: 'Unit',
                    border: OutlineInputBorder(),
                  ),
                ),
                SizedBox(height: 10.h),
                // Save button
                CustomButton(
                  text: "Save",
                  onTap: () {
                    final editedItem = Item(
                      id: widget.item.id,
                      title: _titleController.text,
                      price: double.parse(_priceController.text),
                      description: _descriptionController.text.isNotEmpty
                          ? _descriptionController.text
                          : null,
                      imageUrl: widget.item.imageUrl,
                      itemTags: widget.item.itemTags,
                      code: widget.item.code,
                      unit: _unitController.text,
                      isAvailable: widget.item.isAvailable,
                      supplier: widget.item.supplier,
                      category: widget.item.category,
                    );
                    itemController.updateItem(widget.item.id, editedItem);
                  },
                  color: kPrimary,
                  btnWidth: width / 2.9,
                  radius: 30,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
