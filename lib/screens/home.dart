import 'dart:async';
import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

class HomeIntroSection extends StatefulWidget {
  const HomeIntroSection({super.key});

  @override
  State<HomeIntroSection> createState() => _HomeIntroSectionState();
}

class _HomeIntroSectionState extends State<HomeIntroSection> {
  BoxShape _currentShape = BoxShape.circle;
  late Timer _timer;

  @override
  void initState() {
    super.initState();
    _startShapeAnimation();
  }

  void _startShapeAnimation() {
    _timer = Timer.periodic(const Duration(seconds: 3), (_) {
      setState(() {
        _currentShape = _currentShape == BoxShape.circle
            ? BoxShape.rectangle
            : BoxShape.circle;
      });
    });
  }

  @override
  void dispose() {
    _timer.cancel();
    super.dispose();
  }

  void _launchUrl(String url) async {
    final uri = Uri.parse(url);
    if (await canLaunchUrl(uri)) {
      launchUrl(uri);
    } else {
      throw 'Could not launch $url';
    }
  }

  @override
  Widget build(BuildContext context) {
    // Check if screen width is mobile size
    final screenWidth = MediaQuery.of(context).size.width;
    final isMobile = screenWidth < 768;

    return Padding(
      padding: EdgeInsets.symmetric(
        vertical: 32,
        horizontal: isMobile ? 20 : 50,
      ),
      child: isMobile
          ? _buildMobileLayout()
          : _buildDesktopLayout(),
    );
  }

  Widget _buildDesktopLayout() {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        // Left Side: Text & Social Icons
        Expanded(
          flex: 1,
          child: _buildInfoSection(),
        ),

        const SizedBox(width: 40),

        // Right Side: Animated Image
        Expanded(
          flex: 1,
          child: _buildAnimatedImage(),
        ),
      ],
    );
  }

  Widget _buildMobileLayout() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        // Top: Animated Image
        _buildAnimatedImage(size: 180),
        
        const SizedBox(height: 32),
        
        // Bottom: Text & Social Icons
        _buildInfoSection(isCentered: true),
      ],
    );
  }

  Widget _buildInfoSection({bool isCentered = false}) {
    return Column(
      crossAxisAlignment: isCentered ? CrossAxisAlignment.center : CrossAxisAlignment.start,
      children: [
        Text(
          '👨‍💻 Flutter Developer',
          style: TextStyle(
            fontSize: isCentered ? 30 : 36,
            fontWeight: FontWeight.bold,
          ),
          textAlign: isCentered ? TextAlign.center : TextAlign.start,
        ),
        const SizedBox(height: 16),
        Text(
          '👋 Hi, I\'m Asad Rafique. A self-taught passionate Flutter Developer based in Lahore, Pakistan.',
          style: TextStyle(fontSize: isCentered ? 18 : 22),
          textAlign: isCentered ? TextAlign.center : TextAlign.start,
        ),
        const SizedBox(height: 28),
        Row(
          mainAxisAlignment: isCentered ? MainAxisAlignment.center : MainAxisAlignment.start,
          children: [
            _buildSocialIcon(
              'images/Linkedin_logo.png',
              'https://www.linkedin.com/in/asad-rafique-775497277/',
            ),
            const SizedBox(width: 16),
            _buildSocialIcon(
              'images/github.png',
              'https://github.com/Asad-Rafique',
            ),
            const SizedBox(width: 16),
            _buildSocialIcon(
              'images/play-store-logo.png',
              'https://play.google.com/store/search?q=devglim&c=apps&hl=en',
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildAnimatedImage({double size = 220}) {
    return Center(
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 1000),
        width: size,
        height: size,
        curve: Curves.easeInOut,
        decoration: BoxDecoration(
          shape: _currentShape,
          boxShadow: const [
            BoxShadow(
              color: Colors.black26,
              blurRadius: 10,
              spreadRadius: 2,
              offset: Offset(0, 5),
            ),
          ],
        ),
        child: _currentShape == BoxShape.circle
            ? ClipOval(
                child: Image.asset("images/me.jpeg", fit: BoxFit.cover),
              )
            : ClipRRect(
                borderRadius: BorderRadius.circular(20),
                child: Image.asset("images/me.jpeg", fit: BoxFit.cover),
              ),
      ),
    );
  }

  Widget _buildSocialIcon(String assetPath, String url) {
    return InkWell(
      onTap: () => _launchUrl(url),
      child: Image.asset(
        assetPath,
        width: 30,
        height: 30,
      ),
    );
  }
}
