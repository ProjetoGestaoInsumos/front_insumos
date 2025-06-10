import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:front_insumos/api/api_service.dart';
import 'package:front_insumos/models/user.dart';
import 'package:go_router/go_router.dart';

final ApiService _apiService = ApiService();

class RegisterPage extends StatefulWidget {
  const RegisterPage({super.key});

  @override
  State<RegisterPage> createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  UserRole _selectedUserRole = UserRole.professor; // valor padrão
  String? _errorMessage;
  bool _isSubmitting = false;
  final List<UserRole> _userRoles = UserRole.values;

  String _roleLabel(UserRole role) {
    switch (role) {
      case UserRole.admin:
        return 'Administrador';
      case UserRole.tecnico:
        return 'Técnico';
      case UserRole.professor:
        return 'Professor';
    }
  }

  void _submitRegister() async {
    if (_isSubmitting) return;

    setState(() {
      _errorMessage = null;
      _isSubmitting = true;
    });

    if (_formKey.currentState?.validate() ?? false) {
      final user = User(
        name: _nameController.text.trim(),
        email: _emailController.text.trim(),
        password: _passwordController.text,
        role: _selectedUserRole,
      );

      try {
        final response = await _apiService.register(user);

        if (response != null &&
            (response.statusCode == 200 || response.statusCode == 201)) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('Cadastro realizado com sucesso!'),
              duration: Duration(seconds: 1),
            ),
          );

          Future.delayed(const Duration(seconds: 1), () {
            if (mounted) context.go('/login');
          });
        } else {
          final detail = response?.data['detail'];
          setState(() {
            if (detail is String) {
              _errorMessage = detail;
            } else if (detail is List &&
                detail.isNotEmpty &&
                detail[0]['msg'] != null) {
              _errorMessage = detail[0]['msg'];
            } else {
              _errorMessage =
                  'Erro ao registrar: ${response?.statusMessage ?? "desconhecido"}';
            }
          });
        }
      } catch (e) {
        setState(() {
          final response = e is DioException ? e.response : null;
          final detail = response?.data['detail'];

          if (detail is List && detail.isNotEmpty && detail[0]['msg'] != null) {
            _errorMessage = detail[0]['msg'];
          } else if (detail is String) {
            _errorMessage = detail;
          } else {
            _errorMessage = 'Erro durante o cadastro.';
          }
        });
      }
    }

    setState(() => _isSubmitting = false);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Criar Conta'),
        elevation: 0,
        backgroundColor: Colors.transparent,
        foregroundColor: Theme.of(context).primaryColorDark,
      ),
      backgroundColor: Colors.blueGrey[50],
      body: Center(
        child: SingleChildScrollView(
          child: Card(
            elevation: 8.0,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12.0),
            ),
            margin:
                const EdgeInsets.symmetric(horizontal: 20.0, vertical: 10.0),
            child: SizedBox(
              width: 450,
              child: Padding(
                padding: const EdgeInsets.all(32.0),
                child: Form(
                  key: _formKey,
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text('Crie sua conta',
                          style: TextStyle(
                            fontSize: 26,
                            fontWeight: FontWeight.bold,
                            color: Theme.of(context).primaryColor,
                          )),
                      const SizedBox(height: 8),
                      Text(
                        'Preencha os dados abaixo para se registrar',
                        style: TextStyle(fontSize: 16, color: Colors.grey[600]),
                        textAlign: TextAlign.center,
                      ),
                      const SizedBox(height: 32),
                      if (_errorMessage != null)
                        Padding(
                          padding: const EdgeInsets.only(bottom: 16.0),
                          child: Text(
                            _errorMessage!,
                            style: const TextStyle(
                                color: Colors.redAccent, fontSize: 14),
                            textAlign: TextAlign.center,
                          ),
                        ),
                      TextFormField(
                        controller: _nameController,
                        decoration: InputDecoration(
                          labelText: 'Nome Completo',
                          hintText: 'Seu nome',
                          prefixIcon: Icon(Icons.person_outline,
                              color: Theme.of(context).primaryColorDark),
                          filled: true,
                          fillColor: Colors.white,
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(8.0),
                            borderSide: BorderSide(color: Colors.grey[300]!),
                          ),
                          focusedBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(8.0),
                            borderSide: BorderSide(
                                color: Theme.of(context).primaryColor,
                                width: 2.0),
                          ),
                        ),
                        validator: (value) {
                          if (value == null || value.trim().isEmpty) {
                            return 'Informe o nome';
                          }
                          return null;
                        },
                      ),
                      const SizedBox(height: 16),
                      TextFormField(
                        controller: _emailController,
                        decoration: InputDecoration(
                          labelText: 'Email',
                          hintText: 'seu.email@exemplo.com',
                          prefixIcon: Icon(Icons.email_outlined,
                              color: Theme.of(context).primaryColorDark),
                          filled: true,
                          fillColor: Colors.white,
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(8.0),
                            borderSide: BorderSide(color: Colors.grey[300]!),
                          ),
                          focusedBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(8.0),
                            borderSide: BorderSide(
                                color: Theme.of(context).primaryColor,
                                width: 2.0),
                          ),
                        ),
                        keyboardType: TextInputType.emailAddress,
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Informe o email';
                          }
                          if (!RegExp(
                                  r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+")
                              .hasMatch(value)) {
                            return 'Email inválido';
                          }
                          return null;
                        },
                      ),
                      const SizedBox(height: 16),
                      TextFormField(
                        controller: _passwordController,
                        decoration: InputDecoration(
                          labelText: 'Senha',
                          hintText: 'Crie uma senha segura',
                          prefixIcon: Icon(Icons.lock_outline,
                              color: Theme.of(context).primaryColorDark),
                          filled: true,
                          fillColor: Colors.white,
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(8.0),
                            borderSide: BorderSide(color: Colors.grey[300]!),
                          ),
                          focusedBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(8.0),
                            borderSide: BorderSide(
                                color: Theme.of(context).primaryColor,
                                width: 2.0),
                          ),
                        ),
                        obscureText: true,
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Informe a senha';
                          }
                          if (value.length < 8) {
                            return 'A senha deve ter no mínimo 8 caracteres';
                          }
                          return null;
                        },
                      ),
                      const SizedBox(height: 16),
                      DropdownButtonFormField<UserRole>(
                        value: _selectedUserRole,
                        decoration: InputDecoration(
                          labelText: 'Tipo de Usuário',
                          prefixIcon: Icon(Icons.group_outlined,
                              color: Theme.of(context).primaryColorDark),
                          filled: true,
                          fillColor: Colors.white,
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(8.0),
                            borderSide: BorderSide(color: Colors.grey[300]!),
                          ),
                          focusedBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(8.0),
                            borderSide: BorderSide(
                                color: Theme.of(context).primaryColor,
                                width: 2.0),
                          ),
                        ),
                        items: _userRoles.map((UserRole role) {
                          return DropdownMenuItem<UserRole>(
                            value: role,
                            child: Text(_roleLabel(role)),
                          );
                        }).toList(),
                        onChanged: (UserRole? value) {
                          if (value != null) {
                            setState(() {
                              _selectedUserRole = value;
                            });
                          }
                        },
                        validator: (value) {
                          if (value == null) {
                            return 'Selecione o tipo de usuário';
                          }
                          return null;
                        },
                      ),
                      const SizedBox(height: 32),
                      ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Color(0xFFE3E3E3),
                          minimumSize: const Size(double.infinity, 50),
                          padding: const EdgeInsets.symmetric(vertical: 15),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(8.0),
                          ),
                          textStyle: const TextStyle(
                              fontSize: 18, fontWeight: FontWeight.w600),
                        ),
                        onPressed: _isSubmitting ? null : _submitRegister,
                        child: const Text('Cadastrar'),
                      ),
                      const SizedBox(height: 20),
                      TextButton(
                        onPressed: () {
                          context.go('/login');
                        },
                        child: const Text('Já tem conta? Faça login'),
                      )
                    ],
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }
}
