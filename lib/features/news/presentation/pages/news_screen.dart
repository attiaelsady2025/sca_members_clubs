import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:sca_members_clubs/core/theme/app_colors.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sca_members_clubs/features/news/presentation/cubit/news_cubit.dart';
import 'package:sca_members_clubs/features/news/presentation/cubit/news_state.dart';
import 'package:sca_members_clubs/features/news/domain/entities/news_article.dart';
import 'package:sca_members_clubs/features/news/domain/entities/event.dart';
import 'package:sca_members_clubs/core/di/injection_container.dart';
import '../widgets/news_card.dart';
import '../widgets/event_card.dart';

class NewsScreen extends StatefulWidget {
  const NewsScreen({super.key});

  @override
  State<NewsScreen> createState() => _NewsScreenState();
}

class _NewsScreenState extends State<NewsScreen>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => sl<NewsCubit>()..loadNewsAndEvents(),
      child: Scaffold(
        backgroundColor: AppColors.background,
        appBar: AppBar(
          title: const Text("الأخبار والفعاليات"),
          centerTitle: true,
          backgroundColor: Colors.transparent,
          elevation: 0,
          foregroundColor: Colors.black,
          bottom: TabBar(
            controller: _tabController,
            labelColor: AppColors.primary,
            unselectedLabelColor: Colors.grey,
            indicatorColor: AppColors.primary,
            labelStyle: GoogleFonts.cairo(fontWeight: FontWeight.bold),
            tabs: const [
              Tab(text: "أخبار النادي"),
              Tab(text: "الفعاليات القادمة"),
            ],
          ),
        ),
        body: BlocBuilder<NewsCubit, NewsState>(
          builder: (context, state) {
            if (state is NewsLoading) {
              return const Center(child: CircularProgressIndicator());
            }
            if (state is NewsError) {
              return Center(
                child: Text(state.message, style: GoogleFonts.cairo()),
              );
            }
            if (state is NewsLoaded) {
              return TabBarView(
                controller: _tabController,
                children: [
                  _buildNewsList(state.news),
                  _buildEventsList(state.events),
                ],
              );
            }
            return const SizedBox.shrink();
          },
        ),
      ),
    );
  }

  Widget _buildNewsList(List<NewsArticle> newsList) {
    return ListView.separated(
      padding: const EdgeInsets.all(20),
      itemCount: newsList.length,
      separatorBuilder: (context, index) => const SizedBox(height: 16),
      itemBuilder: (context, index) {
        final item = newsList[index];
        return NewsCard(
          title: item.title,
          date: item.date,
          description: item.description,
          imageUrl: item.image,
          onTap: () {
            Navigator.pushNamed(context, '/article_detail', arguments: item);
          },
        );
      },
    );
  }

  Widget _buildEventsList(List<Event> eventsList) {
    return ListView.separated(
      padding: const EdgeInsets.all(20),
      itemCount: eventsList.length,
      separatorBuilder: (context, index) => const SizedBox(height: 16),
      itemBuilder: (context, index) {
        final item = eventsList[index];
        return EventCard(
          title: item.title,
          date: item.date,
          time: item.time,
          location: item.location,
          price: item.price,
          onTap: () {
            Navigator.pushNamed(context, '/article_detail', arguments: item);
          },
        );
      },
    );
  }
}
