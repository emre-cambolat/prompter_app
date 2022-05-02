import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:prompter_app/show_text_page.dart';

class KeyEventPageUI extends StatefulWidget {
  const KeyEventPageUI({Key? key}) : super(key: key);

  @override
  _KeyEventPageUIState createState() => _KeyEventPageUIState();
}

class _KeyEventPageUIState extends State<KeyEventPageUI> {
  late FocusNode fnListener;
  String pressedKey = " ";
  @override
  void initState() {
    fnListener = FocusNode();
    super.initState();
  }

  @override
  void dispose() {
    fnListener.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    FocusScope.of(context).requestFocus(fnListener);

    return RawKeyboardListener(
      autofocus: true,
      focusNode: fnListener,
      onKey: (event) {
        setState(
          () {
            pressedKey = event.logicalKey.debugName.toString();
            print(event.toStringShort());
            // pressedKey = event.toString();
            debugPrint("---------------------" + event.data.toStringShort());
            // FocusScope.of(context).requestFocus(fnListener);
          },
        );
      },
      child: Scaffold(
        appBar: AppBar(
          title: Text("Key Event Page"),
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
            FittedBox(
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Text(
                    "connected",
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
            SizedBox(
              height: 40,
            ),
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
                          pressedKey,
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
                ],
              ),
            ),
            Spacer(
              flex: 4,
            ),
            // TextButton(
            //   onPressed: () {
            //     Navigator.push(
            //       context,
            //       MaterialPageRoute(
            //         builder: (context) => ShowTextPageUI(),
            //       ),
            //     );
            //   },
            //   child: Text("Contiune"),
            // ),
            SizedBox(
              width: MediaQuery.of(context).size.width/1.2,
              child: ElevatedButton(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => ShowTextPageUI(),
                    ),
                  );
                },
                child:  Text("Contiune"),
              ),
            ),
            Spacer(),
          ],
        ),
      ),
    );
  }
}
