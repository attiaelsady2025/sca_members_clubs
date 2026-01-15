import 'dart:async';
import 'mock_data.dart';

class FirebaseService {
  static final FirebaseService _instance = FirebaseService._internal();
  factory FirebaseService() => _instance;
  FirebaseService._internal();

  Future<void> _simulateDelay() async {
    await Future.delayed(const Duration(milliseconds: 800));
  }

  static Map<String, dynamic>? _currentUser;

  // --- Auth ---
  Future<Map<String, dynamic>?> login(
    String identifier,
    String password,
  ) async {
    await _simulateDelay();
    try {
      final user = MockData.registeredUsers.firstWhere(
        (u) => u['identifier'] == identifier && u['password'] == password,
      );
      _currentUser = user['profile'];
      return _currentUser;
    } catch (_) {
      return null;
    }
  }

  Future<void> register(Map<String, dynamic> userData) async {
    await _simulateDelay();
    MockData.registeredUsers.add({
      "identifier": userData['email'] ?? userData['membership_id'],
      "password": userData['password'],
      "profile": {
        ...MockData.memberProfile,
        "name": userData['name'],
        "role": "member",
      },
    });
  }

  Future<Map<String, dynamic>> getUserProfile() async {
    await _simulateDelay();
    return _currentUser ?? MockData.memberProfile;
  }

  // --- Data Fetching with Club Filtering ---
  Future<List<Map<String, dynamic>>> getClubs({
    String? governorate,
    String? clubId,
  }) async {
    await _simulateDelay();
    var list = MockData.clubs;
    if (governorate != null) {
      list = list.where((c) => c['governorate'] == governorate).toList();
    }
    if (clubId != null && clubId != "global") {
      list = list.where((c) => c['id'] == clubId).toList();
    }
    return list;
  }

  Future<List<Map<String, dynamic>>> getNews({String? clubId}) async {
    await _simulateDelay();
    if (clubId != null && clubId != "global") {
      return MockData.news.where((n) => n['club_id'] == clubId).toList();
    }
    return MockData.news;
  }

  Future<List<Map<String, dynamic>>> getEvents({String? clubId}) async {
    await _simulateDelay();
    if (clubId != null && clubId != "global") {
      return MockData.events.where((e) => e['club_id'] == clubId).toList();
    }
    return MockData.events;
  }

  Future<List<Map<String, dynamic>>> getBookings({String? clubId}) async {
    await _simulateDelay();
    if (clubId != null && clubId != "global") {
      return MockData.bookings.where((b) => b['club_id'] == clubId).toList();
    }
    return MockData.bookings;
  }

  Future<List<Map<String, dynamic>>> getInvitationRequests({
    String? clubId,
  }) async {
    await _simulateDelay();
    if (clubId != null && clubId != "global") {
      return MockData.invitationRequests
          .where((r) => r['club_id'] == clubId)
          .toList();
    }
    return MockData.invitationRequests;
  }

  Future<List<Map<String, dynamic>>> getComplaints({String? clubId}) async {
    await _simulateDelay();
    if (clubId != null && clubId != "global") {
      return MockData.complaints.where((c) => c['club_id'] == clubId).toList();
    }
    return MockData.complaints;
  }

  Future<List<Map<String, dynamic>>> getCourts({String? clubId}) async {
    await _simulateDelay();
    return MockData.courts;
  }

  // --- Advanced Admin: Broadcasting & Analytics ---
  Future<void> sendBroadcastNotification(
    String title,
    String message, {
    String? targetClubId,
  }) async {
    await _simulateDelay();
    MockData.notifications.insert(0, {
      "id": "not_${DateTime.now().millisecondsSinceEpoch}",
      "title": title,
      "message": message,
      "time": "الآن",
      "type": "general",
      "is_read": false,
      "club_id": targetClubId,
    });
  }

