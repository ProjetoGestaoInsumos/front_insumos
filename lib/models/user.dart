enum UserRole { admin, tecnico, professor }

UserRole roleFromString(String role) {
  switch (role) {
    case 'admin':
      return UserRole.admin;
    case 'tecnico':
      return UserRole.tecnico;
    case 'professor':
      return UserRole.professor;
    default:
      throw Exception('Função desconhecida: $role');
  }
}

String roleToString(UserRole role) {
  return role.toString().split('.').last;
}

class User {
  final int? id;
  final String name;
  final String email;
  final UserRole role;
  final String? password; // usado só para cadastro/login, não vem da API

  User({
    this.id,
    required this.name,
    required this.email,
    required this.role,
    this.password,
  });

  factory User.fromJson(Map<String, dynamic> json) {
    return User(
      id: json['id'],
      name: json['name'],
      email: json['email'],
      role: roleFromString(json['role']),
    );
  }

  Map<String, dynamic> toJson() {
    final data = {
      'name': name,
      'email': email,
      'role': roleToString(role),
    };
    return data;
  }
}
