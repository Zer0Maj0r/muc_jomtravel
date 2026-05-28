import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:muc_jomtravel/src/model/models.dart';
import 'package:muc_jomtravel/src/service/services.dart';
import 'package:muc_jomtravel/src/shared/utils/validator.dart';
import 'package:muc_jomtravel/src/shared/theme/app_colors.dart';
import 'package:uuid/uuid.dart';

import '../../shared/utils/time_converter.dart';

class ManagePackageForm extends StatefulWidget {
  final Package? package; // If null, we are adding new package

  const ManagePackageForm({super.key, this.package});

  @override
  State<ManagePackageForm> createState() => _ManagePackageFormState();
}

class _ManagePackageFormState extends State<ManagePackageForm> {
  final _formKey = GlobalKey<FormState>();
  final AdminService _adminService = AdminService();

  // Controllers
  final _titleController = TextEditingController();
  final _descriptionController = TextEditingController();
  final _locationController = TextEditingController();
  final _durationController = TextEditingController();
  TimeOfDay _openingHoursController = TimeOfDay.now();
  TimeOfDay _closingHoursController = TimeOfDay.now();
  final _openingDayController = TextEditingController();
  final _closingDayController = TextEditingController();
  final _priceAdultController = TextEditingController();
  final _priceChildController = TextEditingController();
  final _contactController = TextEditingController();
  final _activitiesController = TextEditingController();

  // For images, we use a dynamic list of controllers
  final List<TextEditingController> _imageControllers = [];

