import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import 'package:utime/models/team_model.dart';

import '../providers/teams_provider.dart';

class SetupScreen extends StatefulWidget {
  const SetupScreen({super.key});

  @override
  State<SetupScreen> createState() => _SetupScreenState();
}

class _SetupScreenState extends State<SetupScreen> {
  TeamModel? _timeTemporario;

  @override
  void initState() {
    super.initState();
    Future.microtask(() => context.read<TeamsProvider>().loadTeams());
  }

  Future<void> _confirmar() async {
    if (_timeTemporario == null) return;

    await context.read<TeamsProvider>().selectTeam(_timeTemporario!);

    if (mounted) {
      context.goNamed('home');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [Color(0xFF081120), Color(0xFF0B1730), Color(0xFF101A35)],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
          ),
        ),
        child: Stack(
          children: [
            const _BackgroundDecorations(),
            SafeArea(
              child: Column(
                children: [
                  Expanded(
                    child: Padding(
                      padding: const EdgeInsets.fromLTRB(20, 20, 20, 0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const _HeaderSetup(),
                          const SizedBox(height: 24),
                          Expanded(
                            child: Consumer<TeamsProvider>(
                              builder: (context, provider, child) {
                                if (provider.isLoading) {
                                  return const _LoadingState();
                                }

                                if (provider.error != null) {
                                  return _ErrorState(message: provider.error!);
                                }

                                if (provider.teams.isEmpty) {
                                  return const _EmptyState();
                                }

                                return GridView.builder(
                                  padding: const EdgeInsets.only(bottom: 24),
                                  gridDelegate:
                                      const SliverGridDelegateWithFixedCrossAxisCount(
                                        crossAxisCount: 3,
                                        crossAxisSpacing: 14,
                                        mainAxisSpacing: 14,
                                        childAspectRatio: 0.78,
                                      ),
                                  itemCount: provider.teams.length,
                                  itemBuilder: (context, index) {
                                    final time = provider.teams[index];
                                    final selecionado =
                                        _timeTemporario?.footballDataId ==
                                        time.footballDataId;

                                    return _TeamCard(
                                      nome: time.displayName,
                                      badgeUrl: time.logoUrl ?? '',
                                      selecionado: selecionado,
                                      onTap: () {
                                        setState(() {
                                          _timeTemporario = time;
                                        });
                                      },
                                    );
                                  },
                                );
                              },
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  _BottomConfirmBar(
                    teamName: _timeTemporario?.displayName,
                    onPressed: _timeTemporario != null ? _confirmar : null,
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _BackgroundDecorations extends StatelessWidget {
  const _BackgroundDecorations();

  @override
  Widget build(BuildContext context) {
    return IgnorePointer(
      child: Stack(
        children: [
          Positioned(
            top: -50,
            right: -30,
            child: Container(
              width: 180,
              height: 180,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: const Color(0xFF2563EB).withOpacity(0.12),
              ),
            ),
          ),
          Positioned(
            top: 120,
            left: -40,
            child: Container(
              width: 140,
              height: 140,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: const Color(0xFF22C55E).withOpacity(0.08),
              ),
            ),
          ),
          Positioned(
            bottom: 80,
            right: -50,
            child: Container(
              width: 170,
              height: 170,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: const Color(0xFF38BDF8).withOpacity(0.08),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _HeaderSetup extends StatelessWidget {
  const _HeaderSetup();

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(22),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(28),
        gradient: LinearGradient(
          colors: [
            Colors.white.withOpacity(0.10),
            Colors.white.withOpacity(0.04),
          ],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        border: Border.all(color: Colors.white.withOpacity(0.10)),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.20),
            blurRadius: 24,
            offset: const Offset(0, 12),
          ),
        ],
      ),
      child: const Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _HeaderBadge(),
          SizedBox(height: 18),
          Text(
            'Escolha seu\nclube do coração',
            style: TextStyle(
              color: Colors.white,
              fontSize: 30,
              fontWeight: FontWeight.w800,
              height: 1.08,
              letterSpacing: -0.5,
            ),
          ),
          SizedBox(height: 10),
          Text(
            'Personalize o app com notícias, jogos e conteúdos do seu time favorito.',
            style: TextStyle(
              color: Color(0xFFB8C4D9),
              fontSize: 14,
              height: 1.45,
            ),
          ),
        ],
      ),
    );
  }
}

class _HeaderBadge extends StatelessWidget {
  const _HeaderBadge();

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Container(
          height: 46,
          width: 46,
          decoration: BoxDecoration(
            color: const Color(0xFF2563EB),
            borderRadius: BorderRadius.circular(14),
          ),
          child: const Icon(
            Icons.sports_soccer_rounded,
            color: Colors.white,
            size: 24,
          ),
        ),
        const SizedBox(width: 12),
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 7),
          decoration: BoxDecoration(
            color: Colors.white.withOpacity(0.06),
            borderRadius: BorderRadius.circular(999),
            border: Border.all(color: Colors.white.withOpacity(0.08)),
          ),
          child: const Text(
            'Configuração inicial',
            style: TextStyle(
              color: Color(0xFFDCE7F7),
              fontSize: 12,
              fontWeight: FontWeight.w600,
            ),
          ),
        ),
      ],
    );
  }
}

class _TeamCard extends StatelessWidget {
  final String nome;
  final String badgeUrl;
  final bool selecionado;
  final VoidCallback onTap;

  const _TeamCard({
    required this.nome,
    required this.badgeUrl,
    required this.selecionado,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final borderColor = selecionado
        ? const Color(0xFF60A5FA)
        : Colors.white.withOpacity(0.08);

    final backgroundGradient = selecionado
        ? [const Color(0xFF17305F), const Color(0xFF13294D)]
        : [Colors.white.withOpacity(0.07), Colors.white.withOpacity(0.04)];

    return AnimatedScale(
      scale: selecionado ? 1.02 : 1,
      duration: const Duration(milliseconds: 180),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: onTap,
          borderRadius: BorderRadius.circular(22),
          child: AnimatedContainer(
            duration: const Duration(milliseconds: 220),
            curve: Curves.easeOut,
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 14),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(22),
              gradient: LinearGradient(
                colors: backgroundGradient,
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
              ),
              border: Border.all(
                color: borderColor,
                width: selecionado ? 1.6 : 1,
              ),
              boxShadow: [
                BoxShadow(
                  color: selecionado
                      ? const Color(0xFF2563EB).withOpacity(0.22)
                      : Colors.black.withOpacity(0.10),
                  blurRadius: selecionado ? 22 : 10,
                  offset: const Offset(0, 10),
                ),
              ],
            ),
            child: Column(
              children: [
                Align(
                  alignment: Alignment.topRight,
                  child: AnimatedOpacity(
                    opacity: selecionado ? 1 : 0,
                    duration: const Duration(milliseconds: 180),
                    child: Container(
                      height: 22,
                      width: 22,
                      decoration: const BoxDecoration(
                        color: Color(0xFF60A5FA),
                        shape: BoxShape.circle,
                      ),
                      child: const Icon(
                        Icons.check_rounded,
                        size: 14,
                        color: Colors.white,
                      ),
                    ),
                  ),
                ),
                Expanded(
                  child: Center(
                    child: Container(
                      height: 78,
                      width: 78,
                      padding: const EdgeInsets.all(12),
                      decoration: BoxDecoration(
                        color: Colors.white.withOpacity(0.08),
                        shape: BoxShape.circle,
                        border: Border.all(
                          color: Colors.white.withOpacity(0.08),
                        ),
                      ),
                      child: Image.network(
                        badgeUrl,
                        fit: BoxFit.contain,
                        errorBuilder: (_, __, ___) => const Icon(
                          Icons.shield_rounded,
                          color: Colors.white24,
                          size: 36,
                        ),
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 10),
                Text(
                  nome,
                  textAlign: TextAlign.center,
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(
                    color: Colors.white.withOpacity(selecionado ? 1 : 0.90),
                    fontSize: 12,
                    fontWeight: selecionado ? FontWeight.w700 : FontWeight.w600,
                    height: 1.25,
                  ),
                ),
                const SizedBox(height: 6),
                AnimatedContainer(
                  duration: const Duration(milliseconds: 180),
                  height: 4,
                  width: selecionado ? 26 : 0,
                  decoration: BoxDecoration(
                    color: const Color(0xFF60A5FA),
                    borderRadius: BorderRadius.circular(999),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _BottomConfirmBar extends StatelessWidget {
  final String? teamName;
  final VoidCallback? onPressed;

  const _BottomConfirmBar({required this.teamName, required this.onPressed});

  @override
  Widget build(BuildContext context) {
    final hasSelection = teamName != null;

    return Container(
      padding: const EdgeInsets.fromLTRB(20, 12, 20, 18),
      decoration: BoxDecoration(
        color: Colors.black.withOpacity(0.20),
        border: Border(top: BorderSide(color: Colors.white.withOpacity(0.06))),
      ),
      child: SafeArea(
        top: false,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            if (hasSelection) ...[
              Container(
                width: double.infinity,
                margin: const EdgeInsets.only(bottom: 12),
                padding: const EdgeInsets.symmetric(
                  horizontal: 14,
                  vertical: 12,
                ),
                decoration: BoxDecoration(
                  color: Colors.white.withOpacity(0.06),
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(color: Colors.white.withOpacity(0.05)),
                ),
                child: Row(
                  children: [
                    const Icon(
                      Icons.favorite_rounded,
                      color: Color(0xFF60A5FA),
                      size: 18,
                    ),
                    const SizedBox(width: 8),
                    Expanded(
                      child: Text(
                        'Time selecionado: $teamName',
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 13,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: onPressed,
                style: ElevatedButton.styleFrom(
                  elevation: 0,
                  backgroundColor: const Color(0xFF2563EB),
                  disabledBackgroundColor: const Color(0xFF1B2740),
                  disabledForegroundColor: const Color(0xFF6C7A92),
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(vertical: 17),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(18),
                  ),
                ),
                child: Text(
                  hasSelection
                      ? 'Continuar com $teamName'
                      : 'Selecione um time para continuar',
                  style: const TextStyle(
                    fontSize: 15,
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _LoadingState extends StatelessWidget {
  const _LoadingState();

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 20),
        decoration: BoxDecoration(
          color: Colors.white.withOpacity(0.05),
          borderRadius: BorderRadius.circular(20),
          border: Border.all(color: Colors.white.withOpacity(0.06)),
        ),
        child: const Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            CircularProgressIndicator(color: Color(0xFF60A5FA)),
            SizedBox(height: 16),
            Text(
              'Carregando times...',
              style: TextStyle(color: Color(0xFFB8C4D9), fontSize: 14),
            ),
          ],
        ),
      ),
    );
  }
}

class _ErrorState extends StatelessWidget {
  const _ErrorState({required this.message});

  final String message;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Text(
          message,
          textAlign: TextAlign.center,
          style: const TextStyle(color: Colors.white, fontSize: 14),
        ),
      ),
    );
  }
}

class _EmptyState extends StatelessWidget {
  const _EmptyState();

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Container(
        padding: const EdgeInsets.all(24),
        decoration: BoxDecoration(
          color: Colors.white.withOpacity(0.05),
          borderRadius: BorderRadius.circular(24),
          border: Border.all(color: Colors.white.withOpacity(0.06)),
        ),
        child: const Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(Icons.search_off_rounded, color: Color(0xFF64748B), size: 42),
            SizedBox(height: 12),
            Text(
              'Nenhum time encontrado',
              style: TextStyle(
                color: Colors.white,
                fontSize: 17,
                fontWeight: FontWeight.w700,
              ),
            ),
            SizedBox(height: 6),
            Text(
              'Tente novamente mais tarde.',
              style: TextStyle(color: Color(0xFF94A3B8), fontSize: 13),
            ),
          ],
        ),
      ),
    );
  }
}
