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
  bool _showButtons = true;
  late CameraController _cameraController;
  late List<CameraDescription> _availableCameras;
  late int _currentCameraIndex;

  @override
  void initState() {
    super.initState();
    _initCamera();
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.landscapeLeft,
      DeviceOrientation.landscapeRight,
    ]);
  }

  @override
  void dispose() {
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.landscapeLeft,
      DeviceOrientation.landscapeRight,
      DeviceOrientation.portraitUp
    ]);
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
            if (_showButtons)
              Positioned(
                top: 10,
                left: 0,
                child: Padding(
                  padding: const EdgeInsets.only(bottom: 100),
                  child: ElevatedButton.icon(
                    onPressed: () => Navigator.of(context).pop(),
                    icon: Icon(Icons.arrow_back, size: 30),
                    label: Text(
                      'Voltar',
                      style:
                          TextStyle(fontSize: 18, fontWeight: FontWeight.w400),
                    ),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.transparent,
                    ),
                  ),
                ),
              ),
            if (_showButtons) // tive que colocar dois ifs com a mesma condiçao pra nao ter que envolver tudo em um container
              Positioned(
                top: 10,
                child: Padding(
                  padding: const EdgeInsets.only(bottom: 100),
                  child: ElevatedButton.icon(
                    onPressed: () => _switchCamera(),
                    icon: Icon(Icons.flip_camera_ios, size: 30),
                    label: Text('Alternar câmera',
                        style: TextStyle(
                            fontSize: 18, fontWeight: FontWeight.w400)),
                    style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.transparent),
                  ),
                ),
              ),
          ],
        ),
      );
    }
  }

  _initCamera() async {
    _availableCameras = await availableCameras();
    _currentCameraIndex = 0; // Define a primeira câmera como padrão
    _cameraController = CameraController(
      _availableCameras[_currentCameraIndex],
      ResolutionPreset.high,
    );
    await _cameraController.initialize();
    setState(() => _isLoading = false);
  }

  _switchCamera() {
    int newIndex = (_currentCameraIndex + 1) % _availableCameras.length;
    setState(() {
      _currentCameraIndex = newIndex;
      _cameraController = CameraController(
        _availableCameras[_currentCameraIndex],
        ResolutionPreset.high,
      );
      _cameraController.initialize().then((_) {
        if (mounted) {
          setState(() {});
        }
      });
    });
  }

  _recordVideo() async {
    if (_isRecording) {
      final file = await _cameraController
          .stopVideoRecording(); //retorna o arquivo de video
      setState(() {
        _isRecording = false;
        _showButtons = true;
      }); // update
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
      setState(() {
        _isRecording = true;
        _showButtons = false;
      }); // começou a gravar
    }
  }

  // @override
  // void initState() {
  //   super.initState();
  //   _initCamera();
  // }
}
