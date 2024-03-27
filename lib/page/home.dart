import 'package:croc_top/auth/supabase_service.dart';
import 'package:croc_top/models/profile.dart';
import 'package:croc_top/page/login.dart';
import 'package:croc_top/page/profile.dart';
import 'package:croc_top/services/database_service.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int _currentIndex = 0;
  User? _currentUser;
  Map<String, dynamic>? _userProfile;

  @override
  void initState() {
    super.initState();
    _loadCurrentUser();
  }

  Future<void> _loadCurrentUser() async {
    final currentUser = await AuthService.getCurrentUser();
    if (currentUser != null) {
      final userProfile = await DatabaseService.getUserProfile(currentUser.id);
      if (userProfile != null) {
        final profile = Profile.fromMap(userProfile);
        setState(() {
          _currentUser = currentUser;
          _userProfile = userProfile;
          print(_userProfile);
        });
      }
    }
  }

  Future<void> _logoutUser(BuildContext context) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setBool('isLoggedIn', false);

    Navigator.pushReplacement(
      context,
      MaterialPageRoute(
        builder: (context) => const LoginScreen(),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: _currentUser != null
            ? Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text('Welcome, ${_currentUser!.email}, to CrocTop!'),
                  Text('ID: ${_currentUser!.id}'),
                  Text(
                      'Nom d\'utilisateur : ${Profile.fromMap(_userProfile!).username}'),
                ],
              )
            : const CircularProgressIndicator(),
      ),
      bottomNavigationBar: BottomNavigationBar(
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: '',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.menu_book),
            label: '',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.library_add),
            label: '',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.person_sharp),
            label: '',
          ),
        ],
        currentIndex: _currentIndex,
        selectedItemColor: Colors.amber[800],
        onTap: (index) {
          setState(() {
            if (index == 3) {
              Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) =>
                        ProfileScreen(userProfile: _userProfile)),
              );
              _currentIndex = index;
            } else {
              _currentIndex = index;
            }
          });
        },
        type: BottomNavigationBarType.fixed,
        showSelectedLabels: false,
        showUnselectedLabels: false,
      ),
    );
  }
}
