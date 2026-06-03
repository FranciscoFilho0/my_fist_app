import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:go_router/go_router.dart';

import '../models/candidate.dart';
import '../routes/app_routes.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> with TickerProviderStateMixin {
  List<Candidate> _all = Candidate.candidates();
  String _filter = 'todos';

  late final AnimationController _headerAnim;
  late final Animation<double> _headerFade;

  @override
  void initState() {
    super.initState();
    _headerAnim = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 500),
    )..forward();
    _headerFade = CurvedAnimation(parent: _headerAnim, curve: Curves.easeOut);
  }

  @override
  void dispose() {
    _headerAnim.dispose();
    super.dispose();
  }

  // ── Filtro ───────────────────────────────────

  List<Candidate> get _filtered {
    if (_filter == 'disponivel') return _all.where((c) => c.available).toList();
    if (_filter == 'indisponivel') return _all.where((c) => !c.available).toList();
    return _all;
  }

  void _setFilter(String f) {
    HapticFeedback.selectionClick();
    setState(() => _filter = f);
  }

  // ── Recebe novo candidato ────────────────────

  Future<void> _openCreate() async {
    final result = await context.push<Candidate>(AppRoutes.createCandidate);
    if (result != null) {
      setState(() => _all = [..._all, result]);
      _showSnack('${result.name} adicionado com sucesso!');
    }
  }

  void _showSnack(String msg) {
    ScaffoldMessenger.of(context).clearSnackBars();
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Row(
          children: [
            const Icon(Icons.check_circle_outline, color: Colors.white, size: 18),
            const SizedBox(width: 8),
            Expanded(child: Text(msg)),
          ],
        ),
        backgroundColor: const Color(0xFF43A047),
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        margin: const EdgeInsets.all(16),
        duration: const Duration(seconds: 2),
      ),
    );
  }

  // ── Helpers ──────────────────────────────────

  String _initials(String name) {
    final parts = name.trim().split(' ');
    if (parts.length >= 2) return '${parts[0][0]}${parts[1][0]}'.toUpperCase();
    return name.isNotEmpty ? name[0].toUpperCase() : '?';
  }

  static const _avatarColors = [
    Color(0xFF6C63FF), Color(0xFF3F51B5), Color(0xFFE91E63),
    Color(0xFF009688), Color(0xFFFF5722), Color(0xFF795548),
    Color(0xFF607D8B),
  ];

  Color _avatarColor(int index) => _avatarColors[index % _avatarColors.length];

  // ── Build ────────────────────────────────────

  @override
  Widget build(BuildContext context) {
    final list = _filtered;

    return Scaffold(
      backgroundColor: const Color(0xFFF5F6FA),


      body: Stack(
  children: [
    Positioned.fill(
      child: Image.asset(
        'assets/images/fundo.jpg',
        fit: BoxFit.cover,
      ),
    ),
      
       Column(
        children: [
          FadeTransition(
            opacity: _headerFade,
            child: _buildHeader(),
          ),
          _buildStatsRow(),
          _buildSearchBar(),
          _buildFilterRow(),
          Padding(
            padding: const EdgeInsets.fromLTRB(14, 10, 14, 4),
            child: Align(
              alignment: Alignment.centerLeft,
              child: Text(
                '${list.length} candidato${list.length != 1 ? 's' : ''}',
                style: const TextStyle(
                  fontSize: 10,
                  fontWeight: FontWeight.w600,
                  color: Color.fromARGB(255, 255, 255, 255),
                  letterSpacing: 0.8,
                  backgroundColor: Color(0xFF6C63FF),
                  textBaseline: TextBaseline.alphabetic,
                ),
              ),
            ),
          ),
          Expanded(
            child: list.isEmpty
                ? _buildEmptyState()
                : ListView.builder(
                    padding: const EdgeInsets.fromLTRB(12, 0, 12, 100),
                    itemCount: list.length,
                    itemBuilder: (context, index) =>
                        _CandidateCard(
                          candidate: list[index],
                          color: _avatarColor(index),
                          initials: _initials(list[index].name),
                          animationDelay: Duration(milliseconds: index * 60),
                        ),
                  ),
          ),
        ],
      ),
  ],
      ),
      floatingActionButton: _GradientFAB(onTap: _openCreate),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
    );
  }

  // ── Header ───────────────────────────────────

  Widget _buildHeader() {
    return Container(
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          colors: [Color(0xFF6C63FF), Color(0xFF3F51B5)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
      ),
      child: SafeArea(
        bottom: false,
        child: Padding(
          padding: const EdgeInsets.fromLTRB(16, 10, 16, 18),
          child: Row(
            children: [
              const Icon(Icons.people_alt_outlined,
                  color: Colors.white, size: 26),
              const SizedBox(width: 10),
              const Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Candidatos',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 22,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  Text(
                    'Banco de talentos',
                    style: TextStyle(color: Colors.white70, fontSize: 12),
                  ),
                ],
              ),
              const Spacer(),
              Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: Colors.white.withOpacity(0.15),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: const Icon(Icons.notifications_outlined,
                    color: Colors.white, size: 20),
              ),
            ],
          ),
        ),
      ),
    );
  }

  // ── Stats ────────────────────────────────────

  Widget _buildStatsRow() {
    final available = _all.where((c) => c.available).length;
    final skillsCount =
        _all.expand((c) => c.technicalSkills).toSet().length;

    return Padding(
      padding: const EdgeInsets.fromLTRB(12, 12, 12, 0),
      child: Row(
        children: [
          _StatPill(
            value: '${_all.length}',
            label: 'total',
            valueColor: const Color(0xFF6C63FF),
          ),
          const SizedBox(width: 8),
          _StatPill(
            value: '$available',
            label: 'disponíveis',
            valueColor: const Color(0xFF43A047),
          ),
          const SizedBox(width: 8),
          _StatPill(
            value: '$skillsCount',
            label: 'habilidades',
            valueColor: const Color(0xFFFB8C00),
          ),
        ],
      ),
    );
  }

  // ── Search bar (visual) ───────────────────────

  Widget _buildSearchBar() {
    return Container(
      margin: const EdgeInsets.fromLTRB(12, 10, 12, 0),
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 11),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: const Color(0xFFE0E3F0), width: 1.5),
      ),
      child: Row(
        children: [
          const Icon(Icons.search, color: Color(0xFFAAAAAA), size: 18),
          const SizedBox(width: 8),
          Text(
            'Buscar candidato...',
            style: TextStyle(fontSize: 13, color: Colors.grey[400]),
          ),
        ],
      ),
    );
  }

  // ── Filtros ───────────────────────────────────

  Widget _buildFilterRow() {
    const filters = [
      ('todos', 'Todos'),
      ('disponivel', 'Disponíveis'),
      ('indisponivel', 'Indisponíveis'),
    ];
    return SizedBox(
      height: 42,
      child: ListView(
        scrollDirection: Axis.horizontal,
        padding: const EdgeInsets.fromLTRB(12, 8, 12, 0),
        children: filters.map((f) {
          final active = _filter == f.$1;
          return GestureDetector(
            onTap: () => _setFilter(f.$1),
            child: AnimatedContainer(
              duration: const Duration(milliseconds: 220),
              margin: const EdgeInsets.only(right: 8),
              padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 5),
              decoration: BoxDecoration(
                color: active ? const Color(0xFF6C63FF) : Colors.white,
                borderRadius: BorderRadius.circular(20),
                border: Border.all(
                  color: active
                      ? const Color(0xFF6C63FF)
                      : const Color(0xFFE0E3F0),
                ),
              ),
              child: Text(
                f.$2,
                style: TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.w500,
                  color: active ? Colors.white : const Color(0xFF888888),
                ),
              ),
            ),
          );
        }).toList(),
      ),
    );
  }

  // ── Empty state ───────────────────────────────

  Widget _buildEmptyState() {
    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(Icons.people_outline, size: 56, color: Colors.grey[300]),
          const SizedBox(height: 12),
          Text(
            'Nenhum candidato neste filtro',
            style: TextStyle(fontSize: 14, color: Colors.grey[400]),
          ),
        ],
      ),
    );
  }
}

