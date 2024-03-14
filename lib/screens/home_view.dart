import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod_todo_app/config/theme/pallete.dart';
import 'package:flutter_riverpod_todo_app/screens/home_screen.dart';
import 'package:flutter_riverpod_todo_app/widgets/side_drawer.dart';
import 'package:flutter_svg/svg.dart';

class HomeView extends StatefulWidget {
  static route() => MaterialPageRoute(
        builder: (context) => const HomeView(),
      );
  const HomeView({super.key});

  @override
  State<HomeView> createState() => _HomeViewState();
}

class _HomeViewState extends State<HomeView> {
  int _page = 0;

  void onPageChange(int index) {
    setState(() {
      _page = index;
    });
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
      body: const HomeScreen(),
      drawer: const SideDrawer(),
    );
  }
}
