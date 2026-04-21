import 'package:flutter/material.dart';
import 'dart:math';

class DynamicWeatherIcon extends StatefulWidget {
  final String condition; 

  const DynamicWeatherIcon({Key? key, required this.condition}) : super(key: key);

  @override
  _DynamicWeatherIconState createState() => _DynamicWeatherIconState();
}

class _DynamicWeatherIconState extends State<DynamicWeatherIcon>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 2),
    )..repeat(); 
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _controller,
      builder: (context, child) {
        return CustomPaint(
          size: const Size(150, 150), 
          painter: WeatherPainter(_controller.value, widget.condition.toLowerCase()),
        );
      },
    );
  }
}

class WeatherPainter extends CustomPainter {
  final double animationValue;
  final String condition;

  WeatherPainter(this.animationValue, this.condition);

  @override
  void paint(Canvas canvas, Size size) {
    final cloudPaint = Paint()
      ..color = Colors.white.withOpacity(0.9)
      ..style = PaintingStyle.fill;

    final double cloudOffset = sin(animationValue * pi * 2) * 10.0;
    
    final bool isRaining = condition.contains('rain') || condition.contains('drizzle') || condition.contains('thunderstorm');
    final bool isStorm = condition.contains('thunderstorm') || condition.contains('storm');

    if (isStorm) {
      if (animationValue > 0.4 && animationValue < 0.5) {
        final lightningPaint = Paint()
          ..color = Colors.yellowAccent
          ..style = PaintingStyle.fill;

        final path = Path();
        path.moveTo(size.width * 0.5 + cloudOffset, size.height * 0.4);
        path.lineTo(size.width * 0.35 + cloudOffset, size.height * 0.7);
        path.lineTo(size.width * 0.5 + cloudOffset, size.height * 0.7);
        path.lineTo(size.width * 0.4 + cloudOffset, size.height * 0.95);
        path.lineTo(size.width * 0.65 + cloudOffset, size.height * 0.6);
        path.lineTo(size.width * 0.45 + cloudOffset, size.height * 0.6);
        path.close();
        canvas.drawPath(path, lightningPaint);
      }
    }

    if (isRaining) {
      final rainPaint = Paint()
        ..color = Colors.lightBlueAccent.withOpacity(0.7)
        ..strokeWidth = 3
        ..strokeCap = StrokeCap.round;

      for (int i = 0; i < 5; i++) {
        double startX = size.width * 0.2 + (i * 20) + cloudOffset;
        double startY = size.height * 0.5 + ((animationValue * 150 + (i * 30)) % 100);

        canvas.drawLine(
          Offset(startX, startY),
          Offset(startX - 5, startY + 15), 
          rainPaint,
        );
      }
    }

    canvas.drawCircle(Offset(size.width * 0.3 + cloudOffset, size.height * 0.5), 25, cloudPaint);
    canvas.drawCircle(Offset(size.width * 0.5 + cloudOffset, size.height * 0.3), 35, cloudPaint);
    canvas.drawCircle(Offset(size.width * 0.7 + cloudOffset, size.height * 0.5), 25, cloudPaint);
    
    final rect = RRect.fromLTRBR(
      size.width * 0.3 + cloudOffset - 5, 
      size.height * 0.3 + 15, 
      size.width * 0.7 + cloudOffset + 5, 
      size.height * 0.5 + 25, 
      const Radius.circular(20)
    );
    canvas.drawRRect(rect, cloudPaint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => true;
}