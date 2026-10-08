import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../core/network/api_service.dart';

class FeeCollectionScreen extends ConsumerStatefulWidget {
  const FeeCollectionScreen({super.key});

  @override
  ConsumerState<FeeCollectionScreen> createState() => _FeeCollectionScreenState();
}

class _FeeCollectionScreenState extends ConsumerState<FeeCollectionScreen> {
  List<dynamic> _students = [];
  bool _isLoading = true;
  String? _error;
  String? _payingKidId;

  @override
  void initState() {
    super.initState();
    _loadStudents();
  }

  Future<void> _loadStudents() async {
    setState(() {
      _isLoading = true;
      _error = null;
    });
    try {
      final response = await ApiService.get('/fees/driver-students');
      final raw = response.data;
      final data = raw is Map ? raw['data'] : null;
      setState(() {
        _students = data is List ? data : [];
      });
    } catch (e) {
      setState(() => _error = 'Could not load students. Pull down to try again.');
    } finally {
      if (mounted) setState(() => _isLoading = false);
    }
  }

  Future<void> _collectPayment(Map<String, dynamic> student) async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Confirm Payment'),
        content: Text(
          'Mark ${student['fullname']}\'s transport fee as paid (cash collected)?',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () => Navigator.pop(context, true),
            style: ElevatedButton.styleFrom(backgroundColor: const Color(0xFF27AE60)),
            child: const Text('Confirm', style: TextStyle(color: Colors.white)),
          ),
        ],
      ),
    );
    if (confirmed != true) return;

    setState(() => _payingKidId = student['kidId']);
    try {
      await ApiService.post('/fees/record-payment', {
        'kidId': student['kidId'],
        'month': student['month'],
        'paymentMethod': 'cash',
      });
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Payment recorded for ${student['fullname']}'),
            backgroundColor: const Color(0xFF27AE60),
            behavior: SnackBarBehavior.floating,
          ),
        );
      }
      await _loadStudents();
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Failed to record payment: $e'),
            backgroundColor: const Color(0xFFFF4B4B),
            behavior: SnackBarBehavior.floating,
          ),
        );
      }
    } finally {
      if (mounted) setState(() => _payingKidId = null);
    }
  }

  Widget _statusBadge(String status) {
    late Color bg;
    late Color fg;
    late String label;
    switch (status) {
      case 'paid':
        bg = const Color(0xFFE8F8EE);
        fg = const Color(0xFF27AE60);
        label = 'Paid';
        break;
      case 'overdue':
        bg = const Color(0xFFFDEAEA);
        fg = const Color(0xFFFF4B4B);
        label = 'Overdue';
        break;
      case 'pending':
        bg = const Color(0xFFFFF6E5);
        fg = const Color(0xFFFFB800);
        label = 'Pending';
        break;
      default:
        bg = const Color(0xFFF0F0F0);
        fg = const Color(0xFF8A94A6);
        label = 'Not Set Up';
    }
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
      decoration: BoxDecoration(color: bg, borderRadius: BorderRadius.circular(20)),
      child: Text(label,
          style: TextStyle(color: fg, fontSize: 12, fontWeight: FontWeight.w600, fontFamily: 'Poppins')),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF0F3FF),
      appBar: AppBar(
        backgroundColor: const Color(0xFF1B3B69),
        title: const Text('Fee Collection',
            style: TextStyle(color: Colors.white, fontFamily: 'Poppins', fontWeight: FontWeight.bold)),
        iconTheme: const IconThemeData(color: Colors.white),
      ),
      body: RefreshIndicator(
        onRefresh: _loadStudents,
        child: _isLoading
            ? const Center(child: CircularProgressIndicator())
            : _error != null
                ? ListView(
                    children: [
                      const SizedBox(height: 120),
                      Icon(Icons.error_outline, size: 48, color: Colors.grey[400]),
                      const SizedBox(height: 12),
                      Center(
                        child: Text(_error!,
                            style: const TextStyle(color: Color(0xFF8A94A6), fontFamily: 'Poppins')),
                      ),
                    ],
                  )
                : _students.isEmpty
                    ? ListView(
                        children: const [
                          SizedBox(height: 120),
                          Icon(Icons.groups_outlined, size: 48, color: Color(0xFF8A94A6)),
                          SizedBox(height: 12),
                          Center(
                            child: Text('No students assigned to your van yet.',
                                style: TextStyle(color: Color(0xFF8A94A6), fontFamily: 'Poppins')),
                          ),
                        ],
                      )
                    : ListView.builder(
                        padding: const EdgeInsets.all(16),
                        itemCount: _students.length,
                        itemBuilder: (context, index) {
                          final s = _students[index];
                          final isPaid = s['status'] == 'paid';
                          final isBusy = _payingKidId == s['kidId'];
                          return Container(
                            margin: const EdgeInsets.only(bottom: 12),
                            padding: const EdgeInsets.all(14),
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(14),
                              boxShadow: [
                                BoxShadow(
                                    color: Colors.black.withOpacity(0.03),
                                    blurRadius: 8,
                                    offset: const Offset(0, 2)),
                              ],
                            ),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Row(
                                  children: [
                                    CircleAvatar(
                                      radius: 22,
                                      backgroundColor: const Color(0xFF1B3B69).withOpacity(0.1),
                                      backgroundImage:
                                          s['image'] != null ? NetworkImage(s['image']) : null,
                                      child: s['image'] == null
                                          ? Text(
                                              (s['fullname'] ?? '?').toString().isNotEmpty
                                                  ? s['fullname'][0].toString().toUpperCase()
                                                  : '?',
                                              style: const TextStyle(
                                                  color: Color(0xFF1B3B69), fontWeight: FontWeight.bold),
                                            )
                                          : null,
                                    ),
                                    const SizedBox(width: 12),
                                    Expanded(
                                      child: Column(
                                        crossAxisAlignment: CrossAxisAlignment.start,
                                        children: [
                                          Text(s['fullname'] ?? 'Unknown',
                                              style: const TextStyle(
                                                  fontWeight: FontWeight.bold,
                                                  fontFamily: 'Poppins',
                                                  fontSize: 15)),
                                          if (s['grade'] != null)
                                            Text('Grade ${s['grade']}',
                                                style: const TextStyle(
                                                    color: Color(0xFF8A94A6),
                                                    fontSize: 12,
                                                    fontFamily: 'Poppins')),
                                        ],
                                      ),
                                    ),
                                    _statusBadge(s['status'] ?? 'not_generated'),
                                  ],
                                ),
                                if (s['amount'] != null) ...[
                                  const SizedBox(height: 10),
                                  Text(
                                    '${s['currency'] ?? 'PKR'} ${s['amount']}',
                                    style: const TextStyle(
                                        fontWeight: FontWeight.bold,
                                        fontSize: 16,
                                        fontFamily: 'Poppins',
                                        color: Color(0xFF1B3B69)),
                                  ),
                                ],
                                if (!isPaid && s['status'] != 'not_generated') ...[
                                  const SizedBox(height: 10),
                                  SizedBox(
                                    width: double.infinity,
                                    height: 42,
                                    child: ElevatedButton(
                                      onPressed: isBusy ? null : () => _collectPayment(s),
                                      style: ElevatedButton.styleFrom(
                                        backgroundColor: const Color(0xFF27AE60),
                                        shape: RoundedRectangleBorder(
                                            borderRadius: BorderRadius.circular(10)),
                                      ),
                                      child: isBusy
                                          ? const SizedBox(
                                              width: 18,
                                              height: 18,
                                              child: CircularProgressIndicator(
                                                  strokeWidth: 2, color: Colors.white),
                                            )
                                          : const Text('Mark as Paid (Cash)',
                                              style: TextStyle(
                                                  color: Colors.white,
                                                  fontFamily: 'Poppins',
                                                  fontWeight: FontWeight.w600)),
                                    ),
                                  ),
                                ],
                              ],
                            ),
                          );
                        },
                      ),
      ),
    );
  }
}
