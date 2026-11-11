import 'dart:async';

import 'package:flutter/material.dart';
import 'package:video_player/video_player.dart';

import '../../core/theme/app_text_styles.dart';
import '../../core/theme/app_tokens.g.dart';
import '../../core/utils/formatters.dart';
import '../../core/widgets/app_button.dart';
import '../../dat/progress/watch_progress_controller.dart';

class PlayerItem {
  final Uri videoUri;

  /// Title of the movie or series.
  final String title;

  /// Second line, e.g. "S1:E3 · Into the Static".
  final String? subtitle;

  /// Catalog id used to remember the watch progress; null disables it.
  final String? videoId;

  /// Index into `Video.episodes`; null for movies.
  final int? episodeIndex;

  const PlayerItem({
    required this.videoUri,
    required this.title,
    this.subtitle,
    this.videoId,
    this.episodeIndex,
  });
}

/// "07 Player": video with the title bar, center transport, seek bar and the
/// bottom control row from the design.
class PlayerPage extends StatefulWidget {
  /// Items played in sequence: when one ends, the next one starts by itself.
  final List<PlayerItem> playlist;
  final int initialIndex;

  const PlayerPage({super.key, required this.playlist, this.initialIndex = 0});

  @override
  State<PlayerPage> createState() => _PlayerPageState();
}

class _PlayerPageState extends State<PlayerPage> {
  static const _seekStep = Duration(seconds: 10);
  static const _controlsTimeout = Duration(seconds: 3);
  static const _nextCountdownSeconds = 5;
  static const _saveInterval = Duration(seconds: 1);

  late VideoPlayerController _controller;
  bool _hasController = false;
  late int _index;
  bool _hasError = false;

  bool _showControls = true;
  Timer? _hideTimer;

  /// Keeps the countdown from reopening after the user cancelled it.
  bool _endHandled = false;
  Timer? _nextTimer;
  int? _nextIn;

  /// Position last written to [WatchProgressController].
  Duration _lastSaved = Duration.zero;

  /// Volume to restore when unmuting.
  double _volumeBeforeMute = 1;

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
      // The old VideoPlayer stays in the tree until the next frame.
      WidgetsBinding.instance.addPostFrameCallback((_) => old.dispose());
    }

    _index = index;
    _hasError = false;
    _endHandled = false;
    _showControls = true;
    _lastSaved = Duration.zero;

    final controller = VideoPlayerController.networkUrl(_current.videoUri)
      ..addListener(_onControllerUpdate);
    _controller = controller;
    _hasController = true;
    _initialize(controller, _resumePosition(_current));
  }

  /// Where the profile stopped watching [item], if it was not finished.
  Duration? _resumePosition(PlayerItem item) {
    final videoId = item.videoId;
    if (videoId == null) return null;
    final entry = WatchProgressController.instance.entryFor(
      videoId,
      item.episodeIndex,
    );
    if (entry == null || entry.finished) return null;
    return entry.position;
  }

  Future<void> _initialize(
    VideoPlayerController controller,
    Duration? resumeAt,
  ) async {
    try {
      await controller.initialize();
      if (!mounted || controller != _controller) return;
      if (resumeAt != null && resumeAt < controller.value.duration) {
        await controller.seekTo(resumeAt);
        if (!mounted || controller != _controller) return;
      }
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
    final ended =
        value.isInitialized &&
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
    _saveProgress(value);
    setState(() {});
  }

  void _saveProgress(VideoPlayerValue value) {
    final videoId = _current.videoId;
    if (videoId == null || !value.isInitialized) return;
    if ((value.position - _lastSaved).abs() < _saveInterval) return;
    _lastSaved = value.position;
    WatchProgressController.instance.save(
      videoId: videoId,
      episodeIndex: _current.episodeIndex,
      position: value.position,
      duration: value.duration,
    );
  }

  @override
  void dispose() {
    _hideTimer?.cancel();
    _nextTimer?.cancel();
    _controller.removeListener(_onControllerUpdate);
    _controller.dispose();
    super.dispose();
  }

  // ---- Controls ----

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

  void _seekTo(Duration target) {
    final duration = _controller.value.duration;
    if (target < Duration.zero) target = Duration.zero;
    if (target > duration) target = duration;
    _cancelNext();
    _controller.seekTo(target);
    _scheduleHide();
  }

  void _seekRelative(Duration offset) =>
      _seekTo(_controller.value.position + offset);

  void _setVolume(double volume) {
    _controller.setVolume(volume.clamp(0.0, 1.0));
    _scheduleHide();
  }

  void _toggleMute() {
    final volume = _controller.value.volume;
    if (volume > 0) {
      _volumeBeforeMute = volume;
      _setVolume(0);
    } else {
      _setVolume(_volumeBeforeMute > 0 ? _volumeBeforeMute : 1);
    }
  }

  void _playNext() {
    if (!_hasNext) return;
    setState(() => _open(_index + 1));
  }

  void _playPrevious() {
    if (_index == 0) return;
    setState(() => _open(_index - 1));
  }

  // ---- Auto-play next episode ----

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

  // ---- Controls visibility ----

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

  // ---- UI ----

  @override
  Widget build(BuildContext context) {
    final isReady = _controller.value.isInitialized && !_hasError;
    final compact = MediaQuery.sizeOf(context).shortestSide < 500;

    return Scaffold(
      backgroundColor: Colors.black,
      body: MouseRegion(
        onHover: isReady ? (_) => _scheduleHide() : null,
        child: GestureDetector(
          behavior: HitTestBehavior.opaque,
          onTap: isReady ? _onTapVideo : null,
          child: Stack(
            fit: StackFit.expand,
            children: [
              if (isReady)
                Center(
                  child: AspectRatio(
                    aspectRatio: _controller.value.aspectRatio,
                    child: VideoPlayer(_controller, key: ValueKey(_controller)),
                  ),
                )
              else if (_hasError)
                const Center(
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(
                        Icons.error_outline,
                        size: AppSpacing.huge,
                        color: AppColors.textSecondary,
                      ),
                      SizedBox(height: AppSpacing.lg),
                      Text(
                        'Unable to play this video.',
                        style: AppTextStyles.title,
                      ),
                    ],
                  ),
                )
              else
                const Center(
                  child: CircularProgressIndicator(
                    strokeWidth: 2.5,
                    color: AppColors.primary,
                    backgroundColor: AppColors.border,
                  ),
                ),
              if (isReady)
                AnimatedOpacity(
                  opacity: _showControls ? 1 : 0,
                  duration: const Duration(milliseconds: 200),
                  child: IgnorePointer(
                    ignoring: !_showControls,
                    child: _buildControls(context, compact),
                  ),
                )
              else
                // While loading or on error only the title bar is shown.
                Stack(
                  fit: StackFit.expand,
                  children: [
                    _buildTopScrim(compact),
                    _buildTitleBar(context, compact),
                  ],
                ),
              if (_nextIn != null) _buildNextOverlay(context, compact),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildTopScrim(bool compact) {
    return Align(
      alignment: Alignment.topCenter,
      child: IgnorePointer(
        child: Container(
          height: compact ? 96 : 200,
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
              colors: [Color(0xCC000000), Color(0x00000000)],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildTitleBar(BuildContext context, bool compact) {
    final subtitle = _current.subtitle;
    final padding = compact ? AppSpacing.lg : AppSpacing.xxxl;
    return Align(
      alignment: Alignment.topCenter,
      child: SafeArea(
        bottom: false,
        child: Padding(
          padding: EdgeInsets.fromLTRB(
            padding - AppSpacing.sm,
            compact ? AppSpacing.sm : 40,
            padding,
            0,
          ),
          child: Row(
            children: [
              IconButton(
                tooltip: 'Back',
                iconSize: compact ? AppSizes.iconMd : AppSizes.iconLg,
                color: AppColors.textPrimary,
                onPressed: () => Navigator.maybePop(context),
                icon: const Icon(Icons.arrow_back),
              ),
              const SizedBox(width: AppSpacing.sm),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      _current.title,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: compact
                          ? AppTextStyles.bodyStrong
                          : AppTextStyles.title,
                    ),
                    if (subtitle != null)
                      Text(
                        subtitle,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: compact
                            ? AppTextStyles.caption
                            : AppTextStyles.body,
                      ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildControls(BuildContext context, bool compact) {
    final value = _controller.value;
    final playIcon = value.isPlaying
        ? Icons.pause_rounded
        : Icons.play_arrow_rounded;
    final playTooltip = value.isPlaying ? 'Pause' : 'Play';
    final padding = compact ? AppSpacing.xl : AppSpacing.xxxl;
    final iconSize = compact ? AppSizes.iconMd : 36.0;
    final subtitle = _current.subtitle;

    final volumeIcon = value.volume == 0
        ? Icons.volume_off_rounded
        : value.volume < 0.5
        ? Icons.volume_down_rounded
        : Icons.volume_up_rounded;

    Widget control(
      IconData icon,
      String tooltip,
      VoidCallback? onPressed, {
      double? size,
    }) {
      return IconButton(
        tooltip: tooltip,
        iconSize: size ?? iconSize,
        color: AppColors.textPrimary,
        disabledColor: AppColors.textDisabled,
        onPressed: onPressed,
        icon: Icon(icon),
      );
    }

    return Stack(
      fit: StackFit.expand,
      children: [
        _buildTopScrim(compact),
        Align(
          alignment: Alignment.bottomCenter,
          child: IgnorePointer(
            child: Container(
              height: compact ? 140 : 320,
              decoration: const BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [Color(0x00000000), Color(0xE6000000)],
                ),
              ),
            ),
          ),
        ),
        _buildTitleBar(context, compact),

        // Center transport: back 10s, play / pause, forward 10s.
        Center(
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              control(
                Icons.replay_10_rounded,
                'Back 10s',
                () => _seekRelative(-_seekStep),
                size: compact ? 40 : 56,
              ),
              SizedBox(width: compact ? AppSpacing.xxxl : 88),
              Material(
                color: AppColors.onPrimary.withValues(alpha: 0.16),
                shape: const CircleBorder(),
                clipBehavior: Clip.antiAlias,
                child: InkWell(
                  onTap: _togglePlayPause,
                  child: SizedBox.square(
                    dimension: compact ? 72 : 112,
                    child: Icon(
                      playIcon,
                      size: compact ? 48 : AppSpacing.huge,
                      color: AppColors.textPrimary,
                    ),
                  ),
                ),
              ),
              SizedBox(width: compact ? AppSpacing.xxxl : 88),
              control(
                Icons.forward_10_rounded,
                'Forward 10s',
                () => _seekRelative(_seekStep),
                size: compact ? 40 : 56,
              ),
            ],
          ),
        ),

        // Seek bar, clock and the bottom control row.
        Align(
          alignment: Alignment.bottomCenter,
          child: SafeArea(
            top: false,
            child: Padding(
              padding: EdgeInsets.fromLTRB(
                padding,
                0,
                padding,
                compact ? AppSpacing.sm : AppSpacing.xxl,
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  _SeekBar(value: value, onSeek: _seekTo, compact: compact),
                  const SizedBox(height: AppSpacing.xs),
                  Row(
                    children: [
                      Text(
                        Formatters.clock(value.position),
                        style: AppTextStyles.label,
                      ),
                      const Spacer(),
                      Text(
                        Formatters.clock(value.duration),
                        style: AppTextStyles.label,
                      ),
                    ],
                  ),
                  SizedBox(height: compact ? 0 : AppSpacing.sm),
                  Row(
                    children: [
                      control(playIcon, playTooltip, _togglePlayPause),
                      control(
                        Icons.replay_10_rounded,
                        'Back 10s',
                        () => _seekRelative(-_seekStep),
                      ),
                      control(
                        Icons.forward_10_rounded,
                        'Forward 10s',
                        () => _seekRelative(_seekStep),
                      ),
                      control(
                        volumeIcon,
                        value.volume == 0 ? 'Unmute' : 'Mute',
                        _toggleMute,
                      ),
                      if (!compact) ...[
                        const SizedBox(width: AppSpacing.sm),
                        _VolumeBar(volume: value.volume, onChanged: _setVolume),
                      ],
                      Expanded(
                        child: compact
                            ? const SizedBox.shrink()
                            : Padding(
                                padding: const EdgeInsets.symmetric(
                                  horizontal: AppSpacing.xl,
                                ),
                                child: Text(
                                  subtitle == null
                                      ? _current.title
                                      : '${_current.title}  ·  $subtitle',
                                  textAlign: TextAlign.center,
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
                                  style: AppTextStyles.bodyStrong,
                                ),
                              ),
                      ),
                      if (widget.playlist.length > 1) ...[
                        control(
                          Icons.skip_previous_rounded,
                          'Previous episode',
                          _index > 0 ? _playPrevious : null,
                        ),
                        control(
                          Icons.skip_next_rounded,
                          'Next episode',
                          _hasNext ? _playNext : null,
                        ),
                      ],
                    ],
                  ),
                ],
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildNextOverlay(BuildContext context, bool compact) {
    final next = widget.playlist[_index + 1];

    return Align(
      alignment: Alignment.bottomRight,
      child: Container(
        margin: EdgeInsets.fromLTRB(
          AppSpacing.lg,
          AppSpacing.lg,
          compact ? AppSpacing.xl : AppSpacing.xxxl,
          compact ? 120 : 200,
        ),
        padding: const EdgeInsets.all(AppSpacing.lg),
        constraints: const BoxConstraints(maxWidth: 360),
        decoration: BoxDecoration(
          color: AppColors.surfaceRaised,
          border: Border.all(color: AppColors.border),
          borderRadius: BorderRadius.circular(AppRadius.lg),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Next episode in ${_nextIn}s', style: AppTextStyles.titleSm),
            const SizedBox(height: AppSpacing.xs),
            Text(
              next.subtitle ?? next.title,
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
              style: AppTextStyles.bodySm,
            ),
            const SizedBox(height: AppSpacing.lg),
            Wrap(
              spacing: AppSpacing.sm,
              runSpacing: AppSpacing.sm,
              children: [
                AppButton(
                  label: 'Cancel',
                  variant: AppButtonVariant.secondary,
                  height: AppSizes.buttonHeightSm,
                  onPressed: () => setState(_cancelNext),
                ),
                AppButton(
                  label: 'Watch now',
                  icon: Icons.skip_next_rounded,
                  height: AppSizes.buttonHeightSm,
                  onPressed: _playNext,
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

/// "progress / track + buffer + played + knob". Tap or drag to seek.
class _SeekBar extends StatelessWidget {
  const _SeekBar({
    required this.value,
    required this.onSeek,
    required this.compact,
  });

  final VideoPlayerValue value;
  final ValueChanged<Duration> onSeek;
  final bool compact;

  double _fraction(Duration part) {
    final total = value.duration.inMilliseconds;
    if (total <= 0) return 0;
    return (part.inMilliseconds / total).clamp(0.0, 1.0);
  }

  @override
  Widget build(BuildContext context) {
    final trackHeight = compact ? 4.0 : 6.0;
    final knob = compact ? 14.0 : 20.0;
    final played = _fraction(value.position);
    final buffered = value.buffered.isEmpty
        ? 0.0
        : _fraction(value.buffered.last.end);

    return LayoutBuilder(
      builder: (context, constraints) {
        final width = constraints.maxWidth;

        void seek(double dx) {
          if (width <= 0) return;
          onSeek(value.duration * (dx / width).clamp(0.0, 1.0));
        }

        Widget bar(double fraction, Color color) => Positioned(
          left: 0,
          width: width * fraction,
          height: trackHeight,
          child: DecoratedBox(
            decoration: BoxDecoration(
              color: color,
              borderRadius: BorderRadius.circular(trackHeight / 2),
            ),
          ),
        );

        return MouseRegion(
          cursor: SystemMouseCursors.click,
          child: GestureDetector(
            behavior: HitTestBehavior.opaque,
            onTapDown: (details) => seek(details.localPosition.dx),
            onHorizontalDragUpdate: (details) => seek(details.localPosition.dx),
            child: SizedBox(
              width: width,
              height: AppSpacing.xl,
              child: Stack(
                alignment: Alignment.centerLeft,
                clipBehavior: Clip.none,
                children: [
                  bar(1, AppColors.onPrimary.withValues(alpha: 0.25)),
                  bar(buffered, AppColors.onPrimary.withValues(alpha: 0.45)),
                  bar(played, AppColors.primary),
                  Positioned(
                    left: (width * played - knob / 2).clamp(0.0, width - knob),
                    width: knob,
                    height: knob,
                    child: const DecoratedBox(
                      decoration: BoxDecoration(
                        color: AppColors.primary,
                        shape: BoxShape.circle,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}

/// The 120px volume line next to the speaker icon. Tap or drag to change.
class _VolumeBar extends StatelessWidget {
  const _VolumeBar({required this.volume, required this.onChanged});

  final double volume;
  final ValueChanged<double> onChanged;

  static const _width = 120.0;

  @override
  Widget build(BuildContext context) {
    return MouseRegion(
      cursor: SystemMouseCursors.click,
      child: GestureDetector(
        behavior: HitTestBehavior.opaque,
        onTapDown: (details) => onChanged(details.localPosition.dx / _width),
        onHorizontalDragUpdate: (details) =>
            onChanged(details.localPosition.dx / _width),
        child: SizedBox(
          width: _width,
          height: AppSpacing.xl,
          child: Center(
            child: ClipRRect(
              borderRadius: BorderRadius.circular(2),
              child: SizedBox(
                height: 4,
                width: _width,
                child: ColoredBox(
                  color: AppColors.onPrimary.withValues(alpha: 0.3),
                  child: FractionallySizedBox(
                    alignment: Alignment.centerLeft,
                    widthFactor: volume.clamp(0.0, 1.0),
                    child: const ColoredBox(color: AppColors.onPrimary),
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
