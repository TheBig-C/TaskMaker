import 'package:flutter/material.dart';
import 'package:flutter_riverpod_todo_app/screens/home_screen.dart';
import 'package:flutter_riverpod_todo_app/screens/search_screen.dart';
import 'package:flutter_riverpod_todo_app/user_profile/widget/user_profile.dart';
import 'package:flutter_riverpod_todo_app/widgets/side_drawer.dart';
import 'package:flutter_svg/svg.dart';

class HomeView extends StatefulWidget {
  const HomeView({Key? key}) : super(key: key);

  @override
  _HomeViewState createState() => _HomeViewState();

  static route() => MaterialPageRoute(
        builder: (context) => const HomeView(),
      );
}

class _HomeViewState extends State<HomeView> {
  late PageController _pageController;
  int _currentIndex = 0;

  @override
  void initState() {
    super.initState();
    _pageController = PageController(initialPage: _currentIndex);
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: SvgPicture.asset(
          '../assets/svgs/taskMasterLogo.svg',
          height: 30,
        ),
        centerTitle: true,
      ),
      body: PageView(
        controller: _pageController,
        onPageChanged: (index) {
          setState(() {
            _currentIndex = index;
          });
        },
        children: [
          HomeScreen(),
          UserProfile(),
        ],
      ),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _currentIndex,
        onTap: (index) {
          setState(() {
            _currentIndex = index;
            _pageController.animateToPage(
              index,
              duration: const Duration(milliseconds: 300),
              curve: Curves.ease,
            );
          });
        },
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: 'Inicio',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.account_circle),
            label: 'Perfil',
          ),
        ],
      ),
      drawer: const SideDrawer(),
    );
  }
}
