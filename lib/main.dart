import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:front_insumos/layouts/main_layout.dart';
import 'package:front_insumos/screens/history_page.dart';
import 'package:front_insumos/screens/home_page.dart';
import 'package:front_insumos/screens/items_test_page.dart';
import 'package:front_insumos/utils/colors.dart';
import 'package:flutter_web_plugins/url_strategy.dart';
import 'package:go_router/go_router.dart';

void main() {
  if (kIsWeb) {
    setUrlStrategy(PathUrlStrategy());
  }
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    final rootNavigatorKey = GlobalKey<NavigatorState>();
    final shellNavigatorKey = GlobalKey<NavigatorState>();

    final GoRouter router = GoRouter(
      navigatorKey: rootNavigatorKey,
      initialLocation: '/login',
      routes: [
        GoRoute(
          path: '/login',
          builder: (context, state) => Scaffold(
            body: Center(child: ElevatedButton(
                onPressed: () {
                  // Para fins de teste, redireciona para a home
                  context.go('/');
                },
                child: const SizedBox(
                  width: double.infinity,
                  child: Center(child: Text('Entrar')),
                ),
              ),),
          ),
        ),
        GoRoute(
          path: '/register',
          builder: (context, state) => const Scaffold(
            body: Center(child: Text('Página de Registro (exemplo)')),
          ),
        ),
        ShellRoute(
          navigatorKey: shellNavigatorKey,
          builder: (context, state, child) {
            final loc = state.uri.toString();
            final path = state.uri.path;
            int selectedIndex = 0;
            if (path == '/' || path == '') {
              selectedIndex = 0;
            } else if (loc.startsWith('/estoque')) {
              selectedIndex = 1;
            } else if (loc.startsWith('/historico')) {
              selectedIndex = 2;
            } else if (loc.startsWith('/pedidos')) {
              selectedIndex = 3;
            } else if (loc.startsWith('/receitas')) {
              selectedIndex = 4;
            }

            return MainLayout(
              selectedIndex: selectedIndex,
              child: child,
            );
          },
          routes: [
            GoRoute(
              path: '/',
              name: 'home',
              builder: (ctx, state) => const HomePage(),
            ),
            GoRoute(
              path: '/estoque',
              name: 'estoque',
              builder: (ctx, state) => ItemsTestPage(),
            ),
            GoRoute(
              path: '/historico',
              name: 'historico',
              builder: (ctx, state) => const HistoryPage(),
            ),
            GoRoute(
              path: '/pedidos',
              name: 'pedidos',
              builder: (ctx, state) => const Scaffold(
                body: Center(child: Text('Página Pedidos (exemplo)')),
              ),
            ),
            GoRoute(
              path: '/receitas',
              name: 'receitas',
              builder: (ctx, state) => const Scaffold(
                body: Center(child: Text('Página Receitas (exemplo)')),
              ),
            ),
          ],
        ),
      ],
      errorBuilder: (ctx, state) => Scaffold(
        body: Center(child: Text('Rota não encontrada: ${state.uri.toString()}')),
      ),
    );

    return MaterialApp.router(
      debugShowCheckedModeBanner: false,
      title: 'Gestão de Insumos',
      theme: ThemeData(
        fontFamily: 'Poppins',
        textTheme: const TextTheme(
          bodyLarge: TextStyle(fontSize: 14),
          bodyMedium: TextStyle(fontSize: 14),
        ),
        colorScheme: ColorScheme.fromSwatch()
            .copyWith(primary: CustomColors.blue, secondary: CustomColors.grey),
      ),
      routerConfig: router,
    );
  }
}