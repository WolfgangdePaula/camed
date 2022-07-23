import 'package:flutter/material.dart';

class Suporte extends StatefulWidget {
  const Suporte({Key? key}) : super(key: key);

  @override
  _SuporteState createState() => _SuporteState();
}

class _SuporteState extends State<Suporte> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Suporte"),
      ),
      body: Container(
        padding: EdgeInsets.all(16),
        child: Column(
          children: [
            Text("Entre em contato com o número abaixo:",style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),),
            Text("(92)9 98430-0373",style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
            Card(
              elevation: 20,
              shape:RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(50),
              ),
              child:Image.asset("assets/contato_wolf.jpeg"),
            )

          ],
        ),
      ),
    );
  }
}
