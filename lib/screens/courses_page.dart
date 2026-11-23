import 'package:flutter/material.dart';

class CoursesPage extends StatelessWidget {
  const CoursesPage({super.key});

  @override
  Widget build(BuildContext context) {
    final modules = [
      {'nom': 'Développement Multi-Plateforme', 'enseignant': 'Mme Aouraghe', 'heures': 32, 'icone': Icons.menu_book},
      {'nom': 'Bases de données avancées', 'enseignant': 'M. Alami', 'heures': 28, 'icone': Icons.storage},
      {'nom': 'Réseaux informatiques', 'enseignant': 'M. Benani', 'heures': 24, 'icone': Icons.network_check},
      {'nom': 'Intelligence artificielle', 'enseignant': 'Mme Idrissi', 'heures': 30, 'icone': Icons.psychology},
      {'nom': 'Cybersécurité', 'enseignant': 'M. Tazi', 'heures': 26, 'icone': Icons.security},
      {'nom': 'Gestion de projet', 'enseignant': 'Mme Fassi', 'heures': 20, 'icone': Icons.computer},
      {'nom': 'Cloud Computing', 'enseignant': 'M. Exemple', 'heures': 22, 'icone': Icons.computer},
      {'nom': 'DevOps et intégration continue', 'enseignant': 'Mme Exemple', 'heures': 18, 'icone': Icons.security},
    ];

    return Scaffold(
      appBar: AppBar(title: const Text('Mes cours')),
      body: Column(
        children: [
          const Padding(
            padding: EdgeInsets.all(16),
            child: Text(
              'Modules du semestre',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
          ),
          Expanded(
            child: ListView.builder(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              itemCount: modules.length,
              itemBuilder: (context, index) {
                final module = modules[index];
                final nom = module['nom'] as String;
                return Card(
                  elevation: 2,
                  margin: const EdgeInsets.only(bottom: 12),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(14),
                  ),
                  child: ListTile(
                    leading: CircleAvatar(child: Text('${index + 1}')),
                    title: Text(nom),
                    subtitle: Text(
                        '${module['enseignant']} • ${module['heures']} h'),
                    trailing: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(module['icone'] as IconData),
                        const Icon(Icons.chevron_right),
                      ],
                    ),
                    onTap: () {
                      debugPrint('Module sélectionné : $nom');
                      ScaffoldMessenger.of(context).hideCurrentSnackBar();
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(content: Text('Module sélectionné : $nom')),
                      );
                    },
                  ),
                );
              },
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(16),
            child: ElevatedButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('Retour'),
            ),
          ),
        ],
      ),
    );
  }
}