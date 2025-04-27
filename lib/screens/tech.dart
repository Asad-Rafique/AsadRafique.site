import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class AnimatedTechStack extends StatelessWidget {
  const AnimatedTechStack({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(32.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          const SizedBox(height: 60),
          const Text(
            '🚀 Tech Stack',
            style: TextStyle(
              fontSize: 32,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 40),
          Wrap(
            alignment: WrapAlignment.center,
            spacing: 60,
            runSpacing: 50,
            children: const [
              TechStackItem(
                icon: FontAwesomeIcons.flutter,
                label: 'Flutter',
              ),
              TechStackItem(
                icon: FontAwesomeIcons.dartLang,
                label: 'Dart',
              ),
              TechStackItem(
                icon: FontAwesomeIcons.fire,
                label: 'Firebase',
              ),
              TechStackItem(
                icon: FontAwesomeIcons.database,
                label: 'SQL',
              ),
              TechStackItem(
                icon: FontAwesomeIcons.laravel,
                label: 'Laravel',
              ),
              TechStackItem(
                icon: FontAwesomeIcons.php,
                label: 'PHP',
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class TechStackItem extends StatefulWidget {
  final IconData icon;
  final String label;

  const TechStackItem({
    Key? key,
    required this.icon,
    required this.label,
  }) : super(key: key);

  @override
  State<TechStackItem> createState() => _TechStackItemState();
}

class _TechStackItemState extends State<TechStackItem> {
  bool _isHovered = false;

  @override
  Widget build(BuildContext context) {
    return MouseRegion(
      onEnter: (_) {
        setState(() {
          _isHovered = true;
        });
      },
      onExit: (_) {
        setState(() {
          _isHovered = false;
        });
      },
      child: AnimatedScale(
        scale: _isHovered ? 1.2 : 1.0,
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeInOut,
        child: Column(
          children: [
            AnimatedContainer(
              duration: const Duration(milliseconds: 300),
              curve: Curves.easeInOut,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: _isHovered ? Colors.deepPurpleAccent : Colors.transparent,
                boxShadow: _isHovered
                    ? [
                        BoxShadow(
                          color: Colors.deepPurpleAccent.withOpacity(0.4),
                          blurRadius: 10,
                          spreadRadius: 5,
                        ),
                      ]
                    : [],
              ),
              padding: const EdgeInsets.all(12),
              child: FaIcon(
                widget.icon,
                size: 48,
                color: _isHovered ? Colors.white : Colors.deepPurpleAccent,
              ),
            ),
            const SizedBox(height: 12),
            Text(
              widget.label,
              style: const TextStyle(
                fontSize: 18,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
