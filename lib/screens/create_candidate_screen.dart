import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../models/candidate.dart';

class CreateCandidateScreen extends StatefulWidget {
  const CreateCandidateScreen({super.key});

  @override
  State<CreateCandidateScreen> createState() =>
      _CreateCandidateScreenState();
}

class _CreateCandidateScreenState extends State<CreateCandidateScreen>
    with TickerProviderStateMixin {
  final _formKeyStep0 = GlobalKey<FormState>();
  final _formKeyStep1 = GlobalKey<FormState>();

  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _documentController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _courseController = TextEditingController();
  final TextEditingController _graduationYearController =
      TextEditingController();
  final TextEditingController _skillController = TextEditingController();

  bool _available = true;
  final List<String> _technicalSkills = [];
  int _currentStep = 0;

  late final AnimationController _fadeController;
  late final AnimationController _progressController;
  late final Animation<double> _fadeAnim;
  late final Animation<double> _progressAnim;

  @override
  void initState() {
    super.initState();

    _fadeController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 350),
    );
    _fadeAnim = CurvedAnimation(
      parent: _fadeController,
      curve: Curves.easeOut,
    );
    _fadeController.forward();

    _progressController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 500),
    );
    _progressAnim = Tween<double>(begin: 0, end: 1 / 3).animate(
      CurvedAnimation(parent: _progressController, curve: Curves.easeInOut),
    );
    _progressController.forward();
  }

  @override
  void dispose() {
    _nameController.dispose();
    _documentController.dispose();
    _emailController.dispose();
    _courseController.dispose();
    _graduationYearController.dispose();
    _skillController.dispose();
    _fadeController.dispose();
    _progressController.dispose();
    super.dispose();
  }

  // ──────────────────────────────────────────────
  // Navegação entre etapas
  // ──────────────────────────────────────────────

  void _goToStep(int step) {
    _fadeController.reset();
    _progressController.animateTo(
      (step + 1) / 3,
      duration: const Duration(milliseconds: 450),
      curve: Curves.easeInOut,
    );
    setState(() => _currentStep = step);
    _fadeController.forward();
  }

  void _nextStep() {
    if (_currentStep == 0 && !(_formKeyStep0.currentState?.validate() ?? false)) {
      return;
    }
    if (_currentStep == 1 && !(_formKeyStep1.currentState?.validate() ?? false)) {
      return;
    }
    if (_currentStep < 2) _goToStep(_currentStep + 1);
  }

  void _prevStep() {
    if (_currentStep > 0) _goToStep(_currentStep - 1);
  }

  // ──────────────────────────────────────────────
  // Habilidades
  // ──────────────────────────────────────────────

  void _addSkill() {
    final skill = _skillController.text.trim();
    if (skill.isEmpty) return;
    if (_technicalSkills.contains(skill)) {
      _showSnack('Habilidade já adicionada!', isError: true);
      return;
    }
    setState(() {
      _technicalSkills.add(skill);
      _skillController.clear();
    });
    HapticFeedback.lightImpact();
  }

  void _removeSkill(String skill) {
    setState(() => _technicalSkills.remove(skill));
    HapticFeedback.selectionClick();
  }

  // ──────────────────────────────────────────────
  // Salvar
  // ──────────────────────────────────────────────

  void _saveCandidate() {
    if (_technicalSkills.isEmpty) {
      _showSnack('Adicione pelo menos uma habilidade técnica.', isError: true);
      return;
    }

    final candidate = Candidate(
      name: _nameController.text.trim(),
      document: _documentController.text.trim(),
      email: _emailController.text.trim(),
      course: _courseController.text.trim(),
      graduationYear: int.parse(_graduationYearController.text.trim()),
      available: _available,
      technicalSkills: List.from(_technicalSkills),
      softSkills: ["Comunicação", "Trabalho em equipe", "Resolução de problemas"],
    );

    HapticFeedback.heavyImpact();
    _showSnack('Candidato cadastrado com sucesso! 🎉');
    Future.delayed(const Duration(milliseconds: 800), () {
      if (mounted) Navigator.pop(context, candidate);
    });
  }

  void _showSnack(String message, {bool isError = false}) {
    ScaffoldMessenger.of(context).clearSnackBars();
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Row(
          children: [
            Icon(
              isError ? Icons.error_outline : Icons.check_circle_outline,
              color: Colors.white,
              size: 18,
            ),
            const SizedBox(width: 8),
            Expanded(child: Text(message)),
          ],
        ),
        backgroundColor: isError ? const Color(0xFFE53935) : const Color(0xFF43A047),
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        margin: const EdgeInsets.all(16),
        duration: const Duration(seconds: 2),
      ),
    );
  }

  // ──────────────────────────────────────────────
  // Helpers de UI
  // ──────────────────────────────────────────────

  String _initials(String name) {
    final parts = name.trim().split(' ');
    if (parts.length >= 2) return '${parts[0][0]}${parts[1][0]}'.toUpperCase();
    if (name.isNotEmpty) return name[0].toUpperCase();
    return '?';
  }

  // ──────────────────────────────────────────────
  // Build
  // ──────────────────────────────────────────────

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return Scaffold(
      backgroundColor: const Color(0xFFF5F6FA),
      body:  Stack(
  children: [
    Positioned.fill(
      child: Image.asset(
        'assets/images/fundo.jpg',
        fit: BoxFit.cover,
      ),
    ),
      
      Column(
        children: [
          _buildHeader(colorScheme),
          _buildProgressBar(colorScheme),
          _buildStepTabs(colorScheme),
          Expanded(
            child: FadeTransition(
              opacity: _fadeAnim,
              child: SingleChildScrollView(
                padding: const EdgeInsets.fromLTRB(16, 12, 16, 24),
                child: _buildStepContent(colorScheme),
              ),
            ),
          ),
          _buildBottomBar(colorScheme),
        ],
      ),
  ],
      ),
    );
  }

  // ──────────────────────────────────────────────
  // Header com gradiente
  // ──────────────────────────────────────────────

  Widget _buildHeader(ColorScheme colorScheme) {
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
          padding: const EdgeInsets.fromLTRB(16, 8, 16, 20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              GestureDetector(
                onTap: () => Navigator.pop(context),
                child: const Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(Icons.arrow_back_ios, color: Colors.white70, size: 16),
                    Text(
                      'Voltar',
                      style: TextStyle(color: Colors.white70, fontSize: 13),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 10),
              const Row(
                children: [
                  Icon(Icons.description_rounded, color: Colors.white, size: 24),
                  SizedBox(width: 10),
                  Text(
                    'Criar Currículo',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 22,
                      fontWeight: FontWeight.w600,
                      letterSpacing: 0.3,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 4),
              const Text(
                'Preencha seus dados profissionais',
                style: TextStyle(color: Colors.white70, fontSize: 13),
              ),
            ],
          ),
        ),
      ),
    );
  }

  // ──────────────────────────────────────────────
  // Barra de progresso animada
  // ──────────────────────────────────────────────

  Widget _buildProgressBar(ColorScheme colorScheme) {
    return Container(
      color: Colors.white,
      padding: const EdgeInsets.fromLTRB(16, 12, 16, 8),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          AnimatedBuilder(
            animation: _progressAnim,
            builder: (_, __) => ClipRRect(
              borderRadius: BorderRadius.circular(4),
              child: LinearProgressIndicator(
                value: _progressAnim.value,
                backgroundColor: const Color(0xFFE8E8F0),
                valueColor: const AlwaysStoppedAnimation(Color(0xFF6C63FF)),
                minHeight: 6,
              ),
            ),
          ),
          const SizedBox(height: 6),
          Text(
            'Etapa ${_currentStep + 1} de 3 — ${_stepNames[_currentStep]}',
            style: TextStyle(
              fontSize: 11,
              color: Colors.grey[600],
              fontWeight: FontWeight.w500,
            ),
          ),
        ],
      ),
    );
  }

  static const _stepNames = ['Dados Pessoais', 'Formação Acadêmica', 'Habilidades'];
  static const _stepIcons = [Icons.person_outline, Icons.school_outlined, Icons.build_outlined];

  // ──────────────────────────────────────────────
  // Abas das etapas
  // ──────────────────────────────────────────────

  Widget _buildStepTabs(ColorScheme colorScheme) {
    return Container(
      color: Colors.white,
      padding: const EdgeInsets.fromLTRB(12, 0, 12, 12),
      child: Row(
        children: List.generate(3, (i) {
          final isActive = _currentStep == i;
          return Expanded(
            child: GestureDetector(
              onTap: () {
                if (i < _currentStep) _goToStep(i);
              },
              child: AnimatedContainer(
                duration: const Duration(milliseconds: 250),
                margin: const EdgeInsets.symmetric(horizontal: 4),
                padding: const EdgeInsets.symmetric(vertical: 7, horizontal: 6),
                decoration: BoxDecoration(
                  color: isActive
                      ? const Color(0xFFEDE7F6)
                      : Colors.transparent,
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(
                      _stepIcons[i],
                      size: 14,
                      color: isActive
                          ? const Color(0xFF6C63FF)
                          : Colors.grey[400],
                    ),
                    const SizedBox(width: 4),
                    Text(
                      _stepNames[i].split(' ').first,
                      style: TextStyle(
                        fontSize: 11,
                        fontWeight: isActive ? FontWeight.w600 : FontWeight.w400,
                        color: isActive
                            ? const Color(0xFF6C63FF)
                            : Colors.grey[400],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          );
        }),
      ),
    );
  }

  // ──────────────────────────────────────────────
  // Conteúdo por etapa
  // ──────────────────────────────────────────────

  Widget _buildStepContent(ColorScheme colorScheme) {
    switch (_currentStep) {
      case 0:
        return _buildStep0(colorScheme);
      case 1:
        return _buildStep1(colorScheme);
      default:
        return _buildStep2(colorScheme);
    }
  }

  // ── Etapa 0: Dados Pessoais ──────────────────

  Widget _buildStep0(ColorScheme colorScheme) {
    return Form(
      key: _formKeyStep0,
      child: Column(
        children: [
          _buildAvatarPreview(),
          const SizedBox(height: 16),
          _buildCard(
            title: 'Dados Pessoais',
            icon: Icons.person_outline,
            children: [
              _buildField(
                controller: _nameController,
                label: 'Nome Completo',
                icon: Icons.person_outline,
                hint: 'Ex: Pedro Silva',
                validator: (v) {
                  if (v == null || v.trim().isEmpty) return 'Informe o nome.';
                  if (v.trim().length < 3) return 'Nome muito curto.';
                  return null;
                },
                onChanged: (_) => setState(() {}),
              ),
              const SizedBox(height: 14),
              _buildField(
                controller: _documentController,
                label: 'CPF',
                icon: Icons.badge_outlined,
                hint: '000.000.000-00',
                keyboardType: TextInputType.number,
                validator: (v) {
                  if (v == null || v.trim().isEmpty) return 'Informe o CPF.';
                  if (v.trim().replaceAll(RegExp(r'\D'), '').length < 11) {
                    return 'CPF inválido.';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 14),
              _buildField(
                controller: _emailController,
                label: 'E-mail',
                icon: Icons.email_outlined,
                hint: 'seuemail@exemplo.com',
                keyboardType: TextInputType.emailAddress,
                validator: (v) {
                  if (v == null || v.trim().isEmpty) return 'Informe o e-mail.';
                  if (!v.contains('@') || !v.contains('.')) {
                    return 'E-mail inválido.';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16),
              _buildAvailableToggle(),
            ],
          ),
        ],
      ),
    );
  }

  // ── Etapa 1: Formação ────────────────────────

  Widget _buildStep1(ColorScheme colorScheme) {
    return Form(
      key: _formKeyStep1,
      child: Column(
        children: [
          _buildCard(
            title: 'Formação Acadêmica',
            icon: Icons.school_outlined,
            children: [
              _buildField(
                controller: _courseController,
                label: 'Curso',
                icon: Icons.menu_book_outlined,
                hint: 'Ex: Técnico em Informática para Internet',
                validator: (v) {
                  if (v == null || v.trim().isEmpty) return 'Informe o curso.';
                  return null;
                },
              ),
              const SizedBox(height: 14),
              _buildField(
                controller: _graduationYearController,
                label: 'Ano de Conclusão',
                icon: Icons.calendar_today_outlined,
                hint: 'Ex: 2026',
                keyboardType: TextInputType.number,
                suffixIcon: const Icon(
                  Icons.workspace_premium_outlined,
                  color: Color(0xFFFFB300),
                  size: 18,
                ),
                validator: (v) {
                  if (v == null || v.trim().isEmpty) return 'Informe o ano.';
                  final year = int.tryParse(v.trim());
                  if (year == null || year < 2000 || year > 2100) {
                    return 'Ano inválido.';
                  }
                  return null;
                },
              ),
            ],
          ),
          const SizedBox(height: 12),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
            decoration: BoxDecoration(
              color: const Color(0xFFF3FAF4),
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: const Color(0xFFC8E6C9)),
            ),
            child: const Row(
              children: [
                Icon(Icons.info_outline, color: Color(0xFF388E3C), size: 16),
                SizedBox(width: 8),
                Expanded(
                  child: Text(
                    'Seus dados de formação podem ser validados pela instituição de ensino.',
                    style: TextStyle(fontSize: 12, color: Color(0xFF388E3C)),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  // ── Etapa 2: Habilidades + Prévia ────────────

  Widget _buildStep2(ColorScheme colorScheme) {
    return Column(
      children: [
        _buildCard(
          title: 'Habilidades Técnicas',
          icon: Icons.build_outlined,
          children: [
            Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: _skillController,
                    onSubmitted: (_) => _addSkill(),
                    decoration: InputDecoration(
                      hintText: 'Ex: React, Flutter, SQL…',
                      hintStyle: const TextStyle(fontSize: 13, color: Color(0xFFBBBBBB)),
                      prefixIcon: const Icon(Icons.add_circle_outline,
                          color: Color(0xFF6C63FF), size: 18),
                      filled: true,
                      fillColor: const Color(0xFFF8F9FF),
                      contentPadding:
                          const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10),
                        borderSide: const BorderSide(color: Color(0xFFE0E3F0)),
                      ),
                      enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10),
                        borderSide: const BorderSide(color: Color(0xFFE0E3F0)),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10),
                        borderSide: const BorderSide(
                            color: Color(0xFF6C63FF), width: 1.5),
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: 8),
                _AddButton(onTap: _addSkill),
              ],
            ),
            const SizedBox(height: 6),
            Text(
              'Pressione Enter ou toque em + para adicionar',
              style: TextStyle(fontSize: 10, color: Colors.grey[400]),
            ),
            const SizedBox(height: 14),
            if (_technicalSkills.isEmpty)
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 12),
                child: Column(
                  children: [
                    Icon(Icons.construction_outlined,
                        size: 36, color: Colors.grey[300]),
                    const SizedBox(height: 6),
                    Text(
                      'Nenhuma habilidade adicionada ainda',
                      style: TextStyle(fontSize: 12, color: Colors.grey[400]),
                    ),
                  ],
                ),
              )
            else
              Wrap(
                spacing: 8,
                runSpacing: 8,
                children: _technicalSkills
                    .map((skill) => _SkillChip(
                          skill: skill,
                          onDelete: () => _removeSkill(skill),
                        ))
                    .toList(),
              ),
            if (_technicalSkills.isNotEmpty) ...[
              const SizedBox(height: 12),
              Container(
                padding:
                    const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                decoration: BoxDecoration(
                  color: const Color(0xFFF8F9FF),
                  borderRadius: BorderRadius.circular(8),
                  border: Border.all(color: const Color(0xFFE0E3F0)),
                ),
                child: Row(
                  children: [
                    const Icon(Icons.auto_awesome,
                        color: Color(0xFFFFB300), size: 14),
                    const SizedBox(width: 6),
                    Text(
                      '${_technicalSkills.length} habilidade${_technicalSkills.length != 1 ? 's' : ''} adicionada${_technicalSkills.length != 1 ? 's' : ''}',
                      style: const TextStyle(
                          fontSize: 12, color: Color(0xFF888888)),
                    ),
                  ],
                ),
              ),
            ],
          ],
        ),
        const SizedBox(height: 12),
        _buildPreviewCard(),
      ],
    );
  }

  // ──────────────────────────────────────────────
  // Widgets auxiliares
  // ──────────────────────────────────────────────

  Widget _buildAvatarPreview() {
    final name = _nameController.text.trim();
    final email = _emailController.text.trim();
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          colors: [Color(0xFFEDE7F6), Color(0xFFE8EAF6)],
        ),
        borderRadius: BorderRadius.circular(16),
      ),
      child: Row(
        children: [
          CircleAvatar(
            radius: 26,
            backgroundColor: const Color(0xFF6C63FF),
            child: Text(
              name.isEmpty ? '?' : _initials(name),
              style: const TextStyle(
                  color: Colors.white,
                  fontSize: 18,
                  fontWeight: FontWeight.w600),
            ),
          ),
          const SizedBox(width: 14),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  name.isEmpty ? 'Seu nome aqui' : name,
                  style: TextStyle(
                    fontSize: 15,
                    fontWeight: FontWeight.w600,
                    color:
                        name.isEmpty ? Colors.grey[400] : const Color(0xFF222222),
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  email.isEmpty ? 'seuemail@exemplo.com' : email,
                  style: TextStyle(
                    fontSize: 12,
                    color: email.isEmpty ? Colors.grey[400] : Colors.grey[600],
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildAvailableToggle() {
    return GestureDetector(
      onTap: () {
        HapticFeedback.selectionClick();
        setState(() => _available = !_available);
      },
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 250),
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
        decoration: BoxDecoration(
          color: _available
              ? const Color(0xFFF3FAF4)
              : const Color(0xFFFCEAEA),
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color: _available
                ? const Color(0xFFC8E6C9)
                : const Color(0xFFFFCDD2),
          ),
        ),
        child: Row(
          children: [
            Icon(
              _available ? Icons.check_circle_outline : Icons.cancel_outlined,
              color: _available
                  ? const Color(0xFF43A047)
                  : const Color(0xFFE53935),
              size: 22,
            ),
            const SizedBox(width: 10),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Disponível para contratação',
                    style: TextStyle(fontSize: 13, fontWeight: FontWeight.w500),
                  ),
                  Text(
                    _available ? 'Ativo — aparece nas buscas' : 'Inativo — oculto das buscas',
                    style: TextStyle(
                      fontSize: 11,
                      color: _available
                          ? const Color(0xFF43A047)
                          : const Color(0xFFE53935),
                    ),
                  ),
                ],
              ),
            ),
            _AnimatedToggle(value: _available),
          ],
        ),
      ),
    );
  }

  Widget _buildPreviewCard() {
    return _buildCard(
      title: 'Prévia do Currículo',
      icon: Icons.remove_red_eye_outlined,
      children: [
        Row(
          children: [
            CircleAvatar(
              radius: 20,
              backgroundColor: const Color(0xFF6C63FF),
              child: Text(
                _nameController.text.isEmpty ? '?' : _initials(_nameController.text),
                style: const TextStyle(color: Colors.white, fontSize: 14),
              ),
            ),
            const SizedBox(width: 10),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    _nameController.text.isEmpty
                        ? 'Nome não preenchido'
                        : _nameController.text,
                    style: const TextStyle(
                        fontSize: 13, fontWeight: FontWeight.w500),
                  ),
                  Text(
                    _emailController.text.isEmpty
                        ? 'email não preenchido'
                        : _emailController.text,
                    style: const TextStyle(
                        fontSize: 11, color: Color(0xFF888888)),
                  ),
                ],
              ),
            ),
            AnimatedContainer(
              duration: const Duration(milliseconds: 250),
              padding:
                  const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
              decoration: BoxDecoration(
                color: _available
                    ? const Color(0xFFE8F5E9)
                    : const Color(0xFFFCE4EC),
                borderRadius: BorderRadius.circular(20),
              ),
              child: Text(
                _available ? '✓ disponível' : '✗ indisponível',
                style: TextStyle(
                  fontSize: 10,
                  fontWeight: FontWeight.w500,
                  color: _available
                      ? const Color(0xFF388E3C)
                      : const Color(0xFFC62828),
                ),
              ),
            ),
          ],
        ),
        if (_courseController.text.isNotEmpty) ...[
          const SizedBox(height: 8),
          Row(
            children: [
              const Icon(Icons.school_outlined,
                  size: 13, color: Color(0xFF6C63FF)),
              const SizedBox(width: 5),
              Expanded(
                child: Text(
                  '${_courseController.text}${_graduationYearController.text.isNotEmpty ? ' · ${_graduationYearController.text}' : ''}',
                  style: const TextStyle(
                      fontSize: 11, color: Color(0xFF555555)),
                ),
              ),
            ],
          ),
        ],
        if (_technicalSkills.isNotEmpty) ...[
          const SizedBox(height: 10),
          Wrap(
            spacing: 6,
            runSpacing: 6,
            children: _technicalSkills
                .map((s) => Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 8, vertical: 3),
                      decoration: BoxDecoration(
                        color: const Color(0xFFEDE7F6),
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: Text(s,
                          style: const TextStyle(
                              fontSize: 10,
                              fontWeight: FontWeight.w500,
                              color: Color(0xFF534AB7))),
                    ))
                .toList(),
          ),
        ],
      ],
    );
  }

  Widget _buildCard({
    required String title,
    required IconData icon,
    required List<Widget> children,
  }) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: const Color(0xFFE8E8E8), width: 0.5),
      ),
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                width: 30,
                height: 30,
                decoration: BoxDecoration(
                  color: const Color(0xFFEDE7F6),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Icon(icon, color: const Color(0xFF6C63FF), size: 16),
              ),
              const SizedBox(width: 10),
              Text(
                title,
                style: const TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w600,
                  color: Color(0xFF3F51B5),
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          ...children,
        ],
      ),
    );
  }

  Widget _buildField({
    required TextEditingController controller,
    required String label,
    required IconData icon,
    required String hint,
    TextInputType keyboardType = TextInputType.text,
    String? Function(String?)? validator,
    ValueChanged<String>? onChanged,
    Widget? suffixIcon,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label.toUpperCase(),
          style: const TextStyle(
            fontSize: 10,
            fontWeight: FontWeight.w600,
            color: Color(0xFF999999),
            letterSpacing: 0.8,
          ),
        ),
        const SizedBox(height: 6),
        TextFormField(
          controller: controller,
          keyboardType: keyboardType,
          onChanged: onChanged,
          validator: validator,
          style: const TextStyle(fontSize: 14, color: Color(0xFF222222)),
          decoration: InputDecoration(
            hintText: hint,
            hintStyle: const TextStyle(
                fontSize: 13, color: Color(0xFFBBBBBB)),
            prefixIcon: Icon(icon, color: const Color(0xFF6C63FF), size: 18),
            suffixIcon: suffixIcon,
            filled: true,
            fillColor: const Color(0xFFF8F9FF),
            contentPadding:
                const EdgeInsets.symmetric(horizontal: 14, vertical: 13),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(10),
              borderSide: const BorderSide(color: Color(0xFFE0E3F0)),
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(10),
              borderSide: const BorderSide(color: Color(0xFFE0E3F0)),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(10),
              borderSide:
                  const BorderSide(color: Color(0xFF6C63FF), width: 1.5),
            ),
            errorBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(10),
              borderSide: const BorderSide(color: Color(0xFFE53935)),
            ),
            focusedErrorBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(10),
              borderSide:
                  const BorderSide(color: Color(0xFFE53935), width: 1.5),
            ),
          ),
        ),
      ],
    );
  }

  // ──────────────────────────────────────────────
  // Barra inferior de navegação
  // ──────────────────────────────────────────────

  Widget _buildBottomBar(ColorScheme colorScheme) {
    return Container(
      color: Colors.white,
      padding:
          EdgeInsets.fromLTRB(16, 12, 16, MediaQuery.of(context).padding.bottom + 12),
      child: Row(
        children: [
          if (_currentStep > 0)
            Expanded(
              flex: 2,
              child: OutlinedButton.icon(
                onPressed: _prevStep,
                icon: const Icon(Icons.arrow_back_ios, size: 14),
                label: const Text('Voltar'),
                style: OutlinedButton.styleFrom(
                  foregroundColor: const Color(0xFF6C63FF),
                  side: const BorderSide(color: Color(0xFF6C63FF)),
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12)),
                  padding: const EdgeInsets.symmetric(vertical: 14),
                ),
              ),
            ),
          if (_currentStep > 0) const SizedBox(width: 12),
          Expanded(
            flex: 3,
            child: _currentStep < 2
                ? _GradientButton(
                    label: 'Próximo',
                    icon: Icons.arrow_forward_ios,
                    onTap: _nextStep,
                  )
                : _GradientButton(
                    label: 'Cadastrar',
                    icon: Icons.save_outlined,
                    onTap: _saveCandidate,
                  ),
          ),
        ],
      ),
    );
  }
}

