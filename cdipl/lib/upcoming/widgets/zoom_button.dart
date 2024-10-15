import 'package:flutter/material.dart';

class ZoomButton extends StatefulWidget {
  final IconData icon;
  final Color color;
  final String tooltipMessage;
  final VoidCallback onPressed;

  const ZoomButton({
    super.key,
    required this.icon,
    required this.color,
    required this.tooltipMessage,
    required this.onPressed,
  });

  @override
  _ZoomButtonState createState() => _ZoomButtonState();
}

class _ZoomButtonState extends State<ZoomButton>
    with SingleTickerProviderStateMixin {
  bool _isPressed = false;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTapDown: (_) => setState(() => _isPressed = true),
      onTapUp: (_) {
        setState(() => _isPressed = false);
        widget.onPressed();
      },
      onTapCancel: () => setState(() => _isPressed = false),
      child: Tooltip(
        message: widget.tooltipMessage,
        child: AnimatedScale(
          scale: _isPressed ? 1.2 : 1.0,
          duration: const Duration(milliseconds: 100),
          child: Icon(widget.icon, color: widget.color),
        ),
      ),
    );
  }
}
