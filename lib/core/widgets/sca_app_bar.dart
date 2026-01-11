import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class ScaAppBar extends StatelessWidget implements PreferredSizeWidget {
  final String title;
  final Color? foregroundColor;
  final List<Widget>? actions;
  final bool centerTitle;

  const ScaAppBar({
    super.key,
    required this.title,
    this.foregroundColor,
    this.actions,
    this.centerTitle = true,
  });

  @override
  Widget build(BuildContext context) {
    return AppBar(
      title: Text(
        title,
        style: GoogleFonts.cairo(fontWeight: FontWeight.bold, fontSize: 18),
      ),
      backgroundColor: Colors.transparent,
      elevation: 0,
      foregroundColor: foregroundColor ?? Colors.black,
      centerTitle: centerTitle,
      actions: actions,
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);
}
