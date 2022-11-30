import 'package:flutter/material.dart';
import 'package:camera/camera.dart';

class CameraPage extends StatefulWidget {
  const CameraPage({Key? key}) : super(key: key);

  @override
  _CameraPageState createState() => _CameraPageState();
}

class _CameraPageState extends State<CameraPage> {
  bool _isLoading = true;
  late CameraController _cameraController;

  @override
  void dispose() {
    _cameraController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (_isLoading) {
      return Container(
        color: Colors.white,
        child: const Center(
          child: CircularProgressIndicator(),
        ),
      );
    } else {
      return CameraPreview(_cameraController);
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
            .max); // criando instancia do camera controller, setando a resoluçao pra max
    await _cameraController.initialize(); // inicializando
    setState(
        () => _isLoading = false); // depois de iniciar, o loading vai pra falso
  }

  @override
  void initState() {
    super.initState();
    _initCamera();
  }
}
