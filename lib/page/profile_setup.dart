import 'package:croc_top/page/home.dart';
import 'package:croc_top/auth/supabase_service.dart';
import 'package:flutter/material.dart';

class ProfileSetupPage extends StatefulWidget {
  const ProfileSetupPage({Key? key}) : super(key: key);

  @override
  State<ProfileSetupPage> createState() => _ProfileSetupPageState();
}

class Country {
  final int id;
  final int code;
  final String alpha2;
  final String alpha3;
  final String name;

  Country({
    required this.id,
    required this.code,
    required this.alpha2,
    required this.alpha3,
    required this.name,
  });
}

class _ProfileSetupPageState extends State<ProfileSetupPage> {
  final TextEditingController _usernameController = TextEditingController();
  DateTime _selectedDate = DateTime.now();

  Country? _selectedCountry;
  List<Country> countries = [];

  @override
  void initState() {
    super.initState();
    fetchCountries();
  }

  void fetchCountries() async {
    try {
      final response =
          await SupabaseService.client!.from('country').select().execute();
      final countriesData = response.data as List<dynamic>;

      setState(() {
        countries = countriesData.map((data) {
          return Country(
            id: data['id'] as int,
            code: data['code'] as int,
            alpha2: data['alpha-2'] as String,
            alpha3: data['alpha-3'] as String,
            name: data['name'] as String,
          );
        }).toList();

        _selectedCountry = countries.isNotEmpty ? countries.first : null;
      });
    } catch (error) {
      print(
          'Erreur lors de la récupération des pays depuis la base de données : $error');
    }
  }

  void _updateUserProfile() async {
    final currentUser = SupabaseService.client!.auth.currentUser;

    if (_usernameController.text.isEmpty || _selectedDate == null) {
      print('Veuillez remplir tous les champs.');
      return;
    }

    if (_selectedCountry == null) {
      print('Veuillez sélectionner un pays.');
      return;
    }

    print('Email: ${currentUser!.email}');
    print('ID: ${currentUser.id}');
    print('Username: ${_usernameController.text}');
    print('Date de Naissance: $_selectedDate');
    print('Pays ID: ${_selectedCountry!.id}');
    print('Pays Name: ${_selectedCountry!.name}');

    try {
      final response = await SupabaseService.client!
          .from('profiles')
          .update({
            'updated_at': DateTime.now().toIso8601String(),
            'username': _usernameController.text,
            'birth_date': _selectedDate.toIso8601String(),
            'country_id': _selectedCountry!.id,
          })
          .eq('id', currentUser.id)
          .execute();
      print("Profil mis à jour avec succès : $response");
      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => const HomeScreen()),
      );
    } catch (error) {
      print('Erreur de mise à jour du profil : $error');
    }
  }

  Future<void> _selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: _selectedDate,
      firstDate: DateTime(1900),
      lastDate: DateTime.now(),
    );
    if (picked != null && picked != _selectedDate) {
      setState(() {
        _selectedDate = picked;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                margin: const EdgeInsets.symmetric(vertical: 10.0),
                child: TextField(
                  controller: _usernameController,
                  decoration: const InputDecoration(
                    labelText: 'Username',
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.all(Radius.circular(15.0)),
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 20),
              InkWell(
                onTap: () {
                  _selectDate(context);
                },
                child: InputDecorator(
                  decoration: const InputDecoration(
                    labelText: 'Sélectionnez une date',
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.all(Radius.circular(15.0)),
                    ),
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: <Widget>[
                      Text(
                        "${_selectedDate.toLocal()}".split(' ')[0],
                        style: const TextStyle(fontSize: 16),
                      ),
                      const Icon(Icons.calendar_today),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 20),
              SizedBox(
                child: InputDecorator(
                  decoration: const InputDecoration(
                    labelText: 'Pays',
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.all(Radius.circular(15.0)),
                    ),
                  ),
                  child: DropdownButton<Country>(
                    value: _selectedCountry,
                    onChanged: (Country? newValue) {
                      setState(() {
                        _selectedCountry = newValue!;
                      });
                    },
                    items: countries
                        .map<DropdownMenuItem<Country>>((Country country) {
                      return DropdownMenuItem<Country>(
                        value: country,
                        child: Text(
                          country.name.length > 30
                              ? '${country.name.substring(0, 30)}...'
                              : country.name,
                        ),
                      );
                    }).toList(),
                  ),
                ),
              ),
              const SizedBox(height: 20),
              ElevatedButton(
                onPressed: _updateUserProfile,
                child: const Text("S'inscrire"),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

void main() {
  runApp(const MaterialApp(
    home: ProfileSetupPage(),
  ));
}
