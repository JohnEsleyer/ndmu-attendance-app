import "package:flutter/material.dart";

// DelayedWidget
class DelayedWidget extends StatefulWidget {
  final Widget child;
  final Duration delay;

  DelayedWidget({required this.child, this.delay = const Duration(seconds: 3)});

  @override
  _DelayedWidgetState createState() => _DelayedWidgetState();
}

class _DelayedWidgetState extends State<DelayedWidget> {
  bool _visible = false;
  @override
  void initState() {
    super.initState();
    Future.delayed(widget.delay, () {
      setState(() {
        _visible = true;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedOpacity(
      duration: Duration(milliseconds: 500),
      opacity: _visible ? 1.0 : 0.0,
      child: widget.child,
    );
  }
}
