import 'package:flutter/material.dart';
import 'package:google_nav_bar/google_nav_bar.dart';
import 'package:mange_eats/cardapio/Cardapio_page.dart';
import 'package:mange_eats/carrinho/CarrinhoPage.dart';


class NavigatorApp extends StatefulWidget {
  const NavigatorApp({super.key});

  @override
  State<NavigatorApp> createState() => _BottomNavBarState();
}

class _BottomNavBarState extends State<NavigatorApp> {
  int indexCurrent = 0;

  void onTap(int index) {
    setState(() {
      indexCurrent = index;
    });
  }

  final List<Widget> _widgetOptions = [
    CardapioPage(),
    CarrinhoPage(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: IndexedStack(
        index: indexCurrent,
        children: _widgetOptions,
      ),
      bottomNavigationBar: GNav(
        backgroundColor:  Colors.red.shade400,
        color: Colors.black,
        activeColor: Colors.white,
        duration: const Duration(milliseconds: 400),
        tabs: const [
          GButton(icon: Icons.home),
          GButton(icon: Icons.shopping_cart_outlined),
        ],
        onTabChange: onTap,
        selectedIndex: indexCurrent,
      ),
    );
  }
}
