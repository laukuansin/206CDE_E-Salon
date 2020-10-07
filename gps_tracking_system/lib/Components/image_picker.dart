import 'dart:io';

import 'package:flutter/material.dart';
import 'package:gps_tracking_system/Factory/text_style_factory.dart';
import 'package:gps_tracking_system/color.dart';
import 'package:image_picker/image_picker.dart';
import 'package:image_picker/image_picker.dart' as Picker;

class ImagePicker extends StatefulWidget{

  final Size imageSize;
  final Function(String) callback;
  ImagePicker({this.imageSize = const Size(150,150), this.callback});

  @override
  State<StatefulWidget> createState() => _ImagePickerState();
}

class _ImagePickerState extends State<ImagePicker>{
  Function(String)callback;
  Size imageSize;
  File imageFile;

  @override
  Widget build(BuildContext context) {
    return Container(
        child:ListTile(
          contentPadding: EdgeInsets.zero,
          leading:Icon(
              Icons.image,
              color: primaryColor
          ),
          title:Align(
            child:Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children:<Widget>[
                  Text("Image", style: TextStyleFactory.p(),),
                  SizedBox(height: 5,),
                  (){
                    return (imageFile == null)? Text("No Image Selected", style: TextStyleFactory.p()):Image.file(imageFile, width:this.imageSize.width, height: this.imageSize.height);
                  }(),
                  SizedBox(height: 5,),
                  RaisedButton(
                    onPressed: pickImage,
                    child: Text("Upload", style: TextStyleFactory.p(color:primaryLightColor)),
                    color: primaryColor,
                  )
                ]
            ),
            alignment: Alignment(-1.2,0),
          ),
          trailing: SizedBox(),
        )
    );
  }

  @override
  void initState() {
    super.initState();
    this.imageSize  = this.widget.imageSize;
    this.callback   = this.widget.callback;
  }

  Future pickImage() async {
    PickedFile pickedImage = await Picker.ImagePicker().getImage(source: ImageSource.gallery);
    setState(() {
      imageFile = File(pickedImage.path);
      callback(imageFile == null? "": imageFile.path);
    });
  }
}