import 'package:flutter/material.dart';

class SelectTextUI extends StatefulWidget {
  const SelectTextUI({ Key? key }) : super(key: key);

  @override
  State<SelectTextUI> createState() => _SelectTextUIState();
}

class _SelectTextUIState extends State<SelectTextUI> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Select Text"),
      ),
    );
  }
}