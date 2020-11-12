import 'dart:async';
import 'dart:io';

import 'package:alarm_clock/module/alarm.dart';
import 'package:alarm_clock/module/alarm_list.dart';
import 'package:alarm_clock/module/test.dart';
import 'package:alarm_clock/screen/alarmsetting.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:alarm_clock/val/string.dart';
import 'package:alarm_clock/module/shared_prefs.dart';

// ignore: must_be_immutable
class MainMenu extends StatefulWidget {
  MainMenu({Key key}) : super(key: key);
  @override
  _MainMenuState createState() => _MainMenuState();
}

class _MainMenuState extends State<MainMenu> {
  //画面描画の前、最初に動作するとこ初期化とかここでおこなったりする
  @override
  void initState() {
    setState(() {
      if (alarmList != null) alarmList.clear();
      loadData();
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    size = MediaQuery.of(context).size;
    return Scaffold(
      //AppBarはアプリのタイトルとかを表示してくれる領域のこと
      appBar: AppBar(
        title: Text(
          title,
          style: TextStyle(
              color: Colors.white, fontWeight: FontWeight.w800, fontSize: 30,letterSpacing: 3),
        ),
        actions: <Widget>[
          //アイコンをそのままボタンにしてくれるWidget
          //アイコン一覧は↓
          //https://api.flutter.dev/flutter/material/Icons-class.html
          IconButton(
            icon: Icon(Icons.alarm_add),
            iconSize: 30,
            color: Colors.white,
            padding: EdgeInsets.fromLTRB(10, 10, 20, 10),
            //onPressed そのまんま押された時の動作を宣言するとこ
            //setState 値を変更して画面を更新するよみたいな感じ
            //画面の更新をかけないと表示上の数値は変わらない
            onPressed: () async {
              Navigator.push(
                context,
                new MaterialPageRoute(builder: (context) => new AlarmSetting()),
              ).then(onGoBack);
            }, //
          ),
          IconButton(
            icon: Icon(Icons.settings),
            iconSize: 30,
            color: Colors.white,
            padding: EdgeInsets.fromLTRB(10, 10, 20, 10),
            onPressed: () {
              Navigator.pushNamed(context, '/setting');
            },
          )
        ],
      ),
      //body アプリのメイン画面
      //Column 子供になるパーツが全部縦に並んでくれる　子供はchildren にいれる
      body: SingleChildScrollView(
        child:
            /*
            Text('テーマカラー：amber[800]', style: TextStyle(fontSize: 20)),
            colortest(Colors.amber[400], 'amber400'),
            colortest(Colors.lime[600], 'lime600'),
            colortest(Colors.amberAccent, 'amberAccent'),
            colortest(Colors.amber[200], 'amber200'),
            colortest(Colors.amberAccent[100], 'amberAccent100'),
            colortest(Colors.amber[50], 'amber50'),
            */

            FutureBuilder(
                future: loadData(needReturn: true),
                builder: (BuildContext context, AsyncSnapshot snapshot) {
                  if (snapshot.hasData) {
                    return alarmList.length > 0
                        ? Column(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: <Widget>[
                              heightSpacer(height: size.height * 0.01),
                              Text(
                                'アラーム登録数：${alarmList.length}',
                                style: itemName,
                              ),
                              ListView.builder(
                                  shrinkWrap: true,
                                  reverse: true,
                                  physics: ScrollPhysics(),
                                  itemCount: alarmList.length,
                                  scrollDirection: Axis.vertical,
                                  itemBuilder: (BuildContext context, int i) {
                                    return GestureDetector(
                                        child: buildListItem(alarmList[i]),
                                        onLongPress: () {
                                          deleteAlarmMode(alarmList[i]);
                                        });
                                  })
                            ],
                          )
                        : Center(child: Card(child: Text('アラーム未登録')));
                  } else {
                    return Text("同期失敗");
                  }
                }),
      ),
    );
  }

  FutureOr onGoBack(dynamic value) {
    setState(() {
      relodeAlarmList();
    });
  }

  deleteAlarmMode(Alarm alarm) async {
    Text title = Text(alartConfirmation);
    Text content = Text(alartDeleteAlarm);
    Text _cansel = Text(cansel);
    Text _delete = Text(delete);
    await showDialog(
        context: context,
        builder: (_) {
          if (Platform.isIOS) {
            return CupertinoAlertDialog(
              title: title,
              content: content,
              actions: <Widget>[
                CupertinoDialogAction(
                  child: _cansel,
                  onPressed: () => Navigator.pop(context),
                ),
                CupertinoDialogAction(
                  child: _delete,
                  isDestructiveAction: true,
                  onPressed: () {
                    deleteAlarm(alarm);
                    Navigator.of(context).pop();
                    setState(() {});
                  },
                ),
              ],
            );
          } else {
            return AlertDialog(
              title: title,
              content: content,
              actions: <Widget>[
                FlatButton(
                  child: _cansel,
                  onPressed: () => Navigator.pop(context),
                ),
                FlatButton(
                  child: _delete,
                  onPressed: () {
                    deleteAlarm(alarm);
                    Navigator.of(context).pop();
                    setState(() {});
                  },
                ),
              ],
            );
          }
        });
  }
}
