import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:sca_members_clubs/core/theme/app_colors.dart';
import 'package:sca_members_clubs/core/services/firebase_service.dart';

class ClubMapScreen extends StatefulWidget {
  const ClubMapScreen({super.key});

  @override
  State<ClubMapScreen> createState() => _ClubMapScreenState();
}

class _ClubMapScreenState extends State<ClubMapScreen> with TickerProviderStateMixin {
  late Future<List<Map<String, dynamic>>> _locationsFuture;
  final TransformationController _transformationController = TransformationController();
  String _selectedCategory = "الكل";
  
  final List<Map<String, dynamic>> _categories = [
    {"name": "الكل", "icon": Icons.map_outlined},
    {"name": "مباني", "icon": Icons.apartment, "type": "building"},
    {"name": "رياضة", "icon": Icons.sports_tennis, "type": "sports"},
    {"name": "مطاعم", "icon": Icons.restaurant, "type": "food"},
    {"name": "خدمات", "icon": Icons.settings, "type": "gate"},
  ];

  @override
  void initState() {
    super.initState();
    _locationsFuture = FirebaseService().getMapLocations();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF0F2F5),
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        title: Text(
          "خريطة النادي البلاتينية",
          style: GoogleFonts.cairo(fontWeight: FontWeight.bold, fontSize: 18),
        ),
        backgroundColor: Colors.white.withOpacity(0.8),
        elevation: 0,
        foregroundColor: AppColors.textPrimary,
        centerTitle: true,
        flexibleSpace: ClipRect(
          child: BackdropFilter(
            filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
            child: Container(color: Colors.transparent),
          ),
        ),
      ),
      body: Stack(
        children: [
          FutureBuilder<List<Map<String, dynamic>>>(
            future: _locationsFuture,
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return const Center(child: CircularProgressIndicator());
              }
              if (snapshot.hasError) {
                return Center(child: Text("خطأ في تحميل الخريطة", style: GoogleFonts.cairo()));
              }

              final allLocations = snapshot.data ?? [];
              final filteredLocations = _selectedCategory == "الكل"
                  ? allLocations
                  : allLocations.where((l) => l['type'] == _categories.firstWhere((c) => c['name'] == _selectedCategory)['type']).toList();

              return InteractiveViewer(
                transformationController: _transformationController,
                minScale: 0.2,
                maxScale: 4.0,
                boundaryMargin: const EdgeInsets.all(1000),
                child: Center(
                  child: SizedBox(
                    width: 1200,
                    height: 1000,
                    child: Stack(
                      children: [
                        // Premium Custom Map Canvas
                        CustomPaint(
                          size: const Size(1200, 1000),
                          painter: ClubMapPainter(),
                        ),

                        // Animated Markers
                        ...filteredLocations.map((loc) {
                          return Positioned(
                            left: (loc['x'] * 1200) - 30,
                            top: (loc['y'] * 1000) - 70,
                            child: _MapMarker(
                              location: loc,
                              onTap: () => _showLocationDetails(context, loc),
                            ),
                          );
                        }).toList(),
                      ],
                    ),
                  ),
                ),
              );
            },
          ),

          // Floating Category Filter
          Positioned(
            bottom: 40,
            left: 20,
            right: 20,
            child: _buildCategoryFilter(),
          ),

          // Zoom Controls
          Positioned(
            right: 20,
            top: 150,
            child: _buildZoomControls(),
          ),
        ],
      ),
    );
  }

  Widget _buildCategoryFilter() {
    return Container(
      height: 60,
      padding: const EdgeInsets.symmetric(horizontal: 12),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.9),
        borderRadius: BorderRadius.circular(30),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 20,
            offset: const Offset(0, 10),
          ),
        ],
      ),
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        itemCount: _categories.length,
        itemBuilder: (context, index) {
          final cat = _categories[index];
          final isSelected = _selectedCategory == cat['name'];
          return Padding(
            padding: const EdgeInsets.symmetric(horizontal: 4),
            child: ChoiceChip(
              label: Text(
                cat['name'],
                style: GoogleFonts.cairo(
                  fontSize: 12,
                  fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
                  color: isSelected ? Colors.white : AppColors.textPrimary,
                ),
              ),
              selected: isSelected,
              onSelected: (selected) {
                if (selected) {
                  setState(() => _selectedCategory = cat['name']);
                }
              },
              selectedColor: AppColors.primary,
              backgroundColor: Colors.transparent,
              elevation: 0,
              pressElevation: 0,
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
            ),
          );
        },
      ),
    );
  }

  Widget _buildZoomControls() {
    return Column(
      children: [
        _zoomButton(Icons.add, () {
          _transformationController.value = Matrix4.identity()..scale(_transformationController.value.getMaxScaleOnAxis() * 1.2);
        }),
        const SizedBox(height: 8),
        _zoomButton(Icons.remove, () {
           _transformationController.value = Matrix4.identity()..scale(_transformationController.value.getMaxScaleOnAxis() * 0.8);
        }),
      ],
    );
  }

  Widget _zoomButton(IconData icon, VoidCallback onTap) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: 44,
        height: 44,
        decoration: BoxDecoration(
          color: Colors.white,
          shape: BoxShape.circle,
          boxShadow: [BoxShadow(color: Colors.black12, blurRadius: 10)],
        ),
        child: Icon(icon, color: AppColors.primary, size: 24),
      ),
    );
  }

  void _showLocationDetails(BuildContext context, Map<String, dynamic> loc) {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      builder: (context) => _LocationDetailSheet(location: loc),
    );
  }
}

