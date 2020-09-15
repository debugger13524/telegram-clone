import 'dart:io';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

class UserImagePicker extends StatefulWidget {

  UserImagePicker(this.imagePickFn);
  final void Function(File pickedImage) imagePickFn;

  @override
  _UserImagePickerState createState() => _UserImagePickerState();
}

class _UserImagePickerState extends State<UserImagePicker> {


  File _image;
  final picker = ImagePicker();
  void _pickImage() async
  {
    final pickedFile = await picker.getImage(source: ImageSource.camera,imageQuality: 70,maxWidth: 200);

    setState(() {
      _image = File(pickedFile.path);
    });
    widget.imagePickFn(_image);

  }
  @override
  Widget build(BuildContext context) {
    return Container(
      child: Column(
        children: <Widget>[
          CircleAvatar(
            radius: 50,
            backgroundColor: Colors.grey,
            backgroundImage: _image!=null?FileImage(_image):null,
          ),
          FlatButton.icon(
            textColor: Colors.teal,
            onPressed: _pickImage,
            icon: Icon(Icons.image),
            label: Text('Add Image'),
          ),
        ],
      ),
    );
  }
}
