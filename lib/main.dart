import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'providers/favorites_provider.dart';
import 'providers/news_provider.dart';
import 'providers/team_details_provider.dart';
import 'providers/teams_provider.dart';
import 'router.dart';
import 'services/football_data_service.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  const apiKey = '954921806b594b049877a1da06bf1bfd';

  runApp(
    MultiProvider(
      providers: [
        Provider(create: (_) => FootballDataService(apiKey: apiKey)),
        ChangeNotifierProvider(
          create: (context) =>
              TeamsProvider(service: context.read<FootballDataService>())
                ..loadSelectedTeam(),
        ),
        ChangeNotifierProvider(
          create: (context) =>
              TeamDetailsProvider(service: context.read<FootballDataService>()),
        ),
        ChangeNotifierProvider(create: (_) => NewsProvider()),
        ChangeNotifierProvider(
          create: (_) => FavoritesProvider()..carregarFavoritos(),
        ),
      ],
      child: const ScoreNewsApp(),
    ),
  );
}

class ScoreNewsApp extends StatelessWidget {
  const ScoreNewsApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      title: 'Score News',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(
          seedColor: const Color(0xFF1E3A5F),
          brightness: Brightness.light,
        ),
        useMaterial3: true,
        fontFamily: 'Roboto',
      ),
      routerConfig: appRouter,
    );
  }
}
