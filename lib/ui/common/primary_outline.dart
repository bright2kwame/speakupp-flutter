import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class PrimaryOutlineButton extends StatelessWidget {
  final String text;
  final VoidCallback? onClick;
  final bool isEnabled;
  final Size size;
  const PrimaryOutlineButton(
      {super.key,
      required this.text,
      required this.onClick,
      required this.size,
      this.isEnabled = true});

  @override
  Widget build(BuildContext context) {
    return ConstrainedBox(
        constraints: BoxConstraints.tight(size),
        child: ElevatedButton(
            style: ElevatedButton.styleFrom(
                shadowColor: Colors.transparent,
                surfaceTintColor: Colors.transparent,
                backgroundColor: Colors.transparent,
                disabledBackgroundColor: Colors.grey,
                shape: RoundedRectangleBorder(
                    side: const BorderSide(color: Colors.white),
                    borderRadius: BorderRadius.circular(25))),
            onPressed: isEnabled ? onClick : null,
            child: Text(text,
                style: GoogleFonts.roboto(fontSize: 18, color: Colors.white))));
  }
}
