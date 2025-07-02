import 'package:finshyt/constants/app_colors.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class NavBar extends StatefulWidget {
  const NavBar({super.key});

  @override
  State<NavBar> createState() => _MyWidgetState();
}

class _MyWidgetState extends State<NavBar> {

  int _selectedIndex = 0;

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }
  
  @override
  Widget build(BuildContext context) {
    return  ClipRRect(
        borderRadius: BorderRadiusGeometry.circular(8),
        child: BottomNavigationBar(
          items: [
            BottomNavigationBarItem(
              icon: Icon(Icons.home_outlined),
              label: 'DashBoard',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.insights_sharp),
              label: 'Manage',
            ),
          ],
          currentIndex: _selectedIndex,
          onTap: _onItemTapped,
          selectedItemColor: AppColors.primary,
          unselectedItemColor: AppColors.secondaryButton,
          selectedLabelStyle: GoogleFonts.inter(color: AppColors.primary, fontSize: 16),
          unselectedLabelStyle: GoogleFonts.inter(color: AppColors.secondaryButton, fontSize: 12),
          iconSize: 28,
          type: BottomNavigationBarType.fixed,
          showSelectedLabels: true,
          showUnselectedLabels: true,
        ),
      );
  }
}