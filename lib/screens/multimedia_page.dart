import 'dart:async';
import 'dart:io';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:record/record.dart';
import 'package:audioplayers/audioplayers.dart';
import 'package:permission_handler/permission_handler.dart';

class MultimediaPage extends StatefulWidget {
  const MultimediaPage({super.key});

  @override
  State<MultimediaPage> createState() => _MultimediaPageState();
}

class _MultimediaPageState extends State<MultimediaPage> {
  final ImagePicker _picker = ImagePicker();
  final AudioRecorder _recorder = AudioRecorder();
  final AudioPlayer _player = AudioPlayer();

  XFile? _image;
  int? _imageSize; // taille en octets (bonus)
  String? _audioPath;
  bool _recording = false;
  bool _busy = false;
  bool _micBlocked = false; // permission définitivement refusée (bonus)

  Timer? _timer; // compteur de durée (bonus)
  int _seconds = 0;

  void _message(String text) {
    if (!mounted) return;
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(text)),
    );
  }

  String _formatDuration(int s) {
    final m = (s ~/ 60).toString().padLeft(2, '0');
    final r = (s % 60).toString().padLeft(2, '0');
    return '$m:$r';
  }

  Future<void> _chooseImage(ImageSource source) async {
    if (_busy) return;
    setState(() => _busy = true);
    try {
      final XFile? selected = await _picker.pickImage(
        source: source,
        imageQuality: 75,
      );
      if (!mounted) return;
      if (selected == null) {
        _message('Sélection annulée.');
      } else {
        final size = await selected.length();
        if (!mounted) return;
        setState(() {
          _image = selected;
          _imageSize = size;
        });
      }
    } catch (e) {
      _message('Impossible de récupérer l’image : $e');
    } finally {
      if (mounted) setState(() => _busy = false);
    }
  }

  Future<void> _startRecording() async {
    if (_busy || _recording) return;
    setState(() => _busy = true);
    try {
      // Sur mobile, permission_handler permet de gérer le refus.
      if (!kIsWeb && (Platform.isAndroid || Platform.isIOS)) {
        final status = await Permission.microphone.request();
        if (!status.isGranted) {
          if (mounted) {
            setState(() => _micBlocked = status.isPermanentlyDenied);
          }
          _message('Microphone non autorisé.');
          return;
        }
        if (mounted) setState(() => _micBlocked = false);
      }
      if (!await _recorder.hasPermission()) {
        _message('Autorisation microphone indisponible.');
        return;
      }
      if (kIsWeb) {
        _message('Enregistrement à tester sur Android/iOS.');
        return;
      }
      final path = '${Directory.systemTemp.path}/question_emsi.m4a';
      await _recorder.start(
        const RecordConfig(encoder: AudioEncoder.aacLc),
        path: path,
      );
      _seconds = 0;
      _timer?.cancel();
      _timer = Timer.periodic(const Duration(seconds: 1), (_) {
        if (mounted) setState(() => _seconds++);
      });
      if (mounted) setState(() => _recording = true);
    } catch (e) {
      _message('Enregistrement impossible : $e');
    } finally {
      if (mounted) setState(() => _busy = false);
    }
  }

  Future<void> _stopRecording() async {
    if (!_recording) return;
    _timer?.cancel();
    try {
      final path = await _recorder.stop();
      if (!mounted) return;
      setState(() {
        _recording = false;
        _audioPath = path;
      });
      _message(path == null
          ? 'Aucun fichier enregistré.'
          : 'Question vocale enregistrée.');
    } catch (e) {
      _message('Erreur lors de l’arrêt : $e');
      if (mounted) setState(() => _recording = false);
    }
  }

  Future<void> _playAudio() async {
    if (_audioPath == null) return;
    try {
      await _player.stop();
      await _player.play(DeviceFileSource(_audioPath!));
    } catch (e) {
      _message('Lecture impossible : $e');
    }
  }

  @override
  void dispose() {
    _timer?.cancel();
    _recorder.dispose();
    _player.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).colorScheme;

    // Bonus : on arrête proprement l'enregistrement avant de quitter la page.
    return PopScope(
      canPop: !_recording,
      onPopInvokedWithResult: (didPop, result) async {
        if (didPop) return;
        await _stopRecording();
        if (mounted) Navigator.pop(context);
      },
      child: Scaffold(
        appBar: AppBar(title: const Text('Espace multimédia')),
        body: ListView(
          padding: const EdgeInsets.all(16),
          children: [
            const Text('Image', style: TextStyle(fontSize: 20)),
            const SizedBox(height: 12),
            Wrap(spacing: 8, runSpacing: 8, children: [
              ElevatedButton.icon(
                style: ElevatedButton.styleFrom(minimumSize: const Size(0, 48)),
                onPressed:
                    _busy ? null : () => _chooseImage(ImageSource.camera),
                icon: const Icon(Icons.camera_alt),
                label: const Text('Prendre une photo'),
              ),
              OutlinedButton.icon(
                onPressed:
                    _busy ? null : () => _chooseImage(ImageSource.gallery),
                icon: const Icon(Icons.photo_library),
                label: const Text('Galerie'),
              ),
            ]),
            const SizedBox(height: 12),
            if (_image != null) ...[
              kIsWeb
                  ? Image.network(_image!.path, height: 190)
                  : Image.file(File(_image!.path), height: 190),
              const SizedBox(height: 8),
              Text('Fichier : ${_image!.name}'),
              if (_imageSize != null) Text('Taille : $_imageSize octets'),
              const SizedBox(height: 8),
              Align(
                alignment: Alignment.centerLeft,
                child: TextButton.icon(
                  onPressed: () => setState(() {
                    _image = null;
                    _imageSize = null;
                  }),
                  icon: const Icon(Icons.delete_outline),
                  label: const Text('Effacer l’image'),
                ),
              ),
            ],
            const Divider(height: 40),
            const Text('Question vocale', style: TextStyle(fontSize: 20)),
            const SizedBox(height: 12),
            ElevatedButton.icon(
              onPressed: _busy
                  ? null
                  : (_recording ? _stopRecording : _startRecording),
              icon: Icon(_recording ? Icons.stop : Icons.mic),
              label: Text(_recording
                  ? 'Arrêter (${_formatDuration(_seconds)})'
                  : 'Enregistrer'),
            ),
            if (_micBlocked) ...[
              const SizedBox(height: 12),
              Card(
                color: colors.errorContainer,
                child: Padding(
                  padding: const EdgeInsets.all(12),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Le microphone est bloqué. Autorisez-le dans les '
                        'réglages de l’application pour enregistrer.',
                        style: TextStyle(color: colors.onErrorContainer),
                      ),
                      const SizedBox(height: 8),
                      TextButton(
                        onPressed: openAppSettings,
                        child: const Text('Ouvrir les réglages'),
                      ),
                    ],
                  ),
                ),
              ),
            ],
            const SizedBox(height: 8),
            if (_audioPath != null)
              OutlinedButton.icon(
                onPressed: _playAudio,
                icon: const Icon(Icons.play_arrow),
                label: const Text('Écouter l’enregistrement'),
              ),
            if (_busy) const LinearProgressIndicator(),
          ],
        ),
      ),
    );
  }
}