import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../services/api_service.dart';

class AdminRequestListScreen extends StatefulWidget {
  const AdminRequestListScreen({super.key});

  @override
  State<AdminRequestListScreen> createState() => _AdminRequestListScreenState();
}

class _AdminRequestListScreenState extends State<AdminRequestListScreen> {
  bool _loading = true;
  List<dynamic> _requests = [];
  String? _errorMessage;

  static const Color bg = Color(0xFF142028); // Dark background similar to screenshot
  static const Color tealAccent = Color(0xFF00FFCC); // Bright cyan/teal
  static const Color tableRowBg = Color(0xFF0D181C); // Very dark teal for rows

  @override
  void initState() {
    super.initState();
    _loadRequests();
  }

  Future<void> _loadRequests() async {
    setState(() => _loading = true);
    final response = await ApiService.getAdminData();
    if (!mounted) return;

    if (response['status'] == 'success' && response['data'] != null) {
      setState(() {
        _requests = response['data']['requests'] ?? [];
        _loading = false;
      });
    } else {
      setState(() {
        _errorMessage = response['message'] ?? 'Failed to load requests.';
        _loading = false;
      });
    }
  }

  Future<void> _handleAction(String action, int id) async {
    final response = await ApiService.performAdminAction(action, id);
    if (!mounted) return;

    if (response['status'] == 'success') {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(response['message'] ?? 'Action successful'), backgroundColor: Colors.green),
      );
      _loadRequests();
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(response['message'] ?? 'Action failed'), backgroundColor: Colors.redAccent),
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
                              '📊 ',
                              style: TextStyle(fontSize: 32),
                            ),
                            Text(
                              'Admin Dashboard',
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
                                DataColumn(label: Text('Tracking ID')),
                                DataColumn(label: Text('Name')),
                                DataColumn(label: Text('Address')),
                                DataColumn(label: Text('Phone')),
                                DataColumn(label: Text('Waste')),
                                DataColumn(label: Text('Date')),
                                DataColumn(label: Text('Status')),
                                DataColumn(label: Text('Action')),
                              ],
                              rows: _requests.map((row) {
                                final id = int.parse(row['id'].toString());
                                final status = row['status'].toString();

                                Color statusColor = Colors.orange; // Default Pending
                                if (status == 'Assigned') statusColor = Colors.yellow;
                                if (status == 'Completed') statusColor = Colors.green;

                                return DataRow(
                                  cells: [
                                    DataCell(Center(child: Text(row['id'].toString()))),
                                    DataCell(Center(child: Text(row['tracking_id'].toString()))),
                                    DataCell(Center(child: Text(row['name'].toString()))),
                                    DataCell(Center(child: ConstrainedBox(constraints: const BoxConstraints(maxWidth: 150), child: Text(row['address'].toString(), overflow: TextOverflow.ellipsis, maxLines: 2)))),
                                    DataCell(Center(child: Text(row['phone'].toString()))),
                                    DataCell(Center(child: Text(row['waste_type'].toString()))),
                                    DataCell(Center(child: Text(row['pickup_date'].toString()))),
                                    DataCell(
                                      Center(
                                        child: Text(
                                          status,
                                          style: TextStyle(
                                            color: statusColor,
                                            fontWeight: FontWeight.w600,
                                          ),
                                        ),
                                      ),
                                    ),
                                    DataCell(
                                      Center(
                                        child: Row(
                                          mainAxisSize: MainAxisSize.min,
                                          children: [
                                            _ActionButton(
                                              label: 'Assign',
                                              bgColor: Colors.orange,
                                              textColor: Colors.black,
                                              onTap: () => _handleAction('assign', id),
                                            ),
                                            const SizedBox(width: 4),
                                            _ActionButton(
                                              label: 'Complete',
                                              bgColor: Colors.green,
                                              textColor: Colors.white,
                                              onTap: () => _handleAction('complete', id),
                                            ),
                                            const SizedBox(width: 4),
                                            _ActionButton(
                                              label: 'Remove',
                                              bgColor: Colors.red,
                                              textColor: Colors.white,
                                              onTap: () => _handleAction('delete_request', id),
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
