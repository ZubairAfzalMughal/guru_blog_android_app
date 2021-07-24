import 'package:flutter/material.dart';
import 'package:guru_blog/models/login_model.dart';
import 'package:provider/provider.dart';

class UpdateProfile extends StatefulWidget {
  static const String id = "id";

  const UpdateProfile({Key? key}) : super(key: key);

  @override
  _UpdateProfileState createState() => _UpdateProfileState();
}

class _UpdateProfileState extends State<UpdateProfile> {
  String? name;
  final _formKey = GlobalKey<FormState>();
  final _scaffoldKey = GlobalKey<ScaffoldState>();
  TextEditingController? controller;

  @override
  void initState() {
    controller = TextEditingController(
        text: Provider.of<UserModel>(context, listen: false).userData!.name);
    super.initState();
  }

  @override
  void dispose() {
    controller!.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      appBar: AppBar(
        title: Text("Update Profile"),
        leading: IconButton(
          icon: Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: FutureBuilder<UserData?>(
          future: Provider.of<UserModel>(context, listen: false).userInfo(),
          builder: (context, snapshot) {
            return Column(
              children: [
                Form(
                  key: _formKey,
                  child: TextFormField(
                    controller: controller,
                    style: TextStyle(fontWeight: FontWeight.bold),
                    autovalidateMode: AutovalidateMode.onUserInteraction,
                    onChanged: (value) => setState(() => this.name = value),
                    validator: (name) => name!.isEmpty ? "InValid Name" : null,
                    decoration: InputDecoration(
                      labelText: "Email",
                      filled: true,
                      labelStyle: TextStyle(
                          fontWeight: FontWeight.bold, color: Colors.black87),
                      border: border,
                      enabledBorder: border,
                    ),
                  ),
                ),
                ElevatedButton(
                  style: TextButton.styleFrom(
                      backgroundColor: Theme.of(context).primaryColor),
                  onPressed: () {
                    if (_formKey.currentState!.validate()) {
                      Provider.of<UserModel>(context, listen: false)
                          .updateUser(this.name);
                      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                        content: Text(
                          "Profile Has been Updated",
                          style: TextStyle(color: Colors.white),
                        ),
                        backgroundColor: Theme.of(context).primaryColor,
                        duration: Duration(seconds: 2),
                      ));
                    }
                  },
                  child: Text("Update"),
                )
              ],
            );
          },
        ),
      ),
    );
  }

  var border = OutlineInputBorder(
    borderSide: BorderSide(color: Colors.black87, width: 2),
  );
}
