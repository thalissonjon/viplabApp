import 'dart:convert';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:path/path.dart';
import 'package:video_player/video_player.dart';
import 'package:gallery_saver/gallery_saver.dart';
import 'package:viplabprojeto/api/firebase_api.dart';
import 'package:viplabprojeto/pages/loading.dart';
import 'package:http/http.dart' as http;
import 'package:flutter/services.dart';
import 'package:uuid/uuid.dart';

// replay no video gravado
class VideoPage extends StatefulWidget {
  final String filePath;
  const VideoPage({Key? key, required this.filePath}) : super(key: key);

  @override
  _VideoPageState createState() => _VideoPageState();
}

class _VideoPageState extends State<VideoPage> {
  late VideoPlayerController _videoPlayerController;
  var token = Uuid().v4();

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
  }

  @override
  void dispose() {
    // SystemChrome.setPreferredOrientations([
    //   DeviceOrientation.portraitUp,
    //   DeviceOrientation.portraitDown,
    //   DeviceOrientation.landscapeLeft,
    //   DeviceOrientation.landscapeRight,
    // ]);
    _videoPlayerController.dispose();
    super.dispose();
  }

  Future _initVideoPlayer() async {
    _videoPlayerController = VideoPlayerController.file(File(widget
        .filePath)); // criar um novo video controller com o file passado para esse  widget
    await _videoPlayerController.initialize();
    await _videoPlayerController.setLooping(true); // rodar o video varias vezes
    await _videoPlayerController.play(); // startar o video

    print("--------------------------------------------------------");
  }

  _saveFile() async {
    final video = File(widget.filePath);
    await GallerySaver.saveVideo(video.path);
    File(video.path).deleteSync();
  }

  Future uploadVideo() async {
    final video = File(widget.filePath);

    final fileName = basename(video.path);
    final destination = 'videosCoverTest/$fileName';

    final task = FirebaseApi.uploadVideo(destination, video);
    if (task == null) return; // sera null se ocorrer algum erro na api

    final snapshot = await task!.whenComplete(() {});
    final url = await snapshot.ref.getDownloadURL();

    // String apiUrl = 'http://thalisson.pythonanywhere.com/link/';

    // String url =
    //     'https://firebasestorage.googleapis.com/v0/b/viplabcovertest-ade03.appspot.com/o/videosCoverTest%2FREC4083772658994295899.mp4?alt=media&token=10de9ecf-15f8-46d0-9f47-7632479ae098';
    String apiUrl = 'http://192.168.100.23:8000/link/';
    var response = await http.post(
      Uri.parse(apiUrl),
      headers: <String, String>{'Content-Type': 'text/plain'},
      body: jsonEncode(<String, String>{'link': url, 'token': token}),
    );

    print(response.statusCode);
    return response;
  }

  Future<void> resultadosAPI() async {
    final response =
        await http.get(Uri.parse('http://192.168.100.23:8000/link/'));
    // final Map<String, dynamic> data = json.decode(response.body);
    final Map<String, dynamic> data = jsonDecode(response.body);
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
  Widget build(BuildContext context) {
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.landscapeLeft,
      DeviceOrientation.landscapeRight,
    ]);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Preview'),
        elevation: 0,
        backgroundColor: Colors.black26,
        actions: [
          IconButton(
            icon: const Icon(Icons.check),
            onPressed: () {
              // _saveFile(); // clicar pra salvar
              uploadVideo(); // upload para o firebase storage e envio
              // resultadosAPI();
              // sendUrl();
              // sendLink();

              Navigator.push(
                  // context, MaterialPageRoute(builder: (context) => Gravar()));
                  context,
                  MaterialPageRoute(
                      builder: (context) => LoadingScreen(token: token)));
              // sendLink(urlDownload);
            },
          )
        ],
      ),
      extendBodyBehindAppBar: true,
      body: FutureBuilder(
        future: _initVideoPlayer(),
        builder: (context, state) {
          if (state.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else {
            return VideoPlayer(_videoPlayerController);
          }
        },
      ),
    );
  }
}

/* uploadImage(String title, File file) {
  var request = http.MultipartRequest(
      "POST", Uri.parse("gs://viplabcovertest.appspot.com/videos"));

  request.fields['title'] = "covervideo";

  var video = http.MultipartFile.fromBytes('video', (await rootBundle.load('assets/testimage.png')).buffer.asUint8List(), filename: 'testimage.png');
}  */

