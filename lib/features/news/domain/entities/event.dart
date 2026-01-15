import 'package:equatable/equatable.dart';

class Event extends Equatable {
  final String id;
  final String title;
  final String date;
  final String time;
  final String location;
  final String price;
  final String description;
  final String content;
  final String clubId;

  const Event({
    required this.id,
    required this.title,
    required this.date,
    required this.time,
    required this.location,
    required this.price,
    required this.description,
    required this.content,
    required this.clubId,
  });

  @override
  List<Object?> get props => [id, title, date, clubId];
}
