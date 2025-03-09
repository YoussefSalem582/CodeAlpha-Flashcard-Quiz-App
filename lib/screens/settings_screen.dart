import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/settings_provider.dart';

class SettingsScreen extends StatelessWidget {
  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Settings'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            const Text(
              'Settings',
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 20),
            Consumer<SettingsProvider>(
              builder: (context, settings, child) {
                return ListTile(
                  title: const Text('Option 1'),
                  trailing: Switch(
                    value: settings.option1,
                    onChanged: (bool value) {
                      settings.setOption1(value);
                    },
                  ),
                );
              },
            ),
            Consumer<SettingsProvider>(
              builder: (context, settings, child) {
                return ListTile(
                  title: const Text('Option 2'),
                  trailing: Switch(
                    value: settings.option2,
                    onChanged: (bool value) {
                      settings.setOption2(value);
                    },
                  ),
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}