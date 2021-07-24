import 'package:animated_text_kit/animated_text_kit.dart';
import 'package:flutter/material.dart';
import 'package:guru_blog/models/login_model.dart';
import 'package:guru_blog/screen/login.dart';
import 'package:guru_blog/screen/main_screen.dart';
import 'package:provider/provider.dart';
import 'package:rflutter_alert/rflutter_alert.dart';
import '../widgets/loading_dialog.dart';

class Register extends StatefulWidget {
  static const String id = "register";

  @override
  _RegisterState createState() => _RegisterState();
}

class _RegisterState extends State<Register> {
  final _formKey = GlobalKey<FormState>();
  late String name = "";
  late String email = "";
  late String password = "";
  TextEditingController _nameController = TextEditingController();
  TextEditingController _emailController = TextEditingController();
  TextEditingController _passController = TextEditingController();
  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    _passController.dispose();
    super.dispose();
  }
  @override
  Widget build(BuildContext context) {
    final currentUser = Provider.of<UserModel>(context);
    return Scaffold(
      appBar: AppBar(
        title: Text("Register"),
      ),
      body: SingleChildScrollView(
        child: SafeArea(
          child: Padding(
            padding: const EdgeInsets.all(10.0),
            child: Form(
              key: _formKey,
              child: Center(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    SizedBox(
                      height: 100.0,
                      child: Image.asset(
                        'assets/images/guru-logo.png',
                      ),
                    ),
                    DefaultTextStyle(
                      style: TextStyle(
                          color: Colors.black87,
                          fontSize: 22.0,
                          fontWeight: FontWeight.bold),
                      child: AnimatedTextKit(
                        animatedTexts: [
                          TypewriterAnimatedText('Guru'),
                          TypewriterAnimatedText('Blogging'),
                        ],
                      ),
                    ),
                    SizedBox(
                      height: 15.0,
                    ),
                    //Adding Text Fields
                    _buildName(),
                    SizedBox(
                      height: 15.0,
                    ),

                    _buildEmail(),
                    SizedBox(
                      height: 15.0,
                    ),

                    _buildPassword(),
                    SizedBox(
                      height: 15.0,
                    ),
                    _buildButton(currentUser),
                    SizedBox(
                      height: 50.0,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          Text(
                            "Already have an account",
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          GestureDetector(
                            onTap: () {
                              Navigator.pushNamed(context, Login.id);
                            },
                            child: Text(
                              "Login",
                              style: TextStyle(
                                  color: Theme.of(context).primaryColor,
                                  fontSize: 20.0,
                                  fontWeight: FontWeight.w900),
                            ),
                          )
                        ],
                      ),
                    )
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  var border = OutlineInputBorder(
    borderSide: BorderSide(color: Colors.black87, width: 2),
  );

  _buildName() {
    return TextFormField(
      controller: _nameController,
      style: TextStyle(fontWeight: FontWeight.bold),
      autovalidateMode: AutovalidateMode.onUserInteraction,
      onChanged: (value) => setState(() => name = value),
      validator: (field) => field!.isEmpty ? "Field required" : null,
      decoration: InputDecoration(
        labelText: "Name",
        filled: true,
        labelStyle:
            TextStyle(fontWeight: FontWeight.bold, color: Colors.black87),
        border: border,
        enabledBorder: border,
      ),
    );
  }

  _buildEmail() {
    return TextFormField(
      controller: _emailController,
      style: TextStyle(fontWeight: FontWeight.bold),
      autovalidateMode: AutovalidateMode.onUserInteraction,
      onChanged: (value) => setState(() => this.email = value),
      validator: (email) => !email!.contains('@') ? "Invalid email" : null,
      decoration: InputDecoration(
        labelText: "Email",
        filled: true,
        labelStyle:
            TextStyle(fontWeight: FontWeight.bold, color: Colors.black87),
        border: border,
        enabledBorder: border,
      ),
    );
  }

  _buildPassword() {
    return TextFormField(
      controller: _passController,
      obscureText: true,
      style: TextStyle(fontWeight: FontWeight.bold),
      onChanged: (value) => setState(() => password = value),
      autovalidateMode: AutovalidateMode.onUserInteraction,
      validator: (pass) => pass!.length < 6 ? "Too short length" : null,
      decoration: InputDecoration(
        labelText: "Password",
        filled: true,
        labelStyle:
            TextStyle(fontWeight: FontWeight.bold, color: Colors.black87),
        border: border,
        enabledBorder: border,
      ),
    );
  }

  _buildButton(UserModel currentUser) {
    return ElevatedButton(
      style: TextButton.styleFrom(
        backgroundColor: Colors.deepPurple,
        padding: EdgeInsets.symmetric(horizontal: 100.0, vertical: 20.0),
        shape: RoundedRectangleBorder(),
      ),
      onPressed: () async {
        final state = _formKey.currentState;
        if (state!.validate()) {

          showLoaderDialog(context,"Loading....");
          bool result = await currentUser.register(email, password, name);
          if (result) {
            Navigator.pop(context);
            _nameController.clear();//Clearing Fields
            _emailController.clear();//Clearing Fields
            _passController.clear();//Clearing Fields
            Navigator.pushNamed(context, MainScreen.id);
          } else {
            //show Dialog Box
            Navigator.pop(
                context); // Closing our Loading Dialog if it is running
            showDialog('Error', currentUser.error);
          }
        }
      },
      child: Text(
        "Register",
        style: TextStyle(fontSize: 20.0),
      ),
    );
  }

  void showDialog(String title, String message) {
    Alert(
      context: context,
      type: AlertType.error,
      title: title,
      desc: message,
      buttons: [
        DialogButton(
          color: Theme.of(context).primaryColor,
          child: Text(
            "OK",
            style: TextStyle(color: Colors.white, fontSize: 20.0),
          ),
          onPressed: () {
            Navigator.pop(context);
          },
        )
      ],
    ).show();
  }
}
