import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:sca_members_clubs/core/theme/app_colors.dart';
import 'package:sca_members_clubs/core/widgets/primary_button.dart';
import 'package:sca_members_clubs/core/widgets/sca_app_bar.dart';
import 'package:sca_members_clubs/core/services/firebase_service.dart';

class InvitationsScreen extends StatefulWidget {
  const InvitationsScreen({super.key});

  @override
  State<InvitationsScreen> createState() => _InvitationsScreenState();
}

class _InvitationsScreenState extends State<InvitationsScreen> {
  late Future<List<Map<String, dynamic>>> _invitationsFuture;
  late Future<List<Map<String, dynamic>>> _cardsFuture;
  late Future<int> _visitorsCountFuture;
  final PageController _cardPageController = PageController();
  int _currentCardIndex = 0;

  @override
  void initState() {
    super.initState();
    _loadData();
  }

  void _loadData() {
    setState(() {
      _invitationsFuture = FirebaseService().getInvitations();
      _cardsFuture = FirebaseService().getInvitationCards();
      _visitorsCountFuture = FirebaseService().getCurrentVisitorsCount();
    });
  }

  @override
  void dispose() {
    _cardPageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: const ScaAppBar(title: "دعوات الزوار"),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [
            // Visitors Tracking Widget (New Feature)
            FutureBuilder<int>(
              future: _visitorsCountFuture,
              builder: (context, snapshot) {
                final count = snapshot.data ?? 0;
                return Container(
                  padding: const EdgeInsets.all(20),
                  margin: const EdgeInsets.only(bottom: 24),
                  decoration: BoxDecoration(
                    gradient: const LinearGradient(
                      colors: [AppColors.secondary, AppColors.primary],
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                    ),
                    borderRadius: BorderRadius.circular(24),
                    boxShadow: [
                      BoxShadow(
                        color: AppColors.primary.withOpacity(0.3),
                        blurRadius: 20,
                        offset: const Offset(0, 10),
                      ),
                    ],
                  ),
                  child: Row(
                    children: [
                      Container(
                        padding: const EdgeInsets.all(12),
                        decoration: BoxDecoration(
                          color: Colors.white.withOpacity(0.2),
                          shape: BoxShape.circle,
                        ),
                        child: const Icon(
                          Icons.people_alt,
                          color: Colors.white,
                          size: 32,
                        ),
                      ),
                      const SizedBox(width: 20),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              "الزوار المتواجدون حالياً",
                              style: GoogleFonts.cairo(
                                color: Colors.white70,
                                fontSize: 14,
                              ),
                            ),
                            Text(
                              "$count زوار في عهدتك",
                              style: GoogleFonts.cairo(
                                color: Colors.white,
                                fontWeight: FontWeight.bold,
                                fontSize: 20,
                              ),
                            ),
                          ],
                        ),
                      ),
                      const Icon(Icons.info_outline, color: Colors.white70),
                    ],
                  ),
                );
              },
            ),

            // Invitation Cards Carousel
            FutureBuilder<List<Map<String, dynamic>>>(
              future: _cardsFuture,
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const SizedBox(
                    height: 180,
                    child: Center(child: CircularProgressIndicator()),
                  );
                }
                final cards = snapshot.data ?? [];
                if (cards.isEmpty) return const SizedBox.shrink();

                return Column(
                  children: [
                    SizedBox(
                      height: 300,
                      child: PageView.builder(
                        controller: _cardPageController,
                        itemCount: cards.length,
                        onPageChanged: (index) =>
                            setState(() => _currentCardIndex = index),
                        itemBuilder: (context, index) {
                          final card = cards[index];
                          return _buildBalanceCard(card);
                        },
                      ),
                    ),
                    const SizedBox(height: 12),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: List.generate(
                        cards.length,
                        (index) => AnimatedContainer(
                          duration: const Duration(milliseconds: 300),
                          margin: const EdgeInsets.symmetric(horizontal: 4),
                          height: 8,
                          width: _currentCardIndex == index ? 24 : 8,
                          decoration: BoxDecoration(
                            color: _currentCardIndex == index
                                ? AppColors.primary
                                : Colors.grey[300],
                            borderRadius: BorderRadius.circular(4),
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(height: 24),
                    TextButton.icon(
                      onPressed: () => _handleRequestNewCard(),
                      icon: const Icon(
                        Icons.add_card,
                        size: 20,
                        color: AppColors.primary,
                      ),
                      label: Text(
                        "طلب كارت دعوات إضافي",
                        style: GoogleFonts.cairo(
                          color: AppColors.primary,
                          fontWeight: FontWeight.bold,
                          fontSize: 14,
                        ),
                      ),
                    ),
                  ],
                );
              },
            ),

            const SizedBox(height: 32),

            // Active Invitations Header
            _buildSectionHeader(
              "آخر الدعوات",
              onViewAll: () =>
                  Navigator.pushNamed(context, '/invitations_history'),
            ),
            const SizedBox(height: 16),

            FutureBuilder<List<Map<String, dynamic>>>(
              future: _invitationsFuture,
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(child: CircularProgressIndicator());
                }
                final invitations = snapshot.data ?? [];

                return ListView.separated(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  itemCount: invitations.length,
                  separatorBuilder: (context, index) =>
                      const SizedBox(height: 16),
                  itemBuilder: (context, index) {
                    final inv = invitations[index];
                    return _buildInvitationCard(context, inv);
                  },
                );
              },
            ),
          ],
        ),
      ),
      bottomNavigationBar: Padding(
        padding: const EdgeInsets.all(20.0),
        child: PrimaryButton(
          text: "إصدار دعوة جديدة",
          onPressed: () async {
            await Navigator.pushNamed(context, '/create_invitation');
            _loadData(); // Refresh on back
          },
        ),
      ),
    );
  }

  Widget _buildBalanceCard(Map<String, dynamic> card) {
    final int total = card['total'];
    final int used = card['used'];
    final int remaining = total - used;
    final double usagePercent = total > 0 ? used / total : 0;
    final Color cardColor = Color(int.parse(card['color']));

    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 6, vertical: 4),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(32),
        boxShadow: [
          BoxShadow(
            color: cardColor.withOpacity(0.4),
            blurRadius: 20,
            offset: const Offset(0, 10),
          ),
        ],
      ),
      clipBehavior: Clip.antiAlias,
      child: Stack(
        children: [
          // 1. Dynamic Gradient Background
          Container(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [
                  cardColor,
                  cardColor
                      .withBlue(cardColor.blue + 40)
                      .withRed(cardColor.red - 20),
                ],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
            ),
          ),

          // 2. Subtle Glow Overlay
          Positioned(
            top: -60,
            left: -60,
            child: Container(
              width: 250,
              height: 250,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: Colors.white.withOpacity(0.08),
              ),
            ),
          ),

          // 3. Repeating Pattern Watermark
          Positioned.fill(
            child: Opacity(
              opacity: 0.05,
              child: Image.asset(
                'assets/images/logo.png',
                fit: BoxFit.none,
                scale: 6,
                color: Colors.white,
              ),
            ),
          ),

          // 4. Large Ghosted Icon
          Positioned(
            bottom: -30,
            right: -20,
            child: Opacity(
              opacity: 0.12,
              child: Icon(
                Icons.card_membership_rounded,
                size: 200,
                color: Colors.white,
              ),
            ),
          ),

          // 5. Main Content Row
          Padding(
            padding: const EdgeInsets.all(24),
            child: Row(
              children: [
                // Info Section
                Expanded(
                  flex: 3,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      // Badge for Card Type
                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 10,
                          vertical: 4,
                        ),
                        decoration: BoxDecoration(
                          color: Colors.white.withOpacity(0.2),
                          borderRadius: BorderRadius.circular(20),
                          border: Border.all(
                            color: Colors.white.withOpacity(0.3),
                          ),
                        ),
                        child: Text(
                          card['type'].toString().toUpperCase(),
                          style: GoogleFonts.cairo(
                            color: Colors.white,
                            fontSize: 12,
                            fontWeight: FontWeight.bold,
                            letterSpacing: 0.5,
                          ),
                        ),
                      ),
                      const SizedBox(height: 20),

                      // Progress Ring and Metrics
                      Row(
                        children: [
                          Stack(
                            alignment: Alignment.center,
                            children: [
                              SizedBox(
                                width: 55,
                                height: 55,
                                child: CircularProgressIndicator(
                                  value: usagePercent,
                                  backgroundColor: Colors.white.withOpacity(
                                    0.1,
                                  ),
                                  valueColor:
                                      const AlwaysStoppedAnimation<Color>(
                                        Colors.orangeAccent,
                                      ),
                                  strokeWidth: 5,
                                ),
                              ),
                              Text(
                                "${(usagePercent * 100).toInt()}%",
                                style: GoogleFonts.poppins(
                                  color: Colors.white,
                                  fontSize: 10,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(width: 16),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  "$remaining دعوة",
                                  style: GoogleFonts.cairo(
                                    color: Colors.white,
                                    fontSize: 26,
                                    fontWeight: FontWeight.w900,
                                    height: 1.1,
                                    shadows: const [
                                      Shadow(
                                        color: Colors.black26,
                                        blurRadius: 4,
                                        offset: Offset(0, 2),
                                      ),
                                    ],
                                  ),
                                ),
                                Text(
                                  "رصيد متبقي لسيادتكم",
                                  style: GoogleFonts.cairo(
                                    color: Colors.white70,
                                    fontSize: 11,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),

                      const SizedBox(height: 16),

                      // Total & Used Metrics
                      Row(
                        children: [
                          _buildMiniMetric("الإجمالي", "$total"),
                          Container(
                            margin: const EdgeInsets.symmetric(horizontal: 10),
                            width: 1,
                            height: 15,
                            color: Colors.white24,
                          ),
                          _buildMiniMetric(
                            "تم استخدام",
                            "$used",
                            isWarning: true,
                          ),
                        ],
                      ),

                      const Spacer(),

                      // Expiry with accent
                      Row(
                        children: [
                          const Icon(
                            Icons.verified_user_rounded,
                            color: Colors.amber,
                            size: 14,
                          ),
                          const SizedBox(width: 6),
                          Text(
                            "صالح حتى: ${card['expiry']}",
                            style: GoogleFonts.cairo(
                              color: Colors.white,
                              fontSize: 11,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),

                // 6. Real Glass Grid Section
                Expanded(
                  flex: 2,
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(20),
                    child: BackdropFilter(
                      filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
                      child: Container(
                        padding: const EdgeInsets.all(12),
                        decoration: BoxDecoration(
                          color: Colors.white.withOpacity(0.1),
                          borderRadius: BorderRadius.circular(20),
                          border: Border.all(
                            color: Colors.white.withOpacity(0.2),
                          ),
                        ),
                        child: GridView.builder(
                          shrinkWrap: true,
                          padding: EdgeInsets.zero,
                          physics: const NeverScrollableScrollPhysics(),
                          gridDelegate:
                              const SliverGridDelegateWithFixedCrossAxisCount(
                                crossAxisCount: 5,
                                mainAxisSpacing: 6,
                                crossAxisSpacing: 6,
                              ),
                          itemCount: 30,
                          itemBuilder: (context, index) {
                            bool isUsed = index < used;
                            bool isRemaining = index >= used && index < total;

                            return Container(
                              decoration: BoxDecoration(
                                shape: BoxShape.circle,
                                color: isRemaining
                                    ? Colors.white
                                    : (isUsed
                                          ? Colors.orangeAccent.withOpacity(0.3)
                                          : Colors.white.withOpacity(0.05)),
                                boxShadow: isRemaining
                                    ? [
                                        BoxShadow(
                                          color: Colors.white.withOpacity(0.4),
                                          blurRadius: 8,
                                          spreadRadius: 1,
                                        ),
                                      ]
                                    : null,
                              ),
                              child: isUsed
                                  ? const Center(
                                      child: Icon(
                                        Icons.check,
                                        size: 8,
                                        color: Colors.orangeAccent,
                                      ),
                                    )
                                  : null,
                            );
                          },
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildMiniMetric(
    String label,
    String value, {
    bool isWarning = false,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label.toUpperCase(),
          style: GoogleFonts.cairo(
            color: Colors.white.withOpacity(0.5),
            fontSize: 9,
            fontWeight: FontWeight.bold,
            letterSpacing: 0.5,
          ),
        ),
        Text(
          value,
          style: GoogleFonts.poppins(
            color: isWarning ? Colors.orangeAccent : Colors.white,
            fontSize: 14,
            fontWeight: FontWeight.bold,
          ),
        ),
      ],
    );
  }

  Widget _buildSectionHeader(String title, {VoidCallback? onViewAll}) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Row(
        children: [
          Container(
            width: 5,
            height: 25,
            decoration: BoxDecoration(
              gradient: const LinearGradient(
                colors: [AppColors.primary, AppColors.secondary],
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
              ),
              borderRadius: BorderRadius.circular(10),
            ),
          ),
          const SizedBox(width: 12),
          Text(
            title,
            style: GoogleFonts.cairo(
              fontSize: 20,
              fontWeight: FontWeight.bold,
              color: AppColors.textPrimary,
              letterSpacing: 0.5,
            ),
          ),
          const Spacer(),
          if (onViewAll != null)
            InkWell(
              onTap: onViewAll,
              borderRadius: BorderRadius.circular(8),
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                child: Text(
                  "رؤية الكل",
                  style: GoogleFonts.cairo(
                    fontSize: 12,
                    color: AppColors.primary,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
        ],
      ),
    );
  }

  Widget _buildInvitationCard(BuildContext context, Map<String, dynamic> inv) {
    final guestName = inv['guest_name'] ?? "";
    final date = inv['date'] ?? "";
    final status = inv['status'] ?? "active";
    final guestCount = inv['guest_count'] ?? 1;

    bool isInside = status == "inside";
    bool isActive = status == "active";
    bool isExpired = status == "expired";

    Color statusColor = isActive
        ? AppColors.primary
        : (isInside ? AppColors.success : Colors.grey);
    String actionText = isActive ? "عرض QR" : (isInside ? "تفاصيل" : "منتهي");

    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.04),
            blurRadius: 15,
            offset: const Offset(0, 5),
          ),
        ],
        border: (isActive || isInside)
            ? Border.all(color: statusColor.withOpacity(0.1), width: 1.5)
            : null,
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: () => _showInvitationDetails(context, inv),
          borderRadius: BorderRadius.circular(20),
          child: Padding(
            padding: const EdgeInsets.all(20),
            child: Row(
              children: [
                Container(
                  width: 60,
                  height: 60,
                  decoration: BoxDecoration(
                    color: statusColor.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(14),
                  ),
                  child: Icon(
                    isInside
                        ? Icons.verified_user_rounded
                        : (isActive
                              ? Icons.qr_code_2_rounded
                              : Icons.history_rounded),
                    color: statusColor,
                    size: 30,
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        guestName,
                        style: GoogleFonts.cairo(
                          fontWeight: FontWeight.bold,
                          fontSize: 16,
                          color: isExpired
                              ? Colors.grey
                              : AppColors.textPrimary,
                        ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                      const SizedBox(height: 2),
                      Text(
                        isInside
                            ? "متواجد حالياً بالنادي"
                            : "تاريخ: $date • $guestCount أفراد",
                        style: GoogleFonts.cairo(
                          color: Colors.grey,
                          fontSize: 12,
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(width: 12),
                if (!isExpired)
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 14,
                      vertical: 8,
                    ),
                    decoration: BoxDecoration(
                      color: statusColor,
                      borderRadius: BorderRadius.circular(12),
                      boxShadow: [
                        BoxShadow(
                          color: statusColor.withOpacity(0.3),
                          blurRadius: 8,
                          offset: const Offset(0, 4),
                        ),
                      ],
                    ),
                    child: Text(
                      actionText,
                      style: GoogleFonts.cairo(
                        color: Colors.white,
                        fontSize: 12,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  )
                else
                  Text(
                    "منتهي",
                    style: GoogleFonts.cairo(
                      color: Colors.grey,
                      fontSize: 12,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  void _showInvitationDetails(BuildContext context, Map<String, dynamic> inv) {
    final String name = inv['guest_name'] ?? "";
    final String date = inv['date'] ?? "";
    final String status = inv['status'] ?? "active";
    final int guestCount = inv['guest_count'] ?? 1;
    final String? expiry = inv['expiry'];

    bool isInside = status == "inside";
    bool isActive = status == "active";

    showDialog(
      context: context,
      builder: (context) => Dialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(28)),
        clipBehavior: Clip.antiAlias,
        child: Container(
          width: double.infinity,
          constraints: const BoxConstraints(maxWidth: 400),
          child: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                // Dialog Header
                Container(
                  width: double.infinity,
                  padding: const EdgeInsets.symmetric(vertical: 32),
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      colors: [
                        isActive ? AppColors.primary : AppColors.success,
                        isActive
                            ? AppColors.secondary
                            : AppColors.success.withOpacity(0.8),
                      ],
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                    ),
                  ),
                  child: Column(
                    children: [
                      Container(
                        padding: const EdgeInsets.all(16),
                        decoration: BoxDecoration(
                          color: Colors.white.withOpacity(0.2),
                          shape: BoxShape.circle,
                        ),
                        child: Icon(
                          isActive
                              ? Icons.qr_code_scanner_rounded
                              : Icons.verified_user_rounded,
                          color: Colors.white,
                          size: 40,
                        ),
                      ),
                      const SizedBox(height: 16),
                      Text(
                        isActive ? "تصريح دخول مؤقت" : "الزائر متواجد حالياً",
                        style: GoogleFonts.cairo(
                          fontSize: 22,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                      ),
                    ],
                  ),
                ),

                Padding(
                  padding: const EdgeInsets.all(24.0),
                  child: Column(
                    children: [
                      if (isActive) ...[
                        Container(
                          padding: const EdgeInsets.all(16),
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(20),
                            boxShadow: [
                              BoxShadow(
                                color: Colors.black.withOpacity(0.06),
                                blurRadius: 20,
                                offset: const Offset(0, 10),
                              ),
                            ],
                          ),
                          child: const Icon(
                            Icons.qr_code_2_rounded,
                            size: 180,
                            color: Colors.black87,
                          ),
                        ),
                        const SizedBox(height: 12),
                        Text(
                          "برجاء إظهار الكود لمسؤول الأمن عند الدخول",
                          textAlign: TextAlign.center,
                          style: GoogleFonts.cairo(
                            fontSize: 12,
                            color: Colors.grey[600],
                          ),
                        ),
                        const SizedBox(height: 24),
                      ],

                      _buildModernDetailRow(
                        Icons.person_outline,
                        "اسم الزائر",
                        name,
                      ),
                      const Divider(height: 24),
                      _buildModernDetailRow(
                        Icons.people_outline,
                        "عدد الأفراد",
                        "$guestCount أفراد",
                      ),
                      const Divider(height: 24),
                      _buildModernDetailRow(
                        Icons.calendar_today_outlined,
                        "تاريخ الزيارة",
                        date,
                      ),

                      if (expiry != null && isActive) ...[
                        const Divider(height: 24),
                        _buildModernDetailRow(
                          Icons.timer_outlined,
                          "صالح حتى",
                          "06:00 مساءً",
                        ),
                      ],

                      if (isInside) ...[
                        const Divider(height: 24),
                        _buildModernDetailRow(
                          Icons.login_rounded,
                          "وقت الدخول",
                          "10:30 صباحاً",
                        ),
                      ],

                      const SizedBox(height: 32),

                      if (isActive)
                        PrimaryButton(
                          text: "مشاركة عبر واتساب",
                          onPressed: () => _handleShare(context, name),
                          suffixIcon: Icons.share_rounded,
                        ),

                      const SizedBox(height: 12),
                      TextButton(
                        onPressed: () => Navigator.pop(context),
                        child: Text(
                          "إغلاق",
                          style: GoogleFonts.cairo(
                            color: Colors.grey[600],
                            fontWeight: FontWeight.bold,
                            fontSize: 16,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildModernDetailRow(IconData icon, String label, String value) {
    return Row(
      children: [
        Icon(icon, size: 22, color: AppColors.primary.withOpacity(0.7)),
        const SizedBox(width: 12),
        Text(
          label,
          style: GoogleFonts.cairo(color: Colors.grey[600], fontSize: 14),
        ),
        const Spacer(),
        Text(
          value,
          style: GoogleFonts.cairo(
            fontWeight: FontWeight.bold,
            color: AppColors.textPrimary,
            fontSize: 15,
          ),
        ),
      ],
    );
  }

  void _handleRequestNewCard() async {
    // Show confirmation dialog or immediate request
    final bool? confirm = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(
          "طلب كارت إضافي",
          style: GoogleFonts.cairo(fontWeight: FontWeight.bold),
        ),
        content: Text(
          "هل ترغب في إرسال طلب للإدارة لزيادة رصيد الدعوات الخاص بك؟",
          style: GoogleFonts.cairo(),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: Text("إلغاء", style: GoogleFonts.cairo(color: Colors.grey)),
          ),
          TextButton(
            onPressed: () => Navigator.pop(context, true),
            child: Text(
              "إرسال الطلب",
              style: GoogleFonts.cairo(
                color: AppColors.primary,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ],
      ),
    );

    if (confirm == true) {
      // Simulate API call
      await FirebaseService().requestAdditionalInvitations();

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
              "تم إرسال طلبك بنجاح. سيتم مراجعته من قبل الإدارة.",
              style: GoogleFonts.cairo(),
            ),
            backgroundColor: AppColors.success,
          ),
        );
      }
    }
  }

  void _handleShare(BuildContext context, String name) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          "تم فتح تطبيق واتساب لمشاركة التصريح مع ($name)",
          style: GoogleFonts.cairo(),
        ),
        backgroundColor: const Color(0xFF25D366),
        duration: const Duration(seconds: 3),
      ),
    );
  }
}
