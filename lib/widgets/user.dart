class User {
  final String imagePath;
  final String name;
  final String email;

  const User({
    required this.imagePath,
    required this.name,
    required this.email,
  });
}

class UserPreferences {
  static const mUser = User(
    imagePath:
    'assets/default-profile.png',
    name: 'Name Surname',
    email: 'name.surname@gmail.com',
  );
}
