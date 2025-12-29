import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:grosly/templates/providers/global_variables.dart';
import 'package:provider/provider.dart';

import 'home.dart';
import 'basket_page.dart';
import 'check_out_page.dart';
import 'profile_page.dart';

class MainLayout extends StatefulWidget {
  const MainLayout({super.key});

  @override
  State<MainLayout> createState() => _MainLayoutState();
}

class _MainLayoutState extends State<MainLayout> {
  int _currentIndex = 0;

  List<Widget> get _pages => [
    Home(
      onNavigateToCategories: () {
        setState(() {
          _currentIndex = 1;
        });
      },
    ),
    ViewCategorie(
      onBackPressed: () {
        setState(() {
          _currentIndex = 0;
        });
      },
    ),
    const BasketPage(),
    const Checkout(),
    const ProfilePage(),
  ];

  @override
  Widget build(BuildContext context) {
    final cartItemCount = context.watch<GlobalVariables>().cartItemCount;

    return Scaffold(
      extendBody: true,
      backgroundColor: Colors.white,
      body: IndexedStack(
        index: _currentIndex,
        children: _pages,
      ),
      bottomNavigationBar: BottomNavigationBar(
        onTap: (value) {
          setState(() {
            _currentIndex = value;
          });
        },
        currentIndex: _currentIndex,
        elevation: 0,
        type: BottomNavigationBarType.fixed,
        backgroundColor: Colors.white,
        unselectedItemColor: const Color(0xFFB9BABD),
        selectedItemColor: const Color(0xFF61AD4E),
        showSelectedLabels: false,
        showUnselectedLabels: false,
        items: [
          const BottomNavigationBarItem(
            icon: Icon(FontAwesomeIcons.house, size: 20),
            label: "",
          ),
          const BottomNavigationBarItem(
            icon: Icon(Icons.grid_view_rounded, size: 20),
            label: "",
          ),
          BottomNavigationBarItem(
            icon: Stack(
              clipBehavior: Clip.none,
              children: [
                SizedBox(
                  height: 48,
                  width: 48,
                  child: DecoratedBox(
                    decoration: const BoxDecoration(
                      color: Color(0xFF61AD4E),
                      borderRadius: BorderRadius.all(Radius.circular(100)),
                    ),
                    child: const Icon(
                      FontAwesomeIcons.basketShopping,
                      color: Colors.white,
                      size: 24,
                    ),
                  ),
                ),
                if (cartItemCount > 0)
                  Positioned(
                    right: 0,
                    top: 0,
                    child: Container(
                      padding: const EdgeInsets.all(4),
                      decoration: const BoxDecoration(
                        color: Colors.red,
                        shape: BoxShape.circle,
                      ),
                      constraints: const BoxConstraints(
                        minWidth: 20,
                        minHeight: 20,
                      ),
                      child: Text(
                        '$cartItemCount',
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 10,
                          fontWeight: FontWeight.bold,
                        ),
                        textAlign: TextAlign.center,
                      ),
                    ),
                  ),
              ],
            ),
            label: "",
          ),
          const BottomNavigationBarItem(
            icon: Icon(FontAwesomeIcons.file, size: 20),
            label: "",
          ),
          const BottomNavigationBarItem(
            icon: Icon(FontAwesomeIcons.user, size: 20),
            label: "",
          ),
        ],
      ),
    );
  }
}