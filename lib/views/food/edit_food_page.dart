import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_vector_icons/flutter_vector_icons.dart';
import 'package:rivus_supplier/common/app_style.dart';
import 'package:rivus_supplier/common/custom_btn.dart';
import 'package:rivus_supplier/constants/constants.dart';
import 'package:rivus_supplier/controllers/foods_controller.dart';
import 'package:rivus_supplier/models/items.dart';
import 'package:get/get.dart';

class EditFoodPage extends StatefulWidget {
  const EditFoodPage({Key? key, required this.food}) : super(key: key);

  final Item food;

  @override
  State<EditFoodPage> createState() => _EditFoodPageState();
}

class _EditFoodPageState extends State<EditFoodPage> {
  late TextEditingController _titleController;
  late TextEditingController _priceController;
  late TextEditingController _descriptionController;

  @override
  void initState() {
    super.initState();
    _titleController = TextEditingController(text: widget.food.title ?? '');
    _priceController = TextEditingController(text: widget.food.price.toString() ?? '');
    _descriptionController = TextEditingController(text: widget.food.description ?? '');
  }

  @override
  void dispose() {
    _titleController.dispose();
    _priceController.dispose();
    _descriptionController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final foodController = Get.put(FoodsController());

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
                // Save button
                CustomButton(
                  text: "Save",
                  onTap: () {
                    final editedFood = Item(
                      id: widget.food.id,
                      title: _titleController.text,
                      price: double.parse(_priceController.text),
                      description: _descriptionController.text.isNotEmpty ? _descriptionController.text : null,
                      imageUrl: widget.food.imageUrl,
                      itemTags: widget.food.itemTags,
                      code: widget.food.code,
                      isAvailable: widget.food.isAvailable,
                      supplier: widget.food.supplier,
                      category: widget.food.category,
                    );
                   foodController.updateFood(widget.food.id, editedFood);
                    Get.back();
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
