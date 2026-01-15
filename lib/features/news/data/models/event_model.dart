import 'package:sca_members_clubs/features/news/domain/entities/event.dart';

class EventModel extends Event {
  const EventModel({
    required super.id,
    required super.title,
    required super.date,
    required super.time,
    required super.location,
    required super.price,
    required super.description,
    required super.content,
    required super.clubId,
  });

  factory EventModel.fromMap(Map<String, dynamic> map) {
    return EventModel(
      id: map['id'] ?? '',
      title: map['title'] ?? '',
      date: map['date'] ?? '',
      time: map['time'] ?? '',
      location: map['location'] ?? '',
      price: map['price'] ?? '',
      description: map['description'] ?? '',
      content: map['content'] ?? '',
      clubId: map['club_id'] ?? '',
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'title': title,
      'date': date,
      'time': time,
      'location': location,
      'price': price,
      'description': description,
      'content': content,
      'club_id': clubId,
    };
  }
}
