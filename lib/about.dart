import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:package_info_plus/package_info_plus.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:save_the_world_flutter_app/widgets/comic_panel_dialog.dart';

enum ConfirmAGB { CANCEL, ACCEPT }

void showAppAboutDialog(BuildContext context) async {
  final packageInfo = await PackageInfo.fromPlatform();
  final String version = packageInfo.version;
  final String buildNumber = packageInfo.buildNumber;

  final TextStyle aboutTextStyle = const TextStyle(
    color: Colors.black87,
    fontSize: 14,
    fontWeight: FontWeight.bold,
    height: 1.5,
  );

  final TextStyle linkStyle = const TextStyle(
    color: Colors.blueAccent,
    fontWeight: FontWeight.w900,
    decoration: TextDecoration.underline,
  );

  void launchURL(String url) async {
    final Uri uri = Uri.parse(url);
    if (await canLaunchUrl(uri)) {
      await launchUrl(uri, mode: LaunchMode.externalApplication);
    }
  }

  context.showComicDialog(
    title: 'ÜBER DAS SPIEL',
    icon: Icons.info_outline,
    headerColor: Colors.blueAccent,
    content: SingleChildScrollView(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Image.asset('assets/icons/save_the_world.png', width: 80, height: 80),
          const SizedBox(height: 16),
          Text(
            'VERSION: $version ($buildNumber)',
            style: const TextStyle(fontWeight: FontWeight.w900, fontSize: 12, color: Colors.grey),
          ),
          const Divider(height: 32),
          RichText(
            textAlign: TextAlign.center,
            text: TextSpan(
              children: <TextSpan>[
                TextSpan(
                    style: aboutTextStyle,
                    text: 'Save the World ist ein Spiel entwickelt von Paradoxon '
                        'aka Matthias Lindner.\n\n'),
                TextSpan(
                  style: linkStyle,
                  text: 'UNTERSTÜTZE MICH AUF PATREON',
                  recognizer: TapGestureRecognizer()..onTap = () => launchURL('https://www.patreon.com/paradoxon'),
                ),
                TextSpan(
                  style: aboutTextStyle,
                  text: '\n\nFehler gefunden? ',
                ),
                TextSpan(
                  style: linkStyle,
                  text: 'GitHub Repo',
                  recognizer: TapGestureRecognizer()..onTap = () => launchURL('https://github.com/Paradoxianer/save_the_world'),
                ),
              ],
            ),
          ),
        ],
      ),
    ),
    actions: [
      TextButton(
        onPressed: () {
          showLicensePage(
            context: context,
            applicationIcon: Image.asset('assets/icons/save_the_world.png', width: 64, height: 64),
            applicationVersion: '$version ($buildNumber)',
            applicationLegalese: '© 2019-2026 Paradoxon',
          );
        },
        child: const Text('LIZENZEN ANZEIGEN', style: TextStyle(fontWeight: FontWeight.w900, color: Colors.grey)),
      ),
      const SizedBox(height: 8),
      ElevatedButton(
        onPressed: () => Navigator.pop(context),
        style: ElevatedButton.styleFrom(
          backgroundColor: Colors.blueAccent,
          foregroundColor: Colors.white,
          padding: const EdgeInsets.symmetric(vertical: 16),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
            side: const BorderSide(color: Colors.black, width: 2.5),
          ),
        ),
        child: const Text("ZURÜCK", style: TextStyle(fontWeight: FontWeight.w900)),
      ),
    ],
  );
}

Future<ConfirmAGB?> showDSGVODialog(BuildContext context) {
  void launchURL(String url) async {
    final Uri uri = Uri.parse(url);
    if (await canLaunchUrl(uri)) {
      await launchUrl(uri, mode: LaunchMode.externalApplication);
    }
  }

  final TextStyle aboutTextStyle = const TextStyle(
    color: Colors.black87,
    fontSize: 13,
    height: 1.5,
  );

  final TextStyle linkStyle = const TextStyle(
    color: Colors.blueAccent,
    fontWeight: FontWeight.bold,
    decoration: TextDecoration.underline,
  );

  return showDialog<ConfirmAGB>(
    context: context,
    barrierDismissible: false,
    builder: (BuildContext context) {
      return ComicPanelDialog(
        title: 'AGB & DATENSCHUTZ',
        icon: Icons.gavel,
        headerColor: Colors.blueGrey,
        content: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              RichText(
                text: TextSpan(
                  children: <TextSpan>[
                    TextSpan(
                      style: aboutTextStyle,
                      text: 'Wir die Appentwickler haben begründetes Interesse (s. Art. 6 Abs. 1 lit. f. DSGVO) Daten in Form von Screenshots der App zu erheben und innerhalb der App zu speichern. '
                          'Die App stellt diese dann, soweit es von Ihnen gewollt wird, über soziale Medien zur Verfügung. Dafür wird das interne Social Media Plugin (Android/iOS) benutzt.\n\n'
                          'Die Screenshots werden innerhalb der App solange gespeichert, bis sie geteilt wurden, und danach automatisch gelöscht. '
                          'Um Spielstände zu speichern, wird der Zugriff auf den App-internen Speicher benötigt. Sollten Sie das nicht wünschen, kontaktieren Sie uns bitte für eine alternative Version.\n\n'
                          'Sie können jederzeit widersprechen, allerdings ist die App dann technisch nicht mehr nutzbar.\n\n'
                          'Dass Sie diesen Text lesen müssen, verdanken Sie der DSGVO und dem Schutz Ihrer Privatsphäre.\n\n',
                    ),
                    TextSpan(
                      style: linkStyle,
                      text: 'KONTAKT ZUM ENTWICKLER',
                      recognizer: TapGestureRecognizer()..onTap = () => launchURL('https://github.com/Paradoxianer/save_the_world'),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
        actions: [
          ElevatedButton(
            onPressed: () => Navigator.of(context).pop(ConfirmAGB.ACCEPT),
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.green[700],
              foregroundColor: Colors.white,
              padding: const EdgeInsets.symmetric(vertical: 16),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(16),
                side: const BorderSide(color: Colors.black, width: 2.5),
              ),
            ),
            child: const Text("ICH STIMME ZU", style: TextStyle(fontWeight: FontWeight.w900)),
          ),
          const SizedBox(height: 12),
          TextButton(
            onPressed: () => Navigator.of(context).pop(ConfirmAGB.CANCEL),
            child: const Text(
              "ABBRECHEN", 
              style: TextStyle(color: Colors.grey, fontWeight: FontWeight.bold)
            ),
          ),
        ],
      );
    },
  );
}
