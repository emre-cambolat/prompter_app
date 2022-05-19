import 'package:flutter/material.dart';
import 'package:wakelock/wakelock.dart';

import 'text_example.dart';

class ShowTextPageUI extends StatefulWidget {
  const ShowTextPageUI({Key? key}) : super(key: key);

  @override
  State<ShowTextPageUI> createState() => _ShowTextPageUIState();
}

class _ShowTextPageUIState extends State<ShowTextPageUI> {
  late ScrollController _scrollController;
  bool _isScroll = false;
  bool _reverseDirection = false;
  int _scrollSpeed = 60000;

  @override
  void initState() {
    _scrollController = ScrollController();
    super.initState();
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (_isScroll) {
      Wakelock.enable();
    } else {
      Wakelock.disable();
    }
    return Scaffold(
      appBar: AppBar(
        title: Text("Show Text"),
        leading: IconButton(
          onPressed: () {
            _isScroll = false;
            Navigator.pop(context);
          },
          icon: Icon(
            Icons.arrow_back,
          ),
        ),
      ),
      body: Stack(
        children: [
          Padding(
            padding: EdgeInsets.only(bottom: 26),
            child: SingleChildScrollView(
              controller: _scrollController,
              child: Text(
                uzun_text,
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 96,
                  height: 1.5,
                ),
              ),
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
                      _reverseDirection = false;
                      if (_isScroll == false) {
                        _moveScroll();
                      }
                    },
                    child: Text("Aşağı"),
                    style: ElevatedButton.styleFrom(
                      primary: Colors.green,
                    ),
                  ),
                  ElevatedButton(
                    onPressed: () {
                      _isScroll = false;
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
                      // Duration(
                      //   milliseconds: 100,
                      // );
                      // _isScroll = false;
                      _reverseDirection = true;
                      if (_isScroll == false) {
                        _moveScroll();
                      }
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
                            _scrollSpeed = _scrollSpeed + 2500;
                          });
                        },
                        child: Text("Slow"),
                        style: ElevatedButton.styleFrom(
                          primary: Colors.teal.shade400,
                        ),
                      ),
                      Text(_scrollSpeed.toString() + " ms."),
                      ElevatedButton(
                        onPressed: () {
                          setState(() {
                            _scrollSpeed = (_scrollSpeed - 2500) > 0
                                ? _scrollSpeed - 2500
                                : 1;
                            // debugPrint(
                            //     "Scroll Speed: " + scrollSpeed.toString());
                          });
                        },
                        child: Text("Fast"),
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

  void _moveScroll() {
    _isScroll = true;
    _scrollController
        .animateTo(
      _reverseDirection
          ? _scrollController.position.pixels - 10
          : _scrollController.position.pixels + 10,
      duration: Duration(
        // milliseconds: _scrollSpeed,
        microseconds: _scrollSpeed,
      ),
      curve: Curves.linear,
    )
        .whenComplete(
      () {
        if ((_scrollController.position.maxScrollExtent >=
                    _scrollController.position.pixels ||
                _scrollController.position.minScrollExtent <=
                    _scrollController.position.pixels) &&
            _isScroll) {
          _moveScroll();
        }
      },
    );
  }
}
