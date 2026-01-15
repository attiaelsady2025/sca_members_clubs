import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:sca_members_clubs/core/theme/app_colors.dart';
import 'package:sca_members_clubs/core/services/firebase_service.dart';

class HomeAppBar extends StatelessWidget implements PreferredSizeWidget {
  final String clubName;
  final VoidCallback onMapTap;
  final VoidCallback onNotificationsTap;

  const HomeAppBar({
    super.key,
    required this.clubName,
    required this.onMapTap,
    required this.onNotificationsTap,
  });

  @override
  Widget build(BuildContext context) {
    return AppBar(
      backgroundColor: AppColors.primary,
      elevation: 4,
      shadowColor: AppColors.primary.withOpacity(0.3),
      centerTitle: true,
      titleSpacing: 0,
      leading: Builder(
        builder: (context) => IconButton(
          icon: const Icon(
            Icons.menu_open_rounded,
            color: Colors.white,
            size: 28,
          ),
          onPressed: () => Scaffold.of(context).openDrawer(),
        ),
      ),
      title: Container(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
        decoration: BoxDecoration(
          color: Colors.white.withOpacity(0.12),
          borderRadius: BorderRadius.circular(24),
          border: Border.all(color: Colors.white.withOpacity(0.1)),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              padding: const EdgeInsets.all(4),
              decoration: const BoxDecoration(
                color: AppColors.accent,
                shape: BoxShape.circle,
              ),
              child: const Icon(
                Icons.anchor_rounded,
                size: 14,
                color: AppColors.primary,
              ),
            ),
            const SizedBox(width: 8),
            Text(
              "الصفحة الرئيسية",
              style: GoogleFonts.cairo(
                fontWeight: FontWeight.w800,
                fontSize: 14,
                color: Colors.white,
                letterSpacing: 0.1,
              ),
            ),
          ],
        ),
      ),
      actions: [
        FutureBuilder<int>(
          future: FirebaseService().getUnreadNotificationsCount(),
          builder: (context, snapshot) {
            final count = snapshot.data ?? 0;
            return Container(
              margin: const EdgeInsets.only(left: 4),
              child: Stack(
                alignment: Alignment.center,
                children: [
                  IconButton(
                    onPressed: onNotificationsTap,
                    icon: const Icon(
                      Icons.notifications_none_rounded,
                      color: Colors.white,
                      size: 26,
                    ),
                  ),
                  if (count > 0)
                    Positioned(
                      right: 10,
                      top: 10,
                      child: Container(
                        padding: const EdgeInsets.all(4),
                        decoration: BoxDecoration(
                          color: AppColors.error,
                          shape: BoxShape.circle,
                          border: Border.all(
                            color: AppColors.primary,
                            width: 2,
                          ),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withOpacity(0.2),
                              blurRadius: 4,
                            ),
                          ],
                        ),
                        constraints: const BoxConstraints(
                          minWidth: 18,
                          minHeight: 18,
                        ),
                        child: Text(
                          count > 9 ? '9+' : count.toString(),
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 9,
                            fontWeight: FontWeight.w900,
                          ),
                          textAlign: TextAlign.center,
                        ),
                      ),
                    ),
                ],
              ),
            );
          },
        ),
      ],
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(bottom: Radius.circular(24)),
      ),
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight + 10);
}
