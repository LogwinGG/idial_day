import 'package:flutter/material.dart';
import 'package:idial_day/di.dart';
import 'package:idial_day/screens/main_screen.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Идеальный день',
      debugShowCheckedModeBanner: false,
      theme: ThemeData.dark().copyWith(
        textTheme: TextTheme().copyWith(
          titleMedium: TextStyle(color: Colors.black),
        ),
      ),
      home: FutureBuilder(
        future: DI.getInstance().init(),
        builder: (context,snapshot) {
          if(snapshot.connectionState == ConnectionState.done) {
            return const MainScreen();}
          else {return const Center(child: CircularProgressIndicator());}
        }
      ),
    );
  }
}