class _MapMarker extends StatefulWidget {
  final Map<String, dynamic> location;
  final VoidCallback onTap;

  const _MapMarker({required this.location, required this.onTap});

  @override
  State<_MapMarker> createState() => _MapMarkerState();
}

class _MapMarkerState extends State<_MapMarker> with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _animation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(vsync: this, duration: const Duration(seconds: 2))..repeat(reverse: true);
    _animation = Tween<double>(begin: 0.0, end: 10.0).animate(CurvedAnimation(parent: _controller, curve: Curves.easeInOut));
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: widget.onTap,
      child: AnimatedBuilder(
        animation: _animation,
        builder: (context, child) {
          return Transform.translate(
            offset: Offset(0, -_animation.value),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Container(
                  padding: const EdgeInsets.all(2),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    shape: BoxShape.circle,
                    boxShadow: [
                      BoxShadow(color: Colors.black26, blurRadius: 10, offset: const Offset(0, 5)),
                    ],
                  ),
                  child: Container(
                    padding: const EdgeInsets.all(8),
                    decoration: BoxDecoration(
                      color: widget.location['color'],
                      shape: BoxShape.circle,
                    ),
                    child: Icon(widget.location['icon'], color: Colors.white, size: 24),
                  ),
                ),
                CustomPaint(
                  size: const Size(12, 8),
                  painter: _MarkerArrowPainter(color: widget.location['color']),
                ),
                const SizedBox(height: 4),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                  decoration: BoxDecoration(
                    color: Colors.black.withOpacity(0.7),
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(color: Colors.white24),
                  ),
                  child: Text(
                    widget.location['name'],
                    style: GoogleFonts.cairo(color: Colors.white, fontSize: 11, fontWeight: FontWeight.bold),
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}

class _MarkerArrowPainter extends CustomPainter {
  final Color color;
  _MarkerArrowPainter({required this.color});

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()..color = color;
    final path = Path();
    path.moveTo(0, 0);
    path.lineTo(size.width, 0);
    path.lineTo(size.width / 2, size.height);
    path.close();
    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) => false;
}

class ClubMapPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()..isAntiAlias = true;

    // Grass Background
    paint.color = const Color(0xFFE8F5E9);
    canvas.drawRRect(RRect.fromRectAndRadius(Rect.fromLTWH(0, 0, size.width, size.height), const Radius.circular(40)), paint);

    // Stylized Lake / Water Body
    paint.color = const Color(0xFFBBDEFB);
    final waterPath = Path()
      ..moveTo(size.width * 0.6, size.height * 0.1)
      ..cubicTo(size.width * 0.9, size.height * 0.0, size.width * 1.0, size.height * 0.4, size.width * 0.7, size.height * 0.5)
      ..cubicTo(size.width * 0.5, size.height * 0.6, size.width * 0.4, size.height * 0.2, size.width * 0.6, size.height * 0.1);
    canvas.drawPath(waterPath, paint);

    // Roads / Paths
    paint.color = const Color(0xFFEEEEEE);
    paint.strokeWidth = 35;
    paint.style = PaintingStyle.stroke;
    paint.strokeCap = StrokeCap.round;
    
    final roadPath = Path()
      ..moveTo(size.width * 0.5, 40)
      ..lineTo(size.width * 0.5, size.height - 40)
      ..moveTo(40, size.height * 0.4)
      ..lineTo(size.width - 40, size.height * 0.4)
      ..moveTo(size.width * 0.2, size.height * 0.4)
      ..quadraticBezierTo(size.width * 0.1, size.height * 0.7, size.width * 0.3, size.height * 0.8);
    canvas.drawPath(roadPath, paint);

    // Inner paths (walking paths)
    paint.strokeWidth = 10;
    paint.color = Colors.white;
    canvas.drawPath(roadPath, paint);

    // Buildings Area (Placeholders)
    paint.style = PaintingStyle.fill;
    paint.color = Colors.white.withOpacity(0.8);
    
    // Social Building
    canvas.drawRRect(RRect.fromRectAndRadius(Rect.fromCenter(center: Offset(size.width * 0.5, size.height * 0.4), width: 140, height: 100), const Radius.circular(15)), paint);
    
    // Gym / Sports
    canvas.drawRRect(RRect.fromRectAndRadius(Rect.fromCenter(center: Offset(size.width * 0.8, size.height * 0.3), width: 100, height: 80), const Radius.circular(10)), paint);

    // Trees / Landscape
    paint.color = const Color(0xFF81C784);
    final List<Offset> trees = [
      Offset(size.width * 0.2, size.height * 0.2),
      Offset(size.width * 0.25, size.height * 0.22),
      Offset(size.width * 0.18, size.height * 0.25),
      Offset(size.width * 0.75, size.height * 0.8),
      Offset(size.width * 0.8, size.height * 0.75),
      Offset(size.width * 0.1, size.height * 0.5),
    ];
    for (var pos in trees) {
      canvas.drawCircle(pos, 15, paint);
      canvas.drawCircle(pos + const Offset(5, 5), 10, paint);
    }
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) => false;
}

