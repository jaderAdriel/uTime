import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';

import '../providers/teams_provider.dart';

class SettingsScreen extends StatelessWidget {
  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final time =
        context.watch<TeamsProvider>().selectedTeam?.displayName ?? 'Nenhum';

    return Scaffold(
      backgroundColor: const Color(0xFF1A2744),
      appBar: AppBar(
        backgroundColor: const Color(0xFF1A2744),
        title: const Text(
          'Configurações',
          style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
        ),
      ),
      body: ListView(
        children: [
          // ── Seção: Time favorito ────────────────────────
          _cabecalhoSecao('Time favorito'),
          ListTile(
            tileColor: const Color(0xFF243460),
            leading: const Icon(Icons.sports_soccer, color: Color(0xFF3B5BDB)),
            title: const Text(
              'Time atual',
              style: TextStyle(color: Colors.white),
            ),
            subtitle: Text(
              time,
              style: const TextStyle(color: Color(0xFF8899CC)),
            ),
            trailing: TextButton(
              onPressed: () => context.goNamed('setup'),
              child: const Text(
                'Trocar',
                style: TextStyle(color: Color(0xFF3B5BDB)),
              ),
            ),
          ),

          const SizedBox(height: 8),

          // ── Seção: Sobre ────────────────────────────────
          _cabecalhoSecao('Sobre'),
          ListTile(
            tileColor: const Color(0xFF243460),
            leading: const Icon(Icons.info_outline, color: Color(0xFF3B5BDB)),
            title: const Text('Versão', style: TextStyle(color: Colors.white)),
            subtitle: const Text(
              '1.0.0',
              style: TextStyle(color: Color(0xFF8899CC)),
            ),
          ),
        ],
      ),
    );
  }

  Widget _cabecalhoSecao(String titulo) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 20, 16, 6),
      child: Text(
        titulo.toUpperCase(),
        style: const TextStyle(
          color: Color(0xFF556688),
          fontSize: 11,
          letterSpacing: 1.5,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }
}
