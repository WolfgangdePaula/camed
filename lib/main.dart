//oi
import 'package:camed/Central.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:mysql1/mysql1.dart';
import 'Geral.dart';




void main()async{
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();




  runApp(
    MaterialApp(
      home: Central(),
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primaryColor:Color(0xff00A884),
        appBarTheme: AppBarTheme(
          color: Color(0xff00A884)
        ),
        floatingActionButtonTheme: FloatingActionButtonThemeData(
            backgroundColor: Color(0xff00A884)
        )
      ),
    )
  );
}
