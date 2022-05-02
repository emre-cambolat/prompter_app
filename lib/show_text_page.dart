import 'package:flutter/material.dart';
import 'package:prompter_app/text_example.dart';

class ShowTextPageUI extends StatefulWidget {
  const ShowTextPageUI({Key? key}) : super(key: key);

  @override
  State<ShowTextPageUI> createState() => _ShowTextPageUIState();
}

class _ShowTextPageUIState extends State<ShowTextPageUI> {
  late ScrollController scrollController;
  int scrollSpeed = 0;

  @override
  void initState() {
    scrollController = ScrollController();
    super.initState();
  }

  @override
  void dispose() {
    scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Show Text"),
      ),
      body: Stack(
        children: [
          Padding(
            padding: EdgeInsets.only(bottom: 26),
            child: SingleChildScrollView(
              controller: scrollController,
              child: Text(uzun_text),
            ),
          ),
          Positioned(
            bottom: 0,
            left: 0,
            right: 0,
            child: Container(
              padding: EdgeInsets.symmetric(vertical: 12),
              color: Colors.grey.shade300,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  ElevatedButton(
                    onPressed: () {
                      debugPrint(uzun_text.length.toString());
                      scrollController.animateTo(
                        scrollController.position.maxScrollExtent,
                        duration: Duration(
                          milliseconds: scrollController
                                  .position.maxScrollExtent
                                  .toInt() -
                              scrollController.position.pixels.toInt() +
                              scrollSpeed,
                        ),
                        curve: Curves.linear,
                      );
                    },
                    child: Text("Aşağı"),
                    style: ElevatedButton.styleFrom(
                      primary: Colors.green,
                    ),
                  ),
                  ElevatedButton(
                    onPressed: () {
                      debugPrint(uzun_text.length.toString());
                      scrollController.animateTo(
                        scrollController.position.pixels,
                        duration: Duration(milliseconds: 1),
                        curve: Curves.linear,
                      );
                    },
                    child: Text(
                      "DUR",
                      style: TextStyle(
                        color: Colors.black,
                      ),
                    ),
                    style: ElevatedButton.styleFrom(
                      primary: Colors.yellow,
                    ),
                  ),
                  ElevatedButton(
                    onPressed: () {
                      scrollController.animateTo(
                        scrollController.position.minScrollExtent,
                        duration: Duration(
                          milliseconds:
                              scrollController.position.pixels.toInt() -
                                  scrollController.position.minScrollExtent
                                      .toInt() +
                                  scrollSpeed,
                        ),
                        curve: Curves.linear,
                      );
                    },
                    child: Text("Yukarı"),
                    style: ElevatedButton.styleFrom(
                      primary: Colors.red,
                    ),
                  ),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      ElevatedButton(
                        onPressed: () {
                          setState(() {
                            scrollSpeed = scrollSpeed - 500;
                            debugPrint("Scroll Speed: " + scrollSpeed.toString());
                          });
                        },
                        child: Text("-"),
                        style: ElevatedButton.styleFrom(
                          primary: Colors.teal.shade400,
                        ),
                      ),
                      Text(scrollSpeed.toString() + " ms."),
                      ElevatedButton(
                        onPressed: () {
                          setState(() {
                            scrollSpeed = scrollSpeed + 500;
                            debugPrint("Scroll Speed: " + scrollSpeed.toString());
                          });
                        },
                        child: Text("+"),
                        style: ElevatedButton.styleFrom(
                          primary: Colors.teal.shade900,
                        ),
                      ),
                      
                    ],
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
