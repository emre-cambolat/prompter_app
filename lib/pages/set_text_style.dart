import 'package:flutter/material.dart';

class SetTextStyleUI extends StatefulWidget {
  const SetTextStyleUI({Key? key}) : super(key: key);

  @override
  State<SetTextStyleUI> createState() => _SetTextStyleUIState();
}

class _SetTextStyleUIState extends State<SetTextStyleUI> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Set Text Style"),
      ),
    );
  }
}
