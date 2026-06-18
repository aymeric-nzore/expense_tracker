import 'package:expense_tracker_app/features/transaction/presentation/add_transaction.dart';
import 'package:expense_tracker_app/features/transaction/presentation/home_page.dart';
import 'package:expense_tracker_app/features/transaction/presentation/settings_page.dart';
import 'package:flutter/material.dart';
import 'package:salomon_bottom_bar/salomon_bottom_bar.dart';

class MainPage extends StatefulWidget {
  const MainPage({super.key});

  @override
  State<MainPage> createState() => _MainPageState();
}

class _MainPageState extends State<MainPage> {
  int _currentIndex = 0;

  final List<Widget> _pages = [HomePage(), SettingsPage()];

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return Scaffold(
      backgroundColor: colorScheme.surface,
      body: _pages[_currentIndex],
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      floatingActionButton: FloatingActionButton(
        backgroundColor: colorScheme.primary,
        shape: CircleBorder(),
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => AddTransaction()),
          );
        },
        child: const Icon(Icons.add, color: Colors.white),
      ),
      // Bottom Navigation Bar personnalisée avec SalomonBottomBar
      bottomNavigationBar: BottomAppBar(
        shape: CircularNotchedRectangle(),
        notchMargin: 8,
        color: colorScheme.surface,
        elevation: 8,
        child: SalomonBottomBar(
          duration: Duration(milliseconds: 500),
          currentIndex: _currentIndex,
          onTap: (index) {
            setState(() {
              _currentIndex = index;
            });
          },
          items: [
            SalomonBottomBarItem(
              icon: Icon(Icons.home_outlined),
              title: Text("Home"),
              selectedColor: colorScheme.primary,
            ),
            SalomonBottomBarItem(
              icon: Icon(Icons.settings_outlined),
              title: Text("Settings"),
              selectedColor: colorScheme.primary,
            ),
          ],
        ),
      ),
    );
  }
}
