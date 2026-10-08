import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class PageForm extends StatefulWidget {
  const PageForm({super.key});

  @override
  State<PageForm> createState() => _PageFormState();
}

class _PageFormState extends State<PageForm> {
  // Text Controllers
  final _fullNameController = TextEditingController();
  final _ageController = TextEditingController();
  final _genderController = TextEditingController();
  final _birthdateController = TextEditingController();
  final _contactController = TextEditingController();
  final _addressController = TextEditingController();
  final _schoolController = TextEditingController();
  final _courseController = TextEditingController();
  final _yearLevelController = TextEditingController();
  final _skillsController = TextEditingController();
  final _hobbiesController = TextEditingController();
  final _foodController = TextEditingController();

  bool _isLoading = false;

  // Soft Pastel Colors Palette
  final Color softBackground = const Color(0xFFF9F6FF); // Very soft lavender white
  final Color cardBackground = Colors.white;
  final Color primaryPastel = const Color(0xFFB39DDB); // Soft Lilac / Purple
  final Color secondaryPastel = const Color(0xFFF8BBD0); // Soft Pink Accent
  final Color textColor = const Color(0xFF4A4A4A); // Soft Charcoal for readability

  @override
  void dispose() {
    _fullNameController.dispose();
    _ageController.dispose();
    _genderController.dispose();
    _birthdateController.dispose();
    _contactController.dispose();
    _addressController.dispose();
    _schoolController.dispose();
    _courseController.dispose();
    _yearLevelController.dispose();
    _skillsController.dispose();
    _hobbiesController.dispose();
    _foodController.dispose();
    super.dispose();
  }

