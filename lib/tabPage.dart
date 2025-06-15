import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:liquid_swipe/PageHelpers/LiquidController.dart';
import 'package:liquid_swipe/liquid_swipe.dart';
import 'package:newflutterproject/CartPage.dart';
import 'package:newflutterproject/HomePage.dart';
import 'package:newflutterproject/ProfilePage.dart';
import 'package:newflutterproject/SettingPage.dart';

class Tabpage extends StatefulWidget {
  const Tabpage({super.key});

  @override
  State<Tabpage> createState() => _TabpageState();
}

class _TabpageState extends State<Tabpage> {
  int _currentIndex = 0;
  late LiquidController _liquidController;

  @override
  void initState(){
    super.initState();
    _liquidController = LiquidController();
  }
  final List<Widget>pages= [
    HomePage(""),
    cartPage(),
    Profilepage(),
    SettingPage(),
  ];
  void _onTabTaps (int index){
    setState(() {
      _currentIndex = index;
    });
    _liquidController.animateToPage(page: index, duration: 500);
  }


  @override
  Widget build(BuildContext context) {
    return SafeArea(
        child:Scaffold(
          body: LiquidSwipe(
              pages:pages,
            enableLoop: true,
            positionSlideIcon: 0.5,
            waveType: WaveType.liquidReveal,
            slideIconWidget: Icon(Icons.back_hand),
            liquidController: _liquidController,
            onPageChangeCallback: (index){
                setState(() {
                  _currentIndex = index;
                });
            },
          ),
          bottomNavigationBar: BottomNavigationBar(
              currentIndex: _currentIndex,
              onTap: _onTabTaps,
              selectedItemColor: Colors.blue,
              unselectedItemColor: Colors.blueGrey,
              items: const[
                BottomNavigationBarItem(icon: Icon(Icons.home_outlined), label: "Home"),
                BottomNavigationBarItem(icon: Icon(Icons.shopping_bag_outlined), label: "Cart"),
                BottomNavigationBarItem(icon: Icon(Icons.person_outline), label: "Profile"),
                BottomNavigationBarItem(icon: Icon(Icons.settings), label: "Settings"),
          ],
            type: BottomNavigationBarType.fixed,
          ),
        ) );
  }
}
