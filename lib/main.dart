import 'package:flutter/material.dart';
import 'package:prompter_app/components/app_colors.dart';
import 'pages/key_event_page.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Prompter App',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSwatch().copyWith(
          primary: AppColors.primaryColor,
          secondary: AppColors.darkGrey,

          // or from RGB
        ),
      ),
      home: const KeyEventPageUI(),
    );
  }
}
