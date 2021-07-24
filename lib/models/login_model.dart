import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:firebase_storage/firebase_storage.dart';

class UserModel with ChangeNotifier {
  //Firebase Cloud Reference
  FirebaseFirestore _collectionReference = FirebaseFirestore.instance;

  //Firebase Storage Reference
  Reference _firebaseStorage = FirebaseStorage.instance.ref();
  FirebaseAuth auth = FirebaseAuth.instance;
  String _error = "";
  User? _user;

  //Reading Data From User
  UserData? userData;

  User? get user => _user;

  String get error => _error;

  setCheck() {
    auth.authStateChanges().listen((User? user) {
      _user = user;
    });
  }

  //_____________________________________________________________________
  //Register User to DataBase
  Future<bool> register(String email, String password, String name) async {
    try {
      UserCredential userCredential = await FirebaseAuth.instance
          .createUserWithEmailAndPassword(email: email, password: password);
      _user = userCredential.user;
    } catch (e) {
      _error = e.toString();
      return false;
    }
    //Adding User to Cloud FireStore
    _collectionReference.collection('users').doc(_user?.uid).set({
      'id': _user?.uid,
      'name': name,
      'email': email,
      'imgUrl': '',
      'bgImgUrl': ''
    });
    SharedPreferences preferences = await SharedPreferences.getInstance();
    preferences.setString('key', _user!.uid);
    notifyListeners();
    return true;
  }

  // Logging out User

  void logout() async {
    await auth.signOut();
  }

  //Logging User from firebase Database
  Future<bool> login(String email, String password) async {
    try {
      UserCredential userCredential = await FirebaseAuth.instance
          .signInWithEmailAndPassword(email: email, password: password);
      _user = userCredential.user;
    } catch (e) {
      _error = e.toString();
      return false;
    }
    notifyListeners();
    return true;
  }

  //Read Data From FireStore
  Future<UserData?> userInfo() async {
    DocumentSnapshot doc =
        await _collectionReference.collection('users').doc(_user?.uid).get();
    if (doc.exists) userData = UserData.fromSnapShot(doc);
    return userData;
  }

  //updating User
  updateUser(String? name) {
    _collectionReference.collection('users').doc(_user?.uid).set({
      'id': _user?.uid,
      'name': name,
      'email': _user?.email,
      'imgUrl': '',
      'bgImgUrl': ''
    });
  }

  //uploading profile image
  uploadProfileImg(File file, String name) async {
    try {
      //Create a reference to the location you want to upload to in firebase
      Reference ref = _firebaseStorage.child("${user!.uid}" + "profile");
      //StorageUpload task is used to put the data you want in storage
      //Make sure to get the image first before calling this method otherwise _image will be null.
      UploadTask uploadTask = ref.child("${DateTime.now()}.jpg").putFile(file);
      TaskSnapshot snapshot = await uploadTask.whenComplete(() {});
      final String url = (await snapshot.ref.getDownloadURL());
      print(url);
      //Uploading Image to Cloud FireStore In our Collections
      _collectionReference.collection('users').doc(_user?.uid).set({
        'id': _user?.uid,
        'name': name,
        'email': _user?.email,
        'imgUrl': url,
        'bgImgUrl': ''
      });
    } catch (e) {
      print(e.toString());
    }
    notifyListeners();
  }

  // Uploading Post to Data base
  uploadPost(
      File file, String? interest, String? title, String? description) async {
    try {
      //Create a reference to the location you want to upload to in firebase
      Reference ref = _firebaseStorage.child("${user!.uid}");
      //StorageUpload task is used to put the data you want in storage
      //Make sure to get the image first before calling this method otherwise _image will be null.
      UploadTask uploadTask = ref.child("${DateTime.now()}.jpg").putFile(file);
      TaskSnapshot snapshot = await uploadTask.whenComplete(() {});
      final String url = (await snapshot.ref.getDownloadURL());
      print(url);
      //Uploading Post to Cloud FireStore In our Collections
      _collectionReference.collection('posts/${_user!.uid}/post').add({
        'title': title,
        'createAt': DateTime.now(),
        'desc': description,
        'userId': _user?.uid,
        'url': url.toString(),
        'interest': interest
      });
      //Uploading Post in General Post Collections
      _collectionReference.collection('All Posts').add({
        'title': title,
        'createAt': DateTime.now(),
        'desc': description,
        'userId': _user?.uid,
        'url': url.toString(),
        'interest': interest
      });
    } catch (e) {
      print(e.toString());
    }
    notifyListeners();
  }

  //Fetching Posts

  Stream<QuerySnapshot> fetchPost() {
    return _collectionReference
        .collection('posts/${_user!.uid}/post')
        .snapshots();
  }

  //Fetch General Posts
  Stream<QuerySnapshot> allPost() {
    return _collectionReference
        .collection('All Posts')
        .orderBy('createAt')
        .snapshots();
  }

  //Uploading Comments on Post
  uploadComments(String? id, String message) {
    _collectionReference
        .collection('comments')
        .doc(id)
        .collection('comment')
        .add({
      'CreatedAt': DateTime.now(),
      'message': message,
      'userName': userData!.name,
    });
  }

  //Fetching Comments
  Stream<QuerySnapshot> fetchComments(String id) {
    return _collectionReference
        .collection('comments')
        .doc(id)
        .collection('comment')
        .orderBy('CreatedAt')
        .snapshots();
  }
}

class UserData {
  late String name;
  late String email;
  late String imgUrl;
  late String bgImgUrl;
  late String id;

  UserData({
    required this.id,
    required this.name,
    required this.email,
    required this.bgImgUrl,
    required this.imgUrl,
  });

  // This is for reading data from firebase
  factory UserData.fromSnapShot(DocumentSnapshot docs) {
    return UserData(
      id: docs.get('id'),
      name: docs.get('name'),
      email: docs.get('email'),
      bgImgUrl: docs.get('bgImgUrl'),
      imgUrl: docs.get('imgUrl'),
    );
  }
}
