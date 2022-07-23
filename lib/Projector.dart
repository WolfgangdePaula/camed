import 'dart:async';

import 'package:camed/Suporte.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'Geral.dart';

String situacao="";
bool flag = false;
bool flagProjetor=false;
bool flagContainer = false;

class Projector extends StatefulWidget {
  const Projector({Key? key}) : super(key: key);

  @override
  _ProjectorState createState() => _ProjectorState();
}

class _ProjectorState extends State<Projector> {
  TextEditingController OrderIdController = TextEditingController();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('CaMed - Sistema de Empréstimo'),
      ),
      bottomNavigationBar: Text("Todos os Direitos Reservados a Wolfgang de Paula e Ludivik de Paula"),
      floatingActionButton: FloatingActionButton(
        child:Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.support_agent_outlined),
            Text("Suporte",style: TextStyle(fontSize: 8),)
          ],
        ),
        onPressed: (){
          Navigator.push(context, MaterialPageRoute(builder: (context)=>Suporte()));
        },
      ),
      body:  SingleChildScrollView(
        child: Container(
          alignment: Alignment.center,
          decoration: BoxDecoration(
            image: DecorationImage(
              image: AssetImage("assets/CaMed.png"),
              opacity: 0.4,
              scale: 2.0
            )
          ),

          padding: EdgeInsets.all(32),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              TextField(
                decoration: InputDecoration(
                  label: Text("Coloque o Número do Pedido")
                ),
                style: TextStyle(fontSize: 30),
                textAlign: TextAlign.center,
                controller: OrderIdController,
                keyboardType: TextInputType.number,
              ),
              SizedBox(height: 20,),
              ElevatedButton(
                  onPressed: ()async{
                    await funcao().whenComplete((){
                      showDialog(
                          context: context,
                          builder: (context){
                            return SizedBox(
                              width: 350,
                              height: 400,
                              child:  CupertinoAlertDialog(

                                title: Text("Situação Empréstimo"),
                                content:Column(
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  children: [
                                    Container(
                                      alignment: Alignment.center,
                                      padding:EdgeInsets.fromLTRB(8, 16, 8, 16),
                                      decoration: BoxDecoration(
                                          borderRadius: BorderRadius.circular(26),
                                          color: flagContainer?Colors.greenAccent:Colors.redAccent
                                      ),
                                      child: Text(situacao),
                                    ),
                                    Expanded(
                                      child: Container(
                                          height: flagContainer?250:0,
                                          padding:EdgeInsets.fromLTRB(8, 16, 8, 16),
                                          decoration: BoxDecoration(
                                            borderRadius: BorderRadius.circular(26),
                                          ),
                                          child: ListView.builder(
                                              itemCount: VG.order.length,
                                              itemBuilder: (context, index) {
                                                var horaCelular = DateTime.now();
                                                bool flag;
                                                DateTime dataInicial;
                                                DateTime dataFinal;
                                                String produto;
                                                dataInicial = DateTime.parse(VG.order[index][1].toString().replaceAll('Z', '0'));
                                                dataFinal = DateTime.parse(VG.order[index][2].toString().replaceAll('Z', '0'));
                                                if(dataInicial.difference(horaCelular).inMinutes<=15 && dataFinal.difference(horaCelular).inMinutes>=-15){
                                                  flag = true;
                                                }else{
                                                  flag = false;
                                                }
                                                produto = VG.order[index][3]==2?"Projetor":"";
                                                return Container(
                                                  margin: EdgeInsets.only(top: 8,bottom: 8,left: 8,right: 8),
                                                  padding:EdgeInsets.fromLTRB(8, 16, 8, 16),
                                                  decoration: BoxDecoration(
                                                      borderRadius: BorderRadius.circular(26),
                                                      color:flag?Colors.greenAccent:Colors.redAccent
                                                  ),
                                                  child: ListTile(
                                                      title: Text(flag?"Pode retirar: ":"Ainda não disponível para retirar: "),
                                                      subtitle:Column(
                                                        crossAxisAlignment: CrossAxisAlignment.start,
                                                        children: [
                                                          Text("Produto: $produto"),
                                                          Text("Data: ${dataInicial.day}/${dataInicial.month}/${dataInicial.year}"),
                                                          Text("Hora Retirada: ${dataInicial.hour} h : ${dataInicial.minute} min"),
                                                          Text("Hora Entrega: ${dataFinal.hour} h : ${dataFinal.minute} min"),
                                                          Text("Porta: 1"),
                                                        ],
                                                      ),
                                                      trailing:!flag?null: FloatingActionButton(
                                                          onPressed: ()async{
                                                            /*DataSnapshot retorno;
                                                            await FirebaseAPI.porta.update({"Porta 1":"on"});
                                                            FirebaseAPI.rd.ref("/Portas/Porta 1").onValue.listen((event) {
                                                              if(event.snapshot.value.toString()=="off"){

                                                              }
                                                            });*/
                                                          },
                                                          child: Column(
                                                            mainAxisAlignment: MainAxisAlignment.center,
                                                            children: [
                                                              Icon(Icons.lock_open),
                                                              Text("Abrir",style: TextStyle(fontSize: 10))
                                                            ],
                                                          )
                                                      )
                                                  ),
                                                );
                                              }
                                          )
                                      ),
                                    ),

                                  ],
                                ),
                                actions: [
                                  ElevatedButton(
                                    onPressed: (){
                                      setState(() {
                                        flagContainer = false;
                                        situacao = "Coloque o número do seu pedido";
                                        OrderIdController.text = "";
                                      });
                                      Navigator.of(context, rootNavigator: true).pop();
                                    },
                                    child: Text("OK"),
                                  )
                                ],
                              )
                            );
                          }
                      );
                    });
                    setState(() {

                    });
                  },
                  child: Text('Buscar Serviço')
              ),

              Divider(),
            ],
          ),
        ),
      )
    );


  }
  Future funcao()async{
    var horaCelular = DateTime.now();
    VG.order = await mySQL.consultaSQL(OrderIdController.text.isEmpty?"-1":OrderIdController.text, "wp_bookacti_bookings");
    if(VG.order.isEmpty){
      setState(() {
        flagContainer = false;
        situacao = "Não encontramos sua solicitação";
      });
    }else{
      flagContainer = true;
      situacao = "Encontramos sua solicitação";
      VG.order.forEach((element) {
        DateTime dataInicial;
        DateTime dataFinal;
        dataInicial = DateTime.parse(element[1].toString().replaceAll('Z', '0'));
        dataFinal = DateTime.parse(element[2].toString().replaceAll('Z', '0'));
        if(dataInicial.difference(horaCelular).inMinutes<=15 && dataFinal.difference(horaCelular).inMinutes>=15){
          if(element[3]==2){
            setState(() {
              flag = true;
            });

          }
        }
      });


    }
  }
}


