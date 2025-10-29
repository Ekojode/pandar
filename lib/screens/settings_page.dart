import 'package:flutter/material.dart';

import 'package:url_launcher/url_launcher.dart';

import '../widgets/social_button.dart';

class SettingsPage extends StatefulWidget {
  const SettingsPage({super.key});

  @override
  State<SettingsPage> createState() => _SettingsPageState();
}

class _SettingsPageState extends State<SettingsPage> {
  Color blackColor = const Color(0xff0c120c);
  Color blueColor = const Color(0xff4285F4);
  Color whiteColor = const Color(0xffFDFDFF);
  Color iconColor = const Color(0xff565656);
  Color outlineColor = const Color(0xffD6D6D6);
  Color descriptionColor = const Color(0xff565656);

  @override
  void initState() {
    super.initState();
  }

  Future<void> _openUrl(String url) async {
    final uri = Uri.parse(url);
    if (!await launchUrl(uri, mode: LaunchMode.externalApplication)) {
      if (!mounted) return;
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text('Could not open $url')));
    }
  }

  EdgeInsets get _screenHPad {
    final w = MediaQuery.of(context).size.width;
    final hpad = (w * 0.05).clamp(16.0, 24.0);
    return EdgeInsets.symmetric(horizontal: hpad);
  }

  @override
  Widget build(BuildContext context) {
    final version = '1.0.0';
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        surfaceTintColor: Colors.white,
        leading: IconButton(
          onPressed: () => Navigator.pop(context),
          icon: const Icon(Icons.arrow_back, color: Colors.black),
          tooltip: 'Back',
        ),
        title: const Text(
          'Settings',
          style: TextStyle(
            fontSize: 24,
            fontWeight: FontWeight.w800,
            color: Colors.black,
          ),
        ),
        centerTitle: false,
      ),
      body: SafeArea(
        child: Padding(
          padding: _screenHPad.add(const EdgeInsets.only(bottom: 24, top: 8)),
          child: Column(
            children: [
              const SizedBox(height: 16),
              Row(
                children: [
                  Expanded(
                    child: Text(
                      'Created By',
                      style: TextStyle(
                        fontSize: 14,
                        color: descriptionColor,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                  Text(
                    'Oma-Victor Ekojode',
                    style: TextStyle(
                      fontSize: 14,
                      color: descriptionColor,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 12),
              Row(
                children: [
                  Expanded(
                    child: Text(
                      'Email',
                      style: TextStyle(
                        fontSize: 14,
                        color: descriptionColor,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                  Text(
                    "ekojodeoma@gmail.com",
                    style: TextStyle(
                      fontSize: 14,
                      color: descriptionColor,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 12),
              Row(
                children: [
                  Expanded(
                    child: Text(
                      'Version',
                      style: TextStyle(
                        fontSize: 14,
                        color: descriptionColor,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                  Text(
                    version,
                    style: TextStyle(
                      fontSize: 14,
                      color: descriptionColor,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                ],
              ),

              Spacer(),
              Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Image.asset("assets/images/pandar.png", height: 56),
                  const SizedBox(height: 8),
                  Text(
                    'Version $version',
                    style: TextStyle(
                      fontSize: 12,
                      color: descriptionColor,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  const SizedBox(height: 32),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      SocialIconButton(
                        asset: 'assets/icons/twitter.svg',
                        tooltip: 'X',
                        onTap: () => _openUrl('https://x.com/ekojode_'),
                      ),
                      const SizedBox(width: 16),
                      SocialIconButton(
                        asset: 'assets/icons/github.svg',
                        tooltip: 'GitHub',
                        onTap: () => _openUrl('https://github.com/Ekojode'),
                      ),
                      const SizedBox(width: 16),
                      SocialIconButton(
                        asset: 'assets/icons/linkedin.svg',
                        tooltip: 'LinkedIn',
                        onTap: () => _openUrl(
                          'https://www.linkedin.com/in/ekojode-oma-victor-795185353/',
                        ),
                      ),
                    ],
                  ),
                ],
              ),
              SizedBox(height: 20),
            ],
          ),
        ),
      ),
    );
  }
}
