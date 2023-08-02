import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:flutter/services.dart';
import 'package:viplabprojeto/main.dart';
import 'dart:io';
import 'package:path/path.dart' as path;
import 'package:path_provider/path_provider.dart';
import 'package:intl/intl.dart';

class Results extends StatefulWidget {
  final bool fromReq;
  Results({required this.fromReq});

  @override
  _ResultsState createState() => _ResultsState();
}

class _ResultsState extends State<Results> {
  List<Map<String, dynamic>> data = [];
  bool hasResults = false;

  Future<void> saveJsonData(Map<String, dynamic> jsonData) async {
    print("entrou na funçao de save");
    try {
      final directory = await getApplicationDocumentsDirectory();
      final file = File('${directory.path}/json/resultado.json');
      final pastaJson = Directory('${directory.path}/json');

      if (!(await pastaJson.exists())) {
        await pastaJson.create(recursive: true);
        print('pasta json criada com sucesso em: ${pastaJson.path}');
      } else {
        print('pasta json já existe em: ${pastaJson.path}');
      }

      String folderPath = directory.path + '/json';
      Directory folder = Directory(folderPath);

      // verificar se a pasta existe
      if (await folder.exists()) {
        List<FileSystemEntity> files = folder.listSync();
        print(files);

        // itera sobre os arquivos e remove
        for (FileSystemEntity file in files) {
          file.deleteSync();
        }

        print('Arquivos removidos com sucesso.');
      } else {
        print('A pasta está vazia.');
      }
      final jsonString = jsonEncode(jsonData);

      await file.writeAsString(jsonString);

      print('Arquivo JSON salvo com sucesso em: ${file.path}');
    } catch (e) {
      print('Erro ao salvar o arquivo JSON: $e');
    }
  }

  Future<void> resultadosAPI() async {
    if (widget.fromReq == true) {
      final response =
          await http.get(Uri.parse('http://192.168.100.23:8000/link/'));
      // final Map<String, dynamic> data = json.decode(response.body);
      final Map<String, dynamic> data = jsonDecode(response.body);

      DateTime now = DateTime.now();
      String formattedDateTime = DateFormat('yyyy-MM-dd HH:mm:ss').format(now);

      data['Data'] = formattedDateTime;

      print("indo entrar na funçao");
      saveJsonData(data);

      setState(() {
        this.data = [data];
      });
    } else {
      print("############################ veio da pagina principal");
      final directory = await getApplicationDocumentsDirectory();
      final file = File('${directory.path}/json/resultado.json');
      final jsonContent = await file.readAsString();
      final data = jsonDecode(jsonContent) as Map<String, dynamic>;

      setState(() {
        this.data = [data];
      });
    }
    print("#####################################");
    print(data);

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
                                  fontWeight: FontWeight.w400,
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
                onPressed: _handleVoltarButton,
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
