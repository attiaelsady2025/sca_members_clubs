import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:sca_members_clubs/core/theme/app_colors.dart';
import 'package:sca_members_clubs/core/services/firebase_service.dart';

class AdminBookingScreen extends StatefulWidget {
  const AdminBookingScreen({super.key});

  @override
  State<AdminBookingScreen> createState() => _AdminBookingScreenState();
}

class _AdminBookingScreenState extends State<AdminBookingScreen> {
  late Future<List<Map<String, dynamic>>> _courtsFuture;
  late Future<List<Map<String, dynamic>>> _bookingsFuture;
  String? _clubId;

  @override
  void initState() {
    super.initState();
    _courtsFuture = Future.value([]);
    _bookingsFuture = Future.value([]);
    _loadData();
  }

  Future<void> _loadData() async {
    final profile = await FirebaseService().getUserProfile();
    _clubId = profile['club_id'];
    setState(() {
      _courtsFuture = FirebaseService().getCourts(clubId: _clubId);
      _bookingsFuture = FirebaseService().getBookings(clubId: _clubId);
    });
  }

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2,
      child: Scaffold(
        backgroundColor: AppColors.background,
        appBar: AppBar(
          title: const Text("إدارة الحجوزات والمرافق"),
          backgroundColor: Colors.transparent,
          elevation: 0,
          foregroundColor: Colors.black,
          centerTitle: true,
          bottom: TabBar(
            labelStyle: GoogleFonts.cairo(fontWeight: FontWeight.bold),
            indicatorColor: AppColors.primary,
            labelColor: AppColors.primary,
            unselectedLabelColor: Colors.grey,
            tabs: const [
              Tab(text: "الملاعب والمرافق"),
              Tab(text: "سجل الحجوزات"),
            ],
          ),
        ),
        body: TabBarView(
          children: [_buildFacilitiesList(), _buildBookingsList()],
        ),
      ),
    );
  }

  Widget _buildFacilitiesList() {
    return FutureBuilder<List<Map<String, dynamic>>>(
      future: _courtsFuture,
      builder: (context, snapshot) {
        if (!snapshot.hasData) {
          return const Center(child: CircularProgressIndicator());
        }
        return ListView.separated(
          padding: const EdgeInsets.all(16),
          itemCount: snapshot.data!.length,
          separatorBuilder: (context, index) => const SizedBox(height: 12),
          itemBuilder: (context, index) {
            final court = snapshot.data![index];
            return Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(16),
                border: Border.all(color: Colors.grey.withOpacity(0.1)),
              ),
              child: Row(
                children: [
                  CircleAvatar(
                    backgroundColor: AppColors.primary.withOpacity(0.1),
                    child: Icon(
                      court['type'] == 'tennis'
                          ? Icons.sports_tennis
                          : Icons.sports_soccer,
                      color: AppColors.primary,
                    ),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          court['name'],
                          style: GoogleFonts.cairo(fontWeight: FontWeight.bold),
                        ),
                        Text(
                          court['type'] == 'tennis'
                              ? "ملعب تنس"
                              : "ملعب كرة قدم",
                          style: GoogleFonts.cairo(
                            fontSize: 12,
                            color: Colors.grey,
                          ),
                        ),
                      ],
                    ),
                  ),
                  _buildStatusSwitch(),
                ],
              ),
            );
          },
        );
      },
    );
  }

  Widget _buildStatusSwitch() {
    bool isAvailable = true;
    return StatefulBuilder(
      builder: (context, setState) => Row(
        children: [
          Text(
            isAvailable ? "متاح" : "مغلق",
            style: GoogleFonts.cairo(
              fontSize: 12,
              color: isAvailable ? Colors.green : Colors.red,
            ),
          ),
          Switch(
            value: isAvailable,
            onChanged: (val) => setState(() => isAvailable = val),
            activeThumbColor: Colors.green,
          ),
        ],
      ),
    );
  }

  Widget _buildBookingsList() {
    return FutureBuilder<List<Map<String, dynamic>>>(
      future: _bookingsFuture,
      builder: (context, snapshot) {
        if (!snapshot.hasData) {
          return const Center(child: CircularProgressIndicator());
        }
        return ListView.separated(
          padding: const EdgeInsets.all(16),
          itemCount: snapshot.data!.length,
          separatorBuilder: (context, index) => const SizedBox(height: 12),
          itemBuilder: (context, index) {
            final booking = snapshot.data![index];
            return Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(16),
                border: Border.all(color: Colors.grey.withOpacity(0.1)),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        booking['service_name'],
                        style: GoogleFonts.cairo(fontWeight: FontWeight.bold),
                      ),
                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 8,
                          vertical: 2,
                        ),
                        decoration: BoxDecoration(
                          color: Colors.blue.withOpacity(0.1),
                          borderRadius: BorderRadius.circular(6),
                        ),
                        child: Text(
                          booking['status'],
                          style: GoogleFonts.cairo(
                            fontSize: 10,
                            color: Colors.blue,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 8),
                  Text(
                    "التاريخ: ${booking['date']} - ${booking['time']}",
                    style: GoogleFonts.cairo(fontSize: 12, color: Colors.grey),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    "السعر: ${booking['price']}",
                    style: GoogleFonts.cairo(
                      fontSize: 12,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
            );
          },
        );
      },
    );
  }
}
