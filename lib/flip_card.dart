import 'package:flutter/material.dart';

class FlipCard extends StatefulWidget {
  final int number;
  final bool revealed;
  final Color color;
  const FlipCard({required this.number, required this.revealed, required this.color, Key? key}) : super(key: key);

  @override
  _FlipCardState createState() => _FlipCardState();
}

class _FlipCardState extends State<FlipCard> with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _animation;

  bool _isFront = true;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(duration: Duration(milliseconds: 600), vsync: this);
    _animation = Tween<double>(begin: 0, end: 1).animate(_controller);

    if (widget.revealed) {
      _controller.forward();
      _isFront = false;
    }
  }

  @override
  void didUpdateWidget(covariant FlipCard oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.revealed != oldWidget.revealed) {
      if (widget.revealed) {
        _controller.forward();
        _isFront = false;
      } else {
        _controller.reverse();
        _isFront = true;
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _animation,
      builder: (context, child) {
        final angle = _animation.value * 3.1416;
        return Transform(
          alignment: Alignment.center,
          transform: Matrix4.rotationY(angle),
          child: Container(
            width: 80,
            height: 100,
            decoration: BoxDecoration(
              color: widget.color,
              borderRadius: BorderRadius.circular(12),
              boxShadow: [
                BoxShadow(
                  blurRadius: 8,
                  color: Colors.black26,
                  offset: Offset(2, 2),
                )
              ],
            ),
            alignment: Alignment.center,
            child: angle <= 1.57
              ? Text('?', style: TextStyle(fontSize: 40, fontWeight: FontWeight.bold))
              : Transform(
                  alignment: Alignment.center,
                  transform: Matrix4.rotationY(3.1416),
                  child: Text(
                    '${widget.number}',
                    style: TextStyle(fontSize: 40, fontWeight: FontWeight.bold),
                  ),
              ),
          ),
        );
      },
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }
}
