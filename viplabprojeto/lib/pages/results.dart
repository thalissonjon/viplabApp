import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:flutter/services.dart';

class Results extends StatefulWidget {
  Results({Key? key}) : super(key: key);

  @override
  _ResultsState createState() => _ResultsState();
}

class _ResultsState extends State<Results> {
  List<Map<String, dynamic>> data = [];

  Future<void> resultadosAPI() async {
    final response =
        await http.get(Uri.parse('http://192.168.100.23:8000/link/'));
    // final Map<String, dynamic> data = json.decode(response.body);
    final Map<String, dynamic> data = jsonDecode(response.body);
    setState(() {
      this.data = [data];
    });
    print("#####################################");
    print(data);
    print(data['File']);

    String headers = data[0].cast<String>(); // primeiro item da primeira lista
    String values = data[1].cast<String>(); // primeiro item da segunda lista
    // List<String> headerList = headers.split(";"); // separa o cabeçalho por ";"
    // List<String> valuesList = values.split(";"); // separa os valores por ";"
    List<String> finalList = [];

    for (int i = 0; i < headers.length; i++) {
      String header = headers[i];
      String value = values[i];
      finalList.add('$header: $value');
    }

    print(finalList);
    print(finalList[1]);
  }

  @override
  void initState() {
    super.initState();
    resultadosAPI();
    SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp]);
  }

  @override
  void dispose() {
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
      DeviceOrientation.portraitDown,
      DeviceOrientation.landscapeLeft,
      DeviceOrientation.landscapeRight,
    ]);
    super.dispose();
  }

  // @override
  // Widget build(BuildContext context) {
  //   return Scaffold(
  //     body: Container(
  //         padding: const EdgeInsets.only(
  //           top: 60,
  //           left: 20,
  //           right: 20,
  //         ),
  //         child: Column(
  //           children: [
  //             Row(
  //               children: [
  //                 Text("Resultados",
  //                     style:
  //                         TextStyle(fontSize: 20, fontWeight: FontWeight.bold))
  //               ],
  //             ),
  //             Expanded(
  //               child: ListView.builder(
  //                   itemCount: data.length,
  //                   itemBuilder: (BuildContext context, int index) {
  //                     final Map<String, dynamic> row = data[index];
  //                     List<Widget> rowWidgets = [];
  //                     return Row(
  //                       children: [
  //                         Container(
  //                           height: 170,
  //                           width: 200,
  //                           decoration: BoxDecoration(
  //                               color: Colors.white,
  //                               borderRadius: BorderRadius.circular(15),
  //                               boxShadow: [
  //                                 BoxShadow(
  //                                     blurRadius: 3,
  //                                     offset: Offset(5, 5),
  //                                     color: Color.fromRGBO(0, 74, 173, 0.5)),
  //                                 BoxShadow(
  //                                     blurRadius: 3,
  //                                     offset: Offset(-5, -5),
  //                                     color: Color.fromRGBO(0, 74, 173, 0.5))
  //                               ]),
  //                           child: Align(
  //                               alignment: Alignment.topCenter,
  //                               child: Column(
  //                                 children: [
  //                                   Center(
  //                                       child: Text("DHE",
  //                                           style: TextStyle(
  //                                               fontSize: 14,
  //                                               fontWeight: FontWeight.w600,
  //                                               color: Color.fromRGBO(
  //                                                   0, 74, 173, 1)))),
  //                                   Center(
  //                                       child: Text(
  //                                     row[3].toString(),
  //                                     style: TextStyle(
  //                                         fontSize: 13,
  //                                         fontWeight: FontWeight.w300,
  //                                         color: Color.fromRGBO(0, 74, 173, 1)),
  //                                   ))
  //                                 ],
  //                               )),
  //                         )
  //                       ],
  //                     );
  //                   }),
  //             )
  //           ],
  //         )),
  //   );
  // }
  @override
  Widget build(BuildContext context) {
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
      DeviceOrientation.portraitDown,
    ]);

    return Scaffold(
      body: Container(
        padding: const EdgeInsets.only(
          top: 60,
          left: 20,
          right: 20,
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Resultados',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(height: 16.0),
            Expanded(
              child: ListView.builder(
                itemCount: data.length,
                itemBuilder: (BuildContext context, int index) {
                  final Map<String, dynamic> row = data[index];
                  List<Widget> rowWidgets = [];
                  for (String key in row.keys) {
                    rowWidgets.add(
                      Container(
                        height: 50,
                        margin: const EdgeInsets.only(top: 20),
                        width: MediaQuery.of(context).size.width,
                        decoration: BoxDecoration(
                            color: Colors.white,
                            border: Border.all(
                                width: 1, color: Colors.grey.withOpacity(0.2)),
                            boxShadow: [
                              BoxShadow(
                                  blurRadius: 5,
                                  spreadRadius: 2,
                                  offset: Offset(8, 10),
                                  color: Color.fromRGBO(0, 74, 173, 0.4))
                            ]),
                        child: Center(
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              Text(
                                key,
                                style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  color: Color.fromRGBO(0, 74, 173, 0.4),
                                ),
                              ),
                              Text(row[key].toString(),
                                  style: TextStyle(
                                      color: Color.fromRGBO(0, 74, 173, 1),
                                      fontSize: 14,
                                      fontWeight: FontWeight.w300)),
                            ],
                          ),
                        ),
                      ),
                    );
                  }
                  return Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: rowWidgets,
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
