/*
The MIT License (MIT)
Copyright (c) 6/10/2021 GaNui

Permission is hereby granted, free of charge, to any person
get a copy of this software and associated documentation
files (the "Software"), to deal in the Software without restriction,
including without limitation the rights to use, copy, modify, merge,
publish, distribute, sublicense, and/or sell copies of the Software,
and to permit persons to whom the Software is furnished to do so,
subject to the following conditions:

The above copyright notice and this permission notice shall be included
in all copies or significant portions of the Software.

THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND,
EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF
MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONIFRINGEMENT.
IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM,
DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR
OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE
USE OR OTHER DEALINGS IN THE SOFTWARE.
*/

/*
Modifications made by Imran Mamin on 31/07/2025:
- Removed default elevation from Card widgets.
- Removed 'library flash_card;' from the beginning of the file.
*/
import 'dart:math' as math;
import 'package:flutter/material.dart';

/// UI flash card, commonly found in language teaching to children
class FlashCard extends StatefulWidget {
  /// constructor: Default height 200dp, width 200dp, duration  500 milliseconds
  const FlashCard(
      {required this.frontWidget,
      required this.backWidget,
      Key? key,
      this.duration = const Duration(milliseconds: 500),
      this.height = 200,
      this.width = 200})
      : super(key: key);

  /// this is the front of the card
  final Widget frontWidget;

  /// this is the back of the card
  final Widget backWidget;

  /// flip time
  final Duration duration;

  /// height of card
  final double height;

  /// width of card
  final double width;

  @override
  _FlashCardState createState() => _FlashCardState();
}

class _FlashCardState extends State<FlashCard>
    with SingleTickerProviderStateMixin {
  /// controller flip animation
  late AnimationController _controller;

  /// animation for flip from front to back
  late Animation<double> _frontAnimation;

  ///animation for flip from back  to front
  late Animation<double> _backAnimation;

  /// state of card is front or back
  bool isFrontVisible = true;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(vsync: this, duration: widget.duration);
    _frontAnimation = TweenSequence(
      <TweenSequenceItem<double>>[
        TweenSequenceItem<double>(
          tween: Tween(begin: 0.0, end: math.pi / 2)
              .chain(CurveTween(curve: Curves.linear)),
          weight: 50.0,
        ),
        TweenSequenceItem<double>(
          tween: ConstantTween<double>(math.pi / 2),
          weight: 50.0,
        ),
      ],
    ).animate(_controller);

    _backAnimation = TweenSequence(
      <TweenSequenceItem<double>>[
        TweenSequenceItem<double>(
          tween: ConstantTween<double>(math.pi / 2),
          weight: 50.0,
        ),
        TweenSequenceItem<double>(
          tween: Tween(begin: -math.pi / 2, end: 0.0)
              .chain(CurveTween(curve: Curves.linear)),
          weight: 50.0,
        ),
      ],
    ).animate(_controller);
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        GestureDetector(
          onTap: _toggleSide,
          child: AnimatedCard(
            animation: _frontAnimation,
            child: widget.backWidget,
            height: widget.height,
            width: widget.width,
          ),
        ),
        GestureDetector(
          onTap: _toggleSide,
          child: AnimatedCard(
            animation: _backAnimation,
            child: widget.frontWidget,
            height: widget.height,
            width: widget.width,
          ),
        ),
      ],
    );
  }

  /// when user onTap, It will run function
  void _toggleSide() {
    if (isFrontVisible) {
      _controller.forward();
      isFrontVisible = false;
    } else {
      _controller.reverse();
      isFrontVisible = true;
    }
  }
}

class AnimatedCard extends StatelessWidget {
  AnimatedCard(
      {required this.child,
      required this.animation,
      required this.height,
      required this.width,
      Key? key})
      : super(key: key);

  final Widget child;
  final Animation<double> animation;
  final double height;
  final double width;

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: animation,
      builder: _builder,
      child: SizedBox(
        height: height,
        width: width,
        child: Card(
            elevation: 4,
            shape:
                RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
            borderOnForeground: false,
            child: child,
            // Remove padding.
            /*child: Padding(
              padding: const EdgeInsets.all(10),
              child: child,
            )),*/
        ),
      ),
    );
  }

  Widget _builder(BuildContext context, Widget? child) {
    var transform = Matrix4.identity();
    transform.setEntry(3, 2, 0.001);
    transform.rotateY(animation.value);
    return Transform(
      transform: transform,
      alignment: Alignment.center,
      child: child,
    );
  }
}