  bool _isActive = true;
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    if (widget.package != null) {
      _initData(widget.package!);
    } else {
      // Start with one empty field for new package
      _imageControllers.add(TextEditingController());
    }
  }

  void _initData(Package package) {
    _titleController.text = package.title;
    _descriptionController.text = package.description;
    _locationController.text = package.location;
    _durationController.text = package.duration;
    _priceAdultController.text = package.priceAdult.toString();
    _priceChildController.text = package.priceChild.toString();
    _openingHoursController = stringToTimeOfDay(package.openingHours);
    _closingHoursController = stringToTimeOfDay(package.closingHours);
    _openingDayController.text = package.openingDay;
    _closingDayController.text = package.closingDay;
    _contactController.text = package.contactNumber;
    _activitiesController.text = package.activities.join(", ");

    // Populate image controllers
    if (package.image.isNotEmpty) {
      for (final url in package.image) {
        _imageControllers.add(TextEditingController(text: url));
      }
    } else {
      _imageControllers.add(TextEditingController());
    }
    _isActive = package.isActive;
  }

  @override
  void dispose() {
    _titleController.dispose();
    _descriptionController.dispose();
    _locationController.dispose();
    _durationController.dispose();
    _priceAdultController.dispose();
    _priceChildController.dispose();
    _contactController.dispose();
    for (var controller in _imageControllers) {
      controller.dispose();
    }
    super.dispose();
  }

  Future<void> _savePackage() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() => _isLoading = true);

    try {
      final String packageId = widget.package?.packageId ?? const Uuid().v4();
      final DateTime now = DateTime.now();

      final String formattedOpeningHours = formatTimeOfDay24(
        _openingHoursController,
      );
      final String formattedClosingHours = formatTimeOfDay24(
        _closingHoursController,
      );

      // Parse numbers
      final double priceAdult =
          double.tryParse(_priceAdultController.text) ?? 0.0;
      final double priceChild =
          double.tryParse(_priceChildController.text) ?? 0.0;

      // Handle Image List
      final List<String> images = _imageControllers
          .map((c) => c.text.trim())
          .where((text) => text.isNotEmpty)
          .toList();

      final Package package = Package(
        packageId: packageId,
        title: _titleController.text,
        description: _descriptionController.text,
        location: _locationController.text,
        duration: _durationController.text,
        priceAdult: priceAdult,
        priceChild: priceChild,
        openingHours: formattedOpeningHours,
        closingHours: formattedClosingHours,
        openingDay: _openingDayController.text,
        closingDay: _closingDayController.text,
        activities: _activitiesController.text
            .split(",")
            .map((e) => e.trim())
            .toList(),
        contactNumber: _contactController.text,
        image: images,
        isActive: _isActive,
        popularityScore: widget.package?.popularityScore ?? 0,
        createdAt: widget.package?.createdAt ?? Timestamp.fromDate(now),
        updatedAt: Timestamp.fromDate(now),
      );

      if (widget.package == null) {
        await _adminService.addPackage(package);
      } else {
        await _adminService.updatePackage(package);
      }

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Package saved successfully!')),
        );
        Navigator.pop(context);
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text('Error saving package: $e')));
      }
    } finally {
      setState(() => _isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final isEditing = widget.package != null;

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: Text(
          isEditing ? "Edit Package" : "New Package",
          style: const TextStyle(fontWeight: FontWeight.bold),
        ),
        backgroundColor: AppColors.cardBackground,
        foregroundColor: AppColors.textPrimary,
        elevation: 0,
        actions: [
          IconButton(
            onPressed: _savePackage,
            icon: const Icon(Icons.check, color: AppColors.primary),
          ),
        ],
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator(color: AppColors.primary))
          : SingleChildScrollView(
              padding: const EdgeInsets.all(16),
              child: Form(
                key: _formKey,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _buildSectionHeader("Basic Info"),
                    _buildTextField(_titleController, "Title", required: true),
                    const SizedBox(height: 10),
                    _buildTextField(
                      _descriptionController,
                      "Description",
                      maxLines: 3,
                      required: true,
                    ),
                    const SizedBox(height: 10),

                    _buildTextField(
                      _locationController,
                      "Location",
                      required: true,
                    ),
                    const SizedBox(height: 10),
                    _buildTextField(
                      _durationController,
                      "Duration (e.g. 2 Days)",
                      required: true,
                    ),
                    const SizedBox(height: 10),
                    _buildTextField(
                      _activitiesController,
                      "Activities (comma separated)",
                      required: true,
                    ),

                    const SizedBox(height: 20),
                    _buildSectionHeader("Pricing & Details"),
                    Row(
                      children: [
                        Expanded(
                          child: _buildTextField(
                            _priceAdultController,
                            "Adult Price (RM)",
                            isNumber: true,
                            required: true,
                          ),
                        ),
                        const SizedBox(width: 10),
                        Expanded(
                          child: _buildTextField(
                            _priceChildController,
                            "Child Price (RM)",
                            isNumber: true,
                            required: true,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 10),
                    Row(
                      children: [
                        Expanded(
                          child: _buildTimePickerField(
                            context: context,
                            label: "Opening Hour",
                            time: _openingHoursController,
                            onTimePicked: (t) =>
                                setState(() => _openingHoursController = t),
                          ),
                        ),
                        const SizedBox(width: 10),
                        Expanded(
                          child: _buildTimePickerField(
                            context: context,
                            label: "Closing Hour",
                            time: _closingHoursController,
                            onTimePicked: (t) =>
                                setState(() => _closingHoursController = t),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 10),
                    Row(
                      children: [
                        Expanded(
                          child: _buildTextField(
                            _openingDayController,
                            "Open Day (e.g. Mon)",
                            required: true,
                          ),
                        ),
                        const SizedBox(width: 10),
                        Expanded(
                          child: _buildTextField(
                            _closingDayController,
                            "Close Day (e.g. Sun)",
                            required: true,
                          ),
                        ),
                      ],
                    ),

                    const SizedBox(height: 20),
                    _buildSectionHeader("Contact & Media"),
                    _buildTextField(
                      _contactController,
                      "Contact Number",
                      isNumber: true,
                      required: true,
                    ),
                    const SizedBox(height: 10),
                    ...List.generate(_imageControllers.length, (index) {
                      return Padding(
                        padding: const EdgeInsets.only(bottom: 10),
                        child: Row(
                          children: [
                            Expanded(
                              child: _buildTextField(
                                _imageControllers[index],
                                "Image URL ${index + 1}",
                                required: true,
                              ),
                            ),
                            if (_imageControllers.length > 1)
                              IconButton(
                                icon: const Icon(
                                  Icons.remove_circle,
                                  color: Colors.red,
                                ),
                                onPressed: () {
                                  setState(() {
                                    final controller = _imageControllers
                                        .removeAt(index);
                                    controller.dispose();
                                  });
                                },
                              ),
                          ],
                        ),
                      );
                    }),
                    TextButton.icon(
                      onPressed: () {
                        setState(() {
                          _imageControllers.add(TextEditingController());
                        });
                      },
                      icon: const Icon(Icons.add, color: AppColors.primary),
                      label: const Text("Add Another Image", style: TextStyle(color: AppColors.primary)),
                    ),

                    const SizedBox(height: 20),

                    SwitchListTile(
                      title: const Text("Is Active", style: TextStyle(fontWeight: FontWeight.bold)),
                      subtitle: const Text("Visible to users", style: TextStyle(color: AppColors.textSecondary)),
                      value: _isActive,
                      activeColor: AppColors.primary,
                      onChanged: (val) => setState(() => _isActive = val),
                    ),

                    const SizedBox(height: 30),
                    SizedBox(
                      width: double.infinity,
                      height: 56,
                      child: ElevatedButton(
                        onPressed: _savePackage,
                        style: ElevatedButton.styleFrom(
                          backgroundColor: AppColors.primary,
                          foregroundColor: Colors.white,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(16),
                          ),
                          elevation: 0,
                        ),
                        child: Text(
                          isEditing ? "Update Package" : "Create Package",
                          style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
    );
  }

  Widget _buildSectionHeader(String title) {
    return Padding(
      padding: const EdgeInsets.only(top: 16, bottom: 12),
      child: Text(
        title.toUpperCase(),
        style: const TextStyle(
          fontSize: 12,
          fontWeight: FontWeight.w900,
          color: AppColors.primary,
          letterSpacing: 1.5,
        ),
      ),
    );
  }

  Widget _buildTextField(
    TextEditingController controller,
    String label, {
    bool isNumber = false,
    bool required = false,
    int maxLines = 1,
  }) {
    return TextFormField(
      controller: controller,
      keyboardType: isNumber ? TextInputType.number : TextInputType.text,
      maxLines: maxLines,
      style: const TextStyle(color: AppColors.textPrimary),
      decoration: InputDecoration(
        labelText: label,
        labelStyle: const TextStyle(color: AppColors.textSecondary),
        filled: true,
        fillColor: AppColors.cardBackground,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide.none,
        ),
        contentPadding: const EdgeInsets.symmetric(
          horizontal: 16,
          vertical: 16,
        ),
      ),
      validator: required ? (val) => requiredField(val, label) : null,
    );
  }

  Widget _buildTimePickerField({
    required BuildContext context,
    required String label,
    required TimeOfDay time,
    required Function(TimeOfDay) onTimePicked,
  }) {
    return InkWell(
      onTap: () async {
        final TimeOfDay? picked = await showTimePicker(
          context: context,
          initialTime: time,
        );
        if (picked != null) {
          onTimePicked(picked);
        }
      },
      child: InputDecorator(
        decoration: InputDecoration(
          labelText: label,
          labelStyle: const TextStyle(color: AppColors.textSecondary),
          filled: true,
          fillColor: AppColors.cardBackground,
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: BorderSide.none,
          ),
          contentPadding: const EdgeInsets.symmetric(
            horizontal: 16,
            vertical: 16,
          ),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(time.format(context), style: const TextStyle(color: AppColors.textPrimary)),
            const Icon(Icons.access_time, size: 20, color: AppColors.primary),
          ],
        ),
      ),
    );
  }
}
