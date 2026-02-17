import 'dart:ui';
import 'package:flutter/material.dart';

class GlassDropdown extends StatelessWidget {
  final String? value;
  final List<String> items;
  final Function(String?) onChanged;

  const GlassDropdown({
    super.key,
    required this.value,
    required this.items,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(15),
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          height: 55,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(15),
            gradient: LinearGradient(
              colors: [
                Colors.purple.withOpacity(0.25),
                Colors.purple.withOpacity(0.05),
              ],
            ),
            border: Border.all(
              color: Colors.purple.withOpacity(0.3),
            ),
          ),
          child: DropdownButtonHideUnderline(
            child: DropdownButton<String>(
              value: value,
              icon: const Icon(Icons.arrow_drop_down, color: Colors.purple),
              dropdownColor: Colors.purple.withOpacity(0.3),
              style: const TextStyle(color: Colors.white, fontSize: 16),

              onChanged: onChanged,

              items: items
                  .map(
                    (e) => DropdownMenuItem(
                  value: e,
                  child: Text(
                    e,
                    style: const TextStyle(
                        color: Colors.purple, fontWeight: FontWeight.w500),
                  ),
                ),
              )
                  .toList(),
            ),
          ),
        ),
      ),
    );
  }
}
