import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:flutter/services.dart';
import 'package:viplabprojeto/main.dart';

class Results extends StatefulWidget {
  Results({Key? key}) : super(key: key);

  @override
  _ResultsState createState() => _ResultsState();
}

class _ResultsState extends State<Results> {
  List<Map<String, dynamic>> data = [];
  bool hasResults = false;

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

  void _handleVoltarButton() {
    setState(() {
      hasResults = true;
    });
    
    Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => Gravar(hasResults: true)),
                  );
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
          bottom: 40,
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Resultados',
              style: TextStyle(
                fontSize: 25,
                color: Color.fromRGBO(0, 74, 173, 1),
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(height: 5),
            Expanded(
              child: ListView.builder(
                shrinkWrap: true,
                itemCount: data.length,
                itemBuilder: (BuildContext context, int index) {
                  final Map<String, dynamic> row = data[index];
                  List<Widget> rowWidgets = [];
                  for (String key in row.keys) {
                    rowWidgets.add(
                      Container(
                        height: 50,
                        margin: const EdgeInsets.only(top: 10),
                        width: MediaQuery.of(context).size.width,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(0.4),
                          color: Colors.white,
                          border: Border.all(
                            width: 1,
                            color: Colors.grey.withOpacity(0.2),
                          ),
                          boxShadow: [
                            BoxShadow(
                              blurRadius: 4,
                              spreadRadius: 1,
                              offset: Offset(8, 10),
                              color: Color.fromRGBO(0, 74, 173, 0.2),
                            ),
                          ],
                        ),
                        child: Center(
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              Text(
                                key,
                                style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 18,
                                  color: Color.fromRGBO(0, 74, 173, 1),
                                ),
                              ),
                              Text(
                                row[key].toString(),
                                style: TextStyle(
                                  color: Color.fromRGBO(0, 74, 173, 1),
                                  fontSize: 16,
                                  fontWeight: FontWeight.w300,
                                ),
                              ),
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
            // SizedBox(height: 20),
            Center(
              child: ElevatedButton(
                onPressed:
                  _handleVoltarButton,
                child: Text(
                  "Voltar para a página inicial",
                  style: TextStyle(
                    fontSize: 16,
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Color.fromRGBO(0, 74, 173, 1),
                  padding: EdgeInsets.symmetric(horizontal: 35, vertical: 20),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(50),
                  ),
                  shadowColor: Colors.black,
                  elevation: 10,
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}
