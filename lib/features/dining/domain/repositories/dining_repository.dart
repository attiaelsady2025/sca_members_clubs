import 'package:sca_members_clubs/features/dining/domain/entities/menu_item.dart';
import 'package:sca_members_clubs/features/dining/domain/entities/restaurant.dart';

abstract class DiningRepository {
  Future<List<Restaurant>> getRestaurants({String? clubId});
  Future<List<MenuItem>> getMenu(String restaurantId);
}
