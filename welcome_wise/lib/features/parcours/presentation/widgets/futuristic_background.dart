import 'dart:math';
import 'package:flutter/material.dart';

// --- PREMIUM FUTURISTIC TECH BACKGROUND PAINTER ---
class FuturisticTechBackgroundPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    // Determine drawing colors with tech/bronze style
    final baseColor = const Color(0xFF0F172A).withOpacity(0.06); // Slate 900 base lines
    final accentColor = const Color(0xFFD4AF37).withOpacity(0.08); // Gold/Bronze accent

    final paintLine = Paint()
      ..color = baseColor
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1.2;

    final paintAccentLine = Paint()
      ..color = accentColor
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1.5;

    final paintFill = Paint()
      ..color = Colors.white.withOpacity(0.4)
      ..style = PaintingStyle.fill;

    final paintNodeOutline = Paint()
      ..color = const Color(0xFFD4AF37).withOpacity(0.12)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 2.0;

    // 1. DRAW SUBTLE HORIZONTAL GRID LINES
    final paintGrid = Paint()
      ..color = const Color(0xFF0F172A).withOpacity(0.03)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 0.8;
    for (double y = 50; y < size.height; y += 150) {
      canvas.drawLine(Offset(0, y), Offset(size.width, y), paintGrid);
    }
    for (double x = 50; x < size.width; x += 150) {
      canvas.drawLine(Offset(x, 0), Offset(x, size.height), paintGrid);
    }

    // 2. TECH CONSTELLATION (BOTTOM LEFT NETWORK)
    final pointsBL = [
      Offset(size.width * 0.05, size.height * 0.70),
      Offset(size.width * 0.12, size.height * 0.65),
      Offset(size.width * 0.08, size.height * 0.80),
      Offset(size.width * 0.18, size.height * 0.75),
      Offset(size.width * 0.04, size.height * 0.88),
      Offset(size.width * 0.15, size.height * 0.90),
      Offset(size.width * 0.22, size.height * 0.85),
    ];

    for (int i = 0; i < pointsBL.length; i++) {
      for (int j = i + 1; j < pointsBL.length; j++) {
        final dist = (pointsBL[i] - pointsBL[j]).distance;
        if (dist < size.width * 0.15) {
          canvas.drawLine(pointsBL[i], pointsBL[j], paintLine);
        }
      }
    }

    for (var pt in pointsBL) {
      canvas.drawCircle(pt, 3, Paint()..color = const Color(0xFF0F172A).withOpacity(0.15)..style = PaintingStyle.fill);
      canvas.drawCircle(pt, 6, Paint()..color = const Color(0xFFD4AF37).withOpacity(0.1)..style = PaintingStyle.stroke..strokeWidth = 1.0);
    }

    // 3. CURVED LINE RUNNING DOWN WITH NODES & ICONS (AS SEEN IN MOCKUP)
    final P0 = Offset(size.width * 0.18, 0);
    final P1 = Offset(size.width * 0.08, size.height * 0.5);
    final P2 = Offset(size.width * 0.18, size.height);

    final path1 = Path();
    path1.moveTo(P0.dx, P0.dy);
    path1.quadraticBezierTo(P1.dx, P1.dy, P2.dx, P2.dy);

    final path2 = Path();
    path2.moveTo(P0.dx + 15, P0.dy);
    path2.quadraticBezierTo(P1.dx + 15, P1.dy, P2.dx + 15, P2.dy);

    canvas.drawPath(path1, paintLine);
    canvas.drawPath(path2, paintLine);

    Offset getBezierPoint(double t) {
      final mt = 1.0 - t;
      return Offset(
        mt * mt * P0.dx + 2 * mt * t * P1.dx + t * t * P2.dx,
        mt * mt * P0.dy + 2 * mt * t * P1.dy + t * t * P2.dy,
      );
    }

    final nodeParams = [
      _NodeData(t: 0.12, iconType: _IconType.globe, label: "Global"),
      _NodeData(t: 0.32, iconType: _IconType.factory, label: "Site"),
      _NodeData(t: 0.52, iconType: _IconType.userGear, label: "Rôle"),
      _NodeData(t: 0.72, iconType: _IconType.bell, label: "Alerte"),
      _NodeData(t: 0.90, iconType: _IconType.qrCode, label: "Code"),
    ];

    for (var node in nodeParams) {
      final center = getBezierPoint(node.t);
      
      canvas.drawCircle(center, 28, paintFill);
      canvas.drawCircle(center, 28, paintNodeOutline);
      canvas.drawCircle(center, 24, paintLine);

      for (double angle = 0; angle < 2 * 3.14159; angle += 3.14159 / 4) {
        final startX = center.dx + 28 * 0.9 * cos(angle);
        final startY = center.dy + 28 * 0.9 * sin(angle);
        final endX = center.dx + 28 * 1.1 * cos(angle);
        final endY = center.dy + 28 * 1.1 * sin(angle);
        canvas.drawLine(Offset(startX, startY), Offset(endX, endY), paintAccentLine);
      }

      _drawTechIcon(canvas, center, node.iconType);
    }
  }

  void _drawTechIcon(Canvas canvas, Offset center, _IconType type) {
    final paintIcon = Paint()
      ..color = const Color(0xFF9E7E5D) // Warm golden bronze icon color
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1.5;

    switch (type) {
      case _IconType.globe:
        canvas.drawCircle(center, 10, paintIcon);
        canvas.drawLine(Offset(center.dx - 10, center.dy), Offset(center.dx + 10, center.dy), paintIcon);
        canvas.drawLine(Offset(center.dx, center.dy - 10), Offset(center.dx, center.dy + 10), paintIcon);
        canvas.drawOval(Rect.fromCenter(center: center, width: 10, height: 20), paintIcon);
        break;

      case _IconType.factory:
        final path = Path();
        path.moveTo(center.dx - 10, center.dy + 8);
        path.lineTo(center.dx - 10, center.dy - 2);
        path.lineTo(center.dx - 5, center.dy - 5);
        path.lineTo(center.dx - 5, center.dy - 2);
        path.lineTo(center.dx, center.dy - 5);
        path.lineTo(center.dx, center.dy - 2);
        path.lineTo(center.dx + 5, center.dy - 5);
        path.lineTo(center.dx + 5, center.dy + 8);
        path.close();
        canvas.drawPath(path, paintIcon);
        canvas.drawRect(Rect.fromLTWH(center.dx + 2, center.dy - 9, 2, 4), paintIcon);
        break;

      case _IconType.userGear:
        canvas.drawCircle(Offset(center.dx, center.dy - 3), 3, paintIcon);
        final path = Path();
        path.moveTo(center.dx - 6, center.dy + 7);
        path.quadraticBezierTo(center.dx, center.dy, center.dx + 6, center.dy + 7);
        canvas.drawPath(path, paintIcon);
        canvas.drawCircle(center, 10, paintIcon);
        break;

      case _IconType.bell:
        final path = Path();
        path.moveTo(center.dx - 6, center.dy + 5);
        path.quadraticBezierTo(center.dx - 6, center.dy - 6, center.dx, center.dy - 6);
        path.quadraticBezierTo(center.dx + 6, center.dy - 6, center.dx + 6, center.dy + 5);
        path.close();
        canvas.drawPath(path, paintIcon);
        canvas.drawLine(Offset(center.dx - 8, center.dy + 5), Offset(center.dx + 8, center.dy + 5), paintIcon);
        canvas.drawCircle(Offset(center.dx, center.dy + 7), 2, Paint()..color = const Color(0xFF9E7E5D)..style = PaintingStyle.fill);
        break;

      case _IconType.qrCode:
        canvas.drawRect(Rect.fromCenter(center: center, width: 16, height: 16), paintIcon);
        canvas.drawRect(Rect.fromLTWH(center.dx - 6, center.dy - 6, 3, 3), paintIcon);
        canvas.drawRect(Rect.fromLTWH(center.dx + 3, center.dy - 6, 3, 3), paintIcon);
        canvas.drawRect(Rect.fromLTWH(center.dx - 6, center.dy + 3, 3, 3), paintIcon);
        canvas.drawRect(Rect.fromCenter(center: center, width: 3, height: 3), Paint()..color = const Color(0xFF9E7E5D)..style = PaintingStyle.fill);
        break;
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}

enum _IconType {
  globe,
  factory,
  userGear,
  bell,
  qrCode,
}

class _NodeData {
  final double t;
  final _IconType iconType;
  final String label;

  _NodeData({
    required this.t,
    required this.iconType,
    required this.label,
  });
}
