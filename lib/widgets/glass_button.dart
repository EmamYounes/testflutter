import 'dart:ui';
import 'package:flutter/material.dart';

class GlassButton extends StatelessWidget {
  final String text;
  final IconData? icon;
  final VoidCallback onTap;
  final double height;
  final double radius;

  const GlassButton({
    super.key,
    required this.text,
    required this.onTap,
    this.icon,
    this.height = 55,
    this.radius = 15,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: ClipRRect(
        borderRadius: BorderRadius.circular(radius),
        child: BackdropFilter(
          filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
          child: Container(
            height: height,
            margin: const EdgeInsets.symmetric(vertical: 8),
            decoration: BoxDecoration(
              color: Colors.purpleAccent.withOpacity(0.12),
              borderRadius: BorderRadius.circular(radius),
              border: Border.all(
                color: Colors.white.withOpacity(0.3),
                width: 1.2,
              ),
            ),
            alignment: Alignment.center,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                if (icon != null)
                  Icon(icon, color: Colors.white, size: 20),
                if (icon != null) const SizedBox(width: 8),
                Text(
                  text,
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 17,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
