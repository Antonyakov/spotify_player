import 'package:audioplayers/audioplayers.dart';
import 'package:flutter/material.dart';
import 'package:spotify/theme/colors.dart';

class MusicDetailPage extends StatefulWidget {
  final String title;
  final String description;
  final Color color;
  final String img;
  final String songUrl;

  const MusicDetailPage({
    required this.title,
    required this.description,
    required this.color,
    required this.img,
    required this.songUrl,
    Key? key,
  }) : super(key: key);

  @override
  _MusicDetailPageState createState() => _MusicDetailPageState();
}

class _MusicDetailPageState extends State<MusicDetailPage> {
  double _currentSliderValue = 0.0;
  double _maxSliderValue = 200.0;

  late AudioPlayer advancedPlayer;
  bool isPlaying = true;
   Duration _songDuration = Duration(seconds: 0);
   Duration _currentPosition = Duration(seconds: 0);

  @override
  void initState() {
  super.initState();
  initPlayer();

  }

  void initPlayer() {
    advancedPlayer = AudioPlayer();
    advancedPlayer.onDurationChanged.listen((duration) {
      setState(() {
        _songDuration = duration;
        _maxSliderValue = duration.inMilliseconds.toDouble();
      });
    });

    advancedPlayer.onPositionChanged.listen((position) {
      setState(() {
        _currentPosition = position;
        _currentSliderValue = position.inMilliseconds.toDouble();
      });
    });

    if (widget.songUrl.isNotEmpty) {
      playSound(widget.songUrl);
    } else {
      debugPrint("⚠️ songUrl is empty or null");
    }
  }

  Future<void> playSound(String localPath) async {
    try {
      await advancedPlayer.play(AssetSource(localPath));
    } catch (e) {
      debugPrint("❌ Error playing sound: $e");
    }
  }

  Future<void> stopSound() async {
    await advancedPlayer.stop();
  }

  Future<void> pauseSound() async {
    await advancedPlayer.pause();
  }

  Future<void> seekSound() async {
    await advancedPlayer.seek(Duration(milliseconds: _currentSliderValue.toInt()));
  }

  @override
  void dispose() {
    stopSound();
    super.dispose();
  }

  String formatDuration(Duration duration) {
    int minutes = duration.inMinutes;
    int seconds = duration.inSeconds % 60;
    return "${minutes}:${seconds.toString().padLeft(2, '0')}";
  }

  @override
  Widget build(BuildContext context) {
    var size = MediaQuery.of(context).size;

    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        backgroundColor: Colors.black,
        elevation: 0,
        actions: [
          IconButton(
            icon: Icon(Icons.more_vert, color: Colors.white),
            onPressed: () {},
          )
        ],
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            // Album Cover
            Stack(
              children: [
                Padding(
                  padding: const EdgeInsets.only(left: 30, right: 30, top: 20),
                  child: Container(
                    width: size.width - 100,
                    height: size.width - 100,
                    decoration: BoxDecoration(
                      boxShadow: [
                        BoxShadow(
                          color: widget.color,
                          blurRadius: 50,
                          spreadRadius: 5,
                          offset: Offset(-10, 40),
                        )
                      ],
                      borderRadius: BorderRadius.circular(20),
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(left: 30, right: 30, top: 20),
                  child: Container(
                    width: size.width - 80,
                    height: size.width - 80,
                    decoration: BoxDecoration(
                      image: DecorationImage(
                        image: AssetImage(widget.img),
                        fit: BoxFit.cover,
                      ),
                      borderRadius: BorderRadius.circular(20),
                    ),
                  ),
                ),
              ],
            ),

            SizedBox(height: 20),

            // Song Info
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 10),
              child: Container(
                width: size.width - 80,
                height: 70,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Icon(Icons.folder_special_outlined, color: white),
                    Column(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        Text(
                          widget.title,
                          style: TextStyle(
                            fontSize: 18,
                            color: white,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        SizedBox(
                          width: 150,
                          child: Text(
                            widget.description,
                            style: TextStyle(
                              fontSize: 15,
                              color: white.withOpacity(0.5),
                            ),
                            overflow: TextOverflow.ellipsis,
                          ),
                        )
                      ],
                    ),
                    Icon(Icons.more_vert, color: white),
                  ],
                ),
              ),
            ),

            SizedBox(height: 10),

            // Slider
            Slider(
              activeColor: primary,
              value: _currentSliderValue,
              min: 0,
              max: _maxSliderValue,
              onChanged: (value) {
                setState(() {
                  _currentSliderValue = value;
                });
                seekSound();
              },
            ),

            SizedBox(height: 20),

            // Timer text
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 30),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(formatDuration(_currentPosition), style: TextStyle(color: white.withOpacity(0.5))),
                  Text(formatDuration(_songDuration), style: TextStyle(color: white.withOpacity(0.5))),
                ],
              ),
            ),

            SizedBox(height: 12),

            // Controls
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Icon(Icons.shuffle, color: white.withOpacity(0.8), size: 25),
                  Icon(Icons.skip_previous, color: white.withOpacity(0.8), size: 25),
                  IconButton(
                    iconSize: 50,
                    icon: Container(
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: primary,
                      ),
                      child: Center(
                        child: Icon(
                          isPlaying
                              ? Icons.pause_circle_outline
                              : Icons.play_circle_outlined,
                          size: 28,
                          color: white,
                        ),
                      ),
                    ),
                    onPressed: () {
                      if (isPlaying) {
                        pauseSound();
                      } else {
                        playSound(widget.songUrl);
                      }
                      setState(() {
                        isPlaying = !isPlaying;
                      });
                    },
                  ),
                  Icon(Icons.skip_next, color: white.withOpacity(0.8), size: 25),
                  Icon(Icons.comment, color: white.withOpacity(0.8), size: 25),
                ],
              ),
            ),

            SizedBox(height: 15),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(Icons.tv, color: primary, size: 20),
                SizedBox(width: 10),
                Padding(
                  padding: const EdgeInsets.only(top: 3),
                  child: Text(
                    'Chromecast is ready',
                    style: TextStyle(color: primary),
                  ),
                ),
              ],
            )
          ],
        ),
      ),
    );
  }
}

