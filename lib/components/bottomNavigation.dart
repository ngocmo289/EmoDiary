import 'package:emodiary/screens/Statistic/chart.dart';
import 'package:emodiary/screens/ManagerDiary/homePage.dart';
import 'package:emodiary/screens/Notification/notice.dart';
import 'package:emodiary/screens/Profile/profile.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:curved_navigation_bar/curved_navigation_bar.dart';

class bottomNavigation extends StatefulWidget {
  const bottomNavigation({super.key});

  @override
  State<bottomNavigation> createState() => _bottomNavigationState();
}

class _bottomNavigationState extends State<bottomNavigation> {

  List screens = [const home(),const chart(),const notice(),const profile()];
  int _selectedIndex = 0; // State variable to keep track of the selected index

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBody: true,
      resizeToAvoidBottomInset: false,
      bottomNavigationBar: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 30),
        child: CurvedNavigationBar(
          backgroundColor: Colors.transparent,
          color: Colors.transparent,
          items: [
            _buildNavItemImg(0, "assets/logo2.png", "assets/logo2.png"),
            _buildNavItem(1, "assets/thongke.svg", "assets/thongke.svg"),
            _buildNavItem(2, "assets/notice.svg", "assets/notice.svg"),
            _buildNavItem(3, "assets/profile.svg", "assets/profile.svg"),
          ],
          onTap: _onItemTapped,
        ),
      ),
      body: screens[_selectedIndex], //
    );
  }

  Widget _buildNavItem(int index, String iconPath, String activeIconPath) {
    return Container(
      decoration: BoxDecoration(
        color: _selectedIndex == index ? Colors.blue[300] : Colors.transparent,
        shape: BoxShape.circle,
      ),
     padding: const EdgeInsets.all(10),
      child: SvgPicture.asset(
        _selectedIndex == index ? activeIconPath : iconPath,
        width: 30,
        height: 30,
      ),
    );
  }

  Widget _buildNavItemImg(int index, String iconPath, String activeIconPath) {
    return Container(
      decoration: BoxDecoration(
        color: _selectedIndex == index ? Colors.blue[300] : Colors.transparent,
        shape: BoxShape.circle,
      ),
      padding: const EdgeInsets.all(3),
      child:Image.asset(
        _selectedIndex == index ? activeIconPath : iconPath,
        width: 40,
        height: 40,
      )
    );
  }
}
