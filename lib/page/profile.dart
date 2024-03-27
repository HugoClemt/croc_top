import 'package:croc_top/page/home.dart';
import 'package:croc_top/page/setting.dart';
import 'package:flutter/material.dart';

class ProfileScreen extends StatefulWidget {
  final Map<String, dynamic>? userProfile;
  const ProfileScreen({super.key, this.userProfile});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  int _currentIndex = 3;

  @override
  void initState() {
    super.initState();
    //print(widget.userProfile);
  }

  void navigateToSettingPage(
      BuildContext context, Map<String, dynamic> userProfile) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => SettingPage(userProfile: userProfile),
      ),
    );
  }

  void _ModifierProfil() async {
    final userProfile = widget.userProfile!;
    navigateToSettingPage(context, userProfile);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          SizedBox(
            height: MediaQuery.of(context).size.height * 0.20,
            child: Container(
              color: Colors.grey[300],
              child: Row(
                children: [
                  const SizedBox(
                    width: 150,
                    child: Padding(
                      padding: EdgeInsets.only(top: 50.0),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          CircleAvatar(
                            radius: 50,
                            backgroundImage: AssetImage('assets/profile.png'),
                          ),
                        ],
                      ),
                    ),
                  ),
                  Expanded(
                    child: Container(
                      padding: const EdgeInsets.only(top: 75),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          SizedBox(
                            child: Center(
                              child: Row(
                                children: [
                                  Text(widget.userProfile!['username']),
                                  const SizedBox(width: 10),
                                  SizedBox(
                                    child: IconButton(
                                      icon: const Icon(Icons.edit_note),
                                      onPressed: _ModifierProfil,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                          const SizedBox(height: 15),
                          const SizedBox(
                            child: Center(
                              child: Row(
                                children: [
                                  SizedBox(
                                    child: Text('Abonnement : 15'),
                                  ),
                                  SizedBox(width: 15),
                                  SizedBox(
                                    child: Text('Abonnées : 982'),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
          Expanded(
            child: GridView.count(
              crossAxisCount: 2,
              children: List.generate(
                6,
                (index) {
                  return Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: ElevatedButton(
                      onPressed: () {
                        print('Button $index pressed');
                      },
                      style: ButtonStyle(
                        shape:
                            MaterialStateProperty.all<RoundedRectangleBorder>(
                          RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10.0),
                          ),
                        ),
                      ),
                      child: const Text('Button'),
                    ),
                  );
                },
              ),
            ),
          ),
        ],
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
            if (index == 0) {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const HomeScreen()),
              );
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
