import 'package:clonedoapp/header.dart';
import 'package:clonedoapp/tela_registros.dart';
import 'package:flutter/material.dart';
import 'package:flutter_barcode_scanner/flutter_barcode_scanner.dart';
import 'dart:async';
import 'package:flutter/services.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

final _firestore = Firestore.instance;

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Flutter Demo',
      theme: ThemeData(
        // This is the theme of your application.
        //
        // Try running your application with "flutter run". You'll see the
        // application has a blue toolbar. Then, without quitting the app, try
        // changing the primarySwatch below to Colors.green and then invoke
        // "hot reload" (press "r" in the console where you ran "flutter run",
        // or simply save your changes to "hot reload" in a Flutter IDE).
        // Notice that the counter didn't reset back to zero; the application
        // is not restarted.
        primarySwatch: Colors.blue,
        // This makes the visual density adapt to the platform that you run
        // the app on. For desktop platforms, the controls will be smaller and
        // closer together (more dense) than on mobile platforms.
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      home: TelaPrincipal(),
    );
  }
}

class TelaPrincipal extends StatefulWidget {
  @override
  _TelaPrincipalState createState() => _TelaPrincipalState();
}

class _TelaPrincipalState extends State<TelaPrincipal> {
  bool _initialized = false;
  bool _error = false;

  // Define an async function to initialize FlutterFire
  void initializeFlutterFire() async {
    try {
      // Wait for Firebase to initialize and set `_initialized` state to true
      await Firebase.initializeApp();
      setState(() {
        _initialized = true;
      });
    } catch (e) {
      // Set `_error` state to true if Firebase initialization fails
      setState(() {
        _error = true;
      });
    }
  }

  void initState() {
    initializeFlutterFire();
    super.initState();
  }

  String _scanBarcode = 'Unknown';

  Future<void> scanQR() async {
    String barcodeScanRes;
    // Platform messages may fail, so we use a try/catch PlatformException.
    try {
      barcodeScanRes = await FlutterBarcodeScanner.scanBarcode(
          "#ff6666", "Cancel", true, ScanMode.QR);
      print(barcodeScanRes);
    } on PlatformException {
      barcodeScanRes = 'Failed to get platform version.';
    }

    // If the widget was removed from the tree while the asynchronous platform
    // message was in flight, we want to discard the reply rather than calling
    // setState to update our non-existent appearance.
    if (!mounted) return;

    setState(() {
      _scanBarcode = barcodeScanRes;
    });

    // _firestore.collection('registros').add({
    //   'entrada': DateTime.now().toString(),
    //   'horario': DateTime.now().toString(),
    //   'nome': _scanBarcode,
    //   'saida': DateTime.now().toString(),
    // });
    if (_scanBarcode != '-1') {
      String hora = DateTime.now().hour.toString();
      String min = DateTime.now().minute.toString();
      String dia = DateTime.now().day.toString();
      String mes = DateTime.now().month.toString();
      String ano = DateTime.now().year.toString();
      _firestore.collection('registros').doc(_scanBarcode).set({
        'entrada': "$hora:$min",
        'horario': "$dia/$mes/$ano",
        'nome': _scanBarcode,
        'saida': 'Aguardando',
      });
    }
  }

  void messagesStream() async {
    await for (var snapshot in _firestore.collection('registros').snapshots()) {
      for (var registro in snapshot.docs) {}
    }
  }

  Future<void> scanQR2() async {
    String barcodeScanRes;
    // Platform messages may fail, so we use a try/catch PlatformException.
    try {
      barcodeScanRes = await FlutterBarcodeScanner.scanBarcode(
          "#ff6666", "Cancel", true, ScanMode.QR);
      print(barcodeScanRes);
    } on PlatformException {
      barcodeScanRes = 'Failed to get platform version.';
    }

    // If the widget was removed from the tree while the asynchronous platform
    // message was in flight, we want to discard the reply rather than calling
    // setState to update our non-existent appearance.
    if (!mounted) return;

    setState(() {
      _scanBarcode = barcodeScanRes;
    });

    // _firestore.collection('registros').add({
    //   'entrada': DateTime.now().toString(),
    //   'horario': DateTime.now().toString(),
    //   'nome': _scanBarcode,
    //   'saida': DateTime.now().toString(),
    // });
    String hora = DateTime.now().hour.toString();
    String min = DateTime.now().minute.toString();
    _firestore.collection('registros').doc(_scanBarcode).update({
      'saida': "$hora:$min",
    });
  }

  @override
  Widget build(BuildContext context) {
    var size = MediaQuery.of(context).size;
    return Scaffold(
        appBar: AppBar(
          title: Text("Tela Principal"),
          backgroundColor: Colors.green,
          centerTitle: true,
        ),
        body: Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
              Header(),
              SizedBox(
                height: 60,
              ),
              Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
                child: Column(
                  children: [
                    Row(
                      children: [
                        Expanded(
                          child: FlatButton(
                            onPressed: () => scanQR(),
                            child: Container(
                              decoration: BoxDecoration(
                                color: Colors.lightGreen,
                                // boxShadow: [
                                //   BoxShadow(
                                //     offset: Offset(0, 17),
                                //     blurRadius: 17,
                                //     spreadRadius: -23,
                                //     color: Color(0xFFE6E6E6),
                                //   ),
                                // ],
                                borderRadius: BorderRadius.circular(20),
                              ),
                              alignment: Alignment.center,
                              width: double.infinity,
                              height: 45,
                              child: Text(
                                "Entrada - QRCode",
                                style: TextStyle(
                                  fontSize: size.height * .02,
                                  color: Colors.white,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                          ),
                        ),
                        Expanded(
                          child: FlatButton(
                            onPressed: () => scanQR2(),
                            child: Container(
                              decoration: BoxDecoration(
                                color: Colors.lightGreen,
                                // boxShadow: [
                                //   BoxShadow(
                                //     offset: Offset(0, 17),
                                //     blurRadius: 17,
                                //     spreadRadius: -23,
                                //     color: Color(0xFFE6E6E6),
                                //   ),
                                // ],
                                borderRadius: BorderRadius.circular(20),
                              ),
                              alignment: Alignment.center,
                              width: double.infinity,
                              height: 45,
                              child: Text(
                                "Saída - QRCode",
                                style: TextStyle(
                                  fontSize: size.height * .02,
                                  color: Colors.white,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                    SizedBox(height: 10),
                    RoundedButton(
                        titulo: "Verificar registros",
                        funcao: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(builder: (context) {
                              return TelaRegistros();
                            }),
                          );
                        }),
                  ],
                ),
              ),
            ]));
  }
}

class RoundedButton extends StatelessWidget {
  final String titulo;
  final Function funcao;
  const RoundedButton({
    Key key,
    this.titulo,
    this.funcao,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return FlatButton(
      onPressed: funcao,
      child: Container(
        decoration: BoxDecoration(
          color: Colors.lightGreen,
          // boxShadow: [
          //   BoxShadow(
          //     offset: Offset(0, 17),
          //     blurRadius: 17,
          //     spreadRadius: -23,
          //     color: Color(0xFFE6E6E6),
          //   ),
          // ],
          borderRadius: BorderRadius.circular(20),
        ),
        alignment: Alignment.center,
        width: double.infinity,
        height: 45,
        child: Text(
          titulo,
          style: TextStyle(
            fontSize: 18,
            color: Colors.white,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
    );
  }
}
