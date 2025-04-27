import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class ContactSection extends StatefulWidget {
  const ContactSection({super.key});

  @override
  State<ContactSection> createState() => _ContactSectionState();
}

class _ContactSectionState extends State<ContactSection> {
  // Form controllers
  final _nameController = TextEditingController();
  final _emailController = TextEditingController();
  final _messageController = TextEditingController();
  final _formKey = GlobalKey<FormState>();
  bool _isSubmitting = false;
  bool _showSuccess = false;

  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    _messageController.dispose();
    super.dispose();
  }

  void _launchUrl(String url) async {
    final uri = Uri.parse(url);
    if (await canLaunchUrl(uri)) {
      await launchUrl(uri);
    } else {
      throw 'Could not launch $url';
    }
  }

  void _submitForm() {
    if (_formKey.currentState!.validate()) {
      setState(() {
        _isSubmitting = true;
      });
      
      // Get form data
      final name = _nameController.text;
      final email = _emailController.text;
      final message = _messageController.text;
      
      // Create WhatsApp message text
      final whatsappMessage = "Name: $name\nEmail: $email\nMessage: $message";
      final encodedMessage = Uri.encodeComponent(whatsappMessage);
      
      // Direct WhatsApp URL - works on both mobile and web
      final whatsappUrl = "https://wa.me/923206326121?text=$encodedMessage";
      
      // Open WhatsApp directly
      launchUrl(Uri.parse(whatsappUrl), mode: LaunchMode.externalApplication);
      
      // Show success message and clear form
      Future.delayed(const Duration(milliseconds: 800), () {
        if (mounted) {
          setState(() {
            _isSubmitting = false;
            _showSuccess = true;
            
            // Clear form fields
            _nameController.clear();
            _emailController.clear();
            _messageController.clear();
          });
          
          // Hide success message after 3 seconds
          Future.delayed(const Duration(seconds: 3), () {
            if (mounted) {
              setState(() {
                _showSuccess = false;
              });
            }
          });
        }
      });
    }
  }

  Widget _buildContactInfo() {
    return Container(
      padding: const EdgeInsets.all(30),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            Colors.deepPurple.shade800,
            Colors.deepPurple.shade500,
          ],
        ),
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.2),
            blurRadius: 15,
            spreadRadius: 5,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            "Let's Connect",
            style: TextStyle(
              fontSize: 28,
              fontWeight: FontWeight.bold,
              color: Colors.white,
            ),
          ),
          const SizedBox(height: 20),
          const Text(
            "Feel free to reach out for collaborations, projects, or just to say hello!",
              style: TextStyle(
                fontSize: 16,
              color: Colors.white,
              height: 1.6,
            ),
          ),
          const SizedBox(height: 40),
          _buildContactMethod(
            FontAwesomeIcons.envelope,
            "Email",
            "asadrafique280@gmail.com",
            "mailto:asadrafique280@gmail.com",
          ),
          const SizedBox(height: 25),
          _buildContactMethod(
            FontAwesomeIcons.phone,
            "Phone",
            "+92 320 6326121",
            "tel:+923206326121",
          ),
          const SizedBox(height: 25),
          _buildContactMethod(
            FontAwesomeIcons.locationDot,
            "Location",
            "Lahore, Pakistan",
            "",
            isLink: false,
          ),
          const SizedBox(height: 50),
          const Text(
            "Find me on",
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.w600,
              color: Colors.white,
            ),
          ),
          const SizedBox(height: 20),
          Row(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              _buildSocialIconButton(
                FontAwesomeIcons.linkedin,
                Colors.blue.shade300,
                "https://www.linkedin.com/in/asad-rafique-775497277/",
              ),
              const SizedBox(width: 20),
              _buildSocialIconButton(
                FontAwesomeIcons.github,
                Colors.white,
                "https://github.com/Asad-Rafique",
              ),
              const SizedBox(width: 20),
              _buildSocialIconButton(
                FontAwesomeIcons.googlePlay,
                Colors.green.shade300,
                "https://play.google.com/store/search?q=devglim&c=apps&hl=en",
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildContactMethod(
    IconData icon,
    String title,
    String detail,
    String url, {
    bool isLink = true,
  }) {
    return InkWell(
      onTap: isLink ? () => _launchUrl(url) : null,
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: Colors.white.withOpacity(0.1),
              borderRadius: BorderRadius.circular(12),
            ),
            child: FaIcon(icon, color: Colors.white, size: 20),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: Colors.white70,
                  ),
                ),
                const SizedBox(height: 5),
                Text(
                  detail,
                  style: TextStyle(
                    fontSize: 16,
                    color: Colors.white,
                    decoration: isLink ? TextDecoration.underline : null,
                    decorationColor: isLink ? Colors.white : null,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSocialIconButton(IconData icon, Color color, String url) {
    return InkWell(
      onTap: () => _launchUrl(url),
      child: Container(
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: Colors.white.withOpacity(0.1),
          borderRadius: BorderRadius.circular(12),
        ),
        child: FaIcon(icon, color: color, size: 24),
      ),
    );
  }

  Widget _buildContactForm() {
    return Container(
      padding: const EdgeInsets.all(30),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            spreadRadius: 1,
            offset: const Offset(0, 5),
          ),
        ],
      ),
      child: Form(
        key: _formKey,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              "Send a Message",
              style: TextStyle(
                fontSize: 28,
                fontWeight: FontWeight.bold,
                color: Colors.black87,
              ),
            ),
            const SizedBox(height: 20),
            const Text(
              "I'd love to hear from you. Fill out the form below to get in touch.",
              style: TextStyle(
                fontSize: 16,
                color: Colors.black54,
                height: 1.6,
              ),
            ),
            const SizedBox(height: 30),
            TextFormField(
              controller: _nameController,
              decoration: _inputDecoration("Name", FontAwesomeIcons.user),
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Please enter your name';
                }
                return null;
              },
            ),
            const SizedBox(height: 20),
            TextFormField(
              controller: _emailController,
              decoration: _inputDecoration("Email", FontAwesomeIcons.envelope),
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Please enter your email';
                } else if (!RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$')
                    .hasMatch(value)) {
                  return 'Please enter a valid email';
                }
                return null;
              },
            ),
            const SizedBox(height: 20),
            TextFormField(
              controller: _messageController,
              decoration: _inputDecoration("Message", FontAwesomeIcons.message),
              maxLines: 5,
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Please enter your message';
                }
                return null;
              },
            ),
            const SizedBox(height: 30),
            SizedBox(
              width: double.infinity,
              height: 55,
              child: ElevatedButton(
                onPressed: _isSubmitting ? null : _submitForm,
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.deepPurple,
                  foregroundColor: Colors.white,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  elevation: 2,
                ),
                child: _isSubmitting
                    ? const SizedBox(
                        width: 24,
                        height: 24,
                        child: CircularProgressIndicator(
                          color: Colors.white,
                          strokeWidth: 3,
                        ),
                      )
                    : const Text(
                        "Send Message",
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
              ),
            ),
            if (_showSuccess)
              Padding(
                padding: const EdgeInsets.only(top: 20),
                child: Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: Colors.green.shade100,
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Row(
                    children: [
                      Icon(Icons.check_circle, color: Colors.green.shade700),
                      const SizedBox(width: 12),
                      const Text(
                        "Message sent successfully!",
                        style: TextStyle(
                          color: Colors.black87,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }

  InputDecoration _inputDecoration(String label, IconData icon) {
    return InputDecoration(
      labelText: label,
      prefixIcon: Container(
        padding: const EdgeInsets.all(12),
        child: FaIcon(icon, size: 18, color: Colors.deepPurple),
      ),
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: BorderSide(color: Colors.grey.shade300),
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: BorderSide(color: Colors.grey.shade300),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: const BorderSide(color: Colors.deepPurple, width: 2),
      ),
      filled: true,
      fillColor: Colors.grey.shade50,
      contentPadding: const EdgeInsets.symmetric(vertical: 16, horizontal: 16),
    );
  }

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final isSmallScreen = screenWidth < 800;
    final isMediumScreen = screenWidth >= 800 && screenWidth < 1200;

    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [
            Colors.grey.shade50,
            Colors.grey.shade100,
          ],
        ),
      ),
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 80, horizontal: 20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Text(
              '📬 Get In Touch',
              style: Theme.of(context).textTheme.displayMedium?.copyWith(
                    color: Colors.deepPurple.shade800,
                    fontWeight: FontWeight.bold,
                  ),
          ),
          const SizedBox(height: 16),
            ConstrainedBox(
              constraints: const BoxConstraints(maxWidth: 800),
              child: Text(
                'Have a project in mind or want to discuss an opportunity? Reach out through the form or contact me directly.',
                textAlign: TextAlign.center,
                style: Theme.of(context).textTheme.titleLarge?.copyWith(
                      color: Colors.black54,
                      height: 1.5,
                    ),
              ),
            ),
            const SizedBox(height: 60),
            ConstrainedBox(
              constraints: const BoxConstraints(maxWidth: 1200),
              child: isSmallScreen
                  ? Column(
            children: [
                        _buildContactForm(),
                        const SizedBox(height: 40),
                        _buildContactInfo(),
                      ],
                    )
                  : Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Expanded(
                          flex: isMediumScreen ? 5 : 4,
                          child: _buildContactForm(),
                        ),
                        const SizedBox(width: 30),
                        Expanded(
                          flex: isMediumScreen ? 4 : 3,
                          child: _buildContactInfo(),
                        ),
                      ],
                    ),
            ),
          ],
        ),
      ),
    );
  }
}