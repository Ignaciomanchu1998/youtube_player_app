import 'package:flutter/material.dart';
import 'package:youtube_player_flutter/youtube_player_flutter.dart';

void main() => runApp(const MyApp());

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Video player',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        useMaterial3: true,
      ),
      home: Scaffold(
        appBar: AppBar(
          title: const Text('Material App Bar'),
        ),
        body: const _MyHomePageWidget(
          title: 'Video player',
          url: 'https://www.youtube.com/watch?v=BBAyRBTfsOU',
        ),
      ),
    );
  }
}

class _MyHomePageWidget extends StatefulWidget {
  const _MyHomePageWidget({
    Key? key,
    required this.title,
    required this.url,
  }) : super(key: key);

  final String title;
  final String url;

  @override
  State<_MyHomePageWidget> createState() => _MyHomePageWidgetState();
}

class _MyHomePageWidgetState extends State<_MyHomePageWidget> {
  late YoutubePlayerController _controller;

  late PlayerState playerState;
  late YoutubeMetaData videoMetaData;
  double volume = 100;
  bool muted = false;
  bool _isPlayerReady = false;

  @override
  void initState() {
    // Todo: implement initState
    super.initState();

    videoLoader(widget.url);
  }

  void videoLoader(String url) async {
    _controller = YoutubePlayerController(
      initialVideoId: YoutubePlayer.convertUrlToId(url)!,
      flags: const YoutubePlayerFlags(
        mute: false,
        autoPlay: true,
        disableDragSeek: false,
        loop: false,
        isLive: false,
        forceHD: false,
        enableCaption: true,
        showLiveFullscreenButton: true,
      ),
    )..addListener(listener);
    videoMetaData = const YoutubeMetaData();
    playerState = PlayerState.unknown;
  }

  void listener() {
    if (_isPlayerReady && mounted && !_controller.value.isFullScreen) {
      setState(() {
        playerState = _controller.value.playerState;
        videoMetaData = _controller.metadata;
      });
    }
  }

  @override
  void deactivate() {
    // Pauses video while navigating to next page.
    _controller.pause();
    super.deactivate();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Column(
        children: [
          const Text(
            'Consectetur sunt ullamco adipisicing culpa ipsum ullamco. Amet irure Lorem ad id consequat. Deserunt occaecat sint anim veniam labore anim occaecat aliqua nisi id elit laboris et.',
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w400,
            ),
          ),
          const SizedBox(height: 20),
          YoutubePlayer(
            controller: _controller,
            showVideoProgressIndicator: true,
            progressIndicatorColor: const Color.fromARGB(255, 2, 88, 238),
            onReady: () {
              _isPlayerReady = true;
            },
            onEnded: (data) {
              _controller.load(YoutubePlayer.convertUrlToId(widget.url) ?? '');
            },
            thumbnail: Container(
              decoration: const BoxDecoration(
                image: DecorationImage(
                  image: NetworkImage(
                    'https://img.youtube.com/vi/BBAyRBTfsOU/maxresdefault.jpg',
                  ),
                  fit: BoxFit.cover,
                ),
              ),
            ),
            bufferIndicator: const CircularProgressIndicator(
              strokeWidth: 2.0,
              valueColor: AlwaysStoppedAnimation<Color>(
                Color.fromARGB(255, 2, 88, 238),
              ),
            ),
          ),

          // Aquí se puede agregar más contenido
        ],
      ),
    );
  }
}
