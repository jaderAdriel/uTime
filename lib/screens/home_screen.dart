import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';

import '../models/article.dart';
import '../models/team_model.dart';
import '../providers/news_provider.dart';
import '../providers/teams_provider.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen>
    with SingleTickerProviderStateMixin {
  String? _ultimaBusca;
  late final TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();

    final selectedTeam = Provider.of<TeamsProvider>(context).selectedTeam;
    final busca = (selectedTeam?.displayName ?? 'brasileirao').trim();

    if (_ultimaBusca == busca) {
      return;
    }

    _ultimaBusca = busca;
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!mounted) return;
      context.read<NewsProvider>().buscarNoticias(busca);
    });
  }

  Future<void> _recarregarNoticias() {
    return context.read<NewsProvider>().recarregar();
  }

  List<Article> _filtrarNoticiasDoTime(
    List<Article> noticias,
    TeamModel? team,
  ) {
    if (team == null) {
      return noticias;
    }

    final termos = <String>{
      team.name,
      team.displayName,
      if (team.shortName != null) team.shortName!,
    }.map(_normalizarTexto).where((item) => item.length >= 4).toList();

    return noticias.where((artigo) {
      final conteudo = _normalizarTexto(
        [
          artigo.titulo,
          artigo.descricao,
          artigo.autor,
          ...artigo.tags,
        ].join(' '),
      );

      return termos.any(conteudo.contains);
    }).toList();
  }

  String _normalizarTexto(String valor) {
    const mapa = {
      'á': 'a',
      'à': 'a',
      'â': 'a',
      'ã': 'a',
      'ä': 'a',
      'é': 'e',
      'è': 'e',
      'ê': 'e',
      'ë': 'e',
      'í': 'i',
      'ì': 'i',
      'î': 'i',
      'ï': 'i',
      'ó': 'o',
      'ò': 'o',
      'ô': 'o',
      'õ': 'o',
      'ö': 'o',
      'ú': 'u',
      'ù': 'u',
      'û': 'u',
      'ü': 'u',
      'ç': 'c',
    };

    var normalizado = valor.toLowerCase();
    mapa.forEach((original, substituto) {
      normalizado = normalizado.replaceAll(original, substituto);
    });

    return normalizado
        .replaceAll(RegExp(r'[^a-z0-9]+'), ' ')
        .replaceAll(RegExp(r'\s+'), ' ')
        .trim();
  }

  @override
  Widget build(BuildContext context) {
    final newsProvider = context.watch<NewsProvider>();
    final selectedTeam = context.watch<TeamsProvider>().selectedTeam;
    final teamName = selectedTeam?.displayName ?? 'Brasileirão';
    final noticiasDoTime = _filtrarNoticiasDoTime(
      newsProvider.noticias,
      selectedTeam,
    );

    return Scaffold(
      backgroundColor: const Color(0xFF1A2744),
      appBar: AppBar(
        backgroundColor: const Color(0xFF1A2744),
        title: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Score News',
              style: TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.bold,
              ),
            ),
            Text(
              'Fontes: NewsAPI + ESPN',
              style: const TextStyle(color: Color(0xFF8899CC), fontSize: 12),
            ),
          ],
        ),
        actions: [
          if (selectedTeam != null)
            IconButton(
              icon: const Icon(Icons.shield_outlined, color: Colors.white),
              tooltip: 'Ver detalhes do time',
              onPressed: () =>
                  context.pushNamed('team-details', extra: selectedTeam),
            ),
          IconButton(
            icon: const Icon(Icons.favorite_border, color: Colors.white),
            onPressed: () => context.goNamed('favorites'),
          ),
        ],
      ),
      body: newsProvider.carregando
          ? const Center(
              child: CircularProgressIndicator(color: Color(0xFF3B5BDB)),
            )
          : newsProvider.erro != null
          ? RefreshIndicator(
              onRefresh: _recarregarNoticias,
              color: const Color(0xFF3B5BDB),
              child: ListView(
                physics: const AlwaysScrollableScrollPhysics(),
                padding: const EdgeInsets.all(24),
                children: [
                  Text(
                    newsProvider.erro!,
                    textAlign: TextAlign.center,
                    style: const TextStyle(color: Colors.redAccent),
                  ),
                ],
              ),
            )
          : Column(
              children: [
                if (selectedTeam != null)
                  _TeamNewsHeader(
                    selectedTeam: selectedTeam,
                    onOpenTeam: () =>
                        context.pushNamed('team-details', extra: selectedTeam),
                  ),
                Padding(
                  padding: const EdgeInsets.fromLTRB(16, 12, 16, 0),
                  child: Container(
                    decoration: BoxDecoration(
                      color: const Color(0xFF111D38),
                      borderRadius: BorderRadius.circular(18),
                    ),
                    child: TabBar(
                      controller: _tabController,
                      indicatorSize: TabBarIndicatorSize.tab,
                      indicator: BoxDecoration(
                        color: const Color(0xFF3B5BDB),
                        borderRadius: BorderRadius.circular(14),
                      ),
                      dividerColor: Colors.transparent,
                      labelColor: Colors.white,
                      unselectedLabelColor: const Color(0xFF8899CC),
                      labelStyle: const TextStyle(
                        fontWeight: FontWeight.w700,
                        fontSize: 13,
                      ),
                      tabs: [
                        Tab(text: selectedTeam != null ? 'Do time' : 'Em alta'),
                        const Tab(text: 'Geral'),
                      ],
                    ),
                  ),
                ),
                Expanded(
                  child: TabBarView(
                    controller: _tabController,
                    children: [
                      _NewsList(
                        artigos: noticiasDoTime,
                        emptyMessage: selectedTeam != null
                            ? 'Nenhuma notícia encontrada para $teamName.'
                            : 'Nenhuma notícia encontrada.',
                        onRefresh: _recarregarNoticias,
                      ),
                      _NewsList(
                        artigos: newsProvider.noticias,
                        emptyMessage:
                            'Nenhuma notícia encontrada nas fontes configuradas.',
                        onRefresh: _recarregarNoticias,
                      ),
                    ],
                  ),
                ),
              ],
            ),
    );
  }
}

