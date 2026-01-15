import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:sca_members_clubs/core/theme/app_colors.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sca_members_clubs/features/booking/presentation/cubit/booking_cubit.dart';
import 'package:sca_members_clubs/features/booking/presentation/cubit/booking_state.dart';
import 'package:sca_members_clubs/features/booking/domain/entities/booking.dart';
import 'package:sca_members_clubs/core/di/injection_container.dart';
import 'package:sca_members_clubs/features/home/presentation/cubit/navigation_cubit.dart';
import 'package:intl/intl.dart';
import 'package:intl/date_symbol_data_local.dart';

class MyBookingsScreen extends StatelessWidget {
  const MyBookingsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => sl<BookingCubit>()..loadBookingData(),
      child: const MyBookingsView(),
    );
  }
}

class MyBookingsView extends StatefulWidget {
  const MyBookingsView({super.key});

  @override
  State<MyBookingsView> createState() => _MyBookingsViewState();
}

class _MyBookingsViewState extends State<MyBookingsView> {
  String _selectedStatus = "الكل";
  DateTime? _selectedDate;
  String? _selectedServiceType;

  @override
  void initState() {
    super.initState();
    initializeDateFormatting('ar', null);
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<BookingCubit, BookingState>(
      builder: (context, state) {
        if (state is BookingLoading) {
          return const Center(child: CircularProgressIndicator());
        }
        if (state is BookingError) {
          return Center(child: Text(state.message, style: GoogleFonts.cairo()));
        }
        if (state is BookingLoaded) {
          // Extract unique service names for filter - Ensure String type
          final serviceTypes = state.myBookings
              .map((b) => b.serviceName)
              .toSet()
              .toList();

          // Apply Filters
          var filteredBookings = state.myBookings;

          // 1. Status Filter
          if (_selectedStatus != "الكل") {
            filteredBookings = filteredBookings
                .where((b) => b.status == _selectedStatus)
                .toList();
          }

          // 2. Date Filter
          if (_selectedDate != null) {
            filteredBookings = filteredBookings.where((b) {
              try {
                DateTime bookingDate = DateTime.parse(b.date);
                return isSameDay(bookingDate, _selectedDate!);
              } catch (e) {
                return false;
              }
            }).toList();
          }

          // 3. Service Filter
          if (_selectedServiceType != null) {
            filteredBookings = filteredBookings.where((b) {
              return b.serviceName == _selectedServiceType;
            }).toList();
          }

          return Scaffold(
            backgroundColor: Colors.grey[50],
            body: CustomScrollView(
              slivers: [
                // Clean Header
                SliverAppBar(
                  pinned: true,
                  floating: true,
                  backgroundColor: Colors.white,
                  elevation: 0,
                  centerTitle: true,
                  leading: IconButton(
                    icon: const Icon(
                      Icons.arrow_back_ios_new_rounded,
                      color: AppColors.textPrimary,
                      size: 20,
                    ),
                    onPressed: () {
                      if (Navigator.canPop(context)) {
                        Navigator.of(context).pop();
                      } else {
                        context.read<NavigationCubit>().setTab(0);
                      }
                    },
                  ),
                  title: Text(
                    "سجل الحجوزات",
                    style: GoogleFonts.cairo(
                      color: AppColors.textPrimary,
                      fontWeight: FontWeight.bold,
                      fontSize: 18,
                    ),
                  ),
                  bottom: PreferredSize(
                    preferredSize: const Size.fromHeight(1.0),
                    child: Container(color: Colors.grey[200], height: 1.0),
                  ),
                ),

                // Filters Section
                SliverToBoxAdapter(
                  child: Container(
                    color: Colors.white,
                    padding: const EdgeInsets.fromLTRB(16, 16, 16, 8),
                    child: Column(
                      children: [
                        // Date & Service Horizontal Scroll
                        SingleChildScrollView(
                          scrollDirection: Axis.horizontal,
                          child: Row(
                            children: [
                              _buildFilterAction(
                                label: _selectedDate == null
                                    ? "تاريخ الحجز"
                                    : DateFormat(
                                        'd MMM',
                                        'ar',
                                      ).format(_selectedDate!),
                                icon: Icons.calendar_today_rounded,
                                isActive: _selectedDate != null,
                                onTap: () => _pickDate(context),
                                onClear: _selectedDate != null
                                    ? () => setState(() => _selectedDate = null)
                                    : null,
                              ),
                              const SizedBox(width: 8),
                              _buildFilterAction(
                                label: _selectedServiceType ?? "نوع الخدمة",
                                icon: Icons.category_outlined,
                                isActive: _selectedServiceType != null,
                                onTap: () => _showServiceFilterSheet(
                                  context,
                                  serviceTypes,
                                ),
                                onClear: _selectedServiceType != null
                                    ? () => setState(
                                        () => _selectedServiceType = null,
                                      )
                                    : null,
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(height: 12),
                        // Status Chips
                        SingleChildScrollView(
                          scrollDirection: Axis.horizontal,
                          child: Row(
                            children: [
                              _buildStatusChip("الكل"),
                              const SizedBox(width: 8),
                              _buildStatusChip("مؤكد"),
                              const SizedBox(width: 8),
                              _buildStatusChip("مكتمل"),
                              const SizedBox(width: 8),
                              _buildStatusChip("قيد الانتظار"),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ),

                // Bookings List
                if (filteredBookings.isEmpty)
                  SliverFillRemaining(
                    child: Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Container(
                            padding: const EdgeInsets.all(24),
                            decoration: BoxDecoration(
                              color: Colors.grey[100],
                              shape: BoxShape.circle,
                            ),
                            child: Icon(
                              Icons.calendar_month_outlined,
                              size: 48,
                              color: Colors.grey[400],
                            ),
                          ),
                          const SizedBox(height: 16),
                          Text(
                            "لا توجد حجوزات مطابقة",
                            style: GoogleFonts.cairo(
                              color: Colors.grey[600],
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          if (_selectedDate != null ||
                              _selectedServiceType != null)
                            TextButton(
                              onPressed: () {
                                setState(() {
                                  _selectedDate = null;
                                  _selectedServiceType = null;
                                  _selectedStatus = "الكل";
                                });
                              },
                              child: Text(
                                "مسح المرشحات",
                                style: GoogleFonts.cairo(
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                        ],
                      ),
                    ),
                  )
                else
                  SliverPadding(
                    padding: const EdgeInsets.all(16),
                    sliver: SliverList(
                      delegate: SliverChildBuilderDelegate(
                        (context, index) =>
                            _buildBookingCard(context, filteredBookings[index]),
                        childCount: filteredBookings.length,
                      ),
                    ),
                  ),

                const SliverToBoxAdapter(child: SizedBox(height: 80)),
              ],
            ),
          );
        }
        return const SizedBox.shrink();
      },
    );
  }

  bool isSameDay(DateTime? a, DateTime? b) {
    if (a == null || b == null) return false;
    return a.year == b.year && a.month == b.month && a.day == b.day;
  }

  Future<void> _pickDate(BuildContext context) async {
    final picked = await showDatePicker(
      context: context,
      initialDate:
          _selectedDate ?? DateTime(2026, 1, 12), // Match mock data range
      firstDate: DateTime(2023),
      lastDate: DateTime(2030),
      builder: (context, child) {
        return Theme(
          data: Theme.of(context).copyWith(
            colorScheme: const ColorScheme.light(primary: AppColors.primary),
          ),
          child: child!,
        );
      },
    );
    if (picked != null) {
      if (mounted) setState(() => _selectedDate = picked);
    }
  }

  void _showServiceFilterSheet(BuildContext context, List<String> services) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true, // Allow it to be taller if needed
      backgroundColor: Colors.transparent,
      builder: (context) {
        return Container(
          decoration: const BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
          ),
          constraints: BoxConstraints(
            maxHeight:
                MediaQuery.of(context).size.height * 0.75, // Max 75% height
          ),
          padding: const EdgeInsets.fromLTRB(20, 24, 20, 20),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                width: 40,
                height: 4,
                decoration: BoxDecoration(
                  color: Colors.grey[300],
                  borderRadius: BorderRadius.circular(2),
                ),
              ),
              const SizedBox(height: 16),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    "تصنيف نوع الخدمة",
                    style: GoogleFonts.cairo(
                      fontWeight: FontWeight.bold,
                      fontSize: 18,
                      color: AppColors.textPrimary,
                    ),
                  ),
                  if (_selectedServiceType != null)
                    TextButton(
                      onPressed: () {
                        setState(() => _selectedServiceType = null);
                        Navigator.pop(context);
                      },
                      child: Text(
                        "مسح",
                        style: GoogleFonts.cairo(color: Colors.red),
                      ),
                    ),
                ],
              ),
              const SizedBox(height: 16),
              Flexible(
                child: ListView.separated(
                  shrinkWrap: true,
                  padding: EdgeInsets.zero,
                  itemCount: services.length,
                  separatorBuilder: (context, index) =>
                      const SizedBox(height: 8),
                  itemBuilder: (context, index) {
                    final s = services[index];
                    final isSelected = _selectedServiceType == s;
                    return InkWell(
                      onTap: () {
                        if (mounted) setState(() => _selectedServiceType = s);
                        Navigator.pop(context);
                      },
                      borderRadius: BorderRadius.circular(12),
                      child: Container(
                        padding: const EdgeInsets.all(16),
                        decoration: BoxDecoration(
                          color: isSelected
                              ? AppColors.primary.withOpacity(0.05)
                              : Colors.grey[50],
                          borderRadius: BorderRadius.circular(12),
                          border: Border.all(
                            color: isSelected
                                ? AppColors.primary
                                : Colors.transparent,
                          ),
                        ),
                        child: Row(
                          children: [
                            Container(
                              padding: const EdgeInsets.all(8),
                              decoration: BoxDecoration(
                                color: Colors.white,
                                shape: BoxShape.circle,
                                boxShadow: [
                                  BoxShadow(
                                    color: Colors.black.withOpacity(0.05),
                                    blurRadius: 4,
                                  ),
                                ],
                              ),
                              child: Icon(
                                _getServiceIcon(s),
                                size: 18,
                                color: isSelected
                                    ? AppColors.primary
                                    : Colors.grey[600],
                              ),
                            ),
                            const SizedBox(width: 12),
                            Expanded(
                              child: Text(
                                s,
                                style: GoogleFonts.cairo(
                                  fontSize: 14,
                                  fontWeight: isSelected
                                      ? FontWeight.bold
                                      : FontWeight.w500,
                                  color: isSelected
                                      ? AppColors.primary
                                      : AppColors.textPrimary,
                                ),
                              ),
                            ),
                            if (isSelected)
                              const Icon(
                                Icons.check_circle,
                                color: AppColors.primary,
                                size: 20,
                              ),
                          ],
                        ),
                      ),
                    );
                  },
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  IconData _getServiceIcon(String service) {
    if (service.contains("تنس")) return Icons.sports_tennis;
    if (service.contains("كرة")) return Icons.sports_soccer;
    if (service.contains("سباحة")) return Icons.pool;
    if (service.contains("بادل")) return Icons.sports_tennis; // Close enough
    if (service.contains("جيم") || service.contains("رياضية")) {
      return Icons.fitness_center;
    }
    if (service.contains("تصوير")) return Icons.camera_alt;
    return Icons.category;
  }

  Widget _buildFilterAction({
    required String label,
    required IconData icon,
    required bool isActive,
    required VoidCallback onTap,
    VoidCallback? onClear,
  }) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(30),
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
          decoration: BoxDecoration(
            color: isActive ? AppColors.primary.withOpacity(0.1) : Colors.white,
            border: Border.all(
              color: isActive ? AppColors.primary : Colors.grey[300]!,
            ),
            borderRadius: BorderRadius.circular(30),
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(
                icon,
                size: 16,
                color: isActive ? AppColors.primary : Colors.grey[600],
              ),
              const SizedBox(width: 8),
              Text(
                label,
                style: GoogleFonts.cairo(
                  color: isActive ? AppColors.primary : Colors.grey[700],
                  fontSize: 13,
                  fontWeight: FontWeight.bold,
                ),
              ),
              if (isActive && onClear != null) ...[
                const SizedBox(width: 8),
                InkWell(
                  onTap: onClear,
                  child: const Icon(
                    Icons.close,
                    size: 16,
                    color: AppColors.primary,
                  ),
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildStatusChip(String label) {
    final isSelected = _selectedStatus == label;
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: () => setState(() => _selectedStatus = label),
        borderRadius: BorderRadius.circular(20),
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
          decoration: BoxDecoration(
            color: isSelected ? AppColors.primary : Colors.grey[100],
            borderRadius: BorderRadius.circular(20),
          ),
          child: Text(
            label,
            style: GoogleFonts.cairo(
              color: isSelected ? Colors.white : Colors.grey[600],
              fontSize: 13,
              fontWeight: isSelected ? FontWeight.bold : FontWeight.w600,
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildBookingCard(BuildContext context, Booking booking) {
    final serviceName = booking.serviceName;
    final isCompleted = booking.status == "مكتمل";
    final statusColor = isCompleted ? Colors.grey[700]! : AppColors.success;
    final statusText = booking.status;

    // Format Date for Display (Input: yyyy-MM-dd -> Output: 12 Jan 2026)
    String displayDate = booking.date;
    try {
      final dateObj = DateTime.parse(displayDate);
      displayDate = DateFormat('d MMMM yyyy', 'ar').format(dateObj);
    } catch (e) {
      // Keep original if parse fails
    }

    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.03),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
        border: Border.all(color: Colors.grey[100]!),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header: Icon + Name + Status
          Padding(
            padding: const EdgeInsets.all(16),
            child: Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: AppColors.primary.withOpacity(0.05),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: const Icon(
                    Icons.bookmark,
                    color: AppColors.primary,
                    size: 24,
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        serviceName,
                        style: GoogleFonts.cairo(
                          fontWeight: FontWeight.bold,
                          fontSize: 15,
                          color: AppColors.textPrimary,
                        ),
                      ),
                      if (booking.clubName.isNotEmpty)
                        Text(
                          booking.clubName,
                          style: GoogleFonts.cairo(
                            fontSize: 12,
                            color: Colors.grey[500],
                          ),
                        ),
                    ],
                  ),
                ),
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 10,
                    vertical: 4,
                  ),
                  decoration: BoxDecoration(
                    color: isCompleted
                        ? Colors.grey[200]
                        : AppColors.success.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Text(
                    statusText,
                    style: GoogleFonts.cairo(
                      color: isCompleted ? Colors.grey[600] : AppColors.success,
                      fontSize: 11,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ],
            ),
          ),

          // Divider
          Divider(height: 1, color: Colors.grey[100]),

          // Details Grid
          Padding(
            padding: const EdgeInsets.all(16),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      _buildDetailRow(
                        Icons.calendar_today_outlined,
                        displayDate, // Use Formatted Date
                      ),
                      const SizedBox(height: 8),
                      _buildDetailRow(Icons.access_time, booking.time),
                      if (booking.attendeesCount > 0) ...[
                        const SizedBox(height: 8),
                        _buildDetailRow(
                          Icons.people_outline,
                          "${booking.attendeesCount} أفراد",
                        ),
                      ],
                    ],
                  ),
                ),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    Text(
                      "${booking.totalPrice} ج.م",
                      style: GoogleFonts.cairo(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: AppColors.primary,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Material(
                      color: Colors.transparent,
                      child: InkWell(
                        onTap: () =>
                            _showReceiptDialog(context, booking, serviceName),
                        borderRadius: BorderRadius.circular(8),
                        child: Padding(
                          padding: const EdgeInsets.all(4),
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Text(
                                "عرض الإيصال",
                                style: GoogleFonts.cairo(
                                  color: AppColors.primary,
                                  fontWeight: FontWeight.bold,
                                  fontSize: 12,
                                ),
                              ),
                              const SizedBox(width: 4),
                              const Icon(
                                Icons.arrow_forward_ios_rounded,
                                size: 10,
                                color: AppColors.primary,
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDetailRow(IconData icon, String text) {
    return Row(
      children: [
        Icon(icon, size: 14, color: Colors.grey[400]),
        const SizedBox(width: 6),
        Flexible(
          child: Text(
            text,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: GoogleFonts.cairo(
              color: Colors.grey[600],
              fontSize: 13,
              fontWeight: FontWeight.w600,
            ),
          ),
        ),
      ],
    );
  }

  void _showReceiptDialog(
    BuildContext context,
    Booking booking,
    String serviceName,
  ) {
    if (!mounted) return;

    showDialog(
      context: context,
      builder: (context) => Dialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24)),
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(24),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  "إيصال حجز الكتروني",
                  style: GoogleFonts.cairo(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: AppColors.textPrimary,
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  "#${booking.id}",
                  style: GoogleFonts.cairo(
                    fontSize: 12,
                    color: Colors.grey[400],
                  ),
                ),
                const SizedBox(height: 24),
                _buildReceiptRow("الخدمة", serviceName),
                if (booking.clubName.isNotEmpty)
                  _buildReceiptRow("النادي", booking.clubName),
                _buildReceiptRow("التاريخ", booking.date),
                _buildReceiptRow("الوقت", booking.time),
                Divider(height: 32, color: Colors.grey[200]),

                if (booking.attendeesCount > 0) ...[
                  _buildReceiptRow("العدد", "${booking.attendeesCount}"),
                  Divider(height: 32, color: Colors.grey[200]),
                ],

                _buildReceiptRow(
                  "المبلغ الإجمالي",
                  "${booking.totalPrice} ج.م",
                  isBold: true,
                  color: AppColors.primary,
                ),

                const SizedBox(height: 24),

                // QR Code Section
                Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    border: Border.all(color: Colors.grey[200]!, width: 2),
                    borderRadius: BorderRadius.circular(16),
                  ),
                  child: Column(
                    children: [
                      const Icon(
                        Icons.qr_code_2_rounded,
                        size: 80,
                        color: Colors.black87,
                      ),
                      const SizedBox(height: 4),
                      Text(
                        "امسح الرمز عند الدخول",
                        style: GoogleFonts.cairo(
                          fontSize: 10,
                          color: Colors.grey,
                        ),
                      ),
                    ],
                  ),
                ),

                const SizedBox(height: 24),
                SizedBox(
                  width: double.infinity,
                  child: TextButton(
                    onPressed: () => Navigator.pop(context),
                    style: TextButton.styleFrom(foregroundColor: Colors.grey),
                    child: Text(
                      "إغلاق",
                      style: GoogleFonts.cairo(fontWeight: FontWeight.bold),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildReceiptRow(
    String label,
    String value, {
    bool isBold = false,
    Color? color,
  }) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            label,
            style: GoogleFonts.cairo(color: Colors.grey[500], fontSize: 13),
          ),
          Flexible(
            child: Text(
              value,
              textAlign: TextAlign.end,
              style: GoogleFonts.cairo(
                fontWeight: isBold ? FontWeight.bold : FontWeight.w600,
                fontSize: 14,
                color: color ?? AppColors.textPrimary,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