class _LocationDetailSheet extends StatelessWidget {
  final Map<String, dynamic> location;
  const _LocationDetailSheet({required this.location});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.vertical(top: Radius.circular(32)),
      ),
      padding: const EdgeInsets.all(32),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            width: 40,
            height: 4,
            decoration: BoxDecoration(color: Colors.grey[300], borderRadius: BorderRadius.circular(2)),
          ),
          const SizedBox(height: 24),
          Row(
            children: [
              Container(
                width: 70,
                height: 70,
                decoration: BoxDecoration(
                  color: location['color'].withOpacity(0.1),
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Icon(location['icon'], color: location['color'], size: 35),
              ),
              const SizedBox(width: 20),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      location['name'],
                      style: GoogleFonts.cairo(fontSize: 22, fontWeight: FontWeight.bold, color: AppColors.textPrimary),
                    ),
                    Text(
                      "أكاديميات رياضية ومبنى اجتماعي",
                      style: GoogleFonts.cairo(fontSize: 14, color: AppColors.textSecondary),
                    ),
                  ],
                ),
              ),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                decoration: BoxDecoration(
                  color: Colors.green[50],
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Text(
                  "مفتوح",
                  style: GoogleFonts.cairo(color: Colors.green[700], fontWeight: FontWeight.bold, fontSize: 12),
                ),
              ),
            ],
          ),
          const SizedBox(height: 32),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
               _actionButton(Icons.directions, "التوجه", AppColors.primary),
               _actionButton(Icons.calendar_month, "حجز", AppColors.accent),
               _actionButton(Icons.share, "مشاركة", Colors.blueGrey),
            ],
          ),
          const SizedBox(height: 16),
        ],
      ),
    );
  }

  Widget _actionButton(IconData icon, String label, Color color) {
    return Column(
      children: [
        Container(
          width: 54,
          height: 54,
          decoration: BoxDecoration(
            color: color.withOpacity(0.1),
            shape: BoxShape.circle,
          ),
          child: Icon(icon, color: color, size: 24),
        ),
        const SizedBox(height: 8),
        Text(label, style: GoogleFonts.cairo(fontSize: 14, fontWeight: FontWeight.bold, color: AppColors.textPrimary)),
      ],
    );
  }
}

