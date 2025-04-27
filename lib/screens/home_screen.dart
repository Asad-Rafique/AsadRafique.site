import 'package:flutter/material.dart';
import 'package:portfolio_web/screens/about_screen.dart';
import 'package:portfolio_web/screens/contect.dart';
import 'package:portfolio_web/screens/home.dart';
import 'package:portfolio_web/screens/project.dart';
import 'package:portfolio_web/screens/tech.dart';

import 'dart:io';
import 'package:flutter/services.dart'; // For accessing assets
import 'package:path_provider/path_provider.dart'; // For finding a local directory
import 'package:open_file/open_file.dart'; // For opening the downloaded file
import 'dart:html' as html; // For web download functionality
import 'dart:typed_data'; // For handling byte data
import 'package:flutter/foundation.dart' show kIsWeb; // For platform detection

void _launchCVDownload() async {
  try {
    // Step 1: Load the CV file from the assets folder
    final ByteData cvData = await rootBundle.load('assets/AsadRafiqueResumeIsl.pdf');
    
    // Step 2: Handle download based on platform
    if (kIsWeb) {
      // Web platform: Use HTML download
      final Uint8List bytes = cvData.buffer.asUint8List();
      final blob = html.Blob([bytes], 'application/pdf');
      final url = html.Url.createObjectUrlFromBlob(blob);
      final anchor = html.AnchorElement(href: url)
        ..setAttribute('download', 'AsadRafiqueResumeIsl.pdf')
        ..click();
      html.Url.revokeObjectUrl(url);
      
      print('CV downloaded in browser');
    } else {
      // Mobile/Desktop platform: Save to file system
      final Directory directory = await getApplicationDocumentsDirectory();
      final String filePath = '${directory.path}/AsadRafiqueResumeIsl.pdf';
      
      final File file = File(filePath);
      await file.writeAsBytes(cvData.buffer.asUint8List());
      
      // Open the file
      await OpenFile.open(filePath);
      
      print('CV downloaded and saved to $filePath');
    }
  } catch (e) {
    print('Error downloading CV: $e');
  }
}

class CVSection extends StatelessWidget {
  final VoidCallback _launchCVDownload;
  final Function _scrollToSection;

