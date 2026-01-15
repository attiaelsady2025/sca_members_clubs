import 'package:sca_members_clubs/core/services/firebase_service.dart';
import 'package:sca_members_clubs/features/dining/data/models/menu_item_model.dart';
import 'package:sca_members_clubs/features/dining/data/models/restaurant_model.dart';
import 'package:sca_members_clubs/features/dining/domain/entities/menu_item.dart';
import 'package:sca_members_clubs/features/dining/domain/entities/restaurant.dart';
import 'package:sca_members_clubs/features/dining/domain/repositories/dining_repository.dart';

class DiningRepositoryImpl implements DiningRepository {
  final FirebaseService _firebaseService;

  DiningRepositoryImpl(this._firebaseService);

  @override
  Future<List<MenuItem>> getMenu(String restaurantId) async {
    final result = await _firebaseService.getMenu(restaurantId);
    return result.map((e) => MenuItemModel.fromMap(e)).toList();
  }

  @override
  Future<List<Restaurant>> getRestaurants({String? clubId}) async {
    final result = await _firebaseService.getRestaurants(clubId: clubId);
    return result.map((e) => RestaurantModel.fromMap(e)).toList();
  }
}
