
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:sca_members_clubs/core/services/mock_data.dart';

class FirestoreMigrationService {
  final FirebaseFirestore _db = FirebaseFirestore.instance;

  Future<void> migrateAllData() async {
    try {
      print("🚀 بدء عملية تهجير البيانات...");

      // 1. الأندية (Clubs)
      for (var club in MockData.clubs) {
        await _db.collection('clubs').doc(club['id']).set(club);
      }
      print("✅ تم رفع بيانات الأندية");

      // 2. الأخبار (News)
      for (var n in MockData.news) {
        await _db.collection('news').doc(n['id']).set(n);
      }
      print("✅ تم رفع الأخبار");

      // 3. الفعاليات (Events)
      for (var e in MockData.events) {
        await _db.collection('events').doc(e['id']).set(e);
      }
      print("✅ تم رفع الفعاليات");

      // 4. الحجوزات (Bookings)
      for (var b in MockData.bookings) {
        await _db.collection('bookings').doc(b['id']).set(b);
      }
      print("✅ تم رفع الحجوزات");

      // 5. الملاعب (Courts)
      for (var c in MockData.courts) {
        await _db.collection('facilities').doc(c['id']).set(c);
      }
      print("✅ تم رفع بيانات المرافق");

      // 6. طاقم العمل (Staff)
      for (var s in MockData.staffMembers) {
        await _db.collection('staff').doc(s['id']).set(s);
      }
      print("✅ تم رفع بيانات الموظفين");

      print("🎉 اكتملت عملية التهجير بنجاح!");
    } catch (e) {
      print("❌ خطأ أثناء التهجير: $e");
    }
  }

  // دالة لإنشاء مستخدم جديد في Firestore (يتم استدعاؤها عند التسجيل)
  Future<void> syncUserProfile(Map<String, dynamic> profile) async {
    await _db.collection('users').doc(profile['id']).set(profile);
  }
}
