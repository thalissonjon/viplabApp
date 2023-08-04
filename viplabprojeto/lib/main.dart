import 'package:flutter/material.dart';
import 'package:viplabprojeto/pages/camera_page.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/services.dart';
import 'package:flutter/cupertino.dart';
import 'package:viplabprojeto/pages/covertestinfo.dart';
import 'package:viplabprojeto/pages/results.dart';
import 'dart:io';
import 'package:path/path.dart' as path;
import 'package:path_provider/path_provider.dart';

// import 'package:viplabprojeto/pages/video_page.dart';

Future main() async {
  WidgetsFlutterBinding.ensureInitialized();
  SystemChrome.setPreferredOrientations([
    // DeviceOrientation.portraitUp,
    // DeviceOrientation.portraitDown,
  ]);

  await Firebase.initializeApp();
  // await SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp]);

  runApp(MyApp());
}

/* class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      debugShowCheckedModeBanner: false,
      home: CameraPage(),
      
    );
  }
} */
class MyApp extends StatelessWidget {
  final bool hasResults;

  Future<bool> verificarPasta() async {
    final directory = await getApplicationDocumentsDirectory();
    final pastaJson = Directory('${directory.path}/json');

    if (await pastaJson.exists()) {
      final stream = pastaJson.list();
      await for (var item in stream) {
        if (item is File) {
          // tem arquivo
          print("tem arquivo");
          return true;
        }
      }
    }

    // pasta vazia ou n existe
    print("sem arquivo ou pasta inexistente");
    return false;
  }

  MyApp({this.hasResults = false});

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<bool>(
      future: verificarPasta(),
      builder: (BuildContext context, AsyncSnapshot<bool> snapshot) {
        if (snapshot.hasData) {
          final bool hasResults = snapshot.data ?? false;
          return MaterialApp(
            home: Gravar(hasResults: hasResults),
          );
        } else {
          return CircularProgressIndicator();
        }
      },
    );
  }
  // Widget build(BuildContext context) {

  //   return MaterialApp(
  //     home: Gravar(hasResults: hasResults),
  //   );
  // }
}

class Gravar extends StatelessWidget {
  late bool hasResults;
  final bool fromReq = false;

