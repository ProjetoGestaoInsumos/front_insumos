import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:front_insumos/api/api_service.dart';
import 'package:front_insumos/layouts/main_layout.dart';
import 'package:front_insumos/screens/auth/auth_bloc/auth_bloc.dart';
import 'package:front_insumos/screens/auth/auth_bloc/auth_event.dart';
import 'package:front_insumos/screens/auth/login_page.dart';
import 'package:front_insumos/screens/history_page.dart';
import 'package:front_insumos/screens/home_page.dart';
import 'package:front_insumos/screens/orders_page.dart';
import 'package:front_insumos/screens/recipe_form_page.dart';
import 'package:front_insumos/screens/recipes_page.dart';
import 'package:front_insumos/screens/stock_page.dart';
import 'package:front_insumos/utils/colors.dart';
import 'package:flutter_web_plugins/url_strategy.dart';
import 'package:go_router/go_router.dart';

final authNotifier = ValueNotifier<bool>(false); // false = não logado

void main() {
  if (kIsWeb) {
    setUrlStrategy(PathUrlStrategy());
  }
  final apiService = ApiService();

  runApp(
    BlocProvider(
      create: (context) =>
          AuthBloc(apiService: apiService)..add(CheckAuthEvent()),
      child: const MyApp(),
    ),
  );
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
      refreshListenable: authNotifier,
      redirect: (context, state) {
        final loggedIn = authNotifier.value;
        final goingToLogin = state.uri.path == '/login';

        // Se não está logado e tentou acessar algo além de /login
        if (!loggedIn && !goingToLogin) return '/login';

        // Se está logado e tentou ir para o login
        if (loggedIn && goingToLogin) return '/';

        return null; // segue normalmente
      },
      routes: [
        GoRoute(
          path: '/login',
          builder: (context, state) => LoginPage(),
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
              pageBuilder: (ctx, state) => NoTransitionPage(child: HomePage()),
            ),
            GoRoute(
              path: '/estoque',
              name: 'estoque',
              pageBuilder: (ctx, state) => NoTransitionPage(
                  child: StockPage(
                      abrirPop:
                          state.uri.queryParameters['abrirPop'] == 'true')),
            ),
            GoRoute(
              path: '/historico',
              name: 'historico',
              pageBuilder: (ctx, state) =>
                  NoTransitionPage(child: const HistoryPage()),
            ),
            GoRoute(
              path: '/pedidos',
              name: 'pedidos',
              pageBuilder: (ctx, state) => NoTransitionPage(
                child: OrdersPage(
                    abrirPop: state.uri.queryParameters['abrirPop'] == 'true'),
              ),
            ),
            GoRoute(
              path: '/receitas',
              name: 'receitas',
              pageBuilder: (ctx, state) =>
                  NoTransitionPage(child: const RecipesPage()),
            ),
            GoRoute(
              path: '/receitas/novo',
              name: 'nova_receita',
              builder: (context, state) => const RecipeFormPage(),
            ),
          ],
        ),
      ],
      errorBuilder: (ctx, state) => Scaffold(
        body:
            Center(child: Text('Rota não encontrada: ${state.uri.toString()}')),
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
        inputDecorationTheme: InputDecorationTheme(
          isDense: true,
          hintStyle: TextStyle(color: Colors.grey),
        ),
      ),
      routerConfig: router,
    );
  }
}
