import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:search_app/searchscreen.dart';
import 'package:hive/hive.dart';
import 'package:hive_flutter/hive_flutter.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  SystemChrome.setPreferredOrientations(
      [DeviceOrientation.portraitUp, DeviceOrientation.portraitDown]);
  await Hive.initFlutter();
  await Hive.openBox('search');
  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    Box box = Hive.box('search');

    box.add("People");
    box.add("India");
    box.add("Animal");
    box.add("Nature");
    box.add("Earth");

    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: SearchScreen(box: box),
    );
  }
}
