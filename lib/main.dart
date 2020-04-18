import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutterbeer/loginPage.dart';

void main(){
  WidgetsFlutterBinding.ensureInitialized();
  SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp]).then((_){
    runApp(MyApp());
  });
}

class MyApp extends StatelessWidget{
  Widget build(BuildContext context){
    return MaterialApp(
      home: LoginPage(),
    );
  }
}