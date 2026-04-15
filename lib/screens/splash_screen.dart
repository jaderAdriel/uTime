import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';

import '../providers/teams_provider.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen>
    with SingleTickerProviderStateMixin {
  // Controlador da animação de fade + subida do logo
  late AnimationController _controller;
  late Animation<double> _fadeAnim;
  late Animation<Offset> _slideAnim;

  @override
  void initState() {
    super.initState();

    // Configura a animação: dura 800ms
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 800),
    );

    _fadeAnim = CurvedAnimation(parent: _controller, curve: Curves.easeIn);

    _slideAnim = Tween<Offset>(
      begin: const Offset(0, 0.3), // começa 30% abaixo
      end: Offset.zero, // termina na posição normal
    ).animate(CurvedAnimation(parent: _controller, curve: Curves.easeOut));

    // Inicia a animação assim que a tela abre
    _controller.forward();

    // Após 2.5 segundos, decide para qual tela ir
    Future.delayed(const Duration(milliseconds: 2500), _navegarProximo);
  }

  void _navegarProximo() {
    if (!mounted) return; // segurança: se o widget foi destruído, não navega

    final teamProvider = context.read<TeamsProvider>();

    if (!teamProvider.selectedTeamLoaded) {
      Future.delayed(const Duration(milliseconds: 150), _navegarProximo);
      return;
    }

    // Se o usuário JÁ escolheu um time, vai direto para o Home
    // Se NÃO, vai para a tela de configuração
    if (teamProvider.selectedTeam != null) {
      context.goNamed('home');
    } else {
      context.goNamed('setup');
    }
  }

  @override
  void dispose() {
    _controller.dispose(); // libera memória da animação
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // Fundo azul escuro (cor principal do app)
      backgroundColor: const Color(0xFF1A2744),

      body: Center(
        child: FadeTransition(
          opacity: _fadeAnim,
          child: SlideTransition(
            position: _slideAnim,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                // ── LOGO ──────────────────────────────────
                Container(
                  width: 112,
                  height: 112,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: const Color(0xFF243460),
                    border: Border.all(
                      color: const Color(0xFF3B5BDB),
                      width: 2.5,
                    ),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withValues(alpha: 0.18),
                        blurRadius: 20,
                        offset: const Offset(0, 10),
                      ),
                    ],
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(12),
                    child: ClipOval(
                      child: Image.asset(
                        'assets/app_icon_score_news.png',
                        fit: BoxFit.cover,
                      ),
                    ),
                  ),
                ),

                const SizedBox(height: 24),

                // ── NOME DO APP ───────────────────────────
                const Text(
                  'Score News',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 32,
                    fontWeight: FontWeight.bold,
                    letterSpacing: 1.5,
                  ),
                ),

                const SizedBox(height: 8),

                // ── SLOGAN ────────────────────────────────
                const Text(
                  'NOTÍCIAS DO SEU TIME',
                  style: TextStyle(
                    color: Color(0xFF8899CC),
                    fontSize: 13,
                    letterSpacing: 3,
                  ),
                ),

                const SizedBox(height: 60),

                // ── BARRA DE CARREGAMENTO ─────────────────
                SizedBox(
                  width: 180,
                  child: Column(
                    children: [
                      ClipRRect(
                        borderRadius: BorderRadius.circular(4),
                        child: const LinearProgressIndicator(
                          backgroundColor: Color(0xFF243460),
                          color: Color(0xFF3B5BDB),
                          minHeight: 3,
                        ),
                      ),
                      const SizedBox(height: 10),
                      const Text(
                        'carregando...',
                        style: TextStyle(
                          color: Color(0xFF5566AA),
                          fontSize: 12,
                          letterSpacing: 1,
                        ),
                      ),
                    ],
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
