import 'package:app_notas_diarias/model/Anotacao.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';


class AnotacaoHelper{
static final String nomeTabela = 'anotacao';
  static final AnotacaoHelper _anotacaoHelper = AnotacaoHelper._internal();
  Database? _db;
    factory AnotacaoHelper(){
    return _anotacaoHelper;
  }

  AnotacaoHelper._internal(){

  }

  get db async {
      if(_db != null){
        return _db;
      } else {
_db = await _inicializarDB();
return _db;
      }
  }
_onCreate(Database db, int version) async {

  String createTableSql = "CREATE TABLE $nomeTabela ("
      "id INTEGER PRIMARY KEY AUTOINCREMENT,"
      " titulo VARCHAR,"
      " descricao TEXT,"
      " data DATETIME)";
  await db.execute(createTableSql);

}
  _inicializarDB () async {

      final  _partialPath = await getDatabasesPath();
      final  _completePath = join(_partialPath, "meuBancoDados.db");

      var db = await openDatabase(
        _completePath,
        version: 1,
        onCreate: _onCreate
      );
      return db;

  }


Future<int> salvarAnotacao(Anotacao anotacao) async{ // colocar a classe do tipo anotação depois de ter criado a classe em arquivo separado
  var bancoDados = await db;

  var resultado = await bancoDados.insert(nomeTabela, anotacao.toMap() );
  return resultado;
}

recuperarAnotacoes() async {

      var bancoDados = await db;
      String recuperadorSql = 'SELECT * FROM $nomeTabela ORDER BY data';
      List anotacoes = await bancoDados.rawQuery(recuperadorSql);
      return anotacoes;



}

Future<int> atualizarAnotacao(Anotacao anotacao) async{
      var bancoDados = await db;
return await bancoDados.update(
nomeTabela,
  anotacao.toMap(),
   where: "id = ?",
  whereArgs: [anotacao.id]
);
}

Future<int> removeranotacao(int id) async{
      var bancoDados = await db;
     return  bancoDados.delete(
        nomeTabela,
        where: 'id = ?',
        whereArgs: [id]

      );
}





}