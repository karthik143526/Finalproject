import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../services/api_service.dart';

class AdminFeedbackListScreen extends StatefulWidget {
  const AdminFeedbackListScreen({super.key});

  @override
  State<AdminFeedbackListScreen> createState() => _AdminFeedbackListScreenState();
}

class _AdminFeedbackListScreenState extends State<AdminFeedbackListScreen> {
  bool _loading = true;
  List<dynamic> _feedback = [];
  String? _errorMessage;

  static const Color bg = Color(0xFF142028);
  static const Color tealAccent = Color(0xFF00FFCC);
  static const Color tableRowBg = Color(0xFF0D181C);

  @override
  void initState() {
    super.initState();
    _loadFeedback();
  }

  Future<void> _loadFeedback() async {
    setState(() => _loading = true);
    final response = await ApiService.getAdminData();
    if (!mounted) return;

    if (response['status'] == 'success' && response['data'] != null) {
      setState(() {
        _feedback = response['data']['feedback'] ?? [];
        _loading = false;
      });
    } else {
      setState(() {
        _errorMessage = response['message'] ?? 'Failed to load feedback.';
        _loading = false;
      });
    }
  }

  Future<void> _handleDelete(int id) async {
    final response = await ApiService.performAdminAction('delete_feedback', id);
    if (!mounted) return;

    if (response['status'] == 'success') {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(response['message'] ?? 'Feedback deleted'), backgroundColor: Colors.green),
      );
      _loadFeedback();
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(response['message'] ?? 'Delete failed'), backgroundColor: Colors.redAccent),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: bg,
      body: SafeArea(
        child: _loading
            ? const Center(child: CircularProgressIndicator(color: tealAccent))
            : SingleChildScrollView(
                padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 40),
                child: Center(
                  child: ConstrainedBox(
                    constraints: const BoxConstraints(maxWidth: 1200),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        // Title
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(
                              '💬 ',
                              style: TextStyle(fontSize: 32),
                            ),
                            Text(
                              'Feedback Dashboard',
                              style: GoogleFonts.lora(
                                color: tealAccent,
                                fontSize: 32,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 30),

                        // Error message if any
                        if (_errorMessage != null)
                          Padding(
                            padding: const EdgeInsets.only(bottom: 20),
                            child: Text(_errorMessage!, style: const TextStyle(color: Colors.redAccent)),
                          ),

                        // Table
                        Container(
                          decoration: BoxDecoration(
                            border: Border.all(color: tealAccent, width: 1.5),
                          ),
                          child: SingleChildScrollView(
                            scrollDirection: Axis.horizontal,
                            child: DataTable(
                              headingRowColor: WidgetStateProperty.all(tealAccent),
                              dataRowColor: WidgetStateProperty.all(tableRowBg),
                              dividerThickness: 1,
                              columnSpacing: 30,
                              horizontalMargin: 20,
                              border: TableBorder.all(color: tealAccent, width: 1),
                              headingTextStyle: GoogleFonts.lora(
                                color: Colors.black,
                                fontWeight: FontWeight.bold,
                                fontSize: 15,
                              ),
                              dataTextStyle: GoogleFonts.lora(
                                color: Colors.white,
                                fontSize: 14,
                              ),
                              columns: const [
                                DataColumn(label: Text('ID')),
                                DataColumn(label: Text('Name')),
                                DataColumn(label: Text('Rating')),
                                DataColumn(label: Text('Drawback')),
                                DataColumn(label: Text('Description')),
                                DataColumn(label: Text('Date')),
                                DataColumn(label: Text('Action')),
                              ],
                              rows: _feedback.map((row) {
                                final id = int.parse(row['id'].toString());

                                return DataRow(
                                  cells: [
                                    DataCell(Center(child: Text(row['id'].toString()))),
                                    DataCell(Center(child: Text(row['name'].toString()))),
                                    DataCell(Center(child: Text('⭐ ${row['rating']}'))),
                                    DataCell(Center(child: Text(row['drawback_option'].toString()))),
                                    DataCell(Center(child: ConstrainedBox(constraints: const BoxConstraints(maxWidth: 250), child: Text(row['drawback_text'].toString(), overflow: TextOverflow.ellipsis, maxLines: 2)))),
                                    DataCell(Center(child: Text(row['created_at'].toString()))),
                                    DataCell(
                                      Center(
                                        child: Row(
                                          mainAxisSize: MainAxisSize.min,
                                          children: [
                                            _ActionButton(
                                              label: 'Remove',
                                              bgColor: Colors.red,
                                              textColor: Colors.white,
                                              onTap: () => _handleDelete(id),
                                            ),
                                          ],
                                        ),
                                      ),
                                    ),
                                  ],
                                );
                              }).toList(),
                            ),
                          ),
                        ),
                        const SizedBox(height: 30),

                        // Go Back Button
                        ElevatedButton.icon(
                          onPressed: () => Navigator.pop(context),
                          icon: const Icon(Icons.arrow_back, color: Colors.black, size: 18),
                          label: Text(
                            'Go Back',
                            style: GoogleFonts.lora(
                              color: Colors.black,
                              fontWeight: FontWeight.bold,
                              fontSize: 16,
                            ),
                          ),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: tealAccent,
                            padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(25),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
      ),
    );
  }
}

class _ActionButton extends StatelessWidget {
  final String label;
  final Color bgColor;
  final Color textColor;
  final VoidCallback onTap;

  const _ActionButton({
    required this.label,
    required this.bgColor,
    required this.textColor,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
        decoration: BoxDecoration(
          color: bgColor,
          borderRadius: BorderRadius.circular(2),
        ),
        child: Text(
          label,
          style: TextStyle(
            color: textColor,
            fontSize: 12,
            fontWeight: FontWeight.w600,
          ),
        ),
      ),
    );
  }
}
