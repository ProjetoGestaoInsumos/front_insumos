import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:front_insumos/api/api_service.dart';
import 'package:front_insumos/layouts/main_layout.dart';
import 'package:front_insumos/screens/auth/auth_bloc/auth_bloc.dart';
import 'package:front_insumos/screens/auth/auth_bloc/auth_event.dart';
import 'package:front_insumos/screens/auth/auth_bloc/auth_state.dart';
import 'package:front_insumos/screens/auth/login_page.dart';
import 'package:front_insumos/screens/auth/register_page.dart';
import 'package:front_insumos/screens/history/history_bloc/history_bloc.dart';
import 'package:front_insumos/screens/history/history_bloc/history_event.dart';
import 'package:front_insumos/screens/history/history_page.dart';
import 'package:front_insumos/screens/home/home_page.dart';
import 'package:front_insumos/screens/orders_page.dart';
import 'package:front_insumos/screens/recipe/recipe_bloc/recipe_bloc.dart';
import 'package:front_insumos/screens/recipe/recipe_bloc/recipe_event.dart';
import 'package:front_insumos/screens/recipe/recipe_form_page.dart';
import 'package:front_insumos/screens/recipe/recipes_page.dart';
import 'package:front_insumos/screens/stock/item_bloc/item_bloc.dart';
import 'package:front_insumos/screens/stock/item_bloc/item_event.dart';
import 'package:front_insumos/screens/stock/stock_bloc/stock_bloc.dart';
import 'package:front_insumos/screens/stock/stock_bloc/stock_event.dart';
import 'package:front_insumos/screens/stock/stock_page.dart';
import 'package:front_insumos/utils/colors.dart';
import 'package:flutter_web_plugins/url_strategy.dart';
import 'package:go_router/go_router.dart';

final authNotifier = ValueNotifier<bool>(false); // false = não logado

void main() {
  if (kIsWeb) {
    setUrlStrategy(PathUrlStrategy());
  }

  runApp(
    RepositoryProvider<ApiService>(
      create: (_) => ApiService(),
      child: MultiBlocProvider(
        providers: [
          BlocProvider(
            create: (context) => AuthBloc(
                apiService: context.read<ApiService>(),
                secureStorage: FlutterSecureStorage())
              ..add(CheckAuthEvent()),
          ),
          BlocProvider<StockBloc>(
            create: (context) =>
                StockBloc(apiService: context.read<ApiService>())
                  ..add(LoadStockEvent()),
          ),
          BlocProvider<ItemBloc>(
            create: (context) =>
                ItemBloc(apiService: context.read<ApiService>())
                  ..add(LoadItemEvent()),
          ),
          BlocProvider(
                  create: (context) =>
                      HistoryBloc(apiService: context.read<ApiService>())
                        ..add(FetchMovements()),
                  child: const HistoryPage(),
                ),
        ],
        child: const AppWrapper(),
      ),
    ),
  );
}

class AppWrapper extends StatelessWidget {
  const AppWrapper({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocListener<AuthBloc, AuthState>(
      listenWhen: (previous, current) => previous != current,
      listener: (context, state) {
        authNotifier.value = state is AuthAuthenticated;
      },
      child: const MyApp(),
    );
  }
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
        final isLoggingIn = state.uri.path == '/login';
        final isRegistering = state.uri.path == '/register';

        // Se não está logado e tentou acessar algo além de /login
        final isGoingToPrivate = !isLoggingIn && !isRegistering;

        if (!loggedIn && isGoingToPrivate) return '/login';
        if (loggedIn && (isLoggingIn || isRegistering)) return '/';

        return null;
      },
      routes: [
        GoRoute(
          path: '/login',
          builder: (context, state) => const LoginPage(),
        ),
        GoRoute(
          path: '/register',
          builder: (context, state) => const RegisterPage(),
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
                child: MultiBlocProvider(
                  providers: [
                    BlocProvider(
                      create: (context) =>
                          StockBloc(apiService: context.read<ApiService>())
                            ..add(LoadStockEvent()),
                    ),
                    BlocProvider(
                      create: (context) =>
                          ItemBloc(apiService: context.read<ApiService>())
                            ..add(LoadItemEvent()),
                    ),
                  ],
                child: StockPage(
                  abrirPop: state.uri.queryParameters['abrirPop'] == 'true',
                  ),
                ),
              ),
            ),
            GoRoute(
              path: '/historico',
              name: 'historico',
              pageBuilder: (ctx, state) => NoTransitionPage(
                child: BlocProvider(
                  create: (context) =>
                      HistoryBloc(apiService: context.read<ApiService>())
                        ..add(FetchMovements()),
                  child: const HistoryPage(),
                ),
              ),
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
              pageBuilder: (ctx, state) => NoTransitionPage(
                child: BlocProvider(
                  create: (context) =>
                      RecipeBloc(apiService: context.read<ApiService>())
                        ..add(FetchRecipes()),
                  child: const RecipesPage(),
                ),
              ),
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
        scaffoldBackgroundColor: CustomColors.white,
        textTheme: const TextTheme(
          bodyLarge: TextStyle(fontSize: 14),
          bodyMedium: TextStyle(fontSize: 14),
        ),
        colorScheme: ColorScheme.fromSwatch()
            .copyWith(primary: CustomColors.blue, secondary: CustomColors.grey),
        inputDecorationTheme: const InputDecorationTheme(
          isDense: true,
          hintStyle: TextStyle(color: Colors.grey),
        ),
      ),
      routerConfig: router,
    );
  }
}