class _TeamNewsHeader extends StatelessWidget {
  const _TeamNewsHeader({required this.selectedTeam, required this.onOpenTeam});

  final TeamModel selectedTeam;
  final VoidCallback onOpenTeam;

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.fromLTRB(16, 16, 16, 0),
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: const Color(0xFF243460),
        borderRadius: BorderRadius.circular(14),
      ),
      child: Row(
        children: [
          CircleAvatar(
            backgroundColor: const Color(0xFF1A2744),
            backgroundImage: selectedTeam.logoUrl != null
                ? NetworkImage(selectedTeam.logoUrl!)
                : null,
            child: selectedTeam.logoUrl == null
                ? const Icon(Icons.shield_rounded, color: Colors.white70)
                : null,
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'Notícias filtradas para seu clube',
                  style: TextStyle(
                    color: Color(0xFF8FA8FF),
                    fontSize: 12,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  selectedTeam.displayName,
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 16,
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ],
            ),
          ),
          TextButton(onPressed: onOpenTeam, child: const Text('Ver time')),
        ],
      ),
    );
  }
}

class _NewsList extends StatelessWidget {
  const _NewsList({
    required this.artigos,
    required this.emptyMessage,
    required this.onRefresh,
  });

  final List<Article> artigos;
  final String emptyMessage;
  final Future<void> Function() onRefresh;

  @override
  Widget build(BuildContext context) {
    return RefreshIndicator(
      onRefresh: onRefresh,
      color: const Color(0xFF3B5BDB),
      child: artigos.isEmpty
          ? ListView(
              physics: const AlwaysScrollableScrollPhysics(),
              padding: const EdgeInsets.fromLTRB(24, 56, 24, 24),
              children: [
                Text(
                  emptyMessage,
                  textAlign: TextAlign.center,
                  style: const TextStyle(color: Colors.white70),
                ),
              ],
            )
          : ListView.builder(
              physics: const AlwaysScrollableScrollPhysics(),
              padding: const EdgeInsets.all(16),
              itemCount: artigos.length,
              itemBuilder: (context, index) {
                final artigo = artigos[index];

                return GestureDetector(
                  onTap: () => context.pushNamed(
                    'newsDetail',
                    queryParameters: {'id': artigo.id},
                  ),
                  child: _NewsCard(artigo: artigo),
                );
              },
            ),
    );
  }
}

class _NewsCard extends StatelessWidget {
  const _NewsCard({required this.artigo});

  final Article artigo;

  String _formatarData(DateTime data) {
    final dia = data.day.toString().padLeft(2, '0');
    final mes = data.month.toString().padLeft(2, '0');
    return '$dia/$mes';
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      decoration: BoxDecoration(
        color: const Color(0xFF243460),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (artigo.urlImagem.isNotEmpty)
            ClipRRect(
              borderRadius: const BorderRadius.vertical(
                top: Radius.circular(12),
              ),
              child: Image.network(
                artigo.urlImagem,
                height: 170,
                width: double.infinity,
                fit: BoxFit.cover,
                errorBuilder: (context, error, stackTrace) =>
                    Container(height: 80, color: const Color(0xFF1A2744)),
              ),
            ),
          Padding(
            padding: const EdgeInsets.all(12),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Text(
                      artigo.fonte,
                      style: const TextStyle(
                        color: Color(0xFF3B5BDB),
                        fontSize: 11,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                    const Spacer(),
                    Text(
                      _formatarData(artigo.publicadoEm),
                      style: const TextStyle(
                        color: Color(0xFF8899CC),
                        fontSize: 11,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 6),
                Text(
                  artigo.titulo,
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 15,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                if (artigo.descricao.isNotEmpty) ...[
                  const SizedBox(height: 8),
                  Text(
                    artigo.descricao,
                    maxLines: 3,
                    overflow: TextOverflow.ellipsis,
                    style: const TextStyle(
                      color: Color(0xFFB7C2E1),
                      fontSize: 13,
                      height: 1.4,
                    ),
                  ),
                ],
              ],
            ),
          ),
        ],
      ),
    );
  }
}