  Future<Map<String, dynamic>> getAnalyticsData({String? clubId}) async {
    await _simulateDelay();
    return {
      "visitors_today": clubId == "c2" ? 45 : 124,
      "active_bookings": clubId == "c2" ? 8 : 22,
      "revenue_this_month": clubId == "c2" ? "45,000 ج.م" : "154,200 ج.م",
      "membership_distribution": [
        {"label": "عامل", "value": 65},
        {"label": "تابع", "value": 25},
        {"label": "خارجي", "value": 10},
      ],
      "monthly_activity": [30, 45, 60, 40, 80, 95, 120],
    };
  }

  Future<List<Map<String, dynamic>>> getAdminLogs({String? clubId}) async {
    await _simulateDelay();
    if (clubId != null && clubId != "global") {
      return MockData.adminLogs.where((l) => l['club_id'] == clubId).toList();
    }
    return MockData.adminLogs;
  }

  Future<List<Map<String, dynamic>>> getStaffMembers({String? clubId}) async {
    await _simulateDelay();
    if (clubId != null && clubId != "global") {
      return MockData.staffMembers
          .where((s) => s['club_id'] == clubId)
          .toList();
    }
    return MockData.staffMembers;
  }

  Future<List<Map<String, dynamic>>> getPendingVerifications({
    String? clubId,
  }) async {
    await _simulateDelay();
    if (clubId != null && clubId != "global") {
      return MockData.pendingVerifications
          .where((v) => v['club_id'] == clubId)
          .toList();
    }
    return MockData.pendingVerifications;
  }

  // --- Club Operations: Security & Official Guests ---
  Future<List<Map<String, dynamic>>> getSecurityStaff({String? clubId}) async {
    await _simulateDelay();
    if (clubId != null && clubId != "global") {
      return MockData.securityStaff
          .where((s) => s['club_id'] == clubId)
          .toList();
    }
    return MockData.securityStaff;
  }

  Future<void> updateSecurityShift(
    String id,
    String newShift,
    String newGate,
  ) async {
    await _simulateDelay();
    final i = MockData.securityStaff.indexWhere((s) => s['id'] == id);
    if (i != -1) {
      MockData.securityStaff[i]['shift'] = newShift;
      MockData.securityStaff[i]['gate'] = newGate;
    }
  }

  Future<void> addSecurityStaff(Map<String, dynamic> staffData) async {
    await _simulateDelay();
    MockData.securityStaff.add({
      ...staffData,
      "id": "sec_${DateTime.now().millisecondsSinceEpoch}",
    });
  }

  Future<List<Map<String, dynamic>>> getOfficialGuests({String? clubId}) async {
    await _simulateDelay();
    if (clubId != null && clubId != "global") {
      return MockData.officialGuests
          .where((g) => g['club_id'] == clubId)
          .toList();
    }
    return MockData.officialGuests;
  }

  Future<void> createOfficialInvitation(Map<String, dynamic> guest) async {
    await _simulateDelay();
    MockData.officialGuests.insert(0, {
      ...guest,
      "id": "vip_${DateTime.now().millisecondsSinceEpoch}",
      "entry_code":
          "VIP-${(1000 + DateTime.now().millisecond % 9000).toString()}",
    });
  }

  // --- Other Methods ---
  Future<int> getCurrentVisitorsCount() async {
    await _simulateDelay();
    return MockData.activeVisitors.length;
  }

  Future<void> requestAdditionalInvitations() async {
    await _simulateDelay();
    // Simulate request submission - in real app would create a request record
  }

  // --- User Management ---
  Future<void> createUser(Map<String, dynamic> userData) async {
    await _simulateDelay();
    MockData.registeredUsers.add({
      "identifier": userData['email'] ?? userData['membership_id'],
      "password": userData['password'] ?? "123456", // Default password
      "profile": userData,
    });
  }

  Future<List<Map<String, dynamic>>> getUsers({String? clubId}) async {
    await _simulateDelay();
    var users = MockData.registeredUsers
        .map((u) => u['profile'] as Map<String, dynamic>)
        .toList();
    if (clubId != null && clubId != "global") {
      users = users
          .where((u) => u['club_id'] == clubId || u['role'] == 'member')
          .toList();
    }
    return users;
  }

