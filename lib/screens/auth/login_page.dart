import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:front_insumos/screens/auth/auth_bloc/auth_bloc.dart';
import 'package:front_insumos/screens/auth/auth_bloc/auth_state.dart';
import 'register_page.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();

  String? _errorMessage;

  void _submit() {
    if (_formKey.currentState?.validate() ?? false) {
      setState(() => _errorMessage = null);
      print(
          'Tentativa de login com Email: ${_emailController.text.trim()}, Senha: ${_passwordController.text}');

      Navigator.pushReplacementNamed(context, '/');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.blueGrey[50],
      body: BlocListener<AuthBloc, AuthState>(
        listener: (context, state) {
          if (state is AuthAuthenticated) {
            Navigator.pushReplacementNamed(context, '/');
          } else if (state is AuthError) {
            setState(() => _errorMessage = state.message);
          }
        },
        child: Center(
          child: Card(
            elevation: 8.0,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12.0),
            ),
            margin: const EdgeInsets.all(20.0),
            child: SizedBox(
              width: 400,
              child: Padding(
                padding: const EdgeInsets.all(32.0),
                child: Form(
                  key: _formKey,
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text('Bem-vindo',
                          style: TextStyle(
                            fontSize: 26,
                            fontWeight: FontWeight.bold,
                            color: Theme.of(context).primaryColor,
                          )),
                      const SizedBox(height: 8),
                      Text('Acesse o sistema de insumos',
                          style:
                              TextStyle(fontSize: 16, color: Colors.grey[600])),
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
                        controller: _emailController,
                        decoration: InputDecoration(
                          labelText: 'Email',
                          hintText: 'seu.email@exemplo.com', // Placeholder
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
                          if (value == null || value.isEmpty)
                            return 'Informe o email';
                          if (!RegExp(
                                  r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+")
                              .hasMatch(value)) return 'Email inválido';
                          return null;
                        },
                      ),
                      const SizedBox(height: 16),
                      TextFormField(
                        controller: _passwordController,
                        decoration: InputDecoration(
                          labelText: 'Senha',
                          hintText: 'Sua senha',
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
                          if (value == null || value.isEmpty)
                            return 'Informe a senha';

                          return null;
                        },
                      ),
                      const SizedBox(height: 32),
                      ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Color(0xFFE3E3E3),
                          minimumSize:
                              const Size(double.infinity, 50), // Botão largo
                          padding: const EdgeInsets.symmetric(vertical: 15),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(8.0),
                          ),
                          textStyle: const TextStyle(
                              fontSize: 18, fontWeight: FontWeight.w600),
                        ),
                        onPressed: _submit,
                        child: const Text('Entrar'),
                      ),
                      const SizedBox(height: 20),
                      TextButton(
                        onPressed: () {
                          print("Navegar para registro");
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => const RegisterPage()),
                          );
                        },
                        child: const Text('Não tem conta? Cadastre-se'),
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
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }
}
