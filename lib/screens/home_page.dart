import 'package:flutter/material.dart';
import '../theme_controller.dart';
import 'about_page.dart';
import 'courses_page.dart';
import 'login_page.dart';
import 'multimedia_page.dart';
import 'profile_page.dart';
import 'settings_page.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).colorScheme;
    return Scaffold(
      appBar: AppBar(
        title: const Text('EMSI Connect'),
        centerTitle: true,
        actions: [
          IconButton(
            icon: const Icon(Icons.brightness_6),
            onPressed: () => themeMode.value = themeMode.value == ThemeMode.light
                ? ThemeMode.dark
                : ThemeMode.light,
          ),
          IconButton(
            icon: const Icon(Icons.notifications),
            onPressed: () => debugPrint('Notifications consultées'),
          ),
        ],
      ),
      drawer: Drawer(
        child: ListView(
          padding: EdgeInsets.zero,
          children: [
            UserAccountsDrawerHeader(
              decoration: BoxDecoration(color: colors.primary),
              accountName: Text('Litimi Issam',
                  style: TextStyle(color: colors.onPrimary)),
              accountEmail: Text('issam@emsi.ma',
                  style: TextStyle(color: colors.onPrimary)),
              currentAccountPicture: CircleAvatar(
                backgroundColor: colors.onPrimary,
                child: Icon(Icons.person, color: colors.primary),
              ),
            ),
            ListTile(
              leading: const Icon(Icons.home_outlined),
              title: const Text('Accueil'),
              subtitle: const Text ('test '),
              trailing: const Icon(Icons.arrow_back),
              selected: true,
              onTap: () => Navigator.pop(context),
            ),
            ListTile(
              leading: const Icon(Icons.menu_book_outlined),
              title: const Text('Mes cours'),
              onTap: () {
                Navigator.pop(context); // ferme le Drawer
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const CoursesPage(),
                  ),
                );
              },
            ),
            ListTile(
              leading: const Icon(Icons.person_outline),
              title: const Text('Mon profil'),
              onTap: () {
                Navigator.pop(context);
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const ProfilePage(),
                  ),
                );
              },
            ),
            ListTile(
              leading: const Icon(Icons.perm_media),
              title: const Text('Espace multimédia'),
              onTap: () {
                Navigator.pop(context); // Ferme le Drawer.
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (_) => const MultimediaPage()),
                );
              },
            ),
            ListTile(
              leading: const Icon(Icons.settings_outlined),
              title: const Text('Paramètres'),
              onTap: () {
                Navigator.pop(context);
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const SettingsPage(),
                  ),
                );
              },
            ),
            const Divider(),
            ListTile(
              leading: const Icon(Icons.info_outline),
              title: const Text('À propos'),
              onTap: () {
                Navigator.pop(context);
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const AboutPage(),
                  ),
                );
              },
            ),
            const Divider(),
            ListTile(
              leading: const Icon(Icons.logout),
              title: const Text('Déconnexion'),
              onTap: () {
                Navigator.pop(context);
                Navigator.pushAndRemoveUntil(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const LoginPage(),
                  ),
                  (route) => false,
                );
              },
            ),
          ],
        ),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            Image.asset(
              'assets/images/emsi.png',
              height: 140,
              width: 290,
              fit: BoxFit.cover,
              errorBuilder: (context, error, stackTrace) => Container(
                height: 160,
                width: double.infinity,
                color: colors.primaryContainer,
                child: const Icon(Icons.school, size: 64),
              ),
            ),
            const SizedBox(height: 16),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Column(
                children: [
                  Text(
                    'Bienvenue sur EMSI Connect',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                      color: colors.primary,
                    ),
                  ),
                  const SizedBox(height: 12),
                  const Text(
                    'Votre espace universitaire pour accéder à vos cours, '
                    'votre planning et vos informations personnelles.',
                    textAlign: TextAlign.center,
                  ),
                ],
              ),
            ),
            const SizedBox(height: 24),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: LayoutBuilder(
                builder: (context, constraints) {
                  final columns = constraints.maxWidth < 600 ? 2 : 3;
                  return GridView.count(
                    crossAxisCount: columns,
                    crossAxisSpacing: 12,
                    mainAxisSpacing: 12,
                    childAspectRatio: 1.3,
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    children: [
                      _Rubrique(Icons.menu_book, 'Mes cours', onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => const CoursesPage(),
                          ),
                        );
                      }),
                      const _Rubrique(Icons.calendar_month, 'Planning'),
                      _Rubrique(Icons.person, 'Mon profil', onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => const ProfilePage(),
                          ),
                        );
                      }),
                      const _Rubrique(Icons.task_alt, 'Mes tâches'),
                    ],
                  );
                },
              ),
            ),
            const SizedBox(height: 24),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => debugPrint('Fonctionnalité bientôt disponible'),
        child: const Icon(Icons.add),
      ),
    );
  }
}

class _Rubrique extends StatelessWidget {
  final IconData icone;
  final String libelle;
  final VoidCallback? onTap;
  const _Rubrique(this.icone, this.libelle, {this.onTap});

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).colorScheme;
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(12),
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: colors.primaryContainer,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: colors.outlineVariant),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(icone, size: 40, color: colors.primary),
            const SizedBox(height: 8),
            Text(libelle, textAlign: TextAlign.center),
          ],
        ),
      ),
    );
  }
}