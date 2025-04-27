import 'package:flutter/material.dart';
import 'package:animated_text_kit/animated_text_kit.dart';

class AboutMeSection extends StatefulWidget {
  const AboutMeSection({Key? key}) : super(key: key);

  @override
  State<AboutMeSection> createState() => _AboutMeSectionState();
}

class _AboutMeSectionState extends State<AboutMeSection>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 8),
    )..repeat(); // Continuous rotation
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  Widget buildImageWithBadge() {
    return Stack(
      alignment: Alignment.bottomLeft,
      children: [
        ClipRRect(
          borderRadius: BorderRadius.circular(16),
          child: Image.asset(
            'images/aboutme.png',
            width: 400,
            height: 300,
            fit: BoxFit.cover,
          ),
        ),
        Positioned(
          bottom: -20,
          left: -20,
          child: RotationTransition(
            turns: _controller,
            child: CircleAvatar(
              backgroundColor: Colors.white,
              radius: 50,
              child: const Text(
                '👨‍💻\nFlutter\nDev',
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.bold,
                  height: 1.4,
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget buildAboutText(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        AnimatedTextKit(
          animatedTexts: [
            ColorizeAnimatedText(
              'ABOUT ME',
              textStyle: const TextStyle(
                fontSize: 28,
                fontWeight: FontWeight.bold,
              ),
              colors: [
                Colors.blue,
                Colors.deepPurpleAccent,
                Colors.black87,
                Colors.blue.shade700,
              ],
            ),
          ],
          isRepeatingAnimation: false,
          totalRepeatCount: 1,
        ),
        const SizedBox(height: 16),
        TypewriterAnimatedTextKit(
          text: [
            "Hi, I'm Asad Rafique, a passionate Flutter Developer.",
            "I specialize in building responsive, user-friendly mobile apps.",
            "From ideation to deployment, I deliver value at every step.",
          ],
          textStyle: const TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.w400,
          ),
          speed: const Duration(milliseconds: 100),
        ),
        const SizedBox(height: 20),
        HoverAnimatedText(
          text:
              "I have published live apps, collaborated with teams, and worked on Firebase, RESTful APIs, and UI/UX design principles.",
        ),
        const SizedBox(height: 10),
        HoverAnimatedText(
          text:
              "While my main expertise lies in Flutter and Dart, I also have experience in Laravel and PHP for backend development.",
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(24.0),
      child: LayoutBuilder(
        builder: (context, constraints) {
          bool isMobile = constraints.maxWidth < 800;
          return isMobile
              ? Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    buildImageWithBadge(),
                    const SizedBox(height: 20),
                    buildAboutText(context),
                  ],
                )
              : Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    buildImageWithBadge(),
                    const SizedBox(width: 32),
                    Expanded(child: buildAboutText(context)),
                  ],
                );
        },
      ),
    );
  }
}

class HoverAnimatedText extends StatefulWidget {
  final String text;

  const HoverAnimatedText({Key? key, required this.text}) : super(key: key);

  @override
  State<HoverAnimatedText> createState() => _HoverAnimatedTextState();
}

class _HoverAnimatedTextState extends State<HoverAnimatedText> {
  bool _isHovered = false;

  @override
  Widget build(BuildContext context) {
    return MouseRegion(
      onEnter: (_) => setState(() => _isHovered = true),
      onExit: (_) => setState(() => _isHovered = false),
      child: AnimatedDefaultTextStyle(
        duration: const Duration(milliseconds: 300),
        style: TextStyle(
          fontSize: 16,
          height: 1.6,
          color: _isHovered ? Colors.blue.shade700 : Colors.black87,
          fontWeight: _isHovered ? FontWeight.w600 : FontWeight.normal,
        ),
        child: Text(widget.text),
      ),
    );
  }
}
