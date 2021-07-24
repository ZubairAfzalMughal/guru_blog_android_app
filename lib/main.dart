import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:guru_blog/models/connectivity_model.dart';
import 'package:guru_blog/screen/login.dart';
import 'package:guru_blog/screen/lottie_splash.dart';
import 'package:guru_blog/screen/register.dart';
import 'package:guru_blog/screen/update_profile.dart';
import 'package:provider/provider.dart';
import 'models/login_model.dart';
import 'screen/main_screen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(
          create: (_) => CheckConnection(),
        ),
        ChangeNotifierProvider(
          create: (_) => UserModel(),
        ),
      ],
      child: MyApp(),
    ),
  );
}

class MyApp extends StatefulWidget {
  // This widget is the root of your application.
  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    Provider.of<UserModel>(context).setCheck();
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        bottomNavigationBarTheme: BottomNavigationBarThemeData(
          selectedIconTheme: IconThemeData(color: Colors.purple),
        ),
        primaryColor: Colors.deepPurple,
        brightness: Brightness.light,
        textTheme: GoogleFonts.montserratTextTheme(
          Theme.of(context).textTheme,
        ),
      ),
      initialRoute:Register.id,
      routes: routes,
    );
  }

  Map<String, WidgetBuilder> routes = {
    LottieSplash.id: (context) => LottieSplash(),
    Register.id: (context) => Register(),
    Login.id: (context) => Login(),
    MainScreen.id: (context) => MainScreen(),
    // ignore: equal_keys_in_map
    UpdateProfile.id: (context) => UpdateProfile(),
  };
}
