class Validators {
  static String? email(String? value) {
    final email = (value ?? '').trim();
    if (email.isEmpty) return 'Email obligatoire';
    if (!email.contains('@')) return 'Email invalide';
    return null;
  }

  static String? password(String? value) {
    if (value == null || value.isEmpty) return 'Mot de passe obligatoire';
    if (value.length < 8) return 'Au moins 8 caractères';
    return null;
  }

  static String? required(String? value, String label) {
    if ((value ?? '').trim().isEmpty) return '$label obligatoire';
    return null;
  }

  static String? phone(String? value) {
    final tel = (value ?? '').trim();
    if (tel.isEmpty) return 'Téléphone obligatoire';
    if (!RegExp(r'^[0-9]{8,15}$').hasMatch(tel)) return 'Téléphone invalide';
    return null;
  }
}