import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../services/api_service.dart';
import 'dashboard_screen.dart';

class RequestScreen extends StatefulWidget {
  const RequestScreen({super.key});

  @override
  State<RequestScreen> createState() => _RequestScreenState();
}

class _RequestScreenState extends State<RequestScreen> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController nameController = TextEditingController();
  final TextEditingController phoneController = TextEditingController();
  final TextEditingController addressController = TextEditingController();
  DateTime? pickupDate;
  String wasteType = 'Dry Waste';
  bool _submitting = false;

  static const Color kBg = Color(0xFF030C0B);
  static const Color kPanel = Color(0xFF071410);
  static const Color kBorder = Color(0x1F06EFD4);
  static const Color kText = Color(0xFFE0FAF6);
  static const Color kMuted = Color(0xFF2E5E58);
  static const Color kAccent = Color(0xFF06EFD4);
  static const Color kAccent2 = Color(0xFF0EA5E9);

  Future<void> _selectDate() async {
    final picked = await showDatePicker(
      context: context,
      initialDate: pickupDate ?? DateTime.now(),
      firstDate: DateTime.now(),
      lastDate: DateTime(2035),
      builder: (context, child) {
        return Theme(
          data: Theme.of(context).copyWith(
            colorScheme: const ColorScheme.dark(
              primary: kAccent,
              onPrimary: Colors.black,
              surface: kPanel,
              onSurface: Colors.white,
            ),
          ),
          child: child!,
        );
      },
    );
    if (picked != null) {
      setState(() => pickupDate = picked);
    }
  }

  Future<void> _submitRequest() async {
    if (!_formKey.currentState!.validate()) return;
    if (pickupDate == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please select pickup date'), backgroundColor: Colors.redAccent),
      );
      return;
    }

    setState(() => _submitting = true);

    final formattedDate = "${pickupDate!.year}-${pickupDate!.month.toString().padLeft(2, '0')}-${pickupDate!.day.toString().padLeft(2, '0')}";

    final response = await ApiService.createRequest(
      name: nameController.text.trim(),
      address: addressController.text.trim(),
      phone: phoneController.text.trim(),
      wasteType: wasteType,
      pickupDate: formattedDate,
    );

    if (!mounted) return;
    setState(() => _submitting = false);

    if (response['status'] == 'success') {
      final trackingId = response['tracking_id'] ?? phoneController.text.trim();
      showDialog(
        context: context,
        builder: (context) => AlertDialog(
          backgroundColor: kPanel,
          title: const Text('✔ Request Submitted', style: TextStyle(color: kAccent)),
          content: Text(
            'Your pickup request is registered!\n\nTracking ID: $trackingId\nPickup Date: $formattedDate',
            style: const TextStyle(color: kText),
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(context);
                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(builder: (_) => const DashboardScreen()),
                );
              },
              child: const Text('OK', style: TextStyle(color: kAccent)),
            ),
          ],
        ),
      );
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(response['message'] ?? 'Failed to submit request'), backgroundColor: Colors.redAccent),
      );
    }
  }

  @override
  void dispose() {
    nameController.dispose();
    phoneController.dispose();
    addressController.dispose();
    super.dispose();
  }

  InputDecoration _fieldDecoration(String label, {Widget? prefix}) {
    return InputDecoration(
      labelText: label,
      labelStyle: const TextStyle(color: kMuted, fontSize: 12, letterSpacing: 0.5),
      prefixIcon: prefix,
      filled: true,
      fillColor: const Color(0x0D06EFD4),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: const BorderSide(color: Color(0x0DFFFFFF)),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: const BorderSide(color: kAccent),
      ),
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: const BorderSide(color: Color(0x0DFFFFFF)),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: kBg,
      body: Stack(
        children: [
          Container(
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: [Color(0xFF020A0A), Color(0xFF061516)],
              ),
            ),
          ),
          Positioned(
            top: -80,
            left: -80,
            child: Container(
              width: 320,
              height: 320,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: kAccent.withOpacity(0.08),
              ),
            ),
          ),
          Positioned(
            bottom: -100,
            right: -60,
            child: Container(
              width: 260,
              height: 260,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: kAccent2.withOpacity(0.07),
              ),
            ),
          ),
          Center(
            child: SingleChildScrollView(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 32),
              child: ConstrainedBox(
                constraints: const BoxConstraints(maxWidth: 520),
                child: Container(
                  decoration: BoxDecoration(
                    color: kPanel,
                    borderRadius: BorderRadius.circular(24),
                    border: Border.all(color: kBorder),
                    boxShadow: [
                      BoxShadow(color: Colors.black.withOpacity(0.45), blurRadius: 40, offset: const Offset(0, 12)),
                    ],
                  ),
                  child: Padding(
                    padding: const EdgeInsets.fromLTRB(36, 36, 36, 28),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Container(
                          width: double.infinity,
                          height: 2,
                          margin: const EdgeInsets.only(bottom: 28),
                          decoration: const BoxDecoration(
                            gradient: LinearGradient(colors: [Colors.transparent, kAccent, kAccent2, Colors.transparent]),
                          ),
                        ),
                        Row(
                          children: [
                            Container(
                              width: 8,
                              height: 8,
                              decoration: const BoxDecoration(color: kAccent, shape: BoxShape.circle),
                            ),
                            const SizedBox(width: 10),
                            Text('Collection System', style: GoogleFonts.unbounded(color: kAccent, fontSize: 10, fontWeight: FontWeight.w800, letterSpacing: 1.8)),
                          ],
                        ),
                        const SizedBox(height: 20),
                        Text.rich(
                          TextSpan(
                            children: [
                              const TextSpan(text: 'Waste ', style: TextStyle(color: kText, fontSize: 28, fontWeight: FontWeight.w900)),
                              TextSpan(text: 'Pickup', style: TextStyle(fontSize: 28, fontWeight: FontWeight.w900, foreground: Paint()..shader = const LinearGradient(colors: [kAccent, kAccent2]).createShader(Rect.fromLTWH(0, 0, 180, 0)))),
                              const TextSpan(text: '\nRequest', style: TextStyle(color: kText, fontSize: 28, fontWeight: FontWeight.w900)),
                            ],
                          ),
                        ),
                        const SizedBox(height: 10),
                        const Text('Schedule a doorstep collection in seconds.', style: TextStyle(color: kMuted, fontSize: 13, height: 1.6)),
                        const SizedBox(height: 32),
                        Form(
                          key: _formKey,
                          child: Column(
                            children: [
                              Row(
                                children: [
                                  Expanded(
                                    child: _buildField(
                                      label: '👤 Name',
                                      child: TextFormField(
                                        controller: nameController,
                                        style: const TextStyle(color: kText),
                                        decoration: _fieldDecoration('Full name', prefix: const Icon(Icons.person, color: kAccent)),
                                        validator: (value) => (value == null || value.trim().isEmpty) ? 'Name is required' : null,
                                      ),
                                    ),
                                  ),
                                  const SizedBox(width: 14),
                                  Expanded(
                                    child: _buildField(
                                      label: '📞 Phone',
                                      child: TextFormField(
                                        controller: phoneController,
                                        keyboardType: TextInputType.phone,
                                        maxLength: 10,
                                        style: const TextStyle(color: kText),
                                        decoration: _fieldDecoration('10 digits', prefix: const Icon(Icons.phone, color: kAccent)).copyWith(counterText: ''),
                                        validator: (value) {
                                          if (value == null || value.trim().isEmpty) return 'Phone is required';
                                          if (!RegExp(r'^[0-9]{10}$').hasMatch(value.trim())) return 'Enter valid 10 digit phone';
                                          return null;
                                        },
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                              const SizedBox(height: 16),
                              _buildField(
                                label: '📍 Address',
                                child: TextFormField(
                                  controller: addressController,
                                  style: const TextStyle(color: kText),
                                  maxLines: 3,
                                  decoration: _fieldDecoration('Street, area, city…', prefix: const Icon(Icons.location_on, color: kAccent)),
                                  validator: (value) => (value == null || value.trim().isEmpty) ? 'Address is required' : null,
                                ),
                              ),
                              const SizedBox(height: 16),
                              _buildField(
                                label: '🗑 Waste Type',
                                child: DropdownButtonFormField<String>(
                                  value: wasteType,
                                  dropdownColor: kPanel,
                                  decoration: _fieldDecoration('Select waste type'),
                                  icon: const Icon(Icons.arrow_drop_down, color: kMuted),
                                  style: const TextStyle(color: kText),
                                  items: const [
                                    DropdownMenuItem(value: 'Dry Waste', child: Text('Dry Waste')),
                                    DropdownMenuItem(value: 'Wet Waste', child: Text('Wet Waste')),
                                    DropdownMenuItem(value: 'Plastic', child: Text('Plastic')),
                                    DropdownMenuItem(value: 'Mixed Waste', child: Text('Mixed Waste')),
                                  ],
                                  onChanged: (value) {
                                    if (value != null) setState(() => wasteType = value);
                                  },
                                ),
                              ),
                              const SizedBox(height: 16),
                              _buildField(
                                label: '📅 Pickup Date',
                                child: GestureDetector(
                                  onTap: _selectDate,
                                  child: AbsorbPointer(
                                    child: TextFormField(
                                      decoration: _fieldDecoration('Select date', prefix: const Icon(Icons.calendar_today, color: kAccent)).copyWith(
                                        hintText: pickupDate == null ? 'Pickup date' : '${pickupDate!.day}/${pickupDate!.month}/${pickupDate!.year}',
                                        hintStyle: const TextStyle(color: kMuted),
                                      ),
                                      validator: (_) => pickupDate == null ? 'Pickup date is required' : null,
                                    ),
                                  ),
                                ),
                              ),
                              const SizedBox(height: 24),
                              SizedBox(
                                width: double.infinity,
                                height: 52,
                                child: ElevatedButton(
                                  onPressed: _submitting ? null : _submitRequest,
                                  style: ElevatedButton.styleFrom(
                                    backgroundColor: kAccent,
                                    foregroundColor: Colors.black,
                                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                                    elevation: 0,
                                  ),
                                  child: _submitting
                                      ? const SizedBox(width: 20, height: 20, child: CircularProgressIndicator(color: Colors.black, strokeWidth: 2))
                                      : const Text(
                                          '🚀 SUBMIT REQUEST',
                                          style: TextStyle(fontWeight: FontWeight.bold, letterSpacing: 1),
                                        ),
                                ),
                              ),
                              const SizedBox(height: 14),
                              SizedBox(
                                width: double.infinity,
                                height: 50,
                                child: OutlinedButton(
                                  onPressed: () => Navigator.pushReplacement(
                                    context,
                                    MaterialPageRoute(builder: (_) => const DashboardScreen()),
                                  ),
                                  style: OutlinedButton.styleFrom(
                                    side: const BorderSide(color: Color(0x1FFFFFFF)),
                                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
                                  ),
                                  child: const Text('← Go Back', style: TextStyle(color: kMuted, fontWeight: FontWeight.w700, letterSpacing: 0.5)),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildField({required String label, required Widget child}) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label.toUpperCase(), style: const TextStyle(color: kMuted, fontSize: 10, fontWeight: FontWeight.w700, letterSpacing: 1.2)),
        const SizedBox(height: 8),
        child,
      ],
    );
  }
}
