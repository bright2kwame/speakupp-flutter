import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class PrimaryButton extends StatelessWidget {
  final String text;
  final VoidCallback? onClick;
  final Color color;
  final bool isEnabled;
  final Size size;
  const PrimaryButton(
      {super.key,
      required this.text,
      required this.color,
      required this.onClick,
      required this.size,
      this.isEnabled = true});

  @override
  Widget build(BuildContext context) {
    return ConstrainedBox(
      constraints: BoxConstraints.tight(size),
      child: ElevatedButton(
          style: ElevatedButton.styleFrom(
              backgroundColor: color,
              disabledBackgroundColor: Colors.grey,
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(25))),
          onPressed: isEnabled ? onClick : null,
          child: Text(text,
              style: GoogleFonts.roboto(
                  fontSize: 18,
                  color: Colors.white,
                  fontWeight: FontWeight.bold))),
    );
  }
}
