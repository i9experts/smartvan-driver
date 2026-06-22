import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class AlertDetailScreen extends StatelessWidget {
  final Map<String, dynamic> alert;
  const AlertDetailScreen({super.key, required this.alert});

  @override
  Widget build(BuildContext context) {
    final String type = (alert['type'] ?? 'info').toString().toLowerCase();
    final String title = alert['title'] ?? alert['message'] ?? 'Alert';
    final String body = alert['description'] ?? alert['body'] ?? '';
    final String time = alert['createdAt'] ?? '';
    final String tripId = alert['tripId'] ?? '';

    Color alertColor;
    IconData alertIcon;

    switch (type) {
      case 'sos':
      case 'emergency':
        alertColor = const Color(0xFFFF4B4B);
        alertIcon = Icons.emergency_outlined;
        break;
      case 'payment':
        alertColor = const Color(0xFF27AE60);
        alertIcon = Icons.payment_outlined;
        break;
      case 'trip':
        alertColor = const Color(0xFF1B2B6B);
        alertIcon = Icons.directions_bus_outlined;
        break;
      default:
        alertColor = const Color(0xFFFFB800);
        alertIcon = Icons.notifications_outlined;
    }

    return Scaffold(
      backgroundColor: const Color(0xFFF0F3FF),
      body: Column(
        children: [
          Container(
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: [Color(0xFF1B2B6B), Color(0xFF2D4099)],
              ),
            ),
            child: SafeArea(
              bottom: false,
              child: Padding(
                padding: const EdgeInsets.fromLTRB(8, 8, 20, 20),
                child: Row(
                  children: [
                    IconButton(
                      icon: const Icon(Icons.arrow_back_ios,
                          color: Colors.white),
                      onPressed: () => Navigator.pop(context),
                    ),
                    const Text(
                      'Alert Details',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                        fontFamily: 'Poppins',
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
          Expanded(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Alert Icon & Title
                  Container(
                    width: double.infinity,
                    padding: const EdgeInsets.all(20),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(20),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.05),
                          blurRadius: 10,
                          offset: const Offset(0, 3),
                        ),
                      ],
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            Container(
                              width: 50,
                              height: 50,
                              decoration: BoxDecoration(
                                color: alertColor.withOpacity(0.1),
                                borderRadius: BorderRadius.circular(14),
                              ),
                              child: Icon(alertIcon,
                                  color: alertColor, size: 26),
                            ),
                            const SizedBox(width: 12),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    title,
                                    style: const TextStyle(
                                      fontSize: 16,
                                      fontWeight: FontWeight.bold,
                                      color: Color(0xFF1A1A2E),
                                      fontFamily: 'Poppins',
                                    ),
                                  ),
                                  if (time.isNotEmpty)
                                    Text(
                                      _formatTime(time),
                                      style: const TextStyle(
                                        fontSize: 12,
                                        color: Color(0xFF8A94A6),
                                        fontFamily: 'Poppins',
                                      ),
                                    ),
                                ],
                              ),
                            ),
                          ],
                        ),
                        if (body.isNotEmpty) ...[
                          const SizedBox(height: 16),
                          const Divider(color: Color(0xFFEAECF0)),
                          const SizedBox(height: 16),
                          Text(
                            body,
                            style: const TextStyle(
                              fontSize: 14,
                              color: Color(0xFF8A94A6),
                              fontFamily: 'Poppins',
                              height: 1.6,
                            ),
                          ),
                        ],
                      ],
                    ),
                  ),

                  // Trip Details if available
                  if (tripId.isNotEmpty) ...[
                    const SizedBox(height: 20),
                    const Text(
                      'Trip Details',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: Color(0xFF1A1A2E),
                        fontFamily: 'Poppins',
                      ),
                    ),
                    const SizedBox(height: 12),
                    Container(
                      padding: const EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(16),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withOpacity(0.05),
                            blurRadius: 10,
                            offset: const Offset(0, 3),
                          ),
                        ],
                      ),
                      child: Column(
                        children: [
                          _buildDetailRow('Date',
                              alert['date'] ?? '—'),
                          const Divider(color: Color(0xFFEAECF0)),
                          _buildDetailRow('Shift',
                              alert['shift'] ?? '—'),
                          const Divider(color: Color(0xFFEAECF0)),
                          _buildDetailRow('Start Time',
                              alert['startTime'] ?? '—'),
                        ],
                      ),
                    ),
                    const SizedBox(height: 20),
                    SizedBox(
                      width: double.infinity,
                      height: 52,
                      child: ElevatedButton(
                        onPressed: () => context.go('/home'),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: const Color(0xFFFFB800),
                          foregroundColor: const Color(0xFF1B2B6B),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(14),
                          ),
                          elevation: 0,
                        ),
                        child: const Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(
                              'View Trip',
                              style: TextStyle(
                                fontSize: 15,
                                fontWeight: FontWeight.bold,
                                fontFamily: 'Poppins',
                              ),
                            ),
                            SizedBox(width: 8),
                            Icon(Icons.arrow_forward, size: 18),
                          ],
                        ),
                      ),
                    ),
                  ],
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDetailRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 4),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            label,
            style: const TextStyle(
              fontSize: 13,
              color: Color(0xFF8A94A6),
              fontFamily: 'Poppins',
            ),
          ),
          Text(
            value,
            style: const TextStyle(
              fontSize: 13,
              fontWeight: FontWeight.w600,
              color: Color(0xFF1A1A2E),
              fontFamily: 'Poppins',
            ),
          ),
        ],
      ),
    );
  }

  String _formatTime(String time) {
    try {
      final dt = DateTime.parse(time).toLocal();
      return '${dt.day} ${_month(dt.month)} ${dt.year} — ${dt.hour.toString().padLeft(2, '0')}:${dt.minute.toString().padLeft(2, '0')} ${dt.hour >= 12 ? 'PM' : 'AM'}';
    } catch (e) {
      return time;
    }
  }

  String _month(int m) {
    const months = [
      'Jan', 'Feb', 'Mar', 'Apr', 'May', 'Jun',
      'Jul', 'Aug', 'Sep', 'Oct', 'Nov', 'Dec'
    ];
    return months[m - 1];
  }
}