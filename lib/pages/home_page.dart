import 'package:flutter/material.dart';
import 'package:page_transition/page_transition.dart';
import 'package:spotify/json/songs_json.dart';
import 'package:spotify/pages/album_page.dart';
import 'package:spotify/theme/colors.dart';

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  int activeMenu1 = 0;
  int activeMenu2 = 2;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: getAppBar(),
      body: getBody(),
    );
  }

  AppBar getAppBar() {
    return AppBar(
      backgroundColor: Colors.black,
      elevation: 0,
      title: Padding(
        padding: const EdgeInsets.only(left: 10, right: 10),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: const [
            Text(
              "Explore",
              style: TextStyle(
                  fontSize: 20, color: white, fontWeight: FontWeight.bold),
            ),
            Icon(Icons.list),
          ],
        ),
      ),
    );
  }

  Widget getBody() {
    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          buildMenu(song_type_1, activeMenu1, (index) {
            setState(() {
              activeMenu1 = index;
            });
          }),
          buildSongList(songs , 0, songs.length),
          SizedBox(height: 10),
          buildMenu(song_type_2 as List<String> , activeMenu2, (index) {
            setState(() {
              activeMenu2 = index;
            });
          }),
          buildSongList(songs as List<Map<String, dynamic>>, 3, songs.length),
        ],
      ),
    );
  }

  // Reusable method to build the menu
  Widget buildMenu(List<String> menuItems, int activeMenu, Function(int) onTap) {
    return Padding(
      padding: const EdgeInsets.only(left: 30, top: 20),
      child: SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        child: Row(
          children: List.generate(menuItems.length, (index) {
            return Padding(
              padding: const EdgeInsets.only(right: 25),
              child: GestureDetector(
                onTap: () => onTap(index),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      menuItems[index],
                      style: TextStyle(
                          fontSize: 15,
                          color: activeMenu == index ? primary : grey,
                          fontWeight: FontWeight.w600),
                    ),
                    SizedBox(height: 3),
                    activeMenu == index
                        ? Container(
                      width: 10,
                      height: 3,
                      decoration: BoxDecoration(
                          color: primary,
                          borderRadius: BorderRadius.circular(5)),
                    )
                        : Container(),
                  ],
                ),
              ),
            );
          }),
        ),
      ),
    );
  }

  // Reusable method to build the song list
  Widget buildSongList(List<Map<String, dynamic>> songs, int startIndex, int endIndex) {
    return Padding(
      padding: const EdgeInsets.only(left: 30),
      child: SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        child: Row(
          children: List.generate(endIndex - startIndex, (index) {
            return Padding(
              padding: const EdgeInsets.only(right: 20),
              child: GestureDetector(
                onTap: () {
                  Navigator.push(
                    context,
                    PageTransition(
                      alignment: Alignment.bottomCenter,
                      child: AlbumPage(
                        song: songs[startIndex + index],
                      ),
                      type: PageTransitionType.scale,
                    ),
                  );
                },
                child: Column(
                  children: [
                    FutureBuilder<void>(
                      future: precacheImage(AssetImage(songs[startIndex + index]['img']), context), // Предварительная загрузка изображения
                      builder: (BuildContext context, AsyncSnapshot<void> snapshot) {
                        if (snapshot.connectionState == ConnectionState.waiting) {
                          return Container(
                            width: 140,
                            height: 140,
                            decoration: BoxDecoration(
                              color: Colors.black87, // Серый фон
                              borderRadius: BorderRadius.circular(10),
                            ),
                          );
                        } else if (snapshot.hasError) {
                          // Если ошибка загрузки, можно показать ошибку
                          return Center(child: Icon(Icons.error, color: Colors.red));
                        } else {
                          // Когда изображение загружено, показываем его
                          return Container(
                            width: 140,
                            height: 140,
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(10),
                            ),
                            child: Image.asset(
                              songs[startIndex + index]['img'],
                              fit: BoxFit.cover,
                            ),
                          );
                        }
                      },
                    ),
                    SizedBox(height: 10),
                    Text(
                      songs[startIndex + index]['title'],
                      style: TextStyle(
                        fontSize: 15,
                        color: white,
                        fontWeight: FontWeight.w600,
                      ),
                      textAlign: TextAlign.center,
                    ),
                    SizedBox(height: 5),
                    SizedBox(
                      width: 140,
                      height: 35,// Фиксированная ширина для описания
                      child: Text(
                        songs[startIndex + index]['description'],
                        maxLines: 2,  // Ограничиваем количество строк
                        overflow: TextOverflow.ellipsis,  // Текст обрезается, если слишком длинный
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          fontSize: 12,
                          color: grey,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            );
          }),
        ),
      ),
    );
  }
}
