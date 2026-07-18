import 'dart:async';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:record/record.dart';
import 'package:path_provider/path_provider.dart';
import '../network/api_service.dart';

/// A simple record / stop / upload voice-note button. Calls [onUploaded]
/// with the resulting S3 URL once recording stops and the upload succeeds.
///
/// Built for drivers who may not be comfortable typing a message — used in
/// both the "Send Alert" and "Report an Issue" flows.
class VoiceRecorderButton extends StatefulWidget {
  final void Function(String url) onUploaded;
  final VoidCallback? onRecordingStarted;

  const VoiceRecorderButton({
    super.key,
    required this.onUploaded,
    this.onRecordingStarted,
  });

  @override
  State<VoiceRecorderButton> createState() => _VoiceRecorderButtonState();
}

class _VoiceRecorderButtonState extends State<VoiceRecorderButton> {
  final AudioRecorder _recorder = AudioRecorder();
  bool _isRecording = false;
  bool _isUploading = false;
  Duration _elapsed = Duration.zero;
  Timer? _timer;

  @override
  void dispose() {
    _timer?.cancel();
    _recorder.dispose();
    super.dispose();
  }

  Future<void> _startRecording() async {
    if (!await _recorder.hasPermission()) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text(
                'Microphone permission is required to record a voice note.'),
            backgroundColor: Color(0xFFFF4B4B),
          ),
        );
      }
      return;
    }

    final dir = await getTemporaryDirectory();
    final path =
        '${dir.path}/voice_note_${DateTime.now().millisecondsSinceEpoch}.m4a';
    await _recorder.start(const RecordConfig(encoder: AudioEncoder.aacLc), path: path);

    if (!mounted) return;
    setState(() {
      _isRecording = true;
      _elapsed = Duration.zero;
    });
    widget.onRecordingStarted?.call();

    _timer = Timer.periodic(const Duration(seconds: 1), (_) {
      if (mounted) setState(() => _elapsed += const Duration(seconds: 1));
    });
  }

  Future<void> _stopAndUpload() async {
    _timer?.cancel();
    final path = await _recorder.stop();
    if (mounted) setState(() => _isRecording = false);
    if (path == null) return;

    if (mounted) setState(() => _isUploading = true);
    try {
      final url = await ApiService.uploadImage(File(path));
      if (url != null) {
        widget.onUploaded(url);
      } else if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Voice note upload failed. Please try again.'),
            backgroundColor: Color(0xFFFF4B4B),
          ),
        );
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Voice note upload failed: $e'),
            backgroundColor: const Color(0xFFFF4B4B),
          ),
        );
      }
    } finally {
      if (mounted) setState(() => _isUploading = false);
    }
  }

  String _formatDuration(Duration d) {
    final m = d.inMinutes.toString().padLeft(2, '0');
    final s = (d.inSeconds % 60).toString().padLeft(2, '0');
    return '$m:$s';
  }

  @override
  Widget build(BuildContext context) {
    if (_isUploading) {
      return const Padding(
        padding: EdgeInsets.all(8),
        child: SizedBox(
          width: 20,
          height: 20,
          child: CircularProgressIndicator(strokeWidth: 2),
        ),
      );
    }
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        if (_isRecording)
          Padding(
            padding: const EdgeInsets.only(right: 8),
            child: Text(
              _formatDuration(_elapsed),
              style: const TextStyle(
                color: Color(0xFFFF4B4B),
                fontFamily: 'Poppins',
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        IconButton(
          icon: Icon(
            _isRecording ? Icons.stop_circle : Icons.mic_none,
            color: _isRecording ? const Color(0xFFFF4B4B) : const Color(0xFF1B2B6B),
            size: 28,
          ),
          onPressed: _isRecording ? _stopAndUpload : _startRecording,
          tooltip: _isRecording ? 'Stop recording' : 'Record a voice note',
        ),
      ],
    );
  }
}
