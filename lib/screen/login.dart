import 'package:animated_text_kit/animated_text_kit.dart';
import 'package:flutter/material.dart';
import 'package:guru_blog/models/login_model.dart';
import 'package:guru_blog/screen/main_screen.dart';
import 'package:guru_blog/screen/register.dart';
import 'package:guru_blog/widgets/loading_dialog.dart';
import 'package:provider/provider.dart';
import 'package:rflutter_alert/rflutter_alert.dart';

class Login extends StatefulWidget {
  static const String id = "login";

  @override
  _LoginState createState() => _LoginState();
}

class _LoginState extends State<Login> {
  final _formKey = GlobalKey<FormState>();
  late String email = "";
  late String password = "";

  @override
  Widget build(BuildContext context) {
    final currentUser = Provider.of<UserModel>(context);
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        title: Text("Login"),
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
                              "Don\'t have an account",
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            GestureDetector(
                              onTap: () {
                                Navigator.pushNamed(context, Register.id);
                              },
                              child: Text(
                                "Register",
                                style: TextStyle(
                                    color: Theme.of(context).primaryColor,
                                    fontSize: 20.0,
                                    fontWeight: FontWeight.w900),
                              ),
                            )
                          ],
                        ))
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

  _buildEmail() {
    return TextFormField(
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
      obscureText: true,
      style: TextStyle(fontWeight: FontWeight.bold),
      onChanged: (value) => setState(() => this.password = value),
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
        showLoaderDialog(context,"Loading...");
        if (state!.validate()) {
          bool result = await currentUser.login(email, password);
          if (result) {
            Navigator.pop(context);
            Navigator.pushNamed(context, MainScreen.id);
          } else {
            Navigator.pop(context);
            showDialog("Error", currentUser.error);
          }
        }
      },
      child: Text(
        "Login",
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