  Future<void> _saveBiodata() async {
    setState(() => _isLoading = true);

    try {
      await FirebaseFirestore.instance.collection('biodata').add({
        'full_name': _fullNameController.text,
        'age': _ageController.text,
        'gender': _genderController.text,
        'birthdate': _birthdateController.text,
        'contact': _contactController.text,
        'address': _addressController.text,
        'school': _schoolController.text,
        'course': _courseController.text,
        'year_level': _yearLevelController.text,
        'skills': _skillsController.text,
        'hobbies': _hobbiesController.text,
        'favorite_food': _foodController.text,
        'created_at': FieldValue.serverTimestamp(),
      });

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: const Text('✨ Biodata saved successfully! ✨'),
            backgroundColor: primaryPastel,
            behavior: SnackBarBehavior.floating,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(15),
            ),
          ),
        );
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Failed to save: $e'),
            backgroundColor: Colors.pinkAccent.shade100,
          ),
        );
      }
    } finally {
      if (mounted) setState(() => _isLoading = false);
    }
  }

  // Reusable Helper for Soft Input Fields
  Widget _buildCuteTextField({
    required TextEditingController controller,
    required String labelText,
    required IconData icon,
    TextInputType keyboardType = TextInputType.text,
  }) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: TextField(
        controller: controller,
        keyboardType: keyboardType,
        style: TextStyle(color: textColor, fontSize: 14),
        decoration: InputDecoration(
          prefixIcon: Icon(icon, color: primaryPastel, size: 20),
          labelText: labelText,
          labelStyle: TextStyle(color: textColor.withOpacity(0.7), fontSize: 13),
          filled: true,
          fillColor: const Color(0xFFFAF8FF),
          contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(16),
            borderSide: BorderSide(color: primaryPastel.withOpacity(0.3), width: 1.2),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(16),
            borderSide: BorderSide(color: primaryPastel, width: 2),
          ),
        ),
      ),
    );
  }

  // Section Header Divider
  Widget _buildSectionTitle(String title, IconData icon) {
    return Padding(
      padding: const EdgeInsets.only(top: 16, bottom: 8),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(icon, color: primaryPastel, size: 18),
          const SizedBox(width: 8),
          Text(
            title,
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
              color: textColor,
              letterSpacing: 0.5,
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: softBackground,
      appBar: AppBar(
        title: const Text(
          'Student Biodata',
          style: TextStyle(fontWeight: FontWeight.w600, fontSize: 20),
        ),
        centerTitle: true,
        backgroundColor: primaryPastel,
        elevation: 0,
        foregroundColor: Colors.white,
      ),
      body: Center(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(20.0),
          child: ConstrainedBox(

            constraints: const BoxConstraints(maxWidth: 550),
            child: Card(
              elevation: 4,
              shadowColor: primaryPastel.withOpacity(0.2),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(24),
              ),
              color: cardBackground,
              child: Padding(
                padding: const EdgeInsets.all(24.0),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    // Subtitle
                    Text(
                      'Please fill out your details below',
                      style: TextStyle(
                        color: textColor.withOpacity(0.6),
                        fontSize: 13,
                        fontStyle: FontStyle.italic,
                      ),
                    ),
                    const SizedBox(height: 12),

                    // --- PERSONAL INFORMATION ---
                    _buildSectionTitle('Personal Info', Icons.person_outline_rounded),
                    _buildCuteTextField(
                      controller: _fullNameController,
                      labelText: 'Full Name',
                      icon: Icons.badge_outlined,
                    ),
                    Row(
                      children: [
                        Expanded(
                          child: _buildCuteTextField(
                            controller: _ageController,
                            labelText: 'Age',
                            icon: Icons.cake_outlined,
                            keyboardType: TextInputType.number,
                          ),
                        ),
                        const SizedBox(width: 10),
                        Expanded(
                          child: _buildCuteTextField(
                            controller: _genderController,
                            labelText: 'Gender',
                            icon: Icons.wc_outlined,
                          ),
                        ),
                      ],
                    ),
                    _buildCuteTextField(
                      controller: _birthdateController,
                      labelText: 'Birthdate (e.g., YYYY-MM-DD)',
                      icon: Icons.calendar_today_outlined,
                    ),
                    _buildCuteTextField(
                      controller: _contactController,
                      labelText: 'Contact Number',
                      icon: Icons.phone_outlined,
                      keyboardType: TextInputType.phone,
                    ),
                    _buildCuteTextField(
                      controller: _addressController,
                      labelText: 'Address',
                      icon: Icons.home_outlined,
                    ),

                    const Divider(height: 28, thickness: 1),

                    // --- EDUCATIONAL BACKGROUND ---
                    _buildSectionTitle('Education', Icons.school_outlined),
                    _buildCuteTextField(
                      controller: _schoolController,
                      labelText: 'School / University',
                      icon: Icons.account_balance_outlined,
                    ),
                    _buildCuteTextField(
                      controller: _courseController,
                      labelText: 'Course / Program',
                      icon: Icons.book_outlined,
                    ),
                    _buildCuteTextField(
                      controller: _yearLevelController,
                      labelText: 'Year Level',
                      icon: Icons.military_tech_outlined,
                    ),

                    const Divider(height: 28, thickness: 1),

                    // --- SKILLS & INTERESTS ---
                    _buildSectionTitle('Skills & Hobbies', Icons.favorite_border_rounded),
                    _buildCuteTextField(
                      controller: _skillsController,
                      labelText: 'Skills (e.g., Flutter, Design)',
                      icon: Icons.star_outline_rounded,
                    ),
                    _buildCuteTextField(
                      controller: _hobbiesController,
                      labelText: 'Hobbies & Interests',
                      icon: Icons.palette_outlined,
                    ),
                    _buildCuteTextField(
                      controller: _foodController,
                      labelText: 'Favorite Food',
                      icon: Icons.restaurant_outlined,
                    ),

                    const SizedBox(height: 24),

                    // --- SAVE BUTTON ---
                    SizedBox(
                      width: double.infinity,
                      height: 50,
                      child: ElevatedButton(
                        onPressed: _isLoading ? null : _saveBiodata,
                        style: ElevatedButton.styleFrom(
                          backgroundColor: primaryPastel,
                          foregroundColor: Colors.white,
                          elevation: 2,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(20),
                          ),
                        ),
                        child: _isLoading
                            ? const SizedBox(
                                height: 22,
                                width: 22,
                                child: CircularProgressIndicator(
                                  color: Colors.white,
                                  strokeWidth: 2.5,
                                ),
                              )
                            : const Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Icon(Icons.cloud_upload_rounded, size: 20),
                                  SizedBox(width: 8),
                                  Text(
                                    'Save Biodata to Firebase',
                                    style: TextStyle(
                                      fontSize: 15,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ],
                              ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}