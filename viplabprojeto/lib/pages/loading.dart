import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:http/http.dart' as http;
import 'package:viplabprojeto/pages/results.dart';

class LoadingScreen extends StatefulWidget {
  @override
  _LoadingScreenState createState() => _LoadingScreenState();
}

class _LoadingScreenState extends State<LoadingScreen> {
  bool _isLoading = true;

  Future<void> _loadResults() async {
    // checar a api a cada 10 segundos
    const interval = Duration(seconds: 10);

    while (_isLoading) {
      // requisição é realizada caso os resultados estejam prontos
      final response =
          await http.get(Uri.parse('http://192.168.100.23:8000/link/'));

      // verificar status
      if (response.statusCode == 200) {
        setState(() {
          _isLoading =
              false; // Definir o estado como "false" para interromper o carregamento
        });
        Navigator.pushReplacement(
            context, MaterialPageRoute(builder: (context) => Results()));
        break;
      }

      //aguardar o intervalo pra poder verificar novamente
      await Future.delayed(interval);
    }
  }

  @override
  void initState() {
    super.initState();
    _loadResults();
  }

  @override
  Widget build(BuildContext context) {
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
      DeviceOrientation.portraitDown,
    ]);
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              'O processo demorará alguns minutos para gerar o resultado.',
              style: TextStyle(
                fontSize: 25,
                color: Color.fromRGBO(37, 125, 242, 1),
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(height: 16),
            CircularProgressIndicator(),
          ],
        ),
      ),
    );
  }
}
