import 'package:flutter/material.dart';
import 'package:rive/rive.dart';

class RiveFavouritesAnimation extends StatelessWidget {
  const RiveFavouritesAnimation({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      alignment: Alignment.center,
      width: 200,
      height: 200,
      child: const RiveAnimation.asset('assets/rive/340-656-like-button.riv', ),

    );
  }
}

/// Demonstrates playing a one-shot animation on demand
class PlayOneShotAnimation extends StatefulWidget {
  const PlayOneShotAnimation({Key? key}) : super(key: key);

  @override
  State<PlayOneShotAnimation> createState() => _PlayOneShotAnimationState();
}

class _PlayOneShotAnimationState extends State<PlayOneShotAnimation> {
  /// Controller for playback
  late RiveAnimationController _controller;

  /// Is the animation currently playing?
  bool _isPlaying = false;

  @override
  void initState() {
    super.initState();
    _controller = OneShotAnimation(
      'bounce',
      autoplay: false,
      onStop: () => setState(() => _isPlaying = false),
      onStart: () => setState(() => _isPlaying = true),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('One-Shot Example'),
      ),
      body: Center(
        child: RiveAnimation.asset(
          'assets/rive/340-656-like-button.riv',
          animations: const ['idle', 'curves'],
          fit: BoxFit.cover,
          controllers: [_controller],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        // disable the button while playing the animation
        onPressed: () => _isPlaying ? null : _controller.isActive = true,
        tooltip: 'Bounce',
        child: const Icon(Icons.arrow_upward),
      ),
    );
  }
}