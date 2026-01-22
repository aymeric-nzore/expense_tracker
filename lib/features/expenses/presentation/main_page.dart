import 'package:expense_tracker_app/features/expenses/presentation/home_page.dart';
import 'package:expense_tracker_app/features/expenses/presentation/settings_page.dart';
import 'package:flutter/material.dart';

class MainPage extends StatefulWidget {
  const MainPage({super.key});

  @override
  State<MainPage> createState() => _MainPageState();
}

class _MainPageState extends State<MainPage> {
  int _currentIndex = 0;

  final List<Widget> _pages = [
    HomePage(),
    Placeholder(), // bouton central
    SettingsPage(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _pages[_currentIndex],

      // Bottom Navigation Bar personnalisée
      bottomNavigationBar: Stack(
        clipBehavior: Clip.none,
        alignment: Alignment.bottomCenter,
        children: [
          // 1️⃣ Le fond de la barre
          Container(
            height: 80,
            padding: EdgeInsets.only(top: 10),
            decoration: BoxDecoration(
              color: Colors.white,
              boxShadow: [BoxShadow(color: Colors.black12, blurRadius: 4)],
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                // Icône gauche
                GestureDetector(
                  onTap: () {
                    setState(() {
                      _currentIndex = 0;
                    });
                  },
                  child: Column(
                    children: [
                      Icon(
                        _currentIndex == 0 ? Icons.home : Icons.home_outlined,
                        size: 32,
                        color: _currentIndex == 0
                            ? Colors.amber[700]
                            : Colors.grey,
                      ),
                      Text(
                        "Home",
                        style: TextStyle(fontWeight: FontWeight.bold),
                      ),
                    ],
                  ),
                ),

                SizedBox(width: 60), // espace pour bouton central
                // Icône droite
                GestureDetector(
                  onTap: () {
                    setState(() {
                      _currentIndex = 2;
                    });
                  },
                  child: Column(
                    children: [
                      Icon(
                        _currentIndex == 2
                            ? Icons.settings
                            : Icons.settings_outlined,
                        size: 32,
                        color: _currentIndex == 2
                            ? Colors.amber[700]
                            : Colors.grey,
                      ),
                      Text(
                        "Settings",
                        style: TextStyle(fontWeight: FontWeight.bold),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),

          // 2️⃣ Bouton central flottant
          Positioned(
            top: -25, // décale vers le haut
            child: GestureDetector(
              onTap: () {
                setState(() {
                  _currentIndex = 1;
                });
              },
              child: Container(
                width: 60,
                height: 60,
                decoration: BoxDecoration(
                  color: Colors.amber[700],
                  shape: BoxShape.circle,
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black26,
                      blurRadius: 10,
                      offset: Offset(0, 4),
                    ),
                  ],
                ),
                child: Icon(Icons.add, color: Colors.white, size: 30),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
