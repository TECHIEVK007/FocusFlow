import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:focus_flow/core/theme/app_theme.dart';
import 'package:focus_flow/core/utils/app_settings.dart';

class SettingsScreen extends ConsumerStatefulWidget {
  const SettingsScreen({super.key});

  @override
  ConsumerState<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends ConsumerState<SettingsScreen> {
  String _themeMode = 'system';
  bool _biometricsEnabled = false;

  @override
  void initState() {
    super.initState();
    _loadSettings();
  }

  Future<void> _loadSettings() async {
    final theme = await AppSettings.getTheme();
    final biometrics = await AppSettings.getBiometrics();
    setState(() {
      _themeMode = theme;
      _biometricsEnabled = biometrics;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Settings')),
      body: ListView(
        padding: const EdgeInsets.all(24),
        children: [
          _buildSectionTitle('Appearance'),
          ListTile(
            title: const Text('Theme'),
            trailing: DropdownButton<String>(
              value: _themeMode,
              items: ['system', 'light', 'dark'].map((s) => DropdownMenuItem(value: s, child: Text(s))).toList(),
              onChanged: (val) async {
                setState(() => _themeMode = val!);
                await AppSettings.setTheme(val!);
              },
            ),
          ),
          const SizedBox(height: 24),
          _buildSectionTitle('Security'),
          SwitchListTile(
            title: const Text('Biometric Lock'),
            subtitle: const Text('Use fingerprint/face ID to unlock'),
            value: _biometricsEnabled,
            onChanged: (val) async {
              setState(() => _biometricsEnabled = val);
              await AppSettings.setBiometrics(val);
            },
          ),
          const SizedBox(height: 24),
          _buildSectionTitle('About'),
          ListTile(
            title: const Text('FocusFlow Version'),
            trailing: const Text('1.0.0'),
          ),
          ListTile(
            title: const Text('Clear All Data'),
            trailing: const Icon(Icons.delete, color: Colors.red),
            onTap: () => _confirmClearData(context),
          ),
        ],
      ),
    );
  }

  Widget _buildSectionTitle(String title) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Text(title, style: Theme.of(context).textTheme.titleMedium?.copyWith(color: AppColors.darkPrimary)),
    );
  }

  void _confirmClearData(BuildContext context) {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Clear Data?'),
        content: const Text('This will permanently delete all your tasks, notes, and goals.'),
        actions: [
          TextButton(onPressed: () => Navigator.pop(ctx), child: const Text('Cancel')),
          TextButton(onPressed: () => Navigator.pop(ctx), child: const Text('Delete', style: TextStyle(color: Colors.red))),
        ],
      ),
    );
  }
}