  Future<List<Map<String, dynamic>>> getInvitations() async {
    await _simulateDelay();
    return MockData.invitations;
  }

  Future<List<Map<String, dynamic>>> getInvitationCards() async {
    await _simulateDelay();
    return MockData.invitationCards;
  }

  Future<void> createInvitation(Map<String, dynamic> inv) async {
    await _simulateDelay();
    MockData.invitations.insert(0, {
      ...inv,
      "id": "inv_${DateTime.now().millisecondsSinceEpoch}",
      "status": "active",
    });
  }

  Future<List<Map<String, dynamic>>> getActiveVisitors() async {
    await _simulateDelay();
    return MockData.activeVisitors;
  }

  Future<List<Map<String, dynamic>>> getRestaurants({String? clubId}) async {
    await _simulateDelay();
    return (clubId != null)
        ? MockData.restaurants.where((r) => r['club_id'] == clubId).toList()
        : MockData.restaurants;
  }

  Future<List<Map<String, dynamic>>> getMenu(String rid) async {
    await _simulateDelay();
    return MockData.menuItems.where((m) => m['restaurant_id'] == rid).toList();
  }

  Future<List<Map<String, dynamic>>> getFamilyMembers() async {
    await _simulateDelay();
    return MockData.familyMembers;
  }

  Future<void> addFamilyMember(Map<String, dynamic> m) async {
    await _simulateDelay();
    MockData.familyMembers.add(m);
  }

  Future<List<String>> getMembershipTypes() async {
    await _simulateDelay();
    return MockData.membershipTypes;
  }

  Future<List<Map<String, dynamic>>> getMapLocations() async {
    await _simulateDelay();
    return MockData.mapLocations;
  }

  Future<List<Map<String, dynamic>>> getActivities({String? clubId}) async {
    await _simulateDelay();
    if (clubId != null) {
      return MockData.activities.where((a) => a['club_id'] == clubId).toList();
    }
    return MockData.activities;
  }

  Future<void> addBooking(Map<String, dynamic> b) async {
    await _simulateDelay();
    MockData.bookings.insert(0, b);
  }

  Future<List<Map<String, dynamic>>> getPromos() async {
    await _simulateDelay();
    return MockData.promos;
  }

  Future<List<Map<String, dynamic>>> getNotifications() async {
    await _simulateDelay();
    return MockData.notifications;
  }

  Future<int> getUnreadNotificationsCount() async {
    await _simulateDelay();
    return MockData.notifications.where((n) => !(n['is_read'] as bool)).length;
  }

  Future<void> markNotificationAsRead(String id) async {
    await _simulateDelay();
    final i = MockData.notifications.indexWhere((n) => n['id'] == id);
    if (i != -1) MockData.notifications[i]['is_read'] = true;
  }

  Future<List<Map<String, dynamic>>> getFrequentGuests() async {
    await _simulateDelay();
    return MockData.frequentGuests;
  }

  Future<void> toggleFrequentGuest(Map<String, dynamic> g) async {
    await _simulateDelay();
    final i = MockData.frequentGuests.indexWhere(
      (fg) => fg['national_id'] == g['national_id'],
    );
    if (i != -1) {
      MockData.frequentGuests.removeAt(i);
    } else {
      MockData.frequentGuests.add({
        ...g,
        "id": "fg_${DateTime.now().millisecondsSinceEpoch}",
      });
    }
  }

  Future<List<Map<String, dynamic>>> getBookingSlots(String cid) async {
    await _simulateDelay();
    return MockData.bookingSlots[cid] ?? [];
  }

  Future<void> updateInvitationRequestStatus(
    String reqId,
    String status,
  ) async {
    await _simulateDelay();
    final i = MockData.invitationRequests.indexWhere((r) => r['id'] == reqId);
    if (i != -1) MockData.invitationRequests[i]['status'] = status;
  }
}
