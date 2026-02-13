// Copyright 2018 The Chromium Authors. All rights reserved.
// Use of this source code is governed by a BSD-style license that can be
// found in the LICENSE file.

import 'package:flutter/foundation.dart' show defaultTargetPlatform;
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

enum ConfirmAGB { CANCEL, ACCEPT }


class _LinkTextSpan extends TextSpan {
  // Beware!
  //
  // This class is only safe because the TapGestureRecognizer is not
  // given a deadline and therefore never allocates any resources.
  //
  // In any other situation -- setting a deadline, using any of the less trivial
  // recognizers, etc -- you would have to manage the gesture recognizer's
  // lifetime and call dispose() when the TextSpan was no longer being rendered.
  //
  // Since TextSpan itself is @immutable, this means that you would have to
  // manage the recognizer from outside the TextSpan, e.g. in the State of a
  // stateful widget that then hands the recognizer to the TextSpan.

  _LinkTextSpan({TextStyle style, String url, String text})
      : super(
            style: style,
            text: text ?? url,
            recognizer: TapGestureRecognizer()
              ..onTap = () {
                launch(url, forceSafariVC: false);
              });
}

void showAppAboutDialog(BuildContext context) {
  final ThemeData themeData = Theme.of(context);
  final TextStyle aboutTextStyle = themeData.textTheme.body2;
  final TextStyle linkStyle =
      themeData.textTheme.body2.copyWith(color: themeData.accentColor);

  showAboutDialog(
    context: context,
    applicationVersion: 'Mai 2019',
    applicationIcon:
    Image.asset('assets/icons/save_the_world.png', width: 64, height: 64),
    applicationLegalese: '© 2019 Paradoxon',
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
                      '${defaultTargetPlatform == TargetPlatform.iOS
                      ? 'multiple platforms'
                      : 'iOS and Android'} '
                      ''),
              _LinkTextSpan(
                text: 'Bitte unterstützt mich und die Heilsarmee.',
                style: linkStyle,
                url: 'https://www.patreon.com/paradoxon',
              ),
              TextSpan(
                style: aboutTextStyle,
                text:
                '\n\nFalls ihr Fehler findet, dann meldet sie bitte hier: ',
              ),
              _LinkTextSpan(
                style: linkStyle,
                url:
                'https://bitbucket.org/Paradoxianer/save_the_world_flutter/',
                text: 'save_the_world repo',
              ),
              TextSpan(
                  style: aboutTextStyle,
                  text: '\n\nDank geht an die vielen Unterstützter'
                      ' \n\t- Johannes Walz\n\t- Johannes Ebeling\n\t- Anni Lindner'
                      '\n\nund die Entwickler der flutterplugins'
                      ''),
              _LinkTextSpan(
                  style: linkStyle,
                  url: 'https://pub.dartlang.org/packages/cupertino_icons',
                  text: '\n\t- cupertino_icons'),
              _LinkTextSpan(
                  style: linkStyle,
                  url: 'https://pub.dartlang.org/packages/url_launcher',
                  text: '\n\t- url_launcher'),
              _LinkTextSpan(
                  style: linkStyle,
                  url: 'https://pub.dartlang.org/packages/path_provider',
                  text: '\n\t- path_provider'),
              _LinkTextSpan(
                  style: linkStyle,
                  url: 'https://pub.dartlang.org/packages/esys_flutter_share',
                  text: '\n\t- esys_flutter_share'),
            ],
          ),
        ),
      ),
    ],
  );
}

void showDSGVODialog(BuildContext context) {
  final ThemeData themeData = Theme.of(context);
  final TextStyle aboutTextStyle = themeData.textTheme.body2;
  final TextStyle linkStyle =
  themeData.textTheme.body2.copyWith(color: themeData.accentColor);

  showDialog(
      context: context,
      barrierDismissible: false, // user must tap button for close dialog!
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Stimmst du den AGB und DSGVO zu?'),
          content: SingleChildScrollView(
              child: RichText(
                  text: TextSpan(
                      children: <TextSpan>[
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
                                'verdanken Sie unfähigen Politiken und paranoiden Datenschützen, die keinen Realitätsbezug haben.\n'
                        ),
                        _LinkTextSpan(
                          style: linkStyle,
                          url:
                          'https://bitbucket.org/Paradoxianer/save_the_world_flutter/',
                          text: 'kontakt zum Entwickler',
                        ),
                      ]
                  )
              )
          ),
          actions: <Widget>[
            FlatButton(
              child: const Text('Abbrechen'),
              onPressed: () {
                Navigator.of(context).pop(ConfirmAGB.CANCEL);
              },
            ),
            FlatButton(
              child: const Text('Ich stimme zu'),
              onPressed: () {
                Navigator.of(context).pop(ConfirmAGB.ACCEPT);
              },
            )
          ],
        );
      }
  );
}
