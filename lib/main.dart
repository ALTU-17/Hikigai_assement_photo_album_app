import 'package:flutter/material.dart';
import 'package:photo_album_app/SplashScreen.dart';
import 'package:provider/provider.dart';

import 'HomeScreen.dart';
import 'AppStateMange/imgPro.dart';

void main() {
  runApp(
    ChangeNotifierProvider(
      create: (context) => ImageProvider1(),
      child: MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Photo Album App',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: SplashScreen(),
    );
  }
}