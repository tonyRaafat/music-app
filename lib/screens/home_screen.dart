import 'package:flutter/material.dart';
import 'package:music_player/screens/all_songs.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({Key? key}) : super(key: key);


  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
     
      color: Colors.black
      ),
      child:const Scaffold(
        backgroundColor: Colors.transparent,
        appBar:  _CustomAppBar(),
        body: AllSongs(),
        // bottomNavigationBar:  _CustomBottomNavBar(),
      ),
    );
  }
}

class _CustomBottomNavBar extends StatelessWidget {
  const _CustomBottomNavBar({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return BottomNavigationBar(
      type: BottomNavigationBarType.fixed,
      unselectedItemColor: const Color.fromARGB(82, 255, 255, 255),
      selectedItemColor: Colors.white,
      backgroundColor: const Color.fromARGB(0, 255, 0, 0),
      showSelectedLabels: false,
      showUnselectedLabels: false,
      // elevation: 1,
      items: const [
        BottomNavigationBarItem(icon: Icon(Icons.home), label: 'Home'),
        BottomNavigationBarItem(
            icon: Icon(Icons.favorite_outline), label: 'Favorites'),
        BottomNavigationBarItem(
            icon: Icon(Icons.play_circle_outline), label: 'Play'),
        BottomNavigationBarItem(
            icon: Icon(Icons.people_outline_sharp), label: 'Profile')
      ],
    );
  }
}

class _CustomAppBar extends StatelessWidget implements PreferredSizeWidget {
  const _CustomAppBar({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return AppBar(
      iconTheme: IconThemeData(color: Colors.white),
      backgroundColor: Colors.transparent,
      
      elevation: 0,
      title: Text('Hello, Music World'),
      // leading: const Icon(Icons.grid_view_rounded),
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(56.0);
}