  Gravar({this.hasResults = false, Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Colors.white,
        body: Container(
            padding: const EdgeInsets.only(
              top: 60,
              left: 20,
              right: 20,
            ),
            child: Column(children: [
              Row(
                children: [
                  Image.asset(
                    "assets/eyecheck_logo.png",
                    width: 40,
                    height: 40,
                  ),
                  Text(
                    "EyeCheck",
                    style: TextStyle(
                        fontSize: 25,
                        color: Color.fromRGBO(0, 74, 173, 1),
                        fontWeight: FontWeight.w800),
                  ),
                ],
              ),
              SizedBox(
                height: 30,
              ),
              // Row(
              //   children: [
              //     Text("Testes",
              //         style: TextStyle(
              //             fontSize: 20,
              //             color: Colors.black,
              //             fontWeight: FontWeight.bold))
              //   ],
              // ),
              SizedBox(
                height: 20,
              ),
              Container(
                  width: MediaQuery.of(context).size.width,
                  height: 210,
                  decoration: BoxDecoration(
                      gradient: LinearGradient(colors: [
                        Color.fromRGBO(0, 74, 173, 1),
                        Color.fromRGBO(12, 110, 240, 1),
                        // Color.fromRGBO(0, 110, 173, 1)
                      ]),
                      borderRadius: BorderRadius.only(
                        topLeft: Radius.circular(10),
                        bottomLeft: Radius.circular(10),
                        topRight: Radius.circular(90),
                        bottomRight: Radius.circular(10),
                      )),
                  child: Container(
                    padding: const EdgeInsets.only(top: 20, left: 20),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          "Cover Test (teste de cobertura)",
                          style: TextStyle(
                              fontSize: 19,
                              color: Colors.white,
                              fontWeight: FontWeight.w300),
                        ),
                        SizedBox(
                          height: 20,
                        ),
                        Text(
                            "O Cover Test é um exame oftalmológico utilizado para detectar o estrabismo utilizando um oclusor.",
                            style: TextStyle(
                                fontSize: 17,
                                color: Colors.white,
                                fontWeight: FontWeight.w400)),
                        SizedBox(
                          height: 40,
                        ),
                        Row(
                          children: [
                            Icon(
                              CupertinoIcons.alarm,
                              size: 20,
                              color: Colors.white,
                            ),
                            SizedBox(
                              width: 8,
                            ),
                            Text("5-10 min",
                                style: TextStyle(
                                    fontSize: 14,
                                    color: Colors.white,
                                    fontWeight: FontWeight.w400)),
                            SizedBox(
                              width: 47,
                            ),
                            ElevatedButton(
                                onPressed: () {
                                  Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                          builder: (context) =>
                                              CoverTestinfo()));
                                },
                                child: Text("Saiba mais",
                                    style: TextStyle(
                                        fontSize: 16,
                                        color: Color.fromRGBO(12, 110, 240, 1),
                                        fontWeight: FontWeight.w400)),
                                style: ElevatedButton.styleFrom(
                                    backgroundColor: Colors.white,
                                    padding: EdgeInsets.symmetric(
                                        horizontal: 25, vertical: 5),
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(50),
                                    ),
                                    shadowColor: Colors.black,
                                    elevation: 10))
                          ],
                        )
                      ],
                    ),
                  )),
              Container(
                  height: 150,
                  width: MediaQuery.of(context).size.width,
                  child: Stack(
                    children: [
                      Container(
                          margin: const EdgeInsets.only(top: 20),
                          width: MediaQuery.of(context).size.width,
                          height: 100,
                          decoration: BoxDecoration(
                              color: Colors.white,
                              border: Border.all(
                                  width: 1,
                                  color: Colors.grey.withOpacity(0.2)),
                              boxShadow: [
                                BoxShadow(
                                    blurRadius: 5,
                                    spreadRadius: 2,
                                    offset: Offset(8, 10),
                                    color: Color.fromRGBO(0, 74, 173, 0.2))
                              ])),
                      Container(
                        margin: const EdgeInsets.only(top: 30),
                        width: 80,
                        height: 60,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(20),
                          image: DecorationImage(
                            image: AssetImage("assets/oclusor.png"),
                          ),
                        ),
                      ),
                      Container(
                        width: double.maxFinite,
                        height: 100,
                        // color: Colors.red.withOpacity(0.3),
                        margin: const EdgeInsets.only(left: 80, top: 30),
                        child: Column(children: [
                          Text(
                            "Quer realizar o Cover Test?",
                            style: TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                                color: Color.fromRGBO(0, 74, 173, 1)),
                          ),
                          Text(
                            "Realize agora o seu teste!",
                            style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.w400,
                                color: Color.fromRGBO(0, 74, 173, 1)),
                          ),
                          SizedBox(
                            height: 1,
                          ),
                          ElevatedButton(
                              onPressed: () {
                                Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                        builder: (context) => CameraPage()));
                              },
                              child: Text("Começar",
                                  style: TextStyle(
                                      fontSize: 16,
                                      color: Colors.white,
                                      fontWeight: FontWeight.w400)),
                              style: ElevatedButton.styleFrom(
                                  backgroundColor:
                                      Color.fromRGBO(12, 110, 240, 1),
                                  padding: EdgeInsets.symmetric(
                                      horizontal: 25, vertical: 5),
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(50),
                                  ),
                                  shadowColor: Colors.black,
                                  elevation: 10))
                        ]),
                      ),
                    ],
                  )),

              ElevatedButton(
                onPressed: hasResults
                    ? () {
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) =>
                                    Results(fromReq: fromReq)));
                      }
                    : null,
                child: Text(
                  "Último teste realizado",
                  style: TextStyle(
                    fontSize: 16,
                    color: Colors.white,
                    fontWeight: FontWeight.w400,
                  ),
                ),
                style: ButtonStyle(
                  backgroundColor: hasResults
                      ? MaterialStateProperty.all<Color>(
                          Color.fromRGBO(12, 110, 240, 0.8))
                      : MaterialStateProperty.all<Color>(Colors.grey),
                  padding: MaterialStateProperty.all<EdgeInsets>(
                      EdgeInsets.symmetric(horizontal: 60, vertical: 15)),
                  shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                    RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(50),
                    ),
                  ),
                  shadowColor: MaterialStateProperty.all<Color>(Colors.black),
                  elevation: MaterialStateProperty.all<double>(10),
                ),
              ),

              SizedBox(
                height: 20,
              ),

              Container(
                alignment: Alignment.center,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      "Créditos",
                      textAlign: TextAlign.center,
                      style: TextStyle(
                          fontSize: 24,
                          fontWeight: FontWeight.w400,
                          color: Colors.black),
                    ),
                  ],
                ),
              ),

              SizedBox(
                height: 10,
              ),

              Expanded(
                child: SingleChildScrollView(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Container(
                            height: 70,
                            width: (MediaQuery.of(context).size.width / 2) - 50,
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(15),
                              image: DecorationImage(
                                image: AssetImage("assets/viplab.png"),
                              ),
                              // boxShadow: [
                              //   BoxShadow(
                              //     blurRadius: 3,
                              //     offset: Offset(5, 5),
                              //     color: Color.fromRGBO(0, 74, 173, 0.1),
                              //   ),
                              //   BoxShadow(
                              //     blurRadius: 3,
                              //     offset: Offset(-5, -5),
                              //     color: Color.fromRGBO(0, 74, 173, 0.1),
                              //   ),
                              // ],
                            ),
                          ),
                          SizedBox(
                            width: 20,
                          ),
                          Container(
                            height: 70,
                            width: (MediaQuery.of(context).size.width / 2) - 50,
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(15),
                              image: DecorationImage(
                                image: AssetImage("assets/nca.jpg"),
                              ),
                              // boxShadow: [
                              //   BoxShadow(
                              //     blurRadius: 3,
                              //     offset: Offset(5, 5),
                              //     color: Color.fromRGBO(0, 74, 173, 0.1),
                              //   ),
                              //   BoxShadow(
                              //     blurRadius: 3,
                              //     offset: Offset(-5, -5),
                              //     color: Color.fromRGBO(0, 74, 173, 0.1),
                              //   ),
                              // ],
                            ),
                          ),
                        ],
                      ),
                      SizedBox(
                        height: 30,
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Container(
                            height: 70,
                            width: (MediaQuery.of(context).size.width / 2) - 50,
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(15),
                              image: DecorationImage(
                                image: AssetImage("assets/ufma.png"),
                              ),
                              // boxShadow: [
                              //   BoxShadow(
                              //     blurRadius: 3,
                              //     offset: Offset(5, 5),
                              //     color: Color.fromRGBO(0, 74, 173, 0.1),
                              //   ),
                              //   BoxShadow(
                              //     blurRadius: 3,
                              //     offset: Offset(-5, -5),
                              //     color: Color.fromRGBO(0, 74, 173, 0.1),
                              //   ),
                              // ],
                            ),
                          ),
                          SizedBox(
                            width: 20,
                          ),
                          Container(
                            height: 70,
                            width: (MediaQuery.of(context).size.width / 2) - 50,
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(15),
                              image: DecorationImage(
                                image: AssetImage("assets/fapema.png"),
                              ),
                              // boxShadow: [
                              //   BoxShadow(
                              //     blurRadius: 3,
                              //     offset: Offset(5, 5),
                              //     color: Color.fromRGBO(0, 74, 173, 0.1),
                              //   ),
                              //   BoxShadow(
                              //     blurRadius: 3,
                              //     offset: Offset(-5, -5),
                              //     color: Color.fromRGBO(0, 74, 173, 0.1),
                              //   ),
                              // ],
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            ])));
  }
}

class SplashScreen extends StatelessWidget {
  // arrumar erro de unable to load asset - asset not found
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Image.asset('viplabprojeto/assets/eyecheck_brand.png'), //
      ),
    );
  }
}

// ElevatedButton(
//           child: Text("Começar gravação"),
//           style: ElevatedButton.styleFrom(
//               backgroundColor: Colors.green,
//               padding: EdgeInsets.symmetric(horizontal: 35, vertical: 15),
//               textStyle: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
//           onPressed: () {
//             Navigator.push(
//                 context, MaterialPageRoute(builder: (context) => CameraPage()));
//           },
//         ),