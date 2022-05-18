import 'package:flutter/material.dart';

class AppInfoUI extends StatefulWidget {
  const AppInfoUI({ Key? key }) : super(key: key);

  @override
  State<AppInfoUI> createState() => _AppInfoUIState();
}

class _AppInfoUIState extends State<AppInfoUI> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("App Info"),
      ),
    );
  }
}