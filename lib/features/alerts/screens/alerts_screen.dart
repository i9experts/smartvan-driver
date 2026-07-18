import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../core/network/api_service.dart';
import '../../../core/widgets/voice_recorder_button.dart';

class AlertsScreen extends ConsumerStatefulWidget {
  const AlertsScreen({super.key});

  @override
  ConsumerState<AlertsScreen> createState() => _AlertsScreenState();
}

class _AlertsScreenState extends ConsumerState<AlertsScreen> {
  List<dynamic> _alerts = [];
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadAlerts();
  }

  Future<void> _loadAlerts() async {
    try {
      final response = await ApiService.get('/alert/getNotificationForDriver');
      if (response.statusCode == 200) {
        final raw = response.data;
        final data = raw is Map ? raw['data'] : null;
        setState(() => _alerts = raw is List
            ? raw
            : (data is List
                ? data
                : (data is Map ? (data['notifications'] ?? []) : [])));
      }
    } catch (e) {
    } finally {
      if (mounted) setState(() => _isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF0F3FF),
      body: Column(
        children: [
          // Header
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
                padding: const EdgeInsets.fromLTRB(20, 16, 20, 20),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text(
                      'Alerts',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 22,
                        fontWeight: FontWeight.bold,
                        fontFamily: 'Poppins',
                      ),
                    ),
                    GestureDetector(
                      onTap: () => _showSendAlertDialog(),
                      child: Container(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 14, vertical: 8),
                        decoration: BoxDecoration(
                          color: const Color(0xFFFFB800),
                          borderRadius: BorderRadius.circular(20),
                        ),
                        child: const Row(
                          children: [
                            Icon(Icons.send, color: Color(0xFF1B2B6B), size: 16),
                            SizedBox(width: 6),
                            Text(
                              'Send Alert',
                              style: TextStyle(
                                color: Color(0xFF1B2B6B),
                                fontSize: 13,
                                fontWeight: FontWeight.bold,
                                fontFamily: 'Poppins',
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

          // Alerts List
          Expanded(
            child: _isLoading
                ? const Center(
                    child: CircularProgressIndicator(
                        color: Color(0xFF1B2B6B)))
                : _alerts.isEmpty
                    ? _buildEmptyState()
                    : RefreshIndicator(
                        onRefresh: _loadAlerts,
                        color: const Color(0xFF1B2B6B),
                        child: ListView.builder(
                          padding: const EdgeInsets.all(16),
                          itemCount: _alerts.length,
                          itemBuilder: (context, index) {
                            return _buildAlertCard(_alerts[index]);
                          },
                        ),
                      ),
          ),
        ],
      ),
    );
  }

  Widget _buildEmptyState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            width: 80,
            height: 80,
            decoration: BoxDecoration(
              color: const Color(0xFF1B2B6B).withOpacity(0.1),
              shape: BoxShape.circle,
            ),
            child: const Icon(Icons.notifications_off_outlined,
                size: 40, color: Color(0xFF1B2B6B)),
          ),
          const SizedBox(height: 16),
          const Text(
            'No Alerts',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: Color(0xFF1A1A2E),
              fontFamily: 'Poppins',
            ),
          ),
          const SizedBox(height: 8),
          const Text(
            'No alerts at the moment',
            style: TextStyle(
              fontSize: 13,
              color: Color(0xFF8A94A6),
              fontFamily: 'Poppins',
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildAlertCard(Map<String, dynamic> alert) {
    final String type = (alert['type'] ?? 'info').toString().toLowerCase();
    final String title = alert['title'] ?? alert['message'] ?? 'Alert';
    final String body = alert['description'] ?? alert['body'] ?? '';
    final String time = alert['createdAt'] ?? '';

    Color alertColor;
    IconData alertIcon;
    Color bgColor;

    switch (type) {
      case 'sos':
      case 'emergency':
        alertColor = const Color(0xFFFF4B4B);
        alertIcon = Icons.emergency_outlined;
        bgColor = const Color(0xFFFF4B4B).withOpacity(0.1);
        break;
      case 'payment':
        alertColor = const Color(0xFF27AE60);
        alertIcon = Icons.payment_outlined;
        bgColor = const Color(0xFF27AE60).withOpacity(0.1);
        break;
      case 'trip':
      case 'new_trip':
        alertColor = const Color(0xFF1B2B6B);
        alertIcon = Icons.directions_bus_outlined;
        bgColor = const Color(0xFF1B2B6B).withOpacity(0.1);
        break;
      case 'profile':
        alertColor = const Color(0xFF27AE60);
        alertIcon = Icons.verified_outlined;
        bgColor = const Color(0xFF27AE60).withOpacity(0.1);
        break;
      default:
        alertColor = const Color(0xFFFFB800);
        alertIcon = Icons.notifications_outlined;
        bgColor = const Color(0xFFFFB800).withOpacity(0.1);
    }

    return GestureDetector(
      onTap: () => context.go('/alert-detail', extra: alert),
      child: Container(
        margin: const EdgeInsets.only(bottom: 12),
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
        child: Padding(
          padding: const EdgeInsets.all(14),
          child: Row(
            children: [
              Container(
                width: 46,
                height: 46,
                decoration: BoxDecoration(
                  color: bgColor,
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Icon(alertIcon, color: alertColor, size: 22),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      title,
                      style: const TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.bold,
                        color: Color(0xFF1A1A2E),
                        fontFamily: 'Poppins',
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                    if (body.isNotEmpty) ...[
                      const SizedBox(height: 4),
                      Text(
                        body,
                        style: const TextStyle(
                          fontSize: 12,
                          color: Color(0xFF8A94A6),
                          fontFamily: 'Poppins',
                        ),
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ],
                    if (time.isNotEmpty) ...[
                      const SizedBox(height: 6),
                      Text(
                        _formatTime(time),
                        style: const TextStyle(
                          fontSize: 11,
                          color: Color(0xFF8A94A6),
                          fontFamily: 'Poppins',
                        ),
                      ),
                    ],
                  ],
                ),
              ),
              const Icon(Icons.arrow_forward_ios,
                  size: 14, color: Color(0xFF8A94A6)),
            ],
          ),
        ),
      ),
    );
  }

  String _formatTime(String time) {
    try {
      final dt = DateTime.parse(time).toLocal();
      final now = DateTime.now();
      final diff = now.difference(dt);
      if (diff.inMinutes < 60) return '${diff.inMinutes}m ago';
      if (diff.inHours < 24) return '${diff.inHours}h ago';
      return '${diff.inDays}d ago';
    } catch (e) {
      return time;
    }
  }

  void _showSendAlertDialog() {
    final messageController = TextEditingController();
    String? audioUrl;
    bool isSending = false;

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => StatefulBuilder(
        builder: (context, setSheetState) => Padding(
          padding: EdgeInsets.only(
              bottom: MediaQuery.of(context).viewInsets.bottom),
          child: Container(
            decoration: const BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.only(
                topLeft: Radius.circular(24),
                topRight: Radius.circular(24),
              ),
            ),
            padding: const EdgeInsets.all(24),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  width: 40,
                  height: 4,
                  decoration: BoxDecoration(
                    color: const Color(0xFFEAECF0),
                    borderRadius: BorderRadius.circular(2),
                  ),
                ),
                const SizedBox(height: 16),
                const Text(
                  'Send Alert',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: Color(0xFF1A1A2E),
                    fontFamily: 'Poppins',
                  ),
                ),
                const SizedBox(height: 4),
                const Text(
                  'Type a message or record a voice note for your school admin.',
                  style: TextStyle(
                    fontSize: 12,
                    color: Color(0xFF8A94A6),
                    fontFamily: 'Poppins',
                  ),
                ),
                const SizedBox(height: 16),
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Expanded(
                      child: TextFormField(
                        controller: messageController,
                        maxLines: 3,
                        decoration: InputDecoration(
                          hintText: 'Enter your message... (optional if recording)',
                          hintStyle: const TextStyle(
                              color: Color(0xFF8A94A6), fontFamily: 'Poppins'),
                          filled: true,
                          fillColor: const Color(0xFFF5F6FA),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(12),
                            borderSide: BorderSide.none,
                          ),
                        ),
                      ),
                    ),
                    VoiceRecorderButton(
                      onUploaded: (url) => setSheetState(() => audioUrl = url),
                    ),
                  ],
                ),
                if (audioUrl != null)
                  Padding(
                    padding: const EdgeInsets.only(top: 8),
                    child: Row(
                      children: const [
                        Icon(Icons.check_circle, color: Color(0xFF27AE60), size: 16),
                        SizedBox(width: 6),
                        Text('Voice note attached',
                            style: TextStyle(
                                color: Color(0xFF27AE60),
                                fontFamily: 'Poppins',
                                fontSize: 12)),
                      ],
                    ),
                  ),
                const SizedBox(height: 16),
                SizedBox(
                  width: double.infinity,
                  height: 52,
                  child: ElevatedButton(
                    onPressed: isSending
                        ? null
                        : () async {
                            final message = messageController.text.trim();
                            if (message.isEmpty && audioUrl == null) {
                              ScaffoldMessenger.of(context).showSnackBar(
                                const SnackBar(
                                  content: Text('Type a message or record a voice note first.'),
                                  backgroundColor: Color(0xFFFF4B4B),
                                ),
                              );
                              return;
                            }
                            setSheetState(() => isSending = true);
                            try {
                              await ApiService.post('/alert/sendAlertByDriver', {
                                if (message.isNotEmpty) 'message': message,
                                if (audioUrl != null) 'audioUrl': audioUrl,
                              });
                              if (context.mounted) Navigator.pop(context);
                              if (mounted) {
                                ScaffoldMessenger.of(context).showSnackBar(
                                  const SnackBar(
                                    content: Text('Alert sent to your school admin!'),
                                    backgroundColor: Color(0xFF27AE60),
                                    behavior: SnackBarBehavior.floating,
                                  ),
                                );
                              }
                            } catch (e) {
                              setSheetState(() => isSending = false);
                              ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(
                                  content: Text('Failed to send alert: $e'),
                                  backgroundColor: const Color(0xFFFF4B4B),
                                  behavior: SnackBarBehavior.floating,
                                ),
                              );
                            }
                          },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFFFFB800),
                      foregroundColor: const Color(0xFF1B2B6B),
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12)),
                    ),
                    child: isSending
                        ? const SizedBox(
                            width: 20,
                            height: 20,
                            child: CircularProgressIndicator(
                                strokeWidth: 2, color: Color(0xFF1B2B6B)),
                          )
                        : const Text(
                            'Send Alert',
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                              fontFamily: 'Poppins',
                            ),
                          ),
                  ),
                ),
                const SizedBox(height: 8),
              ],
            ),
          ),
        ),
      ),
    );
  }
}