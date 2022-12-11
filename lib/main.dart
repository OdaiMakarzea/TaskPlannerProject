import 'package:flutter/material.dart';
import 'inbox.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Inbox',
      theme: ThemeData(
        primarySwatch: Colors.indigo,
        primaryColor: Colors.white24
      ),
      home:const InboxPage(),
    );
  }
}
