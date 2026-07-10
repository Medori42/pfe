import 'package:equatable/equatable.dart';

class UserEntity extends Equatable {
  final int     id;
  final String  firstName;
  final String  lastName;
  final String  email;
  final String  role;         // ADMIN | MANAGER | EMPLOYE | RH
  final String  department;
  final String? avatarUrl;
  final String  token;

  const UserEntity({
    required this.id,
    required this.firstName,
    required this.lastName,
    required this.email,
    required this.role,
    required this.department,
    this.avatarUrl,
    required this.token,
  });

  String get fullName => '$firstName $lastName';

  @override
  List<Object?> get props =>
      [id, email, role, department, token];
}
