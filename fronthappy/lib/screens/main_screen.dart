import 'package:flutter/material.dart';
import '../services/api_service.dart';
import 'animals_catalog_screen.dart';
import 'my_applications_screen.dart';
import 'events_screen.dart';
import 'profile_screen.dart';
import 'adoption_profile_screen.dart';
import 'admin_screen.dart';

class MainScreen extends StatefulWidget {
  final String? userRole;

  MainScreen({this.userRole});

  @override
  _MainScreenState createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  int _selectedIndex = 0;
  Map<String, dynamic>? _currentUser;
  bool _isLoadingUser = true;

  @override
  void initState() {
    super.initState();
    _loadCurrentUser();
  }

  Future<void> _loadCurrentUser() async {
    try {
      final user = await ApiService.getCurrentUser();
      setState(() {
        _currentUser = user;
        _isLoadingUser = false;
      });
    } catch (e) {
      setState(() => _isLoadingUser = false);
    }
  }

  bool get isAdmin => _currentUser?['role'] == 'ADMIN';

  List<Widget> get _widgetOptions {
    if (isAdmin) {
      return [
        AnimalsCatalogScreen(),
        AdminPanel(),
        EventsScreen(),
        ProfileScreen(),
      ];
    } else {
      return [
        AnimalsCatalogScreen(),
        MyApplicationsScreen(),
        EventsScreen(),
        ProfileScreen(),
      ];
    }
  }

  List<BottomNavigationBarItem> get _navItems {
    if (isAdmin) {
      return [
        BottomNavigationBarItem(
          icon: Icon(Icons.pets),
          label: 'Животные',
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.admin_panel_settings),
          label: 'Админ',
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.event),
          label: 'События',
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.person),
          label: 'Профиль',
        ),
      ];
    } else {
      return [
        BottomNavigationBarItem(
          icon: Icon(Icons.pets),
          label: 'Животные',
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.list_alt),
          label: 'Заявки',
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.event),
          label: 'События',
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.person),
          label: 'Профиль',
        ),
      ];
    }
  }

  void _onItemTapped(int index) {
    setState(() => _selectedIndex = index);
  }

  @override
  Widget build(BuildContext context) {
    if (_isLoadingUser) {
      return Scaffold(
        body: Center(child: CircularProgressIndicator()),
      );
    }

    return Scaffold(
      appBar: AppBar(
        title: Text('Happy Tails 🐾'),
        backgroundColor: Color(0xFF4CAF50),
        actions: [
          if (!isAdmin)
            IconButton(
              icon: Icon(Icons.assignment),
              tooltip: 'Анкета усыновителя',
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => AdoptionProfileScreen(),
                  ),
                );
              },
            ),
          PopupMenuButton<String>(
            onSelected: (value) {
              if (value == 'logout') {
                _logout();
              }
            },
            itemBuilder: (context) => [
              PopupMenuItem(
                value: 'logout',
                child: Row(
                  children: [
                    Icon(Icons.logout, color: Colors.red),
                    SizedBox(width: 8),
                    Text('Выйти'),
                  ],
                ),
              ),
            ],
          ),
        ],
      ),
      body: _widgetOptions[_selectedIndex],
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _selectedIndex,
        onTap: _onItemTapped,
        type: BottomNavigationBarType.fixed,
        selectedItemColor: Color(0xFF4CAF50),
        items: _navItems,
      ),
      floatingActionButton: _selectedIndex == 0 && !isAdmin
          ? FloatingActionButton.extended(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => AdoptionProfileScreen(),
                  ),
                );
              },
              icon: Icon(Icons.assignment),
              label: Text('Моя анкета'),
              backgroundColor: Color(0xFF4CAF50),
            )
          : null,
    );
  }

  void _logout() {
    ApiService.clearToken();
    Navigator.pushReplacementNamed(context, '/login');
  }
}
