import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:universal_platform/universal_platform.dart';
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
  late FocusNode _fnListener;
  late FocusNode _fnTextField;
  // late FocusAttachment _focusAttachment;
  late Map<String, dynamic> _prompterSettings;

  @override
  void initState() {
    _scrollController = ScrollController();
    _fnListener = FocusNode();
    _fnTextField = FocusNode();
    _prompterSettings = widget.prompterSettings;
    _isLoading = true;
    // if (UniversalPlatform.isAndroid) {
    //   _focusAttachment = _fnListener.attach(context, onKeyEvent: (node, event) {
    //     print("eventttt");
    //     if (event.logicalKey == LogicalKeyboardKey.audioVolumeDown) {
    //       print("value : enter");
    //     }
    //     return KeyEventResult.handled;
    //   });
    // }
    _fnTextField.requestFocus();
    super.initState();
  }

  @override
  void dispose() {
    _scrollController.dispose();
    _fnListener.dispose();
    _fnTextField.dispose();
    super.dispose();
  }

  _saveChanges() {
    FirebaseService.updatePrompterSettings(_prompterSettings);
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        await _saveChanges();
        return true;
      },
      child: RawKeyboardListener(
        autofocus: true,
        focusNode: _fnListener,
        onKey: (event) {
          // debugPrint("---------------------4  " + event.logicalKey.toString());
          debugPrint(
              "---------------------4  " + event.logicalKey.keyId.toString());

          if (UniversalPlatform.isWeb) {
            debugPrint("---------------------4  " + event.data.toString());
            if (event.data.toString().contains("AudioVolumeUp")) {
              _fastButton();
            } else if (event.data.toString().contains("AudioVolumeDown")) {
              _slowButton();
            } else if (event.data.toString().contains("MediaPlayPause")) {
              _pauseButton();
            } else if (event.data.toString().contains("MediaTrackNext")) {
              _downScrollButton();
            } else if (event.data.toString().contains("MediaTrackPrevious")) {
              _upScrollButton();
            }
          } else {
            if (event.isKeyPressed(LogicalKeyboardKey.audioVolumeUp)) {
              _fastButton();
            } else if (event.isKeyPressed(LogicalKeyboardKey.audioVolumeDown)) {
              _slowButton();
            } else if (event.isKeyPressed(LogicalKeyboardKey.mediaPlayPause)) {
              _pauseButton();
            } else if (event.isKeyPressed(LogicalKeyboardKey.mediaTrackNext)) {
              _downScrollButton();
            } else if (event
                .isKeyPressed(LogicalKeyboardKey.mediaTrackPrevious)) {
              _upScrollButton();
            }
          }
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
                  children: [
                    Expanded(
                      flex: 4,
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
                              _pauseButton();
                            },
                            child: Text(
                              _isScroll ? "DUR" : "BAŞLAT",
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
                        ],
                      ),
                    ),
                    Expanded(
                      flex: 1,
                      child: Column(
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
    int _pixel = UniversalPlatform.isWeb ? 20 : 10;
    setState(() {
      _isScroll = true;
      _scrollController
          .animateTo(
        _reverseDirection
            ? _scrollController.position.pixels - _pixel
            : _scrollController.position.pixels + _pixel,
        duration: UniversalPlatform.isWeb
            ? Duration(
                // milliseconds: _prompterSettings["scroll_speed"],
                microseconds: _prompterSettings["scroll_speed"],
                // seconds: 1,
              )
            : Duration(
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
    });
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

  void _pauseButton() {
    setState(() {
      if (_isScroll) {
        _isScroll = false;
        Wakelock.disable();
      } else {
        if (_reverseDirection) {
          _upScrollButton();
        } else {
          _downScrollButton();
        }
      }
    });
  }

  void _upScrollButton() {
    setState(() {
      _reverseDirection = true;
      if (_isScroll == false) {
        Wakelock.enable();
        _moveScroll();
      }
    });
  }

  void _downScrollButton() {
    setState(() {
      _reverseDirection = false;
      if (_isScroll == false) {
        Wakelock.enable();
        _moveScroll();
      }
    });
  }
}
