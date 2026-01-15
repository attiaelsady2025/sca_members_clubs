import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:sca_members_clubs/core/theme/app_colors.dart';
import 'package:sca_members_clubs/features/news/domain/entities/news_article.dart';
import 'package:sca_members_clubs/features/news/domain/entities/event.dart';

class ArticleDetailScreen extends StatelessWidget {
  const ArticleDetailScreen({super.key});

  @override
  Widget build(BuildContext context) {
    // Receive article data from arguments
    final args = ModalRoute.of(context)?.settings.arguments;

    String title = "تفاصيل العنصر";
    String date = "";
    String description = "لا توجد تفاصيل متاحة حالياً.";
    String content = "لا توجد تفاصيل إضافية لهذا العنصر.";
    String? imageUrl;
    String? id;

    if (args is NewsArticle) {
      title = args.title;
      date = args.date;
      description = args.description;
      content = args.content.trim().isNotEmpty
          ? args.content
          : args.description;
      imageUrl = args.image;
      id = args.id;
    } else if (args is Event) {
      title = args.title;
      date = args.date;
      description = "${args.time} - ${args.location}\nالسعر: ${args.price}";
      content = args.content.trim().isNotEmpty
          ? args.content
          : "فعالية قادمة في ${args.location}";
      id = args.id;
      // Events in mock data don't have separate images, maybe use club image or placeholder
    } else if (args is Map) {
      title = (args['title'] ?? args['name'] ?? title).toString();
      date = (args['date'] ?? args['time'] ?? '').toString();
      description = (args['description'] ?? args['subtitle'] ?? description)
          .toString();

      final contentVal = args['content']?.toString();
      if (contentVal != null && contentVal.trim().isNotEmpty) {
        content = contentVal;
      } else {
        final descVal = args['description']?.toString();
        if (descVal != null && descVal.trim().isNotEmpty) {
          content = descVal;
        }
      }

      imageUrl = (args['image'] ?? args['imageUrl'])?.toString();
      id = args['id']?.toString();
    }

    return Scaffold(
      backgroundColor: Colors.white,
      body: CustomScrollView(
        slivers: [
          // Elegant Header with Image
          SliverAppBar(
            expandedHeight: 300,
            pinned: true,
            flexibleSpace: FlexibleSpaceBar(
              background: Stack(
                fit: StackFit.expand,
                children: [
                  // Image or Placeholder
                  Container(
                    color: AppColors.primary.withOpacity(0.05),
                    child: imageUrl != null && imageUrl.isNotEmpty
                        ? Image.network(
                            imageUrl,
                            fit: BoxFit.cover,
                            loadingBuilder: (context, child, progress) {
                              if (progress == null) return child;
                              return Center(
                                child: CircularProgressIndicator(
                                  value: progress.expectedTotalBytes != null
                                      ? progress.cumulativeBytesLoaded /
                                            progress.expectedTotalBytes!
                                      : null,
                                  color: AppColors.primary,
                                  strokeWidth: 2,
                                ),
                              );
                            },
                            errorBuilder: (context, error, stackTrace) =>
                                Center(
                                  child: Column(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Icon(
                                        Icons.image_not_supported_outlined,
                                        size: 60,
                                        color: AppColors.primary.withOpacity(
                                          0.5,
                                        ),
                                      ),
                                      const SizedBox(height: 8),
                                      Text(
                                        "فشل تحميل الصورة",
                                        style: GoogleFonts.cairo(
                                          color: AppColors.textSecondary,
                                          fontSize: 12,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                          )
                        : Center(
                            child: Icon(
                              id != null && id.startsWith('e')
                                  ? Icons.event
                                  : Icons.image,
                              size: 80,
                              color: AppColors.primary.withOpacity(0.3),
                            ),
                          ),
                  ),
                  // Dark Gradient Overlay
                  Container(
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        begin: Alignment.topCenter,
                        end: Alignment.bottomCenter,
                        colors: [
                          Colors.transparent,
                          Colors.black.withOpacity(0.7),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
            leading: IconButton(
              icon: const Icon(Icons.arrow_back_ios, color: Colors.white),
              onPressed: () => Navigator.pop(context),
            ),
          ),

          // Content
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.all(24.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Category / Date Tag
                  if (date.isNotEmpty)
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 12,
                        vertical: 6,
                      ),
                      decoration: BoxDecoration(
                        color: AppColors.primary.withOpacity(0.1),
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: Text(
                        date,
                        style: GoogleFonts.cairo(
                          color: AppColors.primary,
                          fontSize: 12,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  const SizedBox(height: 16),

                  // Title
                  Text(
                    title,
                    style: GoogleFonts.cairo(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                      color: AppColors.textPrimary,
                    ),
                  ),
                  const SizedBox(height: 16),

                  // Summary / Description
                  Text(
                    description,
                    style: GoogleFonts.cairo(
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                      color: Colors.grey[800],
                      height: 1.6,
                    ),
                  ),
                  const SizedBox(height: 24),

                  const Divider(height: 1, color: Color(0xFFEEEEEE)),
                  const SizedBox(height: 24),

                  // Full Content
                  Text(
                    content,
                    style: GoogleFonts.cairo(
                      fontSize: 15,
                      color: Colors.grey[700],
                      height: 1.8,
                    ),
                  ),

                  const SizedBox(height: 48),

                  // Action Button (Optional)
                  if (id != null && id.startsWith('p')) // If it's a promo
                    SizedBox(
                      width: double.infinity,
                      height: 55,
                      child: ElevatedButton(
                        onPressed: () {
                          // Handle call to action
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                              content: Text(
                                "سيتم توجيهك قريباً...",
                                style: GoogleFonts.cairo(),
                              ),
                            ),
                          );
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: AppColors.primary,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(16),
                          ),
                        ),
                        child: Text(
                          "استفد من العرض الآن",
                          style: GoogleFonts.cairo(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                          ),
                        ),
                      ),
                    ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
