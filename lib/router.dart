import 'package:go_router/go_router.dart';

import 'models/team_model.dart';
import 'screens/favorites_screen.dart';
import 'screens/home_screen.dart';
import 'screens/main_shell.dart';
import 'screens/news_detail_screen.dart';
import 'screens/settings_screen.dart';
import 'screens/setup_screen.dart';
import 'screens/splash_screen.dart';
import 'screens/team_details_screen.dart';

final appRouter = GoRouter(
  initialLocation: '/splash',
  routes: [
    GoRoute(
      path: '/splash',
      name: 'splash',
      builder: (context, state) => const SplashScreen(),
    ),
    GoRoute(
      path: '/setup',
      name: 'setup',
      builder: (context, state) => const SetupScreen(),
    ),
    GoRoute(
      path: '/team-details',
      name: 'team-details',
      builder: (context, state) {
        final team = state.extra as TeamModel;
        return TeamDetailsScreen(selectedTeam: team);
      },
    ),
    GoRoute(
      path: '/news',
      name: 'newsDetail',
      builder: (context, state) {
        final id = state.uri.queryParameters['id'] ?? '';
        return NewsDetailScreen(articleId: id);
      },
    ),
    StatefulShellRoute.indexedStack(
      builder: (context, state, navigationShell) =>
          MainShell(navigationShell: navigationShell),
      branches: [
        StatefulShellBranch(
          routes: [
            GoRoute(
              path: '/home',
              name: 'home',
              builder: (context, state) => const HomeScreen(),
            ),
          ],
        ),
        StatefulShellBranch(
          routes: [
            GoRoute(
              path: '/favorites',
              name: 'favorites',
              builder: (context, state) => const FavoritesScreen(),
            ),
          ],
        ),
        StatefulShellBranch(
          routes: [
            GoRoute(
              path: '/settings',
              name: 'settings',
              builder: (context, state) => const SettingsScreen(),
            ),
          ],
        ),
      ],
    ),
  ],
);
