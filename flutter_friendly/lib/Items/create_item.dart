import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_friendly/images/multi_image_upload.dart';

class CreateItem extends StatefulWidget {
  const CreateItem({super.key});

  @override
  State<CreateItem> createState() => _CreateItemState();
}

class _CreateItemState extends State<CreateItem> {
  List<File>? _images;
  final _nameTextController = TextEditingController();
  final _nameFocusNode = FocusNode();
  final _descriptionTextController = TextEditingController();
  final _descriptionFocusNode = FocusNode();
  final _priceTextController = TextEditingController();
  final _priceFocusNode = FocusNode();

  void _handleImageSelection(List<File>? selectedImages) {
    setState(() {
      _images = selectedImages;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: GestureDetector(
        onTap: () {
          _nameFocusNode.unfocus();
          _descriptionFocusNode.unfocus();
          _priceFocusNode.unfocus();
        },
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              MultiImagePickerWidget(onImageSelected: _handleImageSelection),
              const SizedBox(height: 20),
              _images != null
                  ? Text("Images Ready For Upload")
                  : const Text("No image selected"),
              Padding(
                padding: EdgeInsets.all(8.0),
                child: TextFormField(
                  autocorrect: false,
                  controller: _nameTextController,
                  focusNode: _nameFocusNode,
                  // validator: (value) => Validator.validateEmail(
                  //   email: value,
                  // ),
                  decoration: InputDecoration(labelText: "Name"),
                ),
              ),
              Padding(
                padding: EdgeInsets.all(8.0),
                child: TextFormField(
                  autocorrect: false,
                  controller: _descriptionTextController,
                  focusNode: _descriptionFocusNode,
                  // validator: (value) => Validator.validateEmail(
                  //   email: value,
                  // ),
                  decoration: InputDecoration(labelText: "Description"),
                ),
              ),
              Padding(
                padding: EdgeInsets.all(8.0),
                child: TextFormField(
                  keyboardType: TextInputType.number,
                  autocorrect: false,
                  controller: _priceTextController,
                  focusNode: _priceFocusNode,
                  // validator: (value) => Validator.validateEmail(
                  //   email: value,
                  // ),
                  decoration: InputDecoration(labelText: "Price (\$)"),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
