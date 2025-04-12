import 'package:flutter/material.dart';
import 'package:spotify/pages/music_detail_page.dart';
import '../json/songs_json.dart';
import '../theme/colors.dart';

class AlbumPage extends StatefulWidget {
  final dynamic song;

  const AlbumPage({Key? key, this.song}) : super(key: key);

  @override
  _AlbumPageState createState() => _AlbumPageState();
}

class _AlbumPageState extends State<AlbumPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: getBody(),
    );
  }

  void navigateWithScaleTransition(Widget page) {
    Navigator.push(
      context,
      PageRouteBuilder(
        transitionDuration: const Duration(milliseconds: 500),
        pageBuilder: (context, animation, secondaryAnimation) => page,
        transitionsBuilder: (context, animation, secondaryAnimation, child) {
          final curved = CurvedAnimation(parent: animation, curve: Curves.easeInOut);
          return ScaleTransition(
            alignment: Alignment.bottomCenter,
            scale: curved,
            child: child,
          );
        },
      ),
    );
  }

  Widget getBody() {
    final size = MediaQuery.of(context).size;
    final List songAlbums = widget.song['songs'];

    return Stack(
      children: [
        SingleChildScrollView(
          child: Column(
            children: [
              buildAlbumHeader(size),
              const SizedBox(height: 30),
              buildAlbumTitle(),
              buildHorizontalSongList(),
              const SizedBox(height: 30),
              buildSongList(songAlbums, size),
            ],
          ),
        ),
        buildAppBar(),
      ],
    );
  }

  Widget buildAlbumHeader(Size size) {
    return Container(
      width: size.width,
      height: 220,
      decoration: BoxDecoration(
        image: DecorationImage(
          image: AssetImage(widget.song['img']),
          fit: BoxFit.cover,
        ),
      ),
    );
  }

  Widget buildAlbumTitle() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 30),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            widget.song['title'],
            style: const TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: Colors.white,
            ),
          ),
          Container(
            decoration: BoxDecoration(
              color: Colors.grey,
              borderRadius: BorderRadius.circular(5),
            ),
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
            child: const Text('Subscribe', style: TextStyle(color: white)),
          ),
        ],
      ),
    );
  }

  Widget buildHorizontalSongList() {
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: Padding(
        padding: const EdgeInsets.only(left: 30),
        child: Row(
          children: List.generate(songs.length, (index) {
            final song = songs[index];
            return Padding(
              padding: const EdgeInsets.only(right: 30),
              child: GestureDetector(
                onTap: () => navigateWithScaleTransition(
                  MusicDetailPage(
                    title: song['title'],
                    color: song['color'],
                    description: song['description'],
                    img: song['img'],
                    songUrl: song['song_url'],
                  ),
                ),
                child: buildSongCard(song),
              ),
            );
          }),
        ),
      ),
    );
  }

  Widget buildSongCard(dynamic song) {
    return Column(
      children: [
        Container(
          width: 120,
          height: 120,
          decoration: BoxDecoration(
            image: DecorationImage(
              image: AssetImage(song['img']),
              fit: BoxFit.cover,
            ),
            color: primary,
            borderRadius: BorderRadius.circular(10),
          ),
        ),
        const SizedBox(height: 20),
        Text(
          song['title'],
          style: const TextStyle(
            fontSize: 15,
            color: white,
            fontWeight: FontWeight.w600,
          ),
        ),
        const SizedBox(height: 5),
        SizedBox(
          width: MediaQuery.of(context).size.width - 210,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                song['song_count'],
                style: const TextStyle(fontSize: 12, color: grey, fontWeight: FontWeight.w600),
              ),
              Text(
                song['date'],
                style: const TextStyle(fontSize: 12, color: grey, fontWeight: FontWeight.w600),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget buildSongList(List albumSongs, Size size) {
    return Column(
      children: List.generate(albumSongs.length, (index) {
        final song = albumSongs[index];
        return Padding(
          padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 5),
          child: GestureDetector(
            onTap: () => navigateWithScaleTransition(
              MusicDetailPage(
                title: widget.song['title'],
                color: widget.song['color'],
                description: widget.song['description'],
                img: widget.song['img'],
                songUrl: widget.song['song_url'],
              ),
            ),
            child: Row(
              children: [
                SizedBox(
                  width: (size.width - 60) * 0.77,
                  child: Text(
                    "${index + 1} ${song['title']}",
                    style: const TextStyle(color: white),
                  ),
                ),
                SizedBox(
                  width: (size.width - 60) * 0.23,
                  height: 50,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(song['duration'], style: const TextStyle(color: grey, fontSize: 14)),
                      Container(
                        width: 25,
                        height: 25,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: grey.withOpacity(0.8),
                        ),
                        child: const Center(
                          child: Icon(Icons.play_arrow, color: white, size: 16),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        );
      }),
    );
  }

  Widget buildAppBar() {
    return SafeArea(
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          IconButton(
            icon: const Icon(Icons.arrow_back_ios, color: Colors.white),
            onPressed: () => Navigator.pop(context),
          ),
          IconButton(
            icon: const Icon(Icons.more_vert, color: Colors.white),
            onPressed: () => Navigator.pop(context),
          ),
        ],
      ),
    );
  }
}