// ──────────────────────────────────────────────────────────────────────────────
// Widget: card de candidato com animação de entrada
// ──────────────────────────────────────────────────────────────────────────────

class _CandidateCard extends StatefulWidget {
  final Candidate candidate;
  final Color color;
  final String initials;
  final Duration animationDelay;

  const _CandidateCard({
    required this.candidate,
    required this.color,
    required this.initials,
    required this.animationDelay,
  });

  @override
  State<_CandidateCard> createState() => _CandidateCardState();
}

class _CandidateCardState extends State<_CandidateCard>
    with SingleTickerProviderStateMixin {
  late final AnimationController _ctrl;
  late final Animation<double> _fadeAnim;
  late final Animation<Offset> _slideAnim;

  @override
  void initState() {
    super.initState();
    _ctrl = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 350),
    );
    _fadeAnim = CurvedAnimation(parent: _ctrl, curve: Curves.easeOut);
    _slideAnim = Tween<Offset>(
      begin: const Offset(0, 0.15),
      end: Offset.zero,
    ).animate(CurvedAnimation(parent: _ctrl, curve: Curves.easeOut));

    Future.delayed(widget.animationDelay, () {
      if (mounted) _ctrl.forward();
    });
  }

  @override
  void dispose() {
    _ctrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final c = widget.candidate;
    final visibleSkills = c.technicalSkills.take(5).toList();
    final extra = c.technicalSkills.length - 5;

    return FadeTransition(
      opacity: _fadeAnim,
      child: SlideTransition(
        position: _slideAnim,
        child: Container(
          margin: const EdgeInsets.only(bottom: 10),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(16),
            border: Border.all(
              color: const Color(0xFFE8E8F0),
              width: 0.5,
            ),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // ── topo ──────────────────────────
              Padding(
                padding: const EdgeInsets.fromLTRB(14, 14, 14, 0),
                child: Row(
                  children: [
                    CircleAvatar(
                      radius: 22,
                      backgroundColor: widget.color,
                      child: Text(
                        widget.initials,
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            c.name,
                            style: const TextStyle(
                              fontSize: 14,
                              fontWeight: FontWeight.w600,
                              color: Color(0xFF222222),
                            ),
                          ),
                          const SizedBox(height: 1),
                          Text(
                            c.email,
                            style: const TextStyle(
                              fontSize: 11,
                              color: Color(0xFF999999),
                            ),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(width: 8),
                    _AvailBadge(available: c.available),
                  ],
                ),
              ),

              // ── curso + ano ───────────────────
              Padding(
                padding: const EdgeInsets.fromLTRB(14, 8, 14, 0),
                child: Row(
                  children: [
                    const Icon(Icons.school_outlined,
                        size: 13, color: Color(0xFF6C63FF)),
                    const SizedBox(width: 5),
                    Expanded(
                      child: Text(
                        c.course,
                        style: const TextStyle(
                          fontSize: 11,
                          color: Color(0xFF777777),
                        ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                    const SizedBox(width: 6),
                    Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 7, vertical: 2),
                      decoration: BoxDecoration(
                        color: const Color(0xFFF8F9FF),
                        borderRadius: BorderRadius.circular(8),
                        border: Border.all(color: const Color(0xFFE0E3F0)),
                      ),
                      child: Text(
                        '${c.graduationYear}',
                        style: const TextStyle(
                          fontSize: 10,
                          fontWeight: FontWeight.w500,
                          color: Color(0xFF6C63FF),
                        ),
                      ),
                    ),
                  ],
                ),
              ),

              // ── divisor ───────────────────────
              const Padding(
                padding: EdgeInsets.symmetric(horizontal: 14, vertical: 10),
                child: Divider(height: 1, color: Color(0xFFF0F0F5)),
              ),

              // ── habilidades ───────────────────
              Padding(
                padding: const EdgeInsets.fromLTRB(14, 0, 14, 14),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'HABILIDADES TÉCNICAS',
                      style: TextStyle(
                        fontSize: 10,
                        fontWeight: FontWeight.w600,
                        color: Color(0xFFBBBBBB),
                        letterSpacing: 0.6,
                      ),
                    ),
                    const SizedBox(height: 7),
                    Wrap(
                      spacing: 5,
                      runSpacing: 5,
                      children: [
                        ...visibleSkills.map(
                          (s) => Container(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 9, vertical: 3),
                            decoration: BoxDecoration(
                              color: const Color(0xFFEDE7F6),
                              borderRadius: BorderRadius.circular(20),
                            ),
                            child: Text(
                              s,
                              style: const TextStyle(
                                fontSize: 10,
                                fontWeight: FontWeight.w500,
                                color: Color(0xFF534AB7),
                              ),
                            ),
                          ),
                        ),
                        if (extra > 0)
                          Container(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 9, vertical: 3),
                            decoration: BoxDecoration(
                              color: const Color(0xFFF1F1F1),
                              borderRadius: BorderRadius.circular(20),
                            ),
                            child: Text(
                              '+$extra',
                              style: const TextStyle(
                                fontSize: 10,
                                fontWeight: FontWeight.w500,
                                color: Color(0xFF999999),
                              ),
                            ),
                          ),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

// ──────────────────────────────────────────────────────────────────────────────
// Widget: badge disponível / indisponível animado
// ──────────────────────────────────────────────────────────────────────────────

class _AvailBadge extends StatelessWidget {
  final bool available;
  const _AvailBadge({required this.available});

  @override
  Widget build(BuildContext context) {
    return AnimatedContainer(
      duration: const Duration(milliseconds: 300),
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
      decoration: BoxDecoration(
        color: available
            ? const Color(0xFFE8F5E9)
            : const Color(0xFFFCE4EC),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            available ? Icons.check_circle_outline : Icons.cancel_outlined,
            size: 11,
            color: available
                ? const Color(0xFF2E7D32)
                : const Color(0xFFB71C1C),
          ),
          const SizedBox(width: 3),
          Text(
            available ? 'disponível' : 'indisponível',
            style: TextStyle(
              fontSize: 10,
              fontWeight: FontWeight.w500,
              color: available
                  ? const Color(0xFF2E7D32)
                  : const Color(0xFFB71C1C),
            ),
          ),
        ],
      ),
    );
  }
}

// ──────────────────────────────────────────────────────────────────────────────
// Widget: card de estatística
// ──────────────────────────────────────────────────────────────────────────────

class _StatPill extends StatelessWidget {
  final String value;
  final String label;
  final Color valueColor;

  const _StatPill({
    required this.value,
    required this.label,
    required this.valueColor,
  });

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 10),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
              color: const Color(0xFFE8E8F0), width: 0.5),
        ),
        child: Column(
          children: [
            Text(
              value,
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.w600,
                color: valueColor,
              ),
            ),
            const SizedBox(height: 1),
            Text(
              label,
              style: const TextStyle(
                fontSize: 10,
                color: Color(0xFFAAAAAA),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// ──────────────────────────────────────────────────────────────────────────────
// Widget: FAB com gradiente
// ──────────────────────────────────────────────────────────────────────────────

class _GradientFAB extends StatefulWidget {
  final VoidCallback onTap;
  const _GradientFAB({required this.onTap});

  @override
  State<_GradientFAB> createState() => _GradientFABState();
}

class _GradientFABState extends State<_GradientFAB> {
  bool _pressed = false;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTapDown: (_) => setState(() => _pressed = true),
      onTapUp: (_) {
        setState(() => _pressed = false);
        widget.onTap();
      },
      onTapCancel: () => setState(() => _pressed = false),
      child: AnimatedScale(
        scale: _pressed ? 0.95 : 1.0,
        duration: const Duration(milliseconds: 100),
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 14),
          decoration: BoxDecoration(
            gradient: const LinearGradient(
              colors: [Color(0xFF6C63FF), Color(0xFF3F51B5)],
            ),
            borderRadius: BorderRadius.circular(16),
            boxShadow: [
              BoxShadow(
                color: const Color(0xFF6C63FF).withOpacity(0.35),
                blurRadius: 12,
                offset: const Offset(0, 4),
              ),
            ],
          ),
          child: const Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(Icons.person_add_outlined, color: Colors.white, size: 20),
              SizedBox(width: 8),
              Text(
                'Novo candidato',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 15,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}