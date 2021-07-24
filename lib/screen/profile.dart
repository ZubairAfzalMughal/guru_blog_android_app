import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:guru_blog/models/login_model.dart';
import 'package:guru_blog/screen/login.dart';
import 'package:guru_blog/screen/update_profile.dart';
import 'package:guru_blog/widgets/posts_carousel.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';
import '../widgets/custom_clipper.dart';
import 'dart:io';

class Profile extends StatefulWidget {
  @override
  _ProfileState createState() => _ProfileState();
}

class _ProfileState extends State<Profile> {
  late PageController _yourPostsPageController;

  @override
  void initState() {
    super.initState();
    _yourPostsPageController =
        PageController(initialPage: 0, viewportFraction: 0.8);
  }

  @override
  Widget build(BuildContext context) {
    final user = Provider.of<UserModel>(context);
    return Scaffold(
      appBar: AppBar(
          title: Text("Profile"),
          automaticallyImplyLeading: false,
          actions: [
            IconButton(
              onPressed: () {
                Provider.of<UserModel>(context, listen: false).logout();
                Navigator.pushNamedAndRemoveUntil(
                    context, Login.id, (route) => false);
              },
              icon: Icon(Icons.logout, color: Colors.white),
            ),
          ]),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            children: [
              Stack(
                alignment: Alignment.center,
                children: [
                  ClipPath(
                    clipper: ProfileClipper(),
                    child: GestureDetector(
                      onTap: () {
                        showImageOption(context);
                      },
                      child: CachedNetworkImage(
                        height: 300.0,
                        fit: BoxFit.cover,
                        width: double.infinity,
                        imageUrl: user.userData!.imgUrl,
                        placeholder: (context, url) =>
                            Center(child: CircularProgressIndicator()),
                        errorWidget: (context, url, error) => Image.asset(
                          'assets/images/empty_user.png',
                          height: 300.0,
                          width: double.infinity,
                          fit: BoxFit.cover,
                        ),
                      ),
                      // _pFile != null
                      //     ? CachedNetworkImage(
                      //         imageUrl: '',
                      //         placeholder: (context, url) =>
                      //             CircularProgressIndicator(),
                      //       )
                      //     : Image.asset(
                      //         'assets/images/empty_user.png',
                      //         height: 300,
                      //         width: MediaQuery.of(context).size.width,
                      //         fit: BoxFit.cover,
                      //       ),
                    ),
                  ),
                ],
              ),
              //Todo: Displaying user Data
              Container(
                height: 100.0,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    FutureBuilder<UserData?>(
                        future: Provider.of<UserModel>(context, listen: false)
                            .userInfo(),
                        builder: (context, snapshot) {
                          if (snapshot.connectionState ==
                              ConnectionState.waiting) {
                            return CircularProgressIndicator(
                              valueColor: AlwaysStoppedAnimation(
                                  Theme.of(context).primaryColor),
                            );
                          } else if (snapshot.connectionState ==
                              ConnectionState.none) {
                            return Text("Error");
                          }
                          return Consumer<UserModel>(
                            builder:
                                (BuildContext context, value, Widget? child) =>
                                    Column(
                              children: [
                                Row(
                                  children: [
                                    Text(
                                      value.userData!.name,
                                      style: TextStyle(
                                        fontSize: 25.0,
                                        fontWeight: FontWeight.bold,
                                        letterSpacing: 1.5,
                                      ),
                                    ),
                                    IconButton(
                                      onPressed: () {
                                        Navigator.pushNamed(
                                            context, UpdateProfile.id);
                                      },
                                      icon: Icon(Icons.open_in_new),
                                    ),
                                  ],
                                ),
                                Text(
                                  value.userData!.email,
                                  style: TextStyle(
                                      letterSpacing: 1.5,
                                      color: Theme.of(context).primaryColor),
                                ),
                              ],
                            ),
                          );
                        }),
                  ],
                ),
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: <Widget>[
                  Column(
                    children: <Widget>[
                      Text(
                        'Posts',
                        style: TextStyle(
                          color: Colors.black54,
                          fontSize: 22.0,
                        ),
                      ),
                      SizedBox(height: 2.0),
                      StreamBuilder<QuerySnapshot>(
                          stream: Provider.of<UserModel>(context).fetchPost(),
                          builder: (context, snapshot) {
                            if (snapshot.connectionState ==
                                ConnectionState.waiting) {
                              return CircularProgressIndicator(
                                valueColor: AlwaysStoppedAnimation(
                                    Theme.of(context).primaryColor),
                              );
                            }
                            return Text(
                              snapshot.data!.docs.isEmpty
                                  ? '0'
                                  : snapshot.data!.docs.length.toString(),
                              style: TextStyle(
                                fontSize: 20.0,
                                fontWeight: FontWeight.w600,
                              ),
                            );
                          }),
                    ],
                  ),
                  Column(
                    children: [
                      Text(
                        "Comments",
                        style: TextStyle(
                          color: Colors.black54,
                          fontSize: 22.0,
                        ),
                      ),
                      Text(
                        "10",
                        style: TextStyle(
                          fontSize: 20.0,
                          fontWeight: FontWeight.w600,
                        ),
                      )
                    ],
                  ),
                ],
              ),
              PostsCarousel(
                pageController: _yourPostsPageController,
              ),
            ],
          ),
        ),
      ),
    );
  }

  showImageOption(context) {
    return showDialog(
      context: context,
      builder: (context) {
        return SimpleDialog(
          title: const Text('Select Option'),
          children: <Widget>[
            SimpleDialogOption(
              onPressed: () {
                Navigator.pop(context);
              },
              child: const Text('View Image'),
            ),
            SizedBox(
              height: 10.0,
            ),
            SimpleDialogOption(
              onPressed: () {
                SnackBar snackBar = SnackBar(
                  backgroundColor: Theme.of(context).primaryColor,
                  content: Text("Uploading..."),
                  duration: Duration(seconds: 2),
                );
                ScaffoldMessenger.of(context).showSnackBar(snackBar);
                uploadProfile();
                //Showing Message after profile image uploaded
                SnackBar snackBar1 = SnackBar(
                  backgroundColor: Theme.of(context).primaryColor,
                  content: Text("Uploaded Successfully.."),
                  duration: Duration(seconds: 2),
                );
                ScaffoldMessenger.of(context)
                  ..removeCurrentSnackBar()
                  ..showSnackBar(snackBar1);
                Navigator.pop(context);
              },
              child: const Text('Change Image'),
            ),
          ],
        );
      },
    );
  }

  File? _pFile;

  uploadProfile() async {
    final userProvider = Provider.of<UserModel>(context, listen: false);
    try {
      final _picker = ImagePicker();
      PickedFile? _pickedImage =
          await _picker.getImage(source: ImageSource.gallery);
      setState(() {
        _pFile = File(_pickedImage!.path);
      });
      userProvider.uploadProfileImg(_pFile!, userProvider.userData!.name);
    } catch (e) {
      print(e.toString());
    }
  }
}
