import 'package:equatable/equatable.dart';
import 'package:sca_members_clubs/features/news/domain/entities/news_article.dart';

abstract class HomeState extends Equatable {
  const HomeState();

  @override
  List<Object?> get props => [];
}

class HomeInitial extends HomeState {}

class HomeLoading extends HomeState {}

class HomeLoaded extends HomeState {
  final List<Map<String, dynamic>> clubs;
  final List<NewsArticle> news;
  final List<Map<String, dynamic>> promos;

  const HomeLoaded({
    required this.clubs,
    required this.news,
    required this.promos,
  });

  @override
  List<Object?> get props => [clubs, news, promos];
}

class HomeError extends HomeState {
  final String message;
  const HomeError(this.message);

  @override
  List<Object?> get props => [message];
}
