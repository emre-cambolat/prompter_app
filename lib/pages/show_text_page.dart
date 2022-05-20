import 'package:flutter/material.dart';
import 'package:wakelock/wakelock.dart';

import '../services/firebase_services.dart';

class ShowTextPageUI extends StatefulWidget {
  const ShowTextPageUI(
      {Key? key,
      required this.title,
      required this.content,
      required this.textStyle,
      required this.prompterSettings})
      : super(key: key);

  final String title;
  final String content;
  final Map<String, dynamic> textStyle;
  final Map<String, dynamic> prompterSettings;

  @override
  State<ShowTextPageUI> createState() => _ShowTextPageUIState();
}

class _ShowTextPageUIState extends State<ShowTextPageUI> {
  late ScrollController _scrollController;
  bool _isScroll = false;
  bool _reverseDirection = false;
  // int _scrollSpeed = 60000;

  List<FontWeight> _fontWeight = [
    FontWeight.w100,
    FontWeight.w200,
    FontWeight.w300,
    FontWeight.w400,
    FontWeight.w500,
    FontWeight.w600,
    FontWeight.w700,
    FontWeight.w800,
    FontWeight.w900,
  ];

  List<FontStyle> _fontStyle = [
    FontStyle.normal,
    FontStyle.italic,
  ];

  late bool _isLoading;
  late FocusNode _focusNode;
  late Map<String, dynamic> _prompterSettings;

  @override
  void initState() {
    _scrollController = ScrollController();
    _focusNode = FocusNode();
    _prompterSettings = widget.prompterSettings;
    _isLoading = true;

    super.initState();
  }

  @override
  void dispose() {
    _scrollController.dispose();
    _focusNode.dispose();
    super.dispose();
  }

  _saveChanges() {
    FirebaseService.updatePrompterSettings(_prompterSettings);
  }

  @override
  Widget build(BuildContext context) {
    FocusScope.of(context).requestFocus(_focusNode);

    return WillPopScope(
      onWillPop: () async {
        await _saveChanges();
        return true;
      },
      child: RawKeyboardListener(
        autofocus: true,
        focusNode: _focusNode,
        onKey: (event) {
        
          
          debugPrint("---------------------4  " + event.logicalKey.toString());
          debugPrint("---------------------4  " + event.toString());

          // // ! Web
          // debugPrint("---------------------4  " + event.data.toString());
          // if (event.data.toString().contains("AudioVolumeUp")) {
          //   debugPrint("girdiiiii");
          //   _fastButton();
          // } else if (event.data.toString().contains("AudioVolumeDown")) {
          //   _slowButton();
          // } else if (event.data.toString().contains("MediaPlayPause")) {
          //   _stopButton();
          // } else if (event.data.toString().contains("MediaTrackNext")) {
          //   _downScrollButton();
          // } else if (event.data.toString().contains("MediaTrackPrevious")) {
          //   _upScrollButton();
          // }
          // ! Web
        },
        child: Scaffold(
          backgroundColor:
              Color(int.parse(_prompterSettings["background_color"])),
          appBar: AppBar(
            title: Text(widget.title),
            leading: IconButton(
              onPressed: () async {
                _isScroll = false;
                await _saveChanges();
                Navigator.pop(context);
              },
              icon: Icon(
                Icons.arrow_back,
              ),
            ),
          ),
          body: Column(
            children: [
              Expanded(
                child: SingleChildScrollView(
                  controller: _scrollController,
                  child: Padding(
                    padding: const EdgeInsets.all(4.0),
                    child: Text(
                      widget.content,
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        height: double.parse(
                            widget.textStyle["font_height"].toString()),
                        fontSize: double.parse(
                            widget.textStyle["font_size"].toString()),
                        fontStyle: _fontStyle[widget.textStyle["font_style"]],
                        fontWeight:
                            _fontWeight[widget.textStyle["font_weight"]],
                        letterSpacing: double.parse(
                            widget.textStyle["letter_spacing"].toString()),
                        color: Color(int.parse(widget.textStyle["text_color"])),
                      ),
                    ),
                  ),
                ),
              ),
              Container(
                width: double.infinity,
                padding: EdgeInsets.symmetric(vertical: 12),
                color: Colors.grey.shade300,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    ElevatedButton(
                      onPressed: () {
                        _downScrollButton();
                      },
                      child: Text("Aşağı"),
                      style: ElevatedButton.styleFrom(
                        primary: Colors.green,
                      ),
                    ),
                    ElevatedButton(
                      onPressed: () {
                        _stopButton();
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
                        _upScrollButton();
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
                            _slowButton();
                          },
                          child: Text("Yavaş"),
                          style: ElevatedButton.styleFrom(
                            primary: Colors.teal.shade400,
                          ),
                        ),
                        Text(_prompterSettings["scroll_speed"].toString() +
                            " ms."),
                        ElevatedButton(
                          onPressed: () {
                            _fastButton();
                          },
                          child: Text("Hızlı"),
                          style: ElevatedButton.styleFrom(
                            primary: Colors.teal.shade900,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
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
        microseconds: _prompterSettings["scroll_speed"],
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

  void _slowButton() {
    setState(() {
      _prompterSettings["scroll_speed"] =
          _prompterSettings["scroll_speed"] + 2500;
    });
  }

  void _fastButton() {
    setState(() {
      _prompterSettings["scroll_speed"] =
          (_prompterSettings["scroll_speed"] - 2500) > 0
              ? _prompterSettings["scroll_speed"] - 2500
              : 1;
    });
  }

  void _stopButton() {
    _isScroll = false;
    Wakelock.disable();
  }

  void _upScrollButton() {
    _reverseDirection = true;
    if (_isScroll == false) {
      Wakelock.enable();
      _moveScroll();
    }
  }

  void _downScrollButton() {
    _reverseDirection = false;
    if (_isScroll == false) {
      Wakelock.enable();
      _moveScroll();
    }
  }
}
