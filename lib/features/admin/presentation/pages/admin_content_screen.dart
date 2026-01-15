import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:sca_members_clubs/core/theme/app_colors.dart';
import 'package:sca_members_clubs/core/services/firebase_service.dart';

class AdminContentScreen extends StatefulWidget {
  const AdminContentScreen({super.key});

  @override
  State<AdminContentScreen> createState() => _AdminContentScreenState();
}

class _AdminContentScreenState extends State<AdminContentScreen> {
  late Future<List<Map<String, dynamic>>> _newsFuture;
  late Future<List<Map<String, dynamic>>> _promosFuture;
  String? _clubId;

  @override
  void initState() {
    super.initState();
    _newsFuture = Future.value([]);
    _promosFuture = Future.value([]);
    _loadData();
  }

  Future<void> _loadData() async {
    final profile = await FirebaseService().getUserProfile();
    _clubId = profile['club_id'];
    setState(() {
      _newsFuture = FirebaseService().getNews(clubId: _clubId);
      _promosFuture = FirebaseService().getPromos();
    });
  }

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2,
      child: Scaffold(
        backgroundColor: AppColors.background,
        appBar: AppBar(
          title: const Text("إدارة المحتوى"),
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
              Tab(text: "الأخبار والفعاليات"),
              Tab(text: "البانرات والعروض"),
            ],
          ),
        ),
        body: TabBarView(children: [_buildNewsList(), _buildPromosList()]),
        floatingActionButton: FloatingActionButton(
          onPressed: () {}, // Add new content logic
          backgroundColor: AppColors.primary,
          child: const Icon(Icons.add, color: Colors.white),
        ),
      ),
    );
  }

  Widget _buildNewsList() {
    return FutureBuilder<List<Map<String, dynamic>>>(
      future: _newsFuture,
      builder: (context, snapshot) {
        if (!snapshot.hasData) {
          return const Center(child: CircularProgressIndicator());
        }
        return ListView.separated(
          padding: const EdgeInsets.all(16),
          itemCount: snapshot.data!.length,
          separatorBuilder: (context, index) => const SizedBox(height: 12),
          itemBuilder: (context, index) {
            final item = snapshot.data![index];
            return Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: Colors.grey.withOpacity(0.1)),
              ),
              child: Row(
                children: [
                  Container(
                    width: 60,
                    height: 60,
                    decoration: BoxDecoration(
                      color: Colors.grey[200],
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: const Icon(Icons.image, color: Colors.grey),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          item['title'],
                          style: GoogleFonts.cairo(
                            fontWeight: FontWeight.bold,
                            fontSize: 13,
                          ),
                        ),
                        Text(
                          item['date'] ?? "",
                          style: GoogleFonts.cairo(
                            fontSize: 10,
                            color: Colors.grey,
                          ),
                        ),
                      ],
                    ),
                  ),
                  IconButton(
                    icon: const Icon(Icons.edit, size: 20),
                    onPressed: () {},
                  ),
                  IconButton(
                    icon: const Icon(
                      Icons.delete_outline,
                      size: 20,
                      color: Colors.red,
                    ),
                    onPressed: () {},
                  ),
                ],
              ),
            );
          },
        );
      },
    );
  }

  Widget _buildPromosList() {
    return FutureBuilder<List<Map<String, dynamic>>>(
      future: _promosFuture,
      builder: (context, snapshot) {
        if (!snapshot.hasData) {
          return const Center(child: CircularProgressIndicator());
        }
        return ListView.separated(
          padding: const EdgeInsets.all(16),
          itemCount: snapshot.data!.length,
          separatorBuilder: (context, index) => const SizedBox(height: 12),
          itemBuilder: (context, index) {
            final item = snapshot.data![index];
            return Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: Colors.grey.withOpacity(0.1)),
              ),
              child: Row(
                children: [
                  Container(
                    width: 60,
                    height: 60,
                    decoration: BoxDecoration(
                      color: Color(
                        int.parse(item['color'] ?? "0xFF808080"),
                      ).withOpacity(0.2),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Icon(
                      Icons.star,
                      color: Color(int.parse(item['color'] ?? "0xFF808080")),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          item['title'],
                          style: GoogleFonts.cairo(
                            fontWeight: FontWeight.bold,
                            fontSize: 13,
                          ),
                        ),
                        Text(
                          item['subtitle'] ?? "",
                          style: GoogleFonts.cairo(
                            fontSize: 10,
                            color: Colors.grey,
                          ),
                        ),
                      ],
                    ),
                  ),
                  IconButton(
                    icon: const Icon(Icons.edit, size: 20),
                    onPressed: () {},
                  ),
                  IconButton(
                    icon: const Icon(
                      Icons.delete_outline,
                      size: 20,
                      color: Colors.red,
                    ),
                    onPressed: () {},
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
