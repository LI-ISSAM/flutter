import 'package:flutter/material.dart';
import 'student_details_page.dart';

class ProfilePage extends StatefulWidget {
  const ProfilePage({super.key});

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  String _name = 'Litimi Issam';

  Future<void> _editName() async {
    final newName = await showDialog<String>(
      context: context,
      builder: (context) => _NameDialog(initialName: _name),
    );
    if (!mounted) return;
    if (newName != null && newName.isNotEmpty) {
      setState(() => _name = newName);
    }
  }

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).colorScheme;
    return Scaffold(
      appBar: AppBar(title: const Text('Mon profil'), centerTitle: true),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Center(
            child: ConstrainedBox(
              constraints: const BoxConstraints(maxWidth: 600),
              child: Column(
                children: [
                  SizedBox(
                    height: 150,
                    child: Stack(
                      children: [
                        Container(
                          height: 110,
                          width: double.infinity,
                          decoration: BoxDecoration(
                            color: colors.primaryContainer,
                            borderRadius: BorderRadius.circular(20),
                          ),
                        ),
                        Align(
                          alignment: Alignment.bottomCenter,
                          child: CircleAvatar(
                            radius: 45,
                            backgroundImage:
                                const AssetImage('assets/images/Vegeto.jpeg'),
                            onBackgroundImageError: (_, __) {},
                            child: const Icon(Icons.person, size: 48),
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 16),
                  const Align(
                    alignment: Alignment.centerLeft,
                    child: Text(
                      'Informations personnelles',
                      style:
                          TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                    ),
                  ),
                  const SizedBox(height: 12),
                  _Info(Icons.person, 'Nom', _name),
                  const SizedBox(height: 12),
                  const _Info(Icons.school, 'Filière', 'Informatique'),
                  const SizedBox(height: 12),
                  const _Info(Icons.stairs, 'Niveau', 'S5'),
                  const SizedBox(height: 12),
                  const _Info(Icons.email, 'Email', 'issam@gmail.com'),
                  const SizedBox(height: 12),
                  const _Info(
                      Icons.calendar_month, 'Année universitaire', '2026–2027'),
                  const SizedBox(height: 20),
                  Row(
                    children: [
                      Expanded(
                        child: ElevatedButton(
                          onPressed: () => debugPrint('Modifier le profil'),
                          child: const Text('Modifier le profil'),
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: OutlinedButton(
                          onPressed: () => debugPrint('Contacter'),
                          style: OutlinedButton.styleFrom(
                            minimumSize: const Size.fromHeight(48),
                          ),
                          child: const Text('Contacter'),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 12),
                  ElevatedButton(
                    onPressed: _editName,
                    child: const Text('Modifier le nom'),
                  ),
                  const SizedBox(height: 12),
                  ElevatedButton(
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => StudentDetailsPage(
                            studentName: _name,
                            program: 'Intelligence Artificielle',
                          ),
                        ),
                      );
                    },
                    child: const Text('Voir les détails'),
                  ),
                  const SizedBox(height: 24),
                  _CarteEtudiant(name: _name),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class _NameDialog extends StatefulWidget {
  final String initialName;
  const _NameDialog({required this.initialName});

  @override
  State<_NameDialog> createState() => _NameDialogState();
}

class _NameDialogState extends State<_NameDialog> {
  late final TextEditingController _controller;

  @override
  void initState() {
    super.initState();
    _controller = TextEditingController(text: widget.initialName);
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text('Modifier le nom'),
      content: TextField(
        controller: _controller,
        autofocus: true,
        textCapitalization: TextCapitalization.words,
        decoration: const InputDecoration(labelText: 'Nom complet'),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(context),
          child: const Text('Annuler'),
        ),
        ElevatedButton(
          onPressed: () => Navigator.pop(context, _controller.text.trim()),
          style: ElevatedButton.styleFrom(minimumSize: const Size(0, 40)),
          child: const Text('Valider'),
        ),
      ],
    );
  }
}

class _Info extends StatelessWidget {
  final IconData icone;
  final String label;
  final String valeur;
  const _Info(this.icone, this.label, this.valeur);

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).colorScheme;
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: colors.surfaceContainerHighest,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: colors.outlineVariant),
      ),
      child: Row(
        children: [
          Icon(icone, color: colors.primary),
          const SizedBox(width: 12),
          Expanded(child: Text('$label : $valeur')),
        ],
      ),
    );
  }
}

// Carte étudiant (défi bonus TP2)
class _CarteEtudiant extends StatelessWidget {
  final String name;
  const _CarteEtudiant({required this.name});

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).colorScheme;
    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [colors.primary, colors.primary.withOpacity(0.6)],
        ),
        borderRadius: BorderRadius.circular(16),
        boxShadow: const [
          BoxShadow(color: Colors.black26, blurRadius: 6, offset: Offset(0, 3)),
        ],
      ),
      child: Stack(
        children: [
          const Positioned(
            top: 12,
            right: 12,
            child: Icon(Icons.account_balance, color: Colors.white70, size: 32),
          ),
          Padding(
            padding: const EdgeInsets.all(16),
            child: Row(
              children: [
                const CircleAvatar(
                  radius: 36,
                  backgroundColor: Colors.white,
                  child: Icon(Icons.person, size: 40),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        name,
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 4),
                      const Text('Informatique • S5',
                          style: TextStyle(color: Colors.white)),
                      const SizedBox(height: 4),
                      const Text('N° étudiant : 2026-0042',
                          style: TextStyle(color: Colors.white)),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}