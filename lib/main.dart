import 'package:flutter/material.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Exercice Widgets Input',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.blue),
        // Optionnel : Configuration globale de l'AppBar pour toute l'application
        appBarTheme: const AppBarTheme(
          backgroundColor: Colors.blue,
          foregroundColor: Colors.white, // Couleur du texte et des icônes
          centerTitle: true,
        ),
      ),
      home: const FormulairePage(),
    );
  }
}

class FormulairePage extends StatefulWidget {
  const FormulairePage({super.key});

  @override
  State<FormulairePage> createState() => _FormulairePageState();
}

class _FormulairePageState extends State<FormulairePage> {
  // Clé globale pour identifier et valider le formulaire
  final _formKey = GlobalKey<FormState>();

  // Contrôleurs pour les TextField
  final TextEditingController _nomController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  // Variables d'état pour les autres widgets d'input
  String _genre = 'Homme';
  bool _recevoirNotifications = false;

  // Checkboxes pour les centres d'intérêt
  bool _interetSport = false;
  bool _interetMusique = bool.fromEnvironment('false'); // ou false simple
  bool _interetLecture = false;

  double _age = 25.0;

  @override
  void dispose() {
    _nomController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  // Fonction pour afficher le résultat lors de la soumission
  void _soumettreFormulaire() {
    if (_formKey.currentState!.validate()) {
      // Récupérer la liste des centres d'intérêt cochés
      List<String> interets = [];
      if (_interetSport) interets.add('Sport');
      if (_interetMusique) interets.add('Musique');
      if (_interetLecture) interets.add('Lecture');

      showDialog(
        context: context,
        builder: (context) => AlertDialog(
          title: const Text('Données du Formulaire'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('Nom : ${_nomController.text}'),
              Text('Genre : $_genre'),
              Text('Âge : ${_age.toInt()} ans'),
              Text('Notifications : ${_recevoirNotifications ? "Oui" : "Non"}'),
              Text('Centres d\'intérêt : ${interets.isEmpty ? "Aucun" : interets.join(", ")}'),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('Fermer'),
            ),
          ],
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Exercice : Formulaire & Inputs'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: ListView(
            children: [
              // 1. TextField pour le Nom
              TextFormField(
                controller: _nomController,
                decoration: const InputDecoration(
                  labelText: 'Nom d\'utilisateur',
                  border: OutlineInputBorder(),
                  prefixIcon: Icon(Icons.person),
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Veuillez entrer votre nom';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16),

              // 2. TextField pour le Mot de passe
              TextFormField(
                controller: _passwordController,
                obscureText: true,
                decoration: const InputDecoration(
                  labelText: 'Mot de passe',
                  border: OutlineInputBorder(),
                  prefixIcon: Icon(Icons.lock),
                ),
                validator: (value) {
                  if (value == null || value.length < 6) {
                    return 'Le mot de passe doit faire au moins 6 caractères';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16),

              // 3. Radio Buttons avec le nouveau widget RadioGroup
              const Text('Genre :', style: TextStyle(fontWeight: FontWeight.bold)),
              RadioGroup<String>(
                groupValue: _genre,
                onChanged: (String? value) {
                  if (value != null) {
                    setState(() {
                      _genre = value;
                    });
                  }
                },
                child: Row(
                  children: const [
                    Expanded(
                      child: RadioListTile<String>(
                        title: Text('Homme'),
                        value: 'Homme',
                        // groupValue et onChanged supprimés d'ici !
                      ),
                    ),
                    Expanded(
                      child: RadioListTile<String>(
                        title: Text('Femme'),
                        value: 'Femme',
                        // groupValue et onChanged supprimés d'ici !
                      ),
                    ),
                  ],
                ),
              ),
              const Divider(),

              // 4. Checkboxes pour les centres d'intérêt
              const Text('Centres d\'intérêt :', style: TextStyle(fontWeight: FontWeight.bold)),
              CheckboxListTile(
                title: const Text('Sport'),
                value: _interetSport,
                onChanged: (bool? value) {
                  setState(() {
                    _interetSport = value ?? false;
                  });
                },
              ),
              CheckboxListTile(
                title: const Text('Musique'),
                value: _interetMusique,
                onChanged: (bool? value) {
                  setState(() {
                    _interetMusique = value ?? false;
                  });
                },
              ),
              CheckboxListTile(
                title: const Text('Lecture'),
                value: _interetLecture,
                onChanged: (bool? value) {
                  setState(() {
                    _interetLecture = value ?? false;
                  });
                },
              ),
              const Divider(),

              // 5. Slider pour l'Âge
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text('Âge :', style: TextStyle(fontWeight: FontWeight.bold)),
                  Text('${_age.toInt()} ans'),
                ],
              ),
              Slider(
                value: _age,
                min: 10,
                max: 100,
                divisions: 90,
                label: _age.toInt().toString(),
                onChanged: (double value) {
                  setState(() {
                    _age = value;
                  });
                },
              ),
              const Divider(),

              // 6. Switch pour les notifications
              SwitchListTile(
                title: const Text('Recevoir les notifications'),
                subtitle: const Text('Activer les alertes par email/push'),
                value: _recevoirNotifications,
                onChanged: (bool value) {
                  setState(() {
                    _recevoirNotifications = value;
                  });
                },
              ),
              const SizedBox(height: 24),

              // 7. Bouton de Soumission
              FilledButton(
                style: FilledButton.styleFrom(
                  padding: const EdgeInsets.symmetric(vertical: 15),
                ),
                onPressed: _soumettreFormulaire,
                child: const Text(
                  'Valider le Formulaire',
                  style: TextStyle(fontSize: 16),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}