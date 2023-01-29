import 'package:app_notas_diarias/helper/AnotacaoHelper.dart';
import 'package:flutter/material.dart';

import 'package:app_notas_diarias/model/Anotacao.dart';

import 'package:intl/intl.dart';

import 'package:intl/date_symbol_data_local.dart';

class Home extends StatefulWidget {
  const Home({Key? key}) : super(key: key);

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {

  TextEditingController _tituloControler = TextEditingController();
  TextEditingController _descricaoControler = TextEditingController();
  var _db = AnotacaoHelper();
  List<Anotacao> _anotacoes = [];

  _exibirTelaCadastro({Anotacao? anotacao}){
String textoSalvarAtualizar = "";
    if(anotacao == null){
      _tituloControler.text = "";
      _descricaoControler.text = "";
      textoSalvarAtualizar = "Salvar";

    } else {
textoSalvarAtualizar = "Atualizar";
_tituloControler.text = anotacao.titulo!;
_descricaoControler.text = anotacao.descricao!;

    }

    showDialog(context: context,
        builder: (context){
      return AlertDialog(
        title: Text("$textoSalvarAtualizar anotação"),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(
              controller: _tituloControler,
              autofocus: true,
              decoration: InputDecoration(
                labelText: "Título",
                hintText: "Digite o título",
              ),
            ),
            TextField(
              controller: _descricaoControler,
              decoration: InputDecoration(
                hintText: "Digite a descrição",
                labelText: "Descrição",
              ),
            )
          ],
        ),
        actions: [
          ElevatedButton(onPressed: (){
            Navigator.pop(context);
          },
              child: Text("Fechar")),

          ElevatedButton(onPressed: (){
_salvarAtualizarAnotacao(anotacaoSelecionada: anotacao);
Navigator.pop(context);
          },
              child: Text(textoSalvarAtualizar))
        ],

      );
        });
  }

  _salvarAtualizarAnotacao({Anotacao? anotacaoSelecionada})async {
    String titulo = _tituloControler.text;
    String descricao = _descricaoControler.text;
    if(anotacaoSelecionada == null){
      Anotacao anotacao = Anotacao(titulo, descricao, DateTime.now().toString());
      int resultado = await _db.salvarAnotacao(anotacao);

    }else {
anotacaoSelecionada.titulo = titulo;
anotacaoSelecionada.descricao = descricao;
anotacaoSelecionada.data = DateTime.now().toString();
int resultado = await _db.atualizarAnotacao(anotacaoSelecionada);
    }
    _tituloControler.clear();
    _descricaoControler.clear();

    _recuperarAnotacoes();

  }

  _recuperarAnotacoes() async{
    List anotacoesRecuperadas = await _db.recuperarAnotacoes();
    List<Anotacao> listaTemporaria = [];

    for(var item in anotacoesRecuperadas){
Anotacao anotacao = Anotacao.fromMap(item);
listaTemporaria.add(anotacao);

    }
setState(() {
_anotacoes = listaTemporaria;
});
listaTemporaria = [];
    print("Lista de anotações: " + anotacoesRecuperadas.toString());

  }

  _formatarData(String data){

initializeDateFormatting('pt_BR');
var formatador = DateFormat.yMd("pt_BR");

DateTime dataConvertida = DateTime.parse(data);
String dataFormatada = formatador.format(dataConvertida);
return dataFormatada;
  }

  _removerAnotacao(int? id)async{

    await _db.removeranotacao(id!);

    _recuperarAnotacoes();
  }





  @override
  void initState() {

    super.initState();
    _recuperarAnotacoes();
  }


  @override


  Widget build(BuildContext context) {

    return Scaffold(
      appBar: AppBar(
        title: Text("Minhas anotações"),
        backgroundColor: Colors.pinkAccent,
      ),
      body: Column(
children: [
  Expanded(child:
  ListView.builder(
      itemCount: _anotacoes.length,

      itemBuilder: (context, index){
        final anotacao = _anotacoes[index];
        return Card(
          child: ListTile(
            title: Text("${anotacao.titulo}"),
            subtitle: Text("${_formatarData(anotacao.data!)}"),
            trailing: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                GestureDetector(
                  onTap: (){
_exibirTelaCadastro(anotacao: anotacao);
                  },
                  child: Padding(
                    padding: EdgeInsets.only(right:16),

                  child: Icon(
                    Icons.edit,
                    color: Colors.green,
                  ),
                )),

                GestureDetector(
                  onTap: (){
_removerAnotacao(anotacao.id);
                  },
                  child: Icon(
                      Icons.delete,
                    color: Colors.red,
                  ),
                )

              ],
            )
          ),
        );
      })
  )],


      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: Colors.white,
        foregroundColor: Colors.pink.shade500,
        child: Icon(Icons.library_books_sharp),
        onPressed: (){

_exibirTelaCadastro();
        },
      ),
    );
  }
}

