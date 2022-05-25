import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:prompter_app/components/app_colors.dart';
import 'package:prompter_app/components/loading_indicator.dart';
import 'package:prompter_app/services/firebase_services.dart';

class SetKeysUI extends StatefulWidget {
  const SetKeysUI({Key? key}) : super(key: key);

  @override
  State<SetKeysUI> createState() => _SetKeysUIState();
}

class _SetKeysUIState extends State<SetKeysUI>
    with SingleTickerProviderStateMixin {
  late FocusNode _fnListener;
  late AnimationController _animationController;
  bool _isLoading = true;

  bool _isDialogOpen = false;
  List<LogicalKeyboardKey> _keys = [];
  // List<String> keys;

  @override
  void initState() {
    _fnListener = FocusNode();
    _animationController = AnimationController(
      vsync: this,
      lowerBound: 0.5,
      duration: Duration(seconds: 3),
    )..repeat();
    FirebaseService.getData().then(
      (value) {
        _getKeys(keyList: List<String>.from(value["key_settings"]));
      },
    );
    super.initState();
  }

  @override
  void dispose() {
    _fnListener.dispose();
    _animationController.dispose();
    super.dispose();
  }

  void _getKeys({required List<String> keyList}) {
    for (int i = 0; i < keyList.length; i++) {
      _keys.add(LogicalKeyboardKey(int.parse(keyList[i])));
    }
    setState(() {
      _isLoading = false;
    });
  }

   _setKeys() {
     List<String> _temp = [];
     for(int i=0;i<_keys.length;i++){
       _temp.add(_keys[i].keyId.toString());
     }
     FirebaseService.UpdateKeys(_temp);
   }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        await _setKeys();
        return true;
      },
      child: Scaffold(
        appBar: AppBar(
          title: Text("Tuşları Ayarla"),
        ),
        body: _isLoading
            ? loadingIndicator()
            : Column(
                children: [
                  _listTile(
                    keyName: "Aşağı Yön",
                    trailing: _keys[0].keyLabel.toString(),
                    index: 0,
                  ),
                  _listTile(
                    keyName: "Başlat/Dur",
                    trailing: _keys[1].keyLabel.toString(),
                    index: 1,
                  ),
                  _listTile(
                    keyName: "Yukarı Yön",
                    trailing: _keys[2].keyLabel.toString(),
                    index: 2,
                  ),
                  _listTile(
                    keyName: "Yavaşlat",
                    trailing: _keys[3].keyLabel.toString(),
                    index: 3,
                  ),
                  _listTile(
                    keyName: "Hızlandır",
                    trailing: _keys[4].keyLabel.toString(),
                    index: 4,
                  ),
                ],
              ),
      ),
    );
  }

  void _listenKey({required BuildContext context, required int index}) {
    showDialog(
      context: context,
      builder: (context) {
        return RawKeyboardListener(
          autofocus: true,
          focusNode: _fnListener,
          onKey: (event) {
            // debugPrint(
            //     "---------------------4  " + event.logicalKey.keyId.toString());

            debugPrint(event.toString());

            if (_isDialogOpen) {
              setState(() {
                _keys[index] = event.logicalKey;
              });
              Navigator.pop(context);
              _isDialogOpen = false;
            }
          },
          child: AlertDialog(
            title: Wrap(
              alignment: WrapAlignment.center,
              children: [
                Text(
                  "'${_keys[index].keyLabel}'",
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontWeight: FontWeight.w400,
                    color: Colors.black54,
                  ),
                ),
                Text(
                  "yerine Yeni Tuşu Ayarlayın",
                  textAlign: TextAlign.center,
                ),
              ],
            ),
            content: SizedBox(
              height: MediaQuery.of(context).size.height / 5,
              child: _buildBody(),
            ),
          ),
        );
      },
    );
  }

  Widget _buildBody() {
    return AnimatedBuilder(
      animation: CurvedAnimation(
          parent: _animationController, curve: Curves.fastOutSlowIn),
      builder: (context, child) {
        return Stack(
          alignment: Alignment.center,
          children: <Widget>[
            _buildContainer(150 * _animationController.value),
            _buildContainer(200 * _animationController.value),
            _buildContainer(250 * _animationController.value),
            _buildContainer(300 * _animationController.value),
            _buildContainer(350 * _animationController.value),
            Align(
                child: Icon(
              Icons.keyboard_outlined,
              size: 44,
              color: Colors.white,
            )),
          ],
        );
      },
    );
  }

  Widget _buildContainer(double radius) {
    return Container(
      width: radius,
      height: radius,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        color:
            AppColors.primaryColor.withOpacity(1 - _animationController.value),
      ),
    );
  }

  Widget _listTile({
    required String keyName,
    required String trailing,
    required int index,
  }) {
    return Column(
      children: [
        ListTile(
          title: Text("'$keyName' Tuşu"),
          leading: Icon(Icons.keyboard_alt_outlined),
          trailing: Text(
            trailing,
            style: TextStyle(
              color: Colors.black54,
            ),
          ),
          minVerticalPadding: 8,
          onTap: () {
            _isDialogOpen = true;
            _listenKey(
              context: context,
              index: index,
            );
          },
        ),
        Divider(),
      ],
    );
  }
}
