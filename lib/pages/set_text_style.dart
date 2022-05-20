import 'package:flutter/material.dart';
import 'package:prompter_app/components/app_colors.dart';
import 'package:prompter_app/components/loading_indicator.dart';
import 'package:prompter_app/services/firebase_services.dart';
import 'package:flutter_colorpicker/flutter_colorpicker.dart';

class SetTextStyleUI extends StatefulWidget {
  const SetTextStyleUI({Key? key}) : super(key: key);

  @override
  State<SetTextStyleUI> createState() => _SetTextStyleUIState();
}

class _SetTextStyleUIState extends State<SetTextStyleUI> {
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

  late Map<String, dynamic> _prompterSettings;
  late Map<String, dynamic> _textStyle;

  late bool _isLoading;
  bool _isChange = false;

  @override
  void initState() {
    _isLoading = true;
    FirebaseService.getData().then((value) {
      _textStyle = Map<String, dynamic>.from(value["text_style"]);
      _prompterSettings = Map<String, dynamic>.from(value["prompter_settings"]);
      debugPrint(_prompterSettings.toString());
      setState(() {
        _isLoading = false;
      });
    });
    super.initState();
  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
  }

  _saveChanges() {
    if (_isChange) {
      FirebaseService.updateTextStyle(_textStyle);
      FirebaseService.updatePrompterSettings(_prompterSettings);
    }
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        await _saveChanges();
        return true;
      },
      child: Scaffold(
        appBar: AppBar(
          title: Text("Metin Stilini Ayarla"),
          leading: IconButton(
            onPressed: () async {
              await _saveChanges();
              Navigator.pop(context);
            },
            icon: Icon(Icons.arrow_back),
          ),
        ),
        body: SafeArea(
          child: _isLoading
              ? loadingIndicator()
              : Column(
                  children: [
                    Padding(
                      padding: EdgeInsets.only(top: 8.0),
                      child: Wrap(
                        runSpacing: 8,
                        spacing: 12,
                        children: [
                          _setBox(
                            setText: double.parse(
                                    _textStyle["font_height"].toString())
                                .toStringAsFixed(1),
                            leftChild: _setIcon(
                              positiveColor: true,
                              icon: Icons.format_line_spacing,
                              onTap: () {
                                _textStyle["font_height"] =
                                    _textStyle["font_height"] + 0.1;
                              },
                            ),
                            rightChild: _setIcon(
                              icon: Icons.format_line_spacing,
                              onTap: () {
                                if (_textStyle["font_height"] - 0.1 > 0.5) {
                                  _textStyle["font_height"] =
                                      _textStyle["font_height"] - 0.1;
                                }
                              },
                            ),
                          ),
                          _setBox(
                            setText: _textStyle["font_size"].toString(),
                            leftChild: _setIcon(
                              positiveColor: true,
                              icon: Icons.text_fields,
                              onTap: () {
                                _textStyle["font_size"] =
                                    _textStyle["font_size"] + 2;
                              },
                            ),
                            rightChild: _setIcon(
                              icon: Icons.text_fields,
                              onTap: () {
                                if (_textStyle["font_size"] - 2 > 0) {
                                  _textStyle["font_size"] =
                                      _textStyle["font_size"] - 2;
                                }
                              },
                            ),
                          ),
                          _setBox(
                            setText: "",
                            leftChild: _setIcon(
                              positiveColor:
                                  _textStyle["font_style"] == 0 ? false : true,
                              icon: Icons.format_italic,
                              onTap: () {
                                if (_textStyle["font_style"] == 0) {
                                  _textStyle["font_style"] = 1;
                                } else {
                                  _textStyle["font_style"] = 0;
                                }
                              },
                            ),
                            rightChild: SizedBox.shrink(),
                          ),
                          _setBox(
                            setText: _fontWeight[_textStyle["font_weight"]]
                                .toString()
                                .split(RegExp(r"\."))
                                .last,
                            leftChild: _setIcon(
                              positiveColor: true,
                              icon: Icons.format_bold,
                              onTap: () {
                                if (_textStyle["font_weight"] + 1 < 8) {
                                  _textStyle["font_weight"]++;
                                }
                              },
                            ),
                            rightChild: _setIcon(
                              icon: Icons.format_bold,
                              onTap: () {
                                if (_textStyle["font_weight"] - 1 >= 0) {
                                  _textStyle["font_weight"]--;
                                }
                              },
                            ),
                          ),
                          _setBox(
                            setText: double.parse(
                                    _textStyle["letter_spacing"].toString())
                                .toStringAsFixed(1),
                            leftChild: _setIcon(
                              positiveColor: true,
                              icon: Icons.format_textdirection_l_to_r_outlined,
                              onTap: () {
                                _textStyle["letter_spacing"] =
                                    _textStyle["letter_spacing"] + 0.2;
                              },
                            ),
                            rightChild: _setIcon(
                              icon: Icons.format_textdirection_l_to_r_outlined,
                              onTap: () {
                                if (_textStyle["letter_spacing"] >= 0) {
                                  _textStyle["letter_spacing"] =
                                      _textStyle["letter_spacing"] - 0.2;
                                }
                              },
                            ),
                          ),
                          _setBox(
                            setText: "Metin Rengi",
                            leftChild: SizedBox.shrink(),
                            rightChild: InkWell(
                              onTap: () {
                                showDialog(
                                  context: context,
                                  builder: (context) {
                                    return AlertDialog(
                                      content: SingleChildScrollView(
                                        child: ColorPicker(
                                          pickerColor: Color(int.parse(
                                              _textStyle["text_color"])),
                                          onColorChanged: (color) {
                                            _isChange = true;
                                            _textStyle["text_color"] = color
                                                .toString()
                                                .replaceAll(RegExp(r"\)"), "")
                                                .split(RegExp(r"\("))
                                                .last;
                                          },
                                        ),
                                      ),
                                    );
                                  },
                                ).whenComplete(() {
                                  setState(() {});
                                });
                              },
                              child: Container(
                                width: 32,
                                height: 28,
                                color:
                                    Color(int.parse(_textStyle["text_color"])),
                              ),
                            ),
                          ),
                          _setBox(
                            setText: "Arkaplan Rengi",
                            leftChild: SizedBox.shrink(),
                            rightChild: InkWell(
                              onTap: () {
                                showDialog(
                                  context: context,
                                  builder: (context) {
                                    return AlertDialog(
                                      content: SingleChildScrollView(
                                        child: ColorPicker(
                                          pickerColor: Color(int.parse(
                                              _prompterSettings[
                                                  "background_color"])),
                                          onColorChanged: (color) {
                                            _isChange = true;
                                            _prompterSettings[
                                                    "background_color"] =
                                                color
                                                    .toString()
                                                    .replaceAll(
                                                        RegExp(r"\)"), "")
                                                    .split(RegExp(r"\("))
                                                    .last;
                                          },
                                        ),
                                      ),
                                    );
                                  },
                                ).whenComplete(() {
                                  setState(() {});
                                });
                              },
                              child: Container(
                                width: 32,
                                height: 28,
                                color: Color(int.parse(
                                    _prompterSettings["background_color"])),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    Expanded(
                      child: Container(
                        margin: EdgeInsets.all(8),
                        padding: EdgeInsets.all(8),
                        decoration: BoxDecoration(
                          border: Border.all(),
                          color: Color(
                              int.parse(_prompterSettings["background_color"])),
                        ),
                        child: SingleChildScrollView(
                          primary: false,
                          physics: BouncingScrollPhysics(),
                          child: Text(
                            "Deneme yazısı. Yukarıdaki tuşlardan metin stilini ayarlarlayabilirsiniz.",
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              height: double.parse(
                                  _textStyle["font_height"].toString()),
                              fontSize: double.parse(
                                  _textStyle["font_size"].toString()),
                              fontStyle: _fontStyle[_textStyle["font_style"]],
                              fontWeight:
                                  _fontWeight[_textStyle["font_weight"]],
                              letterSpacing: double.parse(
                                  _textStyle["letter_spacing"].toString()),
                              color: Color(int.parse(_textStyle["text_color"])),
                            ),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
        ),
      ),
    );
  }

  Widget _setIcon({
    required IconData icon,
    required void Function() onTap,
    bool positiveColor = false,
  }) {
    return Container(
      width: 32,
      height: 28,
      margin: EdgeInsets.all(2),
      decoration: BoxDecoration(
        color: positiveColor ? Colors.green.shade300 : Colors.red.shade300,
        borderRadius: BorderRadius.circular(4),
      ),
      child: IconButton(
        padding: EdgeInsets.zero,
        color: Colors.white,
        onPressed: () {
          _isChange = true;
          setState(() {
            onTap();
          });
        },
        icon: Icon(icon),
      ),
    );
  }

  Widget _setBox({
    required String setText,
    required Widget leftChild,
    required Widget rightChild,
  }) {
    return Container(
      padding: EdgeInsets.all(4),
      decoration: BoxDecoration(color: AppColors.lightGrey),
      child: FittedBox(
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            leftChild,
            setText.isEmpty
                ? SizedBox.shrink()
                : Padding(
                    padding: EdgeInsets.symmetric(horizontal: 4),
                    child: Text(
                      setText,
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
            rightChild,
          ],
        ),
      ),
    );
  }
}