// ──────────────────────────────────────────────────────────────────────────────
// Widgets isolados
// ──────────────────────────────────────────────────────────────────────────────

class _GradientButton extends StatefulWidget {
  final String label;
  final IconData icon;
  final VoidCallback onTap;

  const _GradientButton({
    required this.label,
    required this.icon,
    required this.onTap,
  });

  @override
  State<_GradientButton> createState() => _GradientButtonState();
}

class _GradientButtonState extends State<_GradientButton> {
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
        scale: _pressed ? 0.97 : 1.0,
        duration: const Duration(milliseconds: 100),
        child: Container(
          padding: const EdgeInsets.symmetric(vertical: 14),
          decoration: BoxDecoration(
            gradient: const LinearGradient(
              colors: [Color(0xFF6C63FF), Color(0xFF3F51B5)],
            ),
            borderRadius: BorderRadius.circular(12),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(widget.icon, color: Colors.white, size: 18),
              const SizedBox(width: 8),
              Text(
                widget.label,
                style: const TextStyle(
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

class _AddButton extends StatefulWidget {
  final VoidCallback onTap;
  const _AddButton({required this.onTap});

  @override
  State<_AddButton> createState() => _AddButtonState();
}

class _AddButtonState extends State<_AddButton>
    with SingleTickerProviderStateMixin {
  late final AnimationController _ctrl;
  late final Animation<double> _scaleAnim;

  @override
  void initState() {
    super.initState();
    _ctrl = AnimationController(
        vsync: this, duration: const Duration(milliseconds: 120));
    _scaleAnim = Tween<double>(begin: 1.0, end: 0.88)
        .animate(CurvedAnimation(parent: _ctrl, curve: Curves.easeIn));
  }

  @override
  void dispose() {
    _ctrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTapDown: (_) => _ctrl.forward(),
      onTapUp: (_) {
        _ctrl.reverse();
        widget.onTap();
      },
      onTapCancel: () => _ctrl.reverse(),
      child: ScaleTransition(
        scale: _scaleAnim,
        child: Container(
          width: 42,
          height: 42,
          decoration: BoxDecoration(
            color: const Color(0xFF6C63FF),
            borderRadius: BorderRadius.circular(12),
          ),
          child: const Icon(Icons.add, color: Colors.white, size: 22),
        ),
      ),
    );
  }
}

class _SkillChip extends StatefulWidget {
  final String skill;
  final VoidCallback onDelete;
  const _SkillChip({required this.skill, required this.onDelete});

  @override
  State<_SkillChip> createState() => _SkillChipState();
}

class _SkillChipState extends State<_SkillChip>
    with SingleTickerProviderStateMixin {
  late final AnimationController _ctrl;
  late final Animation<double> _anim;

  @override
  void initState() {
    super.initState();
    _ctrl = AnimationController(
        vsync: this, duration: const Duration(milliseconds: 250));
    _anim = CurvedAnimation(parent: _ctrl, curve: Curves.elasticOut);
    _ctrl.forward();
  }

  @override
  void dispose() {
    _ctrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return ScaleTransition(
      scale: _anim,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
        decoration: BoxDecoration(
          color: const Color(0xFFEDE7F6),
          borderRadius: BorderRadius.circular(20),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              widget.skill,
              style: const TextStyle(
                fontSize: 12,
                fontWeight: FontWeight.w500,
                color: Color(0xFF534AB7),
              ),
            ),
            const SizedBox(width: 5),
            GestureDetector(
              onTap: widget.onDelete,
              child: Container(
                width: 16,
                height: 16,
                decoration: const BoxDecoration(
                  color: Color(0xFFB39DDB),
                  shape: BoxShape.circle,
                ),
                child: const Icon(Icons.close,
                    size: 10, color: Colors.white),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _AnimatedToggle extends StatelessWidget {
  final bool value;
  const _AnimatedToggle({required this.value});

  @override
  Widget build(BuildContext context) {
    return AnimatedContainer(
      duration: const Duration(milliseconds: 280),
      width: 44,
      height: 24,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(12),
        color: value ? const Color(0xFF43A047) : const Color(0xFFCCCCCC),
      ),
      child: AnimatedAlign(
        duration: const Duration(milliseconds: 280),
        curve: Curves.easeInOut,
        alignment: value ? Alignment.centerRight : Alignment.centerLeft,
        child: Container(
          width: 20,
          height: 20,
          margin: const EdgeInsets.symmetric(horizontal: 2),
          decoration: const BoxDecoration(
            color: Colors.white,
            shape: BoxShape.circle,
            boxShadow: [BoxShadow(color: Colors.black26, blurRadius: 3)],
          ),
        ),
      ),
    );
  }
}