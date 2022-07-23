
import 'package:firebase_database/firebase_database.dart';
import 'package:mysql1/mysql1.dart';

class VG{
  static List order = [];
}
class mySQL{
  static Future<List> consultaSQL(String consulta,String tabela)async{
    List lista=[];
    final conn = await MySqlConnection.connect(ConnectionSettings(
        host: '45.152.46.36',
        port: 3306,
        user: 'u995997858_vU9dn',
        db: 'u995997858_X69x2',
        password: '100%Drika'));

    var results = await conn.query(
        'select order_id,event_start,event_end, activity_id from $tabela where order_id LIKE ' + consulta);
    for(var row in results){
        lista.add(row.values);
    }
    print(lista);
    return lista;

  }



}

class FirebaseAPI{
  static FirebaseDatabase rd = FirebaseDatabase.instance;
  static DatabaseReference porta = FirebaseDatabase.instance.ref("Portas");
}