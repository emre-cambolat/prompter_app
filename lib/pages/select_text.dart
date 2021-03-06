import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:prompter_app/components/loading_indicator.dart';
import 'package:prompter_app/pages/show_text_page.dart';
import 'package:prompter_app/services/firebase_services.dart';
import 'dart:io';

import '../components/app_colors.dart';

class SelectTextUI extends StatefulWidget {
  const SelectTextUI({Key? key}) : super(key: key);

  @override
  State<SelectTextUI> createState() => _SelectTextUIState();
}

class _SelectTextUIState extends State<SelectTextUI> {
  List<Map<String, dynamic>> _textsList = [];
  late Map<String, dynamic> _prompterSettings;
  late Map<String, dynamic> _textStyle;

  late bool _isLoading;

  @override
  void initState() {
    _isLoading = true;
    FirebaseService.getData().then((value) {
      _textsList.addAll(List<Map<String, dynamic>>.from(value["texts"]));
      _textStyle = Map<String, dynamic>.from(value["text_style"]);
      _prompterSettings = Map<String, dynamic>.from(value["prompter_settings"]);
      setState(() {
        _isLoading = false;
      });
    }).catchError(
        (error) => debugPrint("Veriler Çekilemedi: " + error.toString()));
    super.initState();
  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2,
      initialIndex: 0,
      child: Scaffold(
        floatingActionButton: FloatingActionButton(
          child: Icon(
            Icons.add,
          ),
          backgroundColor: AppColors.primaryColor,
          onPressed: () async {
            FilePickerResult? result = await FilePicker.platform.pickFiles(
              allowedExtensions: ['txt', 'doc', 'docx', 'pdf'],
              type: FileType.custom,
            );

            if (result != null) {
              File file = File(result.files.single.path.toString());
              var fileContent =
                  await file.readAsString().onError((error, stackTrace) {
                showDialog(
                  context: context,
                  builder: (context) {
                    return AlertDialog(
                      title: Text("Dosya Açılamadı"),
                      content: Text(
                        "Hata Detayı: " + error.toString(),
                      ),
                      actions: [
                        TextButton(
                          onPressed: () {
                            Navigator.pop(context);
                          },
                          child: Text("Tekrar Dene"),
                        ),
                      ],
                    );
                  },
                );
                return error.toString();
              });
              debugPrint(fileContent.toString());
              _goPage(
                title: fileContent.substring(0, 15) + "...",
                content: fileContent.toString(),
              );
            } else {
              // User canceled the picker
            }
          },
        ),
        appBar: AppBar(
          title: Text("Metin Seç"),
          bottom: TabBar(
            indicatorColor: Colors.white,
            tabs: [
              Padding(
                padding: EdgeInsets.symmetric(vertical: 8),
                child: Text("Sunucudan Eklenenler"),
              ),
              Padding(
                padding: EdgeInsets.symmetric(vertical: 8),
                child: Text("Dosyadan Eklenenler"),
              ),
            ],
          ),
        ),
        body: SafeArea(
          child: _isLoading
              ? loadingIndicator()
              : TabBarView(
                  physics: BouncingScrollPhysics(),
                  children: [
                    ListView.builder(
                      primary: false,
                      physics: BouncingScrollPhysics(),
                      padding: EdgeInsets.symmetric(vertical: 8),
                      itemCount: _textsList.length,
                      itemBuilder: (context, index) {
                        return ListTile(
                          onTap: () {
                            _goPage(
                              title: _textsList[index]["title"].toString(),
                              content: _textsList[index]["text"].toString(),
                            );
                          },
                          minVerticalPadding: 8,
                          leading: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Container(
                                width: 24,
                                height: 24,
                                alignment: Alignment.center,
                                padding: EdgeInsets.all(2),
                                decoration: BoxDecoration(
                                  color: AppColors.primaryColor,
                                  shape: BoxShape.circle,
                                ),
                                child: Text(
                                  (index + 1).toString(),
                                  textAlign: TextAlign.center,
                                  style: TextStyle(
                                    color: Colors.white,
                                  ),
                                ),
                              ),
                            ],
                          ),
                          title: Text(
                            _textsList[index]["title"].toString(),
                            maxLines: 1,
                          ),
                          subtitle: Text(
                            _textsList[index]["text"].toString(),
                            maxLines: 2,
                          ),
                        );
                      },
                    ),
                    Column(
                      children: [],
                    ),
                  ],
                ),
        ),
      ),
    );
  }

  void _goPage({required String title, required String content}) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: ((context) => ShowTextPageUI(
              title: title,
              content: content,
              prompterSettings: _prompterSettings,
              textStyle: _textStyle,
            )),
      ),
    );
  }
}
