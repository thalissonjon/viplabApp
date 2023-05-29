import 'package:flutter/material.dart';
import 'package:camera/camera.dart';
import 'package:viplabprojeto/pages/video_page.dart';
import 'package:flutter/services.dart';

class CameraPage extends StatefulWidget {
  const CameraPage({Key? key}) : super(key: key);

  @override
  _CameraPageState createState() => _CameraPageState();
}

class _CameraPageState extends State<CameraPage> {
  bool _isLoading = true;
  bool _isRecording = false;
  late CameraController _cameraController;

  @override
  void initState() {
    super.initState();
    // Define a orientação como retrato ao entrar na página da câmera
    SystemChrome.setPreferredOrientations([
      // DeviceOrientation.portraitUp,
      // DeviceOrientation.portraitDown,
      DeviceOrientation.landscapeLeft,
      DeviceOrientation.landscapeRight,
    ]);
    _initCamera();
  }

  @override
  void dispose() {
    // Define a orientação padrão ao sair da página da câmera
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
      DeviceOrientation.portraitDown,
      DeviceOrientation.landscapeLeft,
      DeviceOrientation.landscapeRight,
    ]);
    _cameraController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.landscapeLeft,
      DeviceOrientation.landscapeRight,
    ]); // configurando a orientação da tela para paisagem

    if (_isLoading) {
      return Container(
        color: Colors.white,
        child: const Center(
          child: CircularProgressIndicator(),
        ),
      );
    } else {
      return Center(
        child: Stack(
          alignment: Alignment.bottomCenter,
          children: [
            CameraPreview(_cameraController),
            Padding(
              padding: const EdgeInsets.all(25),
              child: FloatingActionButton(
                backgroundColor: Colors.red,
                child: Icon(_isRecording ? Icons.stop : Icons.circle),
                onPressed: () => _recordVideo(),
              ),
            ),
          ],
        ),
      );
    }
  }

  _initCamera() async {
    final cameras = await availableCameras(); // checa as cameras disponiveis
    final front = cameras.firstWhere((camera) =>
        camera.lensDirection ==
        CameraLensDirection.front); // seleciona a camera frontal
    _cameraController = CameraController(
        front,
        ResolutionPreset
            .high); // criando instancia do camera controller, setando a resoluçao pra high
    await _cameraController.initialize(); // inicializando
    setState(
        () => _isLoading = false); // depois de iniciar, o loading vai pra falso
  }

  _recordVideo() async {
    if (_isRecording) {
      final file = await _cameraController
          .stopVideoRecording(); //retorna o arquivo de video
      setState(() => _isRecording = false); // update
      final route = MaterialPageRoute(
        // abrir o arquivo para checagem
        fullscreenDialog: true,
        builder: (_) => VideoPage(filePath: file.path),
      );
      Navigator.push(context, route);
    } else {
      // se nao esta gravando, prepara para gravar
      await _cameraController.prepareForVideoRecording();
      await _cameraController.startVideoRecording();
      setState(() => _isRecording = true); // começou a gravar
    }
  }

  // @override
  // void initState() {
  //   super.initState();
  //   _initCamera();
  // }
}
