import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

// Widget tùy chỉnh cho ElevatedButton với Icon
class CustomElevatedButton extends StatelessWidget {
  final VoidCallback onPressed; // Hàm gọi khi nhấn nút
  final String label; // Text của nút
  final dynamic icon; // Icon của nút
  final Color color; // Màu của nút

  const CustomElevatedButton({
    super.key,
    required this.onPressed,
    required this.label,
    required this.icon,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    return ElevatedButton.icon(
      onPressed: onPressed,
      icon:
          icon is IconData
              ? Icon(icon, color: Colors.white)
              : FaIcon(icon, color: Colors.white, size: 20),
      label: Text(
        label,
        style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
      ),
      style: ElevatedButton.styleFrom(
        backgroundColor: color,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        padding: EdgeInsets.symmetric(vertical: 14, horizontal: 30),
      ),
    );
  }
}
