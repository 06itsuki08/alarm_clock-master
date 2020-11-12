import 'package:alarm_clock/screen/alarmsetting.dart';
import 'package:alarm_clock/screen/mainmenu.dart';
import 'package:alarm_clock/screen/setting.dart';
import 'package:alarm_clock/val/color.dart';
import 'package:alarm_clock/val/string.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_localizations/flutter_localizations.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    SystemChrome.setEnabledSystemUIOverlays([SystemUiOverlay.top]);
    return MaterialApp(

      localizationsDelegates: [
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
      ],
      supportedLocales: [
        Locale('ja', 'JP'),
      ],
      title: title,
      //右上のデバッグモードって帯を消す
      debugShowCheckedModeBanner: false,
      //テーマ　アプリの基本色を決めたりする
      theme: appTheme,
      initialRoute: '/',
      routes: {
        '/': (context) => MainMenu(),
        '/alarmsetting': (context) => AlarmSetting(),
        '/setting': (context) => Setting(),
      },
    );
  }
}
