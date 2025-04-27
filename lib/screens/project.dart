// import 'dart:async';
import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

class Project {
  final String imagePath;
  final String title;
  final String description;
  final String link;
  final List<String> screenshots;

  Project({
    required this.imagePath,
    required this.title,
    required this.description,
    required this.link,
    this.screenshots = const [],
  });
}

class ProjectShowcaseSection extends StatefulWidget {
  const ProjectShowcaseSection({super.key});

  @override
  State<ProjectShowcaseSection> createState() => _ProjectShowcaseSectionState();
}

class _ProjectShowcaseSectionState extends State<ProjectShowcaseSection> {
  final List<Project> projects = [
    Project(
      imagePath: 'images/sobo_sham.png',
      title: 'Sobo Sham Ki Dowayn',
      description:
          'An Islamic app providing daily prayers with translations. Designed for easy access and spiritual support.',
      link:
          'https://play.google.com/store/apps/details?id=com.devglim.Subha_Shaam_Ki_Duaain',
      screenshots: [
        'images/sobo_sham.png',
        'images/sobo_sham_2.png',
        'images/sobo_sham_3.png',
      ],
    ),
    Project(
      imagePath: 'images/yaseen.png',
      title: 'Surah Yaseen App',
      description:
          'A Surah Yaseen reading app with English & Urdu translations. Easy navigation and clear interface.',
      link:
          'https://play.google.com/store/apps/details?id=com.devglim.Surahyaseen',
      screenshots: [
        'images/yaseen.png',
        'images/yaseen_2.png',
        'images/yaseen_3.png',
      ],
    ),
    Project(
      imagePath: 'images/softwersit.png',
      title: 'Development Service Site',
      description:
          'A development service platform for businesses. Includes user/admin panels with full control.',
      link: 'https://devglim.com/',
      screenshots: [
        'images/softwersit.png',
        'images/softwersit_2.png',
      ],
    ),
    Project(
      imagePath: 'images/bmi.png.png',
      title: 'BMI Calculator',
      description:
          'App to calculate Body Mass Index instantly. Provides fitness tips based on results.',
      link:
          'https://play.google.com/store/apps/details?id=com.devglim.bmi_calculator',
      screenshots: [
        'images/bmi.png.png',
        'images/bmi_2.png',
      ],
    ),
    Project(
      imagePath: 'images/norani.png',
      title: 'Noorani Qaida',
      description:
          'Quran learning app for beginners and children. Interactive and child-friendly interface.',
      link:
          'https://play.google.com/store/apps/details?id=com.devglim.nooraniqaida',
      screenshots: [
        'images/norani.png',
        'images/norani_2.png',
      ],
    ),
  ];

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final isMobile = screenWidth < 800;
    final isTablet = screenWidth >= 800 && screenWidth < 1200;

    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(vertical: 20),
          child: Text(
            'Featured Projects',
            style: Theme.of(context).textTheme.displayMedium?.copyWith(
                  color: Colors.deepPurple,
                ),
          ),
        ),
        Padding(
          padding: const EdgeInsets.all(20.0),
          child: isMobile
              ? _buildGrid(columns: 1)
              : isTablet
                  ? _buildGrid(columns: 2)
                  : _buildGrid(columns: 3),
        ),
      ],
    );
  }

  Widget _buildGrid({required int columns}) {
    return GridView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: columns,
        crossAxisSpacing: 16,
        mainAxisSpacing: 16,
        childAspectRatio: 1.0,
      ),
      itemCount: projects.length,
      itemBuilder: (context, index) {
        return _buildProjectCard(projects[index]);
      },
    );
  }

  Widget _buildProjectCard(Project project) {
    return Card(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
      ),
      elevation: 4,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Expanded(
            child: ClipRRect(
              borderRadius: const BorderRadius.vertical(top: Radius.circular(16)),
              child: Image.asset(
                project.imagePath,
                fit: BoxFit.cover,
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  project.title,
                  style: const TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  project.description,
                  maxLines: 3,
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(fontSize: 14, height: 1.4),
                ),
                const SizedBox(height: 12),
                if (project.link.isNotEmpty)
                  ElevatedButton.icon(
                    onPressed: () async {
                      final Uri url = Uri.parse(project.link);
                      if (await canLaunchUrl(url)) {
                        await launchUrl(url);
                      } else {
                        if (context.mounted) {
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(content: Text('Could not open link')),
                          );
                        }
                      }
                    },
                    icon: const Icon(Icons.link),
                    label: const Text('View Project'),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.deepPurple,
                      foregroundColor: Colors.white,
                      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                      textStyle: const TextStyle(fontSize: 14),
                    ),
                  ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
