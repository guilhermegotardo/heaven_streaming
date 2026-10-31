import 'dart:async';

import 'package:flutter/material.dart';
import 'package:video_player/video_player.dart';

class PlayerItem {
  final Uri videoUri;
  final String title;

  const PlayerItem({required this.videoUri, required this.title});
}

class PlayerPage extends StatefulWidget {
  /// Itens reproduzidos em sequência: ao terminar um, o próximo começa sozinho.
  final List<PlayerItem> playlist;
  final int initialIndex;

  const PlayerPage({
    super.key,
    required this.playlist,
    this.initialIndex = 0,
  });

  @override
  State<PlayerPage> createState() => _PlayerPageState();
}

class _PlayerPageState extends State<PlayerPage> {
  static const _seekStep = Duration(seconds: 10);
  static const _controlsTimeout = Duration(seconds: 3);
  static const _nextCountdownSeconds = 5;

  late VideoPlayerController _controller;
  bool _hasController = false;
  late int _index;
  bool _hasError = false;

  bool _showControls = true;
  Timer? _hideTimer;

  /// Evita reabrir a contagem depois que o usuário a cancelou.
  bool _endHandled = false;
  Timer? _nextTimer;
  int? _nextIn;

  PlayerItem get _current => widget.playlist[_index];
  bool get _hasNext => _index < widget.playlist.length - 1;

  @override
  void initState() {
    super.initState();
    _open(widget.initialIndex);
  }

  void _open(int index) {
    _cancelNext();
    if (_hasController) {
      final old = _controller;
      old.removeListener(_onControllerUpdate);
      // O VideoPlayer antigo ainda está na árvore até o próximo frame.
      WidgetsBinding.instance.addPostFrameCallback((_) => old.dispose());
    }

    _index = index;
    _hasError = false;
    _endHandled = false;
    _showControls = true;

    final controller = VideoPlayerController.networkUrl(_current.videoUri)
      ..addListener(_onControllerUpdate);
    _controller = controller;
    _hasController = true;
    _initialize(controller);
  }

  Future<void> _initialize(VideoPlayerController controller) async {
    try {
      await controller.initialize();
      if (!mounted || controller != _controller) return;
      await controller.play();
      _scheduleHide();
    } catch (_) {
      if (!mounted || controller != _controller) return;
      setState(() => _hasError = true);
    }
  }

  void _onControllerUpdate() {
    if (!mounted) return;
    final value = _controller.value;
    final ended = value.isInitialized &&
        value.duration > Duration.zero &&
        (value.isCompleted || value.position >= value.duration);

    if (ended && !_endHandled) {
      _endHandled = true;
      _hideTimer?.cancel();
      _showControls = true;
      if (_hasNext) _startNextCountdown();
    } else if (!ended) {
      _endHandled = false;
    }
    setState(() {});
  }

  @override
  void dispose() {
    _hideTimer?.cancel();
    _nextTimer?.cancel();
    _controller.removeListener(_onControllerUpdate);
    _controller.dispose();
    super.dispose();
  }

  // ---- Controles ----

  void _togglePlayPause() {
    if (_controller.value.isPlaying) {
      _controller.pause();
      _hideTimer?.cancel();
      setState(() => _showControls = true);
    } else {
      _cancelNext();
      if (_endHandled) _controller.seekTo(Duration.zero);
      _controller.play();
      _scheduleHide();
    }
  }

  void _stop() {
    _cancelNext();
    _controller.pause();
    _controller.seekTo(Duration.zero);
    _hideTimer?.cancel();
    setState(() => _showControls = true);
  }

  void _seekRelative(Duration offset) {
    final value = _controller.value;
    var target = value.position + offset;
    if (target < Duration.zero) target = Duration.zero;
    if (target > value.duration) target = value.duration;
    _controller.seekTo(target);
    _scheduleHide();
  }

  void _playNext() {
    if (!_hasNext) return;
    setState(() => _open(_index + 1));
  }

  void _playPrevious() {
    if (_index == 0) return;
    setState(() => _open(_index - 1));
  }

  // ---- Próximo episódio automático ----

