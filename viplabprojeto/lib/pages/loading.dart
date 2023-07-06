import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:http/http.dart' as http;
import 'package:viplabprojeto/pages/results.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';

class LoadingScreen extends StatefulWidget {
  final String token;

  LoadingScreen({required this.token});

  @override
  _LoadingScreenState createState() => _LoadingScreenState();
}

class _LoadingScreenState extends State<LoadingScreen> {
  bool _isLoading = true;

  FlutterLocalNotificationsPlugin? _flutterLocalNotificationsPlugin;

  Future<void> _loadResults() async {
    const String title = 'Seu resultado está pronto!';
    const String body = 'Abra o aplicativo para ver o resultado do seu teste!';
    // checar a api a cada 10 segundos
    const interval = Duration(seconds: 10);
    String apiUrl = 'http://192.168.100.23:8000/link/';

    while (_isLoading) {
      // requisição é realizada caso os resultados estejam prontos
      // final response =
      //     await http.get(Uri.parse('http://192.168.100.23:8000/link/'));

      final response = await http.get(
        Uri.parse(apiUrl),
        headers: {
          'Authorization': 'Bearer ${widget.token}',
        },
      );

      print("##############################");
      print(widget.token);

      // verificar status
      if (response.statusCode == 200) {
        setState(() {
          _isLoading =
              false; // Definir o estado como "false" para interromper o carregamento
        });

        _showNotification(title, body);

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
    _initializeLocalNotifications();
  }

  Future<void> _initializeLocalNotifications() async {
    const int notificationId = 0;
    const String channelId = 'ready';
    const String channelName = 'notif';
    const String title = 'Seu resultado está pronto!';
    const String body = 'Abra o aplicativo para ver o resultado do seu teste.';

    const AndroidInitializationSettings initializationSettingsAndroid =
        AndroidInitializationSettings('app_icon');
    final InitializationSettings initializationSettings =
        InitializationSettings(android: initializationSettingsAndroid);
    _flutterLocalNotificationsPlugin ??= FlutterLocalNotificationsPlugin();
    await _flutterLocalNotificationsPlugin!.initialize(initializationSettings);
  }

  Future<void> _showNotification(String title, String body) async {
    const AndroidNotificationDetails androidPlatformChannelSpecifics =
        AndroidNotificationDetails('ready', 'notif',
            importance: Importance.high, priority: Priority.high);
    const NotificationDetails platformChannelSpecifics =
        NotificationDetails(android: androidPlatformChannelSpecifics);

    await _flutterLocalNotificationsPlugin!.show(
      0,
      title,
      body,
      platformChannelSpecifics,
    );
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
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              'O processo demorará alguns minutos para gerar o resultado.',
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 18,
                color: Color.fromRGBO(37, 125, 242, 1),
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(
              height: 20,
            ),
            CircularProgressIndicator(),
            SizedBox(height: 20),
            Text(
              'Você será notificado quando o resultado estiver pronto.',
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 18,
                color: Color.fromRGBO(37, 125, 242, 1),
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
