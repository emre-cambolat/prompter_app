import 'package:flutter/material.dart';
import 'package:prompter_app/pages/app_info.dart';
import 'package:prompter_app/pages/select_text.dart';
import 'package:prompter_app/pages/set_text_style.dart';
import 'package:universal_platform/universal_platform.dart';
import 'set_keys.dart';

class KeyEventPageUI extends StatefulWidget {
  const KeyEventPageUI({Key? key}) : super(key: key);

  @override
  _KeyEventPageUIState createState() => _KeyEventPageUIState();
}

class _KeyEventPageUIState extends State<KeyEventPageUI> {
  String _pressedKey = " ";
  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {

    return Scaffold(
      appBar: AppBar(
        title: Text("Ana Sayfa"),
        actions: [
          IconButton(
            onPressed: () {
              _openPage(page: AppInfoUI());
            },
            icon: Icon(
              Icons.info,
            ),
          ),
        ],
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Spacer(
            flex: 3,
          ),
          Text("DateTime: " + DateTime.now().toString()),
          SizedBox(
            height: 40,
          ),
          // FittedBox(
          //   child: Row(
          //     mainAxisAlignment: MainAxisAlignment.center,
          //     crossAxisAlignment: CrossAxisAlignment.center,
          //     children: [
          //       Text(
          //         "connected",
          //         textAlign: TextAlign.center,
          //         style: TextStyle(
          //           color: Colors.red,
          //           fontWeight: FontWeight.bold,
          //           fontSize: 24,
          //         ),
          //       ),
          //     ],
          //   ),
          // ),
          // SizedBox(
          //   height: 40,
          // ),
          // TextField(),
          Container(
            margin: EdgeInsets.symmetric(horizontal: 16),
            padding: EdgeInsets.symmetric(horizontal: 8, vertical: 12),
            decoration: BoxDecoration(
              color: Colors.grey.shade400,
              borderRadius: BorderRadius.circular(8),
              border: Border.all(
                color: Colors.black,
              ),
            ),
            child: Column(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Expanded(
                      child: Text(
                        "Pressed Key",
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          color: Colors.black54,
                          fontSize: 32,
                        ),
                      ),
                    ),
                  ],
                ),
                FittedBox(
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Text(
                        _pressedKey,
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          color: Colors.red,
                          fontWeight: FontWeight.bold,
                          fontSize: 24,
                        ),
                      ),
                    ],
                  ),
                ),
                TextField(
                  ),
              ],
            ),
          ),
          Spacer(
            flex: 4,
          ),
          SizedBox(
            width: MediaQuery.of(context).size.width / 1.2,
            child: ElevatedButton(
              onPressed: () {
                _openPage(page: SelectTextUI());
              },
              child: Text("Metin Seç"),
            ),
          ),
          _webPadding(),
          SizedBox(
            width: MediaQuery.of(context).size.width / 1.2,
            child: ElevatedButton(
              onPressed: () {
                _openPage(page: SetTextStyleUI());
              },
              child: Text("Metin Stilini Ayarla"),
            ),
          ),
          _webPadding(),

          SizedBox(
            width: MediaQuery.of(context).size.width / 1.2,
            child: ElevatedButton(
              onPressed: () {
                _openPage(page: SetKeysUI());
                // FirebaseService.updatePrompterSettings({'scroll_spedd':70000});
              },
              child: Text("Tuşları Ayarla"),
            ),
          ),
          // SizedBox(
          //   width: MediaQuery.of(context).size.width / 1.2,
          //   child: ElevatedButton(
          //     style: ElevatedButton.styleFrom(
          //       primary: Colors.green,
          //     ),
          //     onPressed: () {
          //       _openPage(page: ShowTextPageUI());
          //     },
          //     child: Text("Devam Et"),
          //   ),
          // ),
          Spacer(),
        ],
      ),
    );
  }

  void _openPage({required Widget page}) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: ((context) => page),
      ),
    );
  }

  Widget _webPadding() {
    return UniversalPlatform.isWeb
        ? SizedBox(
            height: 20,
          )
        : SizedBox.shrink();
  }
}
