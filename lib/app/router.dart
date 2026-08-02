import 'package:go_router/go_router.dart';

import '../features/map/presentation/map_page.dart';
import '../features/profile/presentation/profile_page.dart';
import '../features/splash/presentation/splash_page.dart';

class AppRouter {
  AppRouter._();

  static final GoRouter router = GoRouter(
    initialLocation: SplashPage.route,
    routes: [
      GoRoute(
        path: SplashPage.route,
        name: SplashPage.name,
        builder: (_, __) => const SplashPage(),
      ),
      GoRoute(
        path: MapPage.route,
        name: MapPage.name,
        builder: (_, __) => const MapPage(),
      ),
      GoRoute(
        path: ProfilePage.route,
        name: ProfilePage.name,
        builder: (_, __) => const ProfilePage(),
      ),
    ],
  );
}
