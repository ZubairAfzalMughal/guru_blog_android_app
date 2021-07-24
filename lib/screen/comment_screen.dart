import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:guru_blog/models/login_model.dart';
import 'package:provider/provider.dart';

class CommentScreen extends StatefulWidget {
  final QueryDocumentSnapshot id;

  const CommentScreen({Key? key, required this.id}) : super(key: key);

  @override
  _CommentScreenState createState() => _CommentScreenState();
}

class _CommentScreenState extends State<CommentScreen> {
  String? message;
  TextEditingController? _controller;

  @override
  void initState() {
    super.initState();
    _controller = TextEditingController();
  }

  @override
  void dispose() {
    super.dispose();
    _controller!.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Comments"),
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          //Creating message UI To get Messages From user
          MessagesField(id: widget.id.id),
          //Create Text Field
          createTextField(),
        ],
      ),
    );
  }

  createTextField() {
    return Container(
      width: double.infinity,
      height: 50.0,
      decoration: BoxDecoration(border: Border.all()),
      child: Row(
        children: [
          // text Field
          Expanded(
            child: TextField(
              controller: _controller,
              decoration: InputDecoration(
                  contentPadding: EdgeInsets.only(left: 10.0),
                  hintStyle: TextStyle(color: Colors.black87),
                  border: InputBorder.none,
                  hintText: "type...."),
              onChanged: (value) => setState(() => message = value),
            ),
          ),
          //send button
          IconButton(
            color: Theme.of(context).primaryColor,
            icon: Icon(Icons.send),
            onPressed: () {
              //Uploading Post
              Provider.of<UserModel>(context, listen: false)
                  .uploadComments(widget.id.id, message!);
              _controller!.clear();
            },
          ),
        ],
      ),
    );
  }
}

class MessagesField extends StatelessWidget {
  final String id;

  const MessagesField({Key? key, required this.id}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<QuerySnapshot>(
      stream: Provider.of<UserModel>(context, listen: false).fetchComments(id),
      builder: (context, snapshot) {
        if (!snapshot.hasData) {
          return Center(
            child: CircularProgressIndicator(
              valueColor:
                  AlwaysStoppedAnimation(Theme.of(context).primaryColor),
            ),
          );
        } else {
          return Expanded(
              child: ListView.builder(
            itemCount: snapshot.data!.docs.length,
            itemBuilder: (context, index) => ListTile(
              title: Text(
                snapshot.data!.docs[index]['userName'],
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
              subtitle: Text(snapshot.data!.docs[index]['message']),
            ),
          ));
        }
      },
    );
  }
}
