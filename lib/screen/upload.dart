import 'package:flutter/material.dart';
import 'package:guru_blog/models/login_model.dart';
import 'package:guru_blog/screen/main_screen.dart';
import 'dart:io';

import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';

class Upload extends StatefulWidget {
  @override
  _UploadState createState() => _UploadState();
}

class _UploadState extends State<Upload> {
  String title = "";
  String type = "Select Interest";
  String description = "";
  TextEditingController? _titleController;
  TextEditingController? _desController;
  File? _image;

  @override
  void initState() {
    super.initState();
    _titleController = TextEditingController();
    _desController = TextEditingController();
  }

  @override
  void dispose() {
    super.dispose();
    _titleController!.dispose();
    _desController!.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final uploadPost = Provider.of<UserModel>(context);
    return Scaffold(
      appBar: AppBar(
        title: Text("Upload Post"),
        automaticallyImplyLeading: false,
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              //Building Title
              _buildTitle(),
              //Building DropDown
              SizedBox(
                height: 10.0,
              ),
              Container(
                padding: EdgeInsets.symmetric(horizontal: 5.0),
                decoration: BoxDecoration(
                    border: Border.all(
                        color: Theme.of(context).primaryColor, width: 2.0)),
                child: DropdownButton(
                  value: type,
                  onChanged: (String? value) => setState(() => type = value!),
                  items: [
                    "Select Interest",
                    "education",
                    "sport",
                    "weather",
                    "trip"
                  ]
                      .map<DropdownMenuItem<String>>(
                        (e) => DropdownMenuItem<String>(
                          child: Text(e),
                          value: e,
                        ),
                      )
                      .toList(),
                ),
              ),
              SizedBox(
                height: 10.0,
              ),
              TextFormField(
                maxLines: 5,
                style: TextStyle(fontWeight: FontWeight.bold),
                autovalidateMode: AutovalidateMode.onUserInteraction,
                onChanged: (value) => setState(() => this.description = value),
                decoration: InputDecoration(
                  labelText: "Description",
                  filled: true,
                  labelStyle: TextStyle(
                      fontWeight: FontWeight.bold, color: Colors.black87),
                  border: border,
                  enabledBorder: border,
                ),
              ),
              SizedBox(
                height: 10.0,
              ),
              _image == null
                  ? GestureDetector(
                      onTap: () async {
                        try {
                          final _picker = ImagePicker();
                          PickedFile? _pickedImage = await _picker.getImage(
                              source: ImageSource.gallery);
                          setState(() {
                            _image = File(_pickedImage!.path);
                          });
                        } catch (e) {
                          print(e.toString());
                        }
                      },
                      child: Card(
                        child: Icon(
                          Icons.camera_alt_outlined,
                          size: 80.0,
                        ),
                      ),
                    )
                  : Image.file(
                      _image!,
                      height: 80.0,
                    ),
              _buildButton(uploadPost),
            ],
          ),
        ),
      ),
    );
  }

  _buildTitle() {
    return TextFormField(
      style: TextStyle(fontWeight: FontWeight.bold),
      autovalidateMode: AutovalidateMode.onUserInteraction,
      onChanged: (value) => setState(() => this.title = value),
      decoration: InputDecoration(
        labelText: "Title",
        filled: true,
        labelStyle:
            TextStyle(fontWeight: FontWeight.bold, color: Colors.black87),
        border: border,
        enabledBorder: border,
      ),
    );
  }

  var border = OutlineInputBorder(
    borderSide: BorderSide(color: Colors.black87, width: 2),
  );

  _buildButton(UserModel uploadPost) {
    return ElevatedButton(
      style: TextButton.styleFrom(
        backgroundColor: Colors.deepPurple,
        padding: EdgeInsets.symmetric(horizontal: 90, vertical: 10.0),
        shape: RoundedRectangleBorder(),
      ),
      onPressed: () {
        if (this.title.isEmpty &&
            this.description.isEmpty &&
            this.type == "Select Interest" &&
            this._image == null) {
          SnackBar snackBar = SnackBar(
            backgroundColor: Theme.of(context).primaryColor,
            content: Text("All option Required"),
            duration: Duration(seconds: 2),
          );
          ScaffoldMessenger.of(context).showSnackBar(snackBar);
        } else {
          uploadPost.uploadPost(_image!, type, title, description);
          SnackBar snackBar = SnackBar(
            backgroundColor: Theme.of(context).primaryColor,
            content: Text("Post Successfully Uploaded"),
            duration: Duration(seconds: 2),
          );
          ScaffoldMessenger.of(context).showSnackBar(snackBar);
          Navigator.pushNamedAndRemoveUntil(
              context, MainScreen.id, (route) => false);
        }
      },
      child: Text(
        "Upload",
        style: TextStyle(fontSize: 20.0),
      ),
    );
  }
}
