import 'package:connectivity/connectivity.dart';
import 'package:flutter/material.dart';
import 'package:guru_blog/models/connectivity_model.dart';
import 'package:guru_blog/screen/error_lottie.dart';
import 'package:guru_blog/screen/feed.dart';
import 'package:guru_blog/screen/profile.dart';
import 'package:guru_blog/screen/search.dart';
import 'package:guru_blog/screen/upload.dart';
import 'package:provider/provider.dart';

class MainScreen extends StatefulWidget {
  static const String id = "main_screen";

  @override
  _MainScreenState createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  @override
  void initState() {
    final result = Provider.of<CheckConnection>(context, listen: false);
    result.checkConnection();
    super.initState();
  }

  @override
  void dispose() {
    final result = Provider.of<CheckConnection>(context, listen: false);
    result.dispose();
    super.dispose();
  }

  int selectedIndex = 0;
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  Widget build(BuildContext context) {
    ConnectivityResult internet =
        context.watch<CheckConnection>().connectivityResult;
    final _widget = [
      Feed(),
      Upload(),
      Search(),
      Profile(),
    ];
    return Scaffold(
      key: _scaffoldKey,
      body: internet == ConnectivityResult.mobile ||
              internet == ConnectivityResult.wifi
          ? _widget[selectedIndex]
          : ErrorLottie(),
      bottomNavigationBar: BottomNavigationBar(
        showSelectedLabels: false,
        showUnselectedLabels: false,
        currentIndex: selectedIndex,
        onTap: (index) => setState(() => selectedIndex = index),
        type: BottomNavigationBarType.fixed,
        elevation: 3.0,
        backgroundColor: Color(0xFFf3f4ed),
        items: [
          BottomNavigationBarItem(icon: Icon(Icons.home_outlined), label: ""),
          BottomNavigationBarItem(icon: Icon(Icons.add_box_outlined), label: ''),
          BottomNavigationBarItem(icon: Icon(Icons.search_outlined), label: ""),
          BottomNavigationBarItem(
              icon: Icon(Icons.account_circle_outlined), label: ""),
        ],
      ),
    );
  }
}
