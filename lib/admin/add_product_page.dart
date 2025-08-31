import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:commerce/constsnt.dart';
import 'package:commerce/services/database_service.dart';
import 'package:commerce/services/image_upload_service.dart';
import 'package:commerce/utils/app_styless.dart';
import 'package:commerce/widgets/custom_button.dart';
import 'package:commerce/widgets/custom_text_form_field.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

class AddProductPage extends StatefulWidget {
  const AddProductPage({super.key});

  @override
  State<AddProductPage> createState() => _AddProductPageState();
}

class _AddProductPageState extends State<AddProductPage> {
  final name = TextEditingController();
  final price = TextEditingController();
  final details = TextEditingController();

  String? selectedCategory;
  final List<String> categories = ["Watch", "Laptop", "TV", "Headphones"];
  File? selectedImage;
  bool isLoading = false;

  Future<void> pickImage() async {
    final XFile? image =
        await ImagePicker().pickImage(source: ImageSource.gallery);
    if (image != null) {
      setState(() {
        selectedImage = File(image.path);
      });
    }
  }

  Future<void> addProduct() async {
    if (name.text.isEmpty ||
        selectedCategory == null ||
        selectedImage == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Please fill all fields & upload image")),
      );
      return;
    }

    setState(() {
      isLoading = true;
    });

    try {
      // 🟢 رفع الصورة على imgbb
      final imageUrl =
          await ImageUploadService().uploadImageToImgbb(selectedImage!);

      if (imageUrl == null) {
        throw "Image upload failed";
      }

      // 🔵 حفظ المنتج في Collection على حسب اسم الـ Category
      await DatabaseMethods().addProduct({
        "name": name.text,
        "category": selectedCategory,
        "image": imageUrl,
        "price": price.text,
        "details": details.text,
        "createdAt": FieldValue.serverTimestamp(),
      }, selectedCategory!);

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("✅ Product added successfully")),
      );

      Navigator.pop(context);
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Error: $e")),
      );
    } finally {
      setState(() {
        isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: GestureDetector(
          onTap: () {
            Navigator.pop(context);
          },
          child: const Icon(Icons.arrow_back_ios_new_outlined),
        ),
        title: Text(
          "Add Product",
          style: AppStyless.styleBold20,
        ),
        centerTitle: true,
      ),
      body: LayoutBuilder(
        builder: (context, constraints) {
          final double height = constraints.maxHeight;
          final double width = constraints.maxWidth;

          return SingleChildScrollView(
            padding: EdgeInsets.symmetric(
              horizontal: width * 0.06,
              vertical: height * 0.02,
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  "Upload the Product Image",
                  style: TextStyle(
                    fontSize: width * 0.04,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                SizedBox(height: height * 0.015),
                Center(
                  child: GestureDetector(
                    onTap: pickImage,
                    child: Container(
                      height: height * 0.22,
                      width: width * 0.45,
                      decoration: BoxDecoration(
                        border: Border.all(color: Colors.grey.shade400),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: selectedImage == null
                          ? const Center(
                              child: Icon(
                                Icons.camera_alt_outlined,
                                size: 40,
                                color: Colors.grey,
                              ),
                            )
                          : ClipRRect(
                              borderRadius: BorderRadius.circular(12),
                              child: Image.file(
                                selectedImage!,
                                fit: BoxFit.cover,
                              ),
                            ),
                    ),
                  ),
                ),
                SizedBox(height: height * 0.03),
                Text(
                  "Product Name",
                  style: TextStyle(
                    fontSize: width * 0.04,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                SizedBox(height: height * 0.01),
                CustomTextFormField(
                  controller: name,
                  hintText: "Enter product name",
                ),
                SizedBox(height: height * 0.03),
                Text(
                  "Product Category",
                  style: TextStyle(
                    fontSize: width * 0.04,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                SizedBox(height: height * 0.01),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  decoration: BoxDecoration(
                    color: const Color(0xfff4f5f9),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: DropdownButtonHideUnderline(
                    child: DropdownButton<String>(
                      value: selectedCategory,
                      hint: const Text("Select Category"),
                      isExpanded: true,
                      iconSize: width * 0.07,
                      items: categories
                          .map((item) => DropdownMenuItem(
                                value: item,
                                child: Text(item),
                              ))
                          .toList(),
                      onChanged: (value) {
                        setState(() {
                          selectedCategory = value;
                        });
                      },
                    ),
                  ),
                ),
                SizedBox(height: height * 0.03),
                Text(
                  "Price",
                  style: TextStyle(
                    fontSize: width * 0.04,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                SizedBox(height: height * 0.01),
                CustomTextFormField(
                  controller: price,
                  hintText: "Enter product price",
                ),
                SizedBox(height: height * 0.03),
                Text(
                  "Details",
                  style: TextStyle(
                    fontSize: width * 0.04,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                SizedBox(height: height * 0.01),
                CustomTextFormField(
                  // maxLines: 6,
                  controller: details,
                  hintText: "Enter product Details",
                ),
                SizedBox(height: height * 0.05),
                isLoading
                    ? const Center(child: CircularProgressIndicator())
                    : CustomButton(
                        text: "Add Product",
                        textColor: Colors.white,
                        backgroundColor: kMostUseColor,
                        onTap: addProduct,
                      ),
                SizedBox(height: height * 0.05),
              ],
            ),
          );
        },
      ),
    );
  }
}