  void _startNextCountdown() {
    _nextIn = _nextCountdownSeconds;
    _nextTimer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (!mounted) return;
      if (_nextIn! <= 1) {
        _playNext();
      } else {
        setState(() => _nextIn = _nextIn! - 1);
      }
    });
  }

  void _cancelNext() {
    _nextTimer?.cancel();
    _nextTimer = null;
    _nextIn = null;
  }

  // ---- Visibilidade dos controles ----

  void _scheduleHide() {
    _hideTimer?.cancel();
    setState(() => _showControls = true);
    _hideTimer = Timer(_controlsTimeout, () {
      if (mounted && _controller.value.isPlaying) {
        setState(() => _showControls = false);
      }
    });
  }

  void _onTapVideo() {
    if (_showControls && _controller.value.isPlaying) {
      _hideTimer?.cancel();
      setState(() => _showControls = false);
    } else {
      _scheduleHide();
    }
  }

  @override
  Widget build(BuildContext context) {
    final isReady = _controller.value.isInitialized;

    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        title: Text(_current.title),
      ),
      body: _hasError
          ? const Center(child: Text('Não foi possível reproduzir o vídeo.'))
          : !isReady
              ? const Center(child: CircularProgressIndicator())
              : MouseRegion(
                  onHover: (_) => _scheduleHide(),
                  child: GestureDetector(
                    behavior: HitTestBehavior.opaque,
                    onTap: _onTapVideo,
                    child: Stack(
                      fit: StackFit.expand,
                      children: [
                        Center(
                          child: AspectRatio(
                            aspectRatio: _controller.value.aspectRatio,
                            child: VideoPlayer(
                              _controller,
                              key: ValueKey(_controller),
                            ),
                          ),
                        ),
                        AnimatedOpacity(
                          opacity: _showControls ? 1 : 0,
                          duration: const Duration(milliseconds: 200),
                          child: IgnorePointer(
                            ignoring: !_showControls,
                            child: _buildControls(context),
                          ),
                        ),
                        if (_nextIn != null) _buildNextOverlay(context),
                      ],
                    ),
                  ),
                ),
    );
  }

  Widget _buildControls(BuildContext context) {
    final value = _controller.value;
    final (playIcon, playLabel) = value.isPlaying
        ? (Icons.pause, 'Pausar')
        : value.position > Duration.zero && !_endHandled
            ? (Icons.play_arrow, 'Continuar')
            : (Icons.play_arrow, 'Play');

    return Align(
      alignment: Alignment.bottomCenter,
      child: Container(
        padding: const EdgeInsets.fromLTRB(16, 32, 16, 12),
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [Colors.transparent, Colors.black87],
          ),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            VideoProgressIndicator(
              _controller,
              allowScrubbing: true,
              padding: const EdgeInsets.symmetric(vertical: 8),
            ),
            Row(
              children: [
                Text(
                  '${_format(value.position)} / ${_format(value.duration)}',
                  style: const TextStyle(color: Colors.white70),
                ),
                const Spacer(),
                if (widget.playlist.length > 1)
                  IconButton(
                    tooltip: 'Anterior',
                    color: Colors.white,
                    onPressed: _index > 0 ? _playPrevious : null,
                    icon: const Icon(Icons.skip_previous),
                  ),
                IconButton(
                  tooltip: 'Voltar 10s',
                  color: Colors.white,
                  onPressed: () => _seekRelative(-_seekStep),
                  icon: const Icon(Icons.replay_10),
                ),
                FilledButton.icon(
                  onPressed: _togglePlayPause,
                  icon: Icon(playIcon),
                  label: Text(playLabel),
                ),
                const SizedBox(width: 8),
                OutlinedButton.icon(
                  onPressed: _stop,
                  style: OutlinedButton.styleFrom(foregroundColor: Colors.white),
                  icon: const Icon(Icons.stop),
                  label: const Text('Parar'),
                ),
                IconButton(
                  tooltip: 'Avançar 10s',
                  color: Colors.white,
                  onPressed: () => _seekRelative(_seekStep),
                  icon: const Icon(Icons.forward_10),
                ),
                if (widget.playlist.length > 1)
                  IconButton(
                    tooltip: 'Próximo',
                    color: Colors.white,
                    onPressed: _hasNext ? _playNext : null,
                    icon: const Icon(Icons.skip_next),
                  ),
                const Spacer(),
                // Mantém os botões centralizados em relação ao tempo à esquerda.
                Opacity(
                  opacity: 0,
                  child: Text(
                    '${_format(value.position)} / ${_format(value.duration)}',
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildNextOverlay(BuildContext context) {
    final next = widget.playlist[_index + 1];

    return Align(
      alignment: Alignment.bottomRight,
      child: Card(
        margin: const EdgeInsets.fromLTRB(16, 16, 16, 120),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Próximo episódio em $_nextIn s',
                style: Theme.of(context).textTheme.titleMedium,
              ),
              const SizedBox(height: 4),
              ConstrainedBox(
                constraints: const BoxConstraints(maxWidth: 320),
                child: Text(next.title, maxLines: 2, overflow: TextOverflow.ellipsis),
              ),
              const SizedBox(height: 12),
              Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  TextButton(
                    onPressed: () => setState(_cancelNext),
                    child: const Text('Cancelar'),
                  ),
                  const SizedBox(width: 8),
                  FilledButton.icon(
                    onPressed: _playNext,
                    icon: const Icon(Icons.skip_next),
                    label: const Text('Assistir agora'),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  static String _format(Duration d) {
    String two(int n) => n.toString().padLeft(2, '0');
    final h = d.inHours;
    final m = d.inMinutes.remainder(60);
    final s = d.inSeconds.remainder(60);
    return h > 0 ? '$h:${two(m)}:${two(s)}' : '${two(m)}:${two(s)}';
  }
}
