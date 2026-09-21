import 'package:flutter/material.dart';

import '../../app_theme.dart';
import '../../client.dart';
import '../../common/navigation.dart';
import '../../common/widgets.dart';

class JoinGroupScreen extends StatefulWidget {
  const JoinGroupScreen({super.key});

  @override
  State<JoinGroupScreen> createState() => _JoinGroupScreenState();
}

class _JoinGroupScreenState extends State<JoinGroupScreen> {
  final _codeController = TextEditingController();
  bool _loading = false;
  String? _error;

  @override
  void dispose() {
    _codeController.dispose();
    super.dispose();
  }

  Future<void> _submit() async {
    if (_loading) return;
    final code = _codeController.text.trim();
    setState(() {
      _loading = true;
      _error = null;
    });
    try {
      await client.group.joinGroup(code);
      if (mounted) enterHome(context);
    } catch (e) {
      setState(() => _error = 'No se encontró ningún grupo con ese código.');
    } finally {
      if (mounted) setState(() => _loading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return SimpleFormPage(
      title: 'Únete a tu gente',
      subtitle: 'Introduce el código que te han compartido.',
      art: const RoundIcon(icon: Icons.groups_rounded, color: AppColors.sky),
      children: [
        TextField(
          controller: _codeController,
          textAlign: TextAlign.center,
          textCapitalization: TextCapitalization.characters,
          onSubmitted: (_) => _submit(),
          style: const TextStyle(
            fontSize: 25,
            fontWeight: FontWeight.w900,
            letterSpacing: 3,
          ),
          decoration: const InputDecoration(hintText: 'NIDO-482'),
        ),
        const SizedBox(height: 8),
        const Text(
          'El código no distingue mayúsculas',
          textAlign: TextAlign.center,
          style: TextStyle(color: AppColors.muted),
        ),
        if (_error != null) ...[
          const SizedBox(height: 12),
          Text(
            _error!,
            textAlign: TextAlign.center,
            style: const TextStyle(color: AppColors.coral),
          ),
        ],
        const SizedBox(height: 20),
        FilledButton(
          onPressed: _loading ? null : _submit,
          child: _loading
              ? const SizedBox(
                  height: 20,
                  width: 20,
                  child: CircularProgressIndicator(
                    strokeWidth: 2,
                    color: Colors.white,
                  ),
                )
              : const Text('Entrar al grupo'),
        ),
      ],
    );
  }
}
