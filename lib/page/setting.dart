import 'package:flutter/material.dart';

class SettingPage extends StatefulWidget {
  final Map<String, dynamic> userProfile;
  const SettingPage({super.key, required this.userProfile});

  @override
  State<SettingPage> createState() => _SettingPageState();
}

class _SettingPageState extends State<SettingPage> {
  @override
  void initState() {
    super.initState();
    print(widget.userProfile);
  }

  @override
  Widget build(BuildContext context) {
    final username = widget.userProfile['username'];
    return Scaffold(
      appBar: AppBar(
        title: const Text('Setting'),
      ),
      body: Center(
        child: Text('Username: $username'),
      ),
    );
  }
}
