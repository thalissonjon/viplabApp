import 'dart:io';
import 'package:flutter/material.dart';
import 'package:path/path.dart';
import 'package:video_player/video_player.dart';
import 'package:gallery_saver/gallery_saver.dart';
import 'package:viplabprojeto/main.dart';
import 'package:viplabprojeto/api/firebase_api.dart';
import 'package:viplabprojeto/pages/firebase_list.dart';
import 'package:http/http.dart' as http;

// import 'package:camera/camera.dart';

// replay no video gravado
class VideoPage extends StatefulWidget {
  final String filePath;

  const VideoPage({Key? key, required this.filePath}) : super(key: key);

  @override
  _VideoPageState createState() => _VideoPageState();
}

class _VideoPageState extends State<VideoPage> {
  late VideoPlayerController _videoPlayerController;

  @override
  void dispose() {
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
    final urlDownload = await snapshot.ref.getDownloadURL();
    print("Link do download $urlDownload");
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Preview'),
        elevation: 0,
        backgroundColor: Colors.black26,
        actions: [
          IconButton(
            icon: const Icon(Icons.check),
            onPressed: () {
              _saveFile(); // clicar pra salvar
              uploadVideo(); // upload para o firebase storage
              Navigator.push(
                  // context, MaterialPageRoute(builder: (context) => Gravar()));
                  context, MaterialPageRoute(builder: (context) => Firebaselist()));
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

