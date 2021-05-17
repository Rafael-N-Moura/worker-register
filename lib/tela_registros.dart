import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

final _firestore = Firestore.instance;

class TelaRegistros extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    var size = MediaQuery.of(context).size;
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Text("Registros"),
        backgroundColor: Colors.green,
      ),
      body: SafeArea(
        child: Container(
          child: Column(
                children: [
                  StreamBuilder<QuerySnapshot>(
                    stream: _firestore.collection('registros').snapshots(),
                    builder: (context, snapshot) {
                      if (snapshot.hasData) {
                        final registros = snapshot.data.documents;
                        List<Container> registroWidgets = [];
                        for (var registro in registros) {
                          final nomeRegistro = registro.data()['nome'];
                          final horarioRegistro = registro.data()['horario'];
                          final entradaRegistro = registro.data()['entrada'];
                          final saidaRegistro = registro.data()['saida'];

                          final registroWidget = Container(
                            margin: EdgeInsets.symmetric(
                                horizontal: 10, vertical: 10),
                            padding: EdgeInsets.symmetric(
                                horizontal: 10, vertical: 10),
                            width: double.infinity,
                            height: 100,
                            decoration: BoxDecoration(
                              border: Border(
                                top:
                                    BorderSide(width: 1.0, color: Colors.black),
                                left:
                                    BorderSide(width: 1.0, color: Colors.black),
                                right:
                                    BorderSide(width: 1.0, color: Colors.black),
                                bottom:
                                    BorderSide(width: 1.0, color: Colors.black),
                              ),
                            ),
                            child: Column(
                              children: <Widget>[
                                Expanded(
                                  child: Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: <Widget>[
                                      Text(
                                        "$horarioRegistro",
                                        style: TextStyle(
                                          fontSize: size.height * .02,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                      Text(
                                        "$nomeRegistro",
                                        style: TextStyle(
                                          fontSize: size.height * .02,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                                Divider(
                                  color: Colors.black,
                                ),
                                Expanded(
                                  child: Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: <Widget>[
                                      Text(
                                        "Entrada: $entradaRegistro ",
                                        style: TextStyle(
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                      Text(
                                        "Saida: $saidaRegistro",
                                        style: TextStyle(
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          );
                          registroWidgets.add(registroWidget);
                        }
                        return Expanded(
                              child: ListView(
                                padding: EdgeInsets.symmetric(
                                    horizontal: 10, vertical: 10),
                                children: registroWidgets,
                              ),
                            ) ??
                            Container();
                      }
                    },
                  ),
                ],
              ) ??
              Container(),
        ),
      ),
    );
  }
}

class Cont extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 10, vertical: 10),
      padding: EdgeInsets.symmetric(horizontal: 10, vertical: 10),
      width: double.infinity,
      height: 100,
      decoration: BoxDecoration(
        border: Border(
          top: BorderSide(width: 1.0, color: Color(0xFFFFFFFFFF)),
          left: BorderSide(width: 1.0, color: Color(0xFFFFFFFFFF)),
          right: BorderSide(width: 1.0, color: Color(0xFFFF000000)),
          bottom: BorderSide(width: 1.0, color: Color(0xFFFF000000)),
        ),
      ),
      child: Column(
        children: <Widget>[
          Expanded(
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                Text("Horário:"),
                Text("Nome"),
              ],
            ),
          ),
          Divider(),
          Expanded(
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                Text("Entrada: "),
                Text("Saida"),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
