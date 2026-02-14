// Copyright 2018 The Chromium Authors. All rights reserved.
// Use of this source code is governed by a BSD-style license that can be
// found in the LICENSE file.

import 'package:flutter/foundation.dart' show defaultTargetPlatform;
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

enum ConfirmAGB { CANCEL, ACCEPT }

class _LinkTextSpan extends TextSpan {
  _LinkTextSpan({TextStyle? style, required String url, String? text})
      : super(
            style: style,
            text: text ?? url,
            recognizer: TapGestureRecognizer()
              ..onTap = () async {
                final Uri uri = Uri.parse(url);
                if (await canLaunchUrl(uri)) {
                  await launchUrl(uri, mode: LaunchMode.externalApplication);
                }
              });
}

void showAppAboutDialog(BuildContext context) {
  final ThemeData themeData = Theme.of(context);
  final TextStyle? aboutTextStyle = themeData.textTheme.bodyMedium;
  final TextStyle? linkStyle =
      themeData.textTheme.bodyMedium?.copyWith(color: themeData.colorScheme.secondary);

  showAboutDialog(
    context: context,
    applicationVersion: 'Februar 2026',
    applicationIcon:
        Image.asset('assets/icons/save_the_world.png', width: 64, height: 64),
    applicationLegalese: '© 2019-2026 Paradoxon',
    children: <Widget>[
      Padding(
        padding: const EdgeInsets.only(top: 24.0),
        child: RichText(
          text: TextSpan(
            children: <TextSpan>[
              TextSpan(
                  style: aboutTextStyle,
                  text: 'Save the World ist ein Spiel entwickelt von Paradoxon '
                      'aka Matthias Lindner.\n'),
              TextSpan(
                  style: aboutTextStyle,
                  text: 'Das Spiel ist erhältlich für '
                      '${defaultTargetPlatform == TargetPlatform.iOS ? 'multiple platforms' : 'iOS and Android'} '
                      ''),
              _LinkTextSpan(
                text: 'Bitte unterstützt mich und die Heilsarmee.',
                style: linkStyle,
                url: 'https://www.patreon.com/paradoxon',
              ),
              TextSpan(
                style: aboutTextStyle,
                text: '\n\nFalls ihr Fehler findet, dann meldet sie bitte hier: ',
              ),
              _LinkTextSpan(
                style: linkStyle,
                url: 'https://github.com/Paradoxianer/save_the_world',
                text: 'save_the_world repo',
              ),
              TextSpan(
                  style: aboutTextStyle,
                  text: '\n\nDank geht an die vielen Unterstützer'
                      ' \n\t- Johannes Walz\n\t- Johannes Ebeling\n\t- Anni Lindner'
                      '\n\nund die Entwickler der flutterplugins'
                      ''),
              _LinkTextSpan(
                  style: linkStyle,
                  url: 'https://pub.dev/packages/cupertino_icons',
                  text: '\n\t- cupertino_icons'),
              _LinkTextSpan(
                  style: linkStyle,
                  url: 'https://pub.dev/packages/url_launcher',
                  text: '\n\t- url_launcher'),
              _LinkTextSpan(
                  style: linkStyle,
                  url: 'https://pub.dev/packages/path_provider',
                  text: '\n\t- path_provider'),
              _LinkTextSpan(
                  style: linkStyle,
                  url: 'https://pub.dev/packages/share_plus',
                  text: '\n\t- share_plus'),
            ],
          ),
        ),
      ),
    ],
  );
}

void showDSGVODialog(BuildContext context) {
  final ThemeData themeData = Theme.of(context);
  final TextStyle? aboutTextStyle = themeData.textTheme.bodyMedium;
  final TextStyle? linkStyle =
      themeData.textTheme.bodyMedium?.copyWith(color: themeData.colorScheme.secondary);

  showDialog(
      context: context,
      barrierDismissible: false, // user must tap button for close dialog!
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Stimmst du den AGB und DSGVO zu?'),
          content: SingleChildScrollView(
              child: RichText(
                  text: TextSpan(children: <TextSpan>[
            TextSpan(
                style: aboutTextStyle,
                text: 'Wir die Appentwickler haben begründetes'
                    'Interesses (s. Art. 6 Abs. 1 lit. f. DSGVO) Daten in Form von Screenshots der App'
                    'zu erheben und innerhalb der App zu speichern. Die App stellt diese dann,'
                    'soweit es von Ihnen gewollt wird, über soziale Medien zur Verfügung. Dafür wird die Android oder IOS'
                    'internes Social Media Plugin benutzt.'
                    'die Screenshots werden innerhalb der App solange gespeicher bis sie an die entsprechenden social Media'
                    'Kanäle weitergegben wurden. Danach werden Sie automatisch im Spiel gelöscht und stehen dem Spiel nicht mehr zur Verfügung'
                    'um Spielsptände zu speicher, wird der zugriff für die Appinternen speicher benötigt und benutzt. Sollten Sie dass nicht wollen'
                    'müssen Sie den Entwickler kontaktieren, wir stellen ihnen dann eine Version zur verfügung die dann ihre spielstände nicht mehr speicher'
                    'sie können gern jederzeit wiedersprechen, allerdings wird dann diese App nicht mehr nutzbar.\n Dass Sie diesen Text lesen müssen'
                    'verdanken Sie unfähigen Politiken und paranoiden Datenschützen, die keinen Realitätsbezug haben.\n'),
            _LinkTextSpan(
              style: linkStyle,
              url: 'https://github.com/Paradoxianer/save_the_world',
              text: 'kontakt zum Entwickler',
            ),
          ]))),
          actions: <Widget>[
            TextButton(
              child: const Text('Abbrechen'),
              onPressed: () {
                Navigator.of(context).pop(ConfirmAGB.CANCEL);
              },
            ),
            TextButton(
              child: const Text('Ich stimme zu'),
              onPressed: () {
                Navigator.of(context).pop(ConfirmAGB.ACCEPT);
              },
            )
          ],
        );
      });
}