  const CVSection(this._launchCVDownload, this._scrollToSection, {super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      constraints: BoxConstraints(maxWidth: 1400.0),
      width: double.infinity,
      child: Column(
        children: [
          const Text('Download my CV', style: TextStyle(fontSize: 24)),
          const SizedBox(height: 20),
          ElevatedButton(
            onPressed: () {
              _launchCVDownload();
            },
            child: const Text('Download CV'),
            style: ElevatedButton.styleFrom(
              foregroundColor: Colors.white,
              backgroundColor: Colors.black87,
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  // Selected section index
  int _selectedIndex = 0;

  // Scroll controller to navigate to sections
  final ScrollController _scrollController = ScrollController();

  // Global keys for each section
  final List<GlobalKey> _sectionKeys = [
    GlobalKey(), // Home
    GlobalKey(), // About
    GlobalKey(), // Projects
    GlobalKey(), // CV
    GlobalKey(), // Contact
  ];

  @override
  void initState() {
    super.initState();

    // Add scroll listener to update selected tab based on viewport
    _scrollController.addListener(_updateSelectedIndexOnScroll);
  }

  @override
  void dispose() {
    _scrollController.removeListener(_updateSelectedIndexOnScroll);
    _scrollController.dispose();
    super.dispose();
  }

  // Update selected index based on scroll position
  void _updateSelectedIndexOnScroll() {
    if (!_scrollController.hasClients) return;

    for (int i = _sectionKeys.length - 1; i >= 0; i--) {
      final key = _sectionKeys[i];
      final context = key.currentContext;

      if (context == null) continue;

      final RenderBox box = context.findRenderObject() as RenderBox;
      final position = box.localToGlobal(Offset.zero);

      // If the section is visible in the viewport
      if (position.dy < MediaQuery.of(context).size.height * 0.5) {
        if (_selectedIndex != i) {
          setState(() {
            _selectedIndex = i;
          });
        }
        break;
      }
    }
  }

  // Scroll to section
  void _scrollToSection(int index) {
    setState(() {
      _selectedIndex = index;
    });

    final context = _sectionKeys[index].currentContext;
    if (context != null) {
      Scrollable.ensureVisible(
        context,
        duration: const Duration(milliseconds: 500),
        curve: Curves.easeInOut,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final screenSize = MediaQuery.of(context).size;
    final screenWidth = screenSize.width;

    // Responsive breakpoints with more granularity
    final isSmallScreen = screenWidth < 600;
    final isMediumScreen = screenWidth >= 600 && screenWidth < 960;
    final isLargeScreen = screenWidth >= 960 && screenWidth < 1400;
    final isExtraLargeScreen = screenWidth >= 1400;

    // Maximum content width - prevents stretching on ultra-wide screens
    final maxContentWidth = isExtraLargeScreen
        ? 1400.0
        : isLargeScreen
            ? 1200.0
            : double.infinity;

    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.white,
        title: _buildLogo(isSmallScreen),
        centerTitle: isSmallScreen,
        leadingWidth: isSmallScreen ? 40 : 0,
        leading: isSmallScreen ? null : const SizedBox.shrink(),
        toolbarHeight: isSmallScreen ? 56 : 70,
        actions: isSmallScreen
            ? [
                // Mobile view - show menu icon
                PopupMenuButton<int>(
                  onSelected: (index) {
                    if (index == -1) {
                      // Handle resume download
                      _launchCVDownload();
                    } else {
                      _scrollToSection(index);
                    }
                  },
                  itemBuilder: (context) => [
                    const PopupMenuItem(value: 0, child: Text('Home')),
                    const PopupMenuItem(value: 1, child: Text('About')),
                    const PopupMenuItem(value: 2, child: Text('Projects')),
                    const PopupMenuItem(value: 3, child: Text('CV')),
                    const PopupMenuItem(value: 4, child: Text('Contact')),
                    const PopupMenuItem(
                      value: -1,
                      child: Text('Download Resume'),
                    ),
                  ],
                  icon: const Icon(Icons.menu, color: Colors.black87),
                ),
              ]
            : isExtraLargeScreen || isLargeScreen
                ? _buildDesktopNav()
                : _buildTabletNav(),
      ),
      body: Center(
        child: SingleChildScrollView(
          controller: _scrollController,
          child: LayoutBuilder(
            builder: (context, constraints) {
              return Center(
                child: Column(
                  children: [
                    // Home section with constrained width for proper scaling
                    _buildSection(
                      _sectionKeys[0],
                      maxContentWidth,
                      HomeIntroSection(),
                    ),

                    const SizedBox(height: 40),

                    // Tech stack section
                    _buildSection(
                      GlobalKey(),
                      maxContentWidth,
                      AnimatedTechStack(),
                    ),

                    const SizedBox(height: 40),

                    // About section
                    _buildSection(
                      _sectionKeys[1],
                      maxContentWidth,
                      AboutMeSection(),
                    ),

                    const SizedBox(height: 40),

                    // Projects section with screenshot gallery
                    _buildSection(
                      _sectionKeys[2],
                      maxContentWidth,
                      ProjectShowcaseSection(),
                    ),

                    const SizedBox(height: 40),

                    // CV section
                    _buildSection(
                      _sectionKeys[3],
                      maxContentWidth,
                      CVSection(_launchCVDownload, _scrollToSection),
                    ),

                    const SizedBox(height: 40),

                    // Contact section
                    _buildSection(
                      _sectionKeys[4],
                      maxContentWidth,
                      ContactSection(),
                    ),

                    // Footer with copyright
                    const SizedBox(height: 40),
                    _buildFooter(),
                  ],
                ),
              );
            },
          ),
        ),
      ),
    );
  }

  // Helper method to build each section with proper constraints
  Widget _buildSection(GlobalKey key, double maxWidth, Widget child) {
    return Container(
      key: key,
      constraints: BoxConstraints(maxWidth: maxWidth),
      width: double.infinity,
      child: child,
    );
  }

  void _launchResumeDownload() async {
    try {
      // Step 1: Load the resume file from the assets folder
      final ByteData resumeData = await rootBundle.load('assets/AsadRafiqueResumeLhr.pdf');

      // Step 2: Handle download based on platform
      if (kIsWeb) {
        // Web platform: Use HTML download
        final Uint8List bytes = resumeData.buffer.asUint8List();
        final blob = html.Blob([bytes], 'application/pdf');
        final url = html.Url.createObjectUrlFromBlob(blob);
        final anchor = html.AnchorElement(href: url)
          ..setAttribute('download', 'AsadRafiqueResumeLhr.pdf')
          ..click();
        html.Url.revokeObjectUrl(url);
        
        print('Resume downloaded in browser');
      } else {
        // Mobile/Desktop platform: Save to file system
        final Directory directory = await getApplicationDocumentsDirectory();
        final String filePath = '${directory.path}/AsadRafiqueResumeLhr.pdf';

        // Write the file data to the local file
        final File file = File(filePath);
        await file.writeAsBytes(resumeData.buffer.asUint8List());

        // Open the file
        await OpenFile.open(filePath);

        print('Resume downloaded and saved to $filePath');
      }
    } catch (e) {
      print('Error downloading resume: $e');
    }
  }

  // Desktop navigation
  List<Widget> _buildDesktopNav() {
    return [
      _buildNavButton('Home', 0),
      _buildNavButton('About', 1),
      _buildNavButton('Projects', 2),
      _buildNavButton('CV', 3),
      _buildNavButton('Contact', 4),
      const SizedBox(width: 16),
      ElevatedButton.icon(
        icon: const Icon(Icons.download_rounded),
        label: const Text('Resume'),
        onPressed: _launchCVDownload,
        style: ElevatedButton.styleFrom(
          foregroundColor: Colors.white,
          backgroundColor: Colors.black87,
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(8),
          ),
        ),
      ),
      const SizedBox(width: 16),
    ];
  }

  // Tablet navigation (more compact)
  List<Widget> _buildTabletNav() {
    return [
      _buildNavButton('Home', 0, compact: true),
      _buildNavButton('About', 1, compact: true),
      _buildNavButton('Projects', 2, compact: true),
      _buildNavButton('CV', 3, compact: true),
      _buildNavButton('Contact', 4, compact: true),
      const SizedBox(width: 8),
      IconButton(
        icon: const Icon(Icons.download_rounded, color: Colors.black87),
        onPressed: _launchCVDownload,
        tooltip: 'Download Resume',
      ),
      const SizedBox(width: 8),
    ];
  }

  Widget _buildLogo(bool isSmall) {
    return Container(
      padding: EdgeInsets.symmetric(
        horizontal: isSmall ? 12 : 16,
        vertical: isSmall ? 6 : 8,
      ),
      decoration: BoxDecoration(
        border: Border.all(color: Colors.black, width: isSmall ? 1.5 : 2),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            "Asad's ",
            style: TextStyle(
              color: Colors.black,
              fontWeight: FontWeight.w400,
              fontSize: isSmall ? 16 : 18,
            ),
          ),
          Text(
            "Portfolio",
            style: TextStyle(
              color: Colors.black,
              fontWeight: FontWeight.bold,
              fontSize: isSmall ? 16 : 18,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildNavButton(String title, int index, {bool compact = false}) {
    return TextButton(
      onPressed: () => _scrollToSection(index),
      style: ButtonStyle(
        backgroundColor: _selectedIndex == index
            ? MaterialStateProperty.all(Colors.black.withOpacity(0.1))
            : null,
        padding: MaterialStateProperty.all(
          EdgeInsets.symmetric(
            horizontal: compact ? 8 : 16,
            vertical: compact ? 4 : 8,
          ),
        ),
        minimumSize: MaterialStateProperty.all(
          Size(compact ? 10 : 40, compact ? 20 : 36),
        ),
      ),
      child: Text(
        title,
        style: TextStyle(
          color: Colors.black,
          fontSize: compact ? 14 : 16,
          fontWeight: _selectedIndex == index ? FontWeight.bold : FontWeight.normal,
        ),
      ),
    );
  }

  Widget _buildFooter() {
    return Container(
      width: double.infinity,
      color: Colors.black87,
      padding: const EdgeInsets.symmetric(vertical: 20),
      child: const Center(
        child: Text(
          ' 2023 Asad Rafique | Flutter Developer',
          style: TextStyle(
            color: Colors.white,
            fontSize: 14,
          ),
        ),
      ),
    );
  }
}
