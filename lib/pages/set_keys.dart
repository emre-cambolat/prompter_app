import 'package:flutter/material.dart';

class SetKeysUI extends StatefulWidget {
  const SetKeysUI({ Key? key }) : super(key: key);

  @override
  State<SetKeysUI> createState() => _SetKeysUIState();
}

class _SetKeysUIState extends State<SetKeysUI> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Tuşları Ayarla"),
      ),
    );
  }
}