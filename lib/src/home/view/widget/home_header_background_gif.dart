// lib/src/home/view/widget/home_header_background_gif.dart
import 'package:flutter/material.dart';
import 'package:gif_view/gif_view.dart';
import 'package:medpik/res/constants/medpik_image_assets.dart';

/// Home header GIF that plays once per app session and freezes on the last frame.
///
/// Uses only [GifView] — never [Image.asset] for this GIF, because Flutter's
/// [Image] widget also animates multi-frame assets and would play a second time.
class HomeHeaderBackgroundGif extends StatefulWidget {
  const HomeHeaderBackgroundGif({
    super.key,
    this.animate = true,
  });

  /// When false, shows a frozen frame only (no playback).
  final bool animate;

  /// True once this session has started (or finished) a play-through.
  /// Prevents a remount from restarting the animation mid-session.
  static bool _playbackClaimedThisSession = false;

  @override
  State<HomeHeaderBackgroundGif> createState() =>
      _HomeHeaderBackgroundGifState();
}

class _HomeHeaderBackgroundGifState extends State<HomeHeaderBackgroundGif> {
  late final GifController _controller;
  late final bool _shouldAutoPlay;

  @override
  void initState() {
    super.initState();
    _controller = GifController();
    // Claim playback in initState so a later remount cannot start a 2nd run.
    _shouldAutoPlay =
        widget.animate && !HomeHeaderBackgroundGif._playbackClaimedThisSession;
    if (_shouldAutoPlay) {
      HomeHeaderBackgroundGif._playbackClaimedThisSession = true;
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _freezeOnLastFrame(int totalFrames) {
    if (totalFrames <= 0) return;
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!mounted) return;
      _controller.seek(totalFrames - 1);
      _controller.pause();
    });
  }

  @override
  Widget build(BuildContext context) {
    return GifView.asset(
      MedpikImageAssets.primaryBackground,
      controller: _controller,
      fit: BoxFit.cover,
      alignment: Alignment.topCenter,
      loop: false,
      autoPlay: _shouldAutoPlay,
      withOpacityAnimation: false,
      onLoaded: (totalFrames) {
        if (!_shouldAutoPlay) {
          _freezeOnLastFrame(totalFrames);
        }
      },
    );
  }
}
