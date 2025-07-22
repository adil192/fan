import 'package:flutter/material.dart';
import 'package:material_symbols_icons/symbols.dart';
import 'package:url_launcher/url_launcher.dart';

class CreditsPage extends StatelessWidget {
  const CreditsPage({super.key});

  static final appUri = Uri.parse('https://github.com/adil192/fan');
  static final fanAnimationPackUri = Uri.parse(
    'https://www.gamedeveloperstudio.com/graphics/viewgraphic.php?item=146n4f419v416n8q83',
  );
  static final fanAudioUri = Uri.parse(
    'https://pixabay.com/sound-effects/fan-loop-75075/?utm_source=link-attribution&utm_medium=referral&utm_campaign=music&utm_content=75075',
  );

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Credits')),
      body: ListView(
        padding: const EdgeInsets.all(16.0),
        children: [
          const _CreditSectionTitle('App'),
          _CreditCard(
            icon: Icons.install_mobile,
            description: 'A free open-source fan noise simulator app',
            author: 'Adil Hanney',
            trailing: const Icon(Icons.open_in_new),
            onTap: () => launchUrl(appUri),
          ),
          const SizedBox(height: 16),

          const _CreditSectionTitle('Art'),
          _CreditCard(
            icon: Symbols.animated_images,
            description: 'Animated electric fans game asset pack',
            author: 'Robert Brooks (GameDeveloperStudio.com)',
            trailing: const Icon(Icons.open_in_new),
            onTap: () => launchUrl(fanAnimationPackUri),
          ),
          const SizedBox(height: 16),

          const _CreditSectionTitle('Audio'),
          _CreditCard(
            icon: Symbols.music_note,
            description: 'Fan loop sound effect',
            author: 'fedsmoker (Freesound)',
            trailing: const Icon(Icons.open_in_new),
            onTap: () => launchUrl(fanAudioUri),
          ),
          const SizedBox(height: 16),

          const _CreditSectionTitle('Other'),
          _CreditCard(
            icon: Symbols.contract,
            description: 'View all licenses',
            author:
                'Full license details including assets and open source packages',
            trailing: const Icon(Icons.arrow_forward),
            onTap: () => showLicensePage(context: context),
          ),
          const SizedBox(height: 16),
        ],
      ),
    );
  }
}

class _CreditSectionTitle extends StatelessWidget {
  const _CreditSectionTitle(this.title);

  final String title;

  @override
  Widget build(BuildContext context) {
    final textTheme = TextTheme.of(context);
    return Text(title, style: textTheme.headlineSmall);
  }
}

class _CreditCard extends StatelessWidget {
  const _CreditCard({
    required this.icon,
    required this.description,
    required this.author,
    this.trailing,
    this.onTap,
  });

  final IconData icon;
  final String description;
  final String? author;
  final Widget? trailing;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    final cardShape =
        Theme.of(context).cardTheme.shape ??
        RoundedRectangleBorder(borderRadius: BorderRadius.circular(12));
    return Card(
      shape: cardShape,
      child: ListTile(
        shape: cardShape,
        leading: Icon(icon),
        title: Text(description),
        subtitle: author != null ? Text(author!) : null,
        trailing: trailing,
        onTap: onTap,
      ),
    );
  }
}
