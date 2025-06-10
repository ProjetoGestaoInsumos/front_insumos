import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:front_insumos/models/user.dart';
import 'package:front_insumos/screens/auth/auth_bloc/auth_bloc.dart';
import 'package:front_insumos/screens/auth/auth_bloc/auth_state.dart';
import 'package:front_insumos/utils/colors.dart';

class TopBar extends StatelessWidget {
  const TopBar({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 90,
      padding: const EdgeInsets.symmetric(horizontal: 20),
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.centerLeft,
          end: Alignment.centerRight,
          colors: [
            CustomColors.blue, // Azul (esquerda)
            CustomColors.blueCesumar, // (direita)
          ],
          stops: [0.5, 0.7],
        ),
      ),
      child: BlocBuilder<AuthBloc, AuthState>(
        builder: (context, state) {
          String nome = 'Usuário';
          String role = '';

          if (state is AuthAuthenticated) {
            nome = _firstAndLastName(state.user.name);

            role = _formatarCargo(state.user.role);
          }
          return Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              Padding(
                padding: const EdgeInsets.only(bottom: 8),
                child: CircleAvatar(
                    radius: 25,
                    backgroundColor: Colors.black,
                    child: Icon(Icons.person)),
              ),
              const SizedBox(width: 12),
              ConstrainedBox(
                constraints: const BoxConstraints(minWidth: 120),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      nome,
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    Text(
                      role,
                      style: TextStyle(
                        color: Colors.white70,
                        fontSize: 14,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          );
        },
      ),
    );
  }

  String _firstAndLastName(String fullName) {
    final parts = fullName.trim().split(' ');
    if (parts.length <= 1) return fullName;
    return '${parts.first} ${parts.last}';
  }

  String _formatarCargo(UserRole role) {
    switch (role) {
      case UserRole.admin:
        return 'Administrador';
      case UserRole.tecnico:
        return 'Técnico';
      case UserRole.professor:
        return 'Professor';
    }
  }
}
