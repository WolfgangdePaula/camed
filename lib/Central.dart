import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import 'Geral.dart';
import 'Suporte.dart';


class Central extends StatefulWidget {
  const Central({Key? key}) : super(key: key);

  @override
  State<Central> createState() => _CentralState();
}

class _CentralState extends State<Central> {
  var horaCelular;
  TextEditingController OrderIdController = TextEditingController();
  bool flagContainer1 = false  ;
  String situacao = "";
  String situacaoPorta='';

  @override
  Widget build(BuildContext context) {

    return Scaffold(
      appBar: AppBar(
        title: Text("CaMed - Sistema de Empréstimo"),
      ),
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
      bottomNavigationBar: Text("© 2022 Wolfgang de Paula && Ludivik de Paula",style: TextStyle(),textAlign: TextAlign.center,),
      body: Container(
        decoration: BoxDecoration(
          image: DecorationImage(
              image: AssetImage("assets/CaMed.png"),
              opacity: 0.4,
              scale: 2.0
          )
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Padding(
                padding: EdgeInsets.all(16),
                child: TextField(
                  controller:OrderIdController,
                  textAlign: TextAlign.center,
                  keyboardType: TextInputType.number,
                  decoration: InputDecoration(
                      label: Text("Coloque o Número do Pedido"),
                  ),
                ),
            ),
            ElevatedButton(
                onPressed: ()async{
                  showDialog(
                      context: context,
                      builder:(context){
                        return AlertDialog(
                          actions: [
                            ElevatedButton(
                              onPressed: (){
                                setState(() {
                                  OrderIdController.text = "";
                                });
                                Navigator.of(context, rootNavigator: true).pop();
                              },
                              child: Text("OK"),
                            )
                          ],
                          content: Container(
                            width:  double.maxFinite,
                            height:  450,
                            child: FutureBuilder(
                                future: funcao(),
                                builder:(context,snapshot){
                                  switch (snapshot.connectionState) {
                                    case ConnectionState.none:
                                    case ConnectionState.waiting:
                                      return Center(
                                        child: CircularProgressIndicator(
                                        ),
                                      );
                                    case ConnectionState.active:
                                    case ConnectionState.done:
                                    return Column(
                                      children: [
                                        Container(
                                          padding:EdgeInsets.fromLTRB(16, 8, 16, 8),
                                          decoration:BoxDecoration(
                                              color: flagContainer1?Colors.greenAccent:Colors.redAccent,
                                              borderRadius: BorderRadius.circular(26)
                                          ),
                                          child: Text(situacao),
                                        ),
                                        Divider(),
                                        SizedBox(
                                          height: 375,
                                          child: ListView.builder(
                                              itemCount: VG.order.length,
                                              itemBuilder: (context, index) {
                                                horaCelular = DateTime.now();
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
                                                  margin:EdgeInsets.only(top: 4,bottom: 4),
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
                                                            BuildContext contextCamed = context;
                                                            await FirebaseAPI.porta.update({"Porta 1":"on"});

                                                            showDialog(
                                                                context: context,
                                                                builder: (context){
                                                                  return StatefulBuilder(
                                                                      builder: (context, setState){
                                                                          FirebaseAPI.rd.ref('Portas/Porta 1').onValue.listen((event) {
                                                                            setState((){
                                                                              situacaoPorta = event.snapshot.value.toString();
                                                                            });
                                                                        });
                                                                        return AlertDialog(
                                                                            content: Container(
                                                                              height: 60,
                                                                              child: Center(
                                                                                child: situacaoPorta == 'off'?Text("Porta Aberta"):CircularProgressIndicator(),
                                                                              ),
                                                                            )
                                                                        );
                                                                      }
                                                                  );

                                                                }
                                                            );



                                                            //await FirebaseAPI.porta.update({"Porta 1":"on"});
                                                            /*FirebaseAPI.rd.ref("/Portas/Porta 1").onValue.listen((event) {
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
                                          ),
                                        )
                                      ],
                                    );

                                  }
                                }
                            ),
                          ),
                        );
                      }
                  );
                },
                child: Text("Buscar Solicitação")
            )
          ],
        ),
      ),
    );

  }
  Future funcao()async{
    VG.order = await mySQL.consultaSQL(OrderIdController.text.isEmpty?"-1":OrderIdController.text, "wp_bookacti_bookings");
    if(VG.order.isEmpty){
      setState(() {
        flagContainer1 = false;
        situacao = "Não encontramos sua solicitação";
      });
    }else{
      setState((){
        flagContainer1 = true;
        situacao = "Encontramos sua solicitação";
      });
      print(VG.order);
    }

  }

}
