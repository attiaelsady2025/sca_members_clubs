import 'package:flutter/material.dart';

class MockData {
  // Members
  static final Map<String, dynamic> memberProfile = {
    "id": "12345678",
    "name": "عطية عبدالله عبدالسلام",
    "email": "atia@example.com",
    "phone": "01000000000",
    "job_title": "مهندس برمجيات",
    "work_number": "98765",
    "national_id": "29001011234567",
    "membership_type": "عضو عامل",
    "department": "الإدارة الهندسية",
    "status": "نشط",
    "role": "member", // Role: member, admin, security
    "expiry_date": "12/2026",
    "join_date": "01/2020",
    "image": "assets/images/profile_placeholder.png", // Use placeholder
    "current_visitors_count": 2, // New: Tracking currently present visitors
  };

  // Active Visitors Details (New: For tracking)
  static final List<Map<String, dynamic>> activeVisitors = [
    {
      "id": "v1",
      "name": "محمود أحمد",
      "entry_time": "10:30 ص",
      "invitation_id": "inv1",
    },
    {
      "id": "v2",
      "name": "علي حسن",
      "entry_time": "11:15 ص",
      "invitation_id": "inv2",
    },
  ];

  // Registered Users for Login
  static final List<Map<String, dynamic>> registeredUsers = [
    {"identifier": "12345678", "password": "123", "profile": memberProfile},
    {
      "identifier": "atia@example.com",
      "password": "password123",
      "profile": memberProfile,
    },
    {"identifier": "user", "password": "123", "profile": memberProfile},
    {
      "identifier": "admin",
      "password": "admin",
      "profile": {
        ...memberProfile,
        "name": "مدير النظام",
        "role": "admin",
        "club_id": "global",
      },
    },
    {
      "identifier": "admin_c1",
      "password": "123",
      "profile": {
        ...memberProfile,
        "name": "مدير نادي التجديف",
        "role": "admin",
        "club_id": "c1",
      },
    },
    {
      "identifier": "admin_c2",
      "password": "123",
      "profile": {
        ...memberProfile,
        "name": "مدير نادي الفيروز",
        "role": "admin",
        "club_id": "c2",
      },
    },
    {
      "identifier": "security",
      "password": "sec",
      "profile": {...memberProfile, "name": "مسؤول الأمن", "role": "security"},
    },
  ];

  // Clubs
  static final List<Map<String, dynamic>> clubs = [
    {
      "id": "c1",
      "name": "نادي التجديف (الإسماعيلية)",
      "image":
          "https://images.unsplash.com/photo-1544620347-c4fd4a3d5962?auto=format&fit=crop&q=80&w=1000",
      "description": "الرياضات المائية والأنشطة.",
      "icon": Icons.rowing,
      "color": Colors.teal,
      "governorate": "الإسماعيلية",
      "google_maps_url": "https://maps.google.com/?q=SCA+Rowing+Club+Ismailia",
    },
    {
      "id": "c2",
      "name": "نادي الفيروز (بورفؤاد)",
      "image":
          "https://images.unsplash.com/photo-1540339832862-4745591b2696?auto=format&fit=crop&q=80&w=1000",
      "description": "استمتع بأفضل الأوقات العائلية في النادي الاجتماعي.",
      "icon": Icons.people,
      "color": Colors.blue,
      "governorate": "بورسعيد",
      "google_maps_url":
          "https://maps.google.com/?q=SCA+Social+Club+Port+Fouad",
    },
    {
      "id": "c3",
      "name": "نادي الجولف (بورسعيد)",
      "image":
          "https://images.unsplash.com/photo-1535131749006-b7f58c99034b?auto=format&fit=crop&q=80&w=1000",
      "description": "ملاعب عالمية لمحبي الجولف.",
      "icon": Icons.golf_course,
      "color": Colors.green,
      "governorate": "بورسعيد",
      "google_maps_url": "https://maps.google.com/?q=SCA+Golf+Club+Port+Said",
    },
    {
      "id": "c4",
      "name": "نادي الشاطئ (السويس)",
      "image":
          "https://images.unsplash.com/photo-1507525428034-b723cf961d3e?auto=format&fit=crop&q=80&w=1000",
      "description": "تجربة صيفية فريدة على البحر الأحمر.",
      "icon": Icons.beach_access,
      "color": Colors.orange,
      "governorate": "السويس",
      "google_maps_url": "https://maps.google.com/?q=SCA+Beach+Club+Suez",
    },
  ];

  // News
  static final List<Map<String, dynamic>> news = [
    {
      "id": "n1",
      "title": "افتتاح حمام السباحة الأوليمبي الجديد",
      "date": "10 يناير 2026",
      "image":
          "https://images.unsplash.com/photo-1576013551627-0cc20b96c2a7?q=80&w=800",
      "description":
          "يسر إدارة النادي الإعلان عن افتتاح حمام السباحة الأوليمبي بعد التجديدات الشاملة التي شملت أنظمة الفلترة والتدفئة.",
      "content":
          "تم الانتهاء من كافة أعمال الصيانة الدورية والتطوير الشامل لحمام السباحة الأوليمبي. تتضمن التجهيزات الجديدة أنظمة رقابة متطورة وغرف تغيير ملابس حديثة. يفتح الحمام أبوابه يومياً من الساعة السابعة صباحاً وحتى العاشرة مساءً.",
      "club_id": "c1",
    },
    {
      "id": "n2",
      "title": "بطولة التنس السنوية",
      "date": "15 فبراير 2026",
      "image":
          "https://images.unsplash.com/photo-1599474924187-334a4ae5bd3c?q=80&w=800",
      "description":
          "بدء التسجيل في بطولة التنس السنوية للأعضاء بفئات الناشئين والكبار، مع جوائز قيمة للفائزين الأوائل.",
      "content":
          "تدعو اللجنة الرياضية السادة الأعضاء للمشاركة في البطولة الكبرى للتنس. ستقام المباريات على مدار أسبوع كامل بنظام المجموعات. التسجيل متاح حالياً لدى مكاتب النشاط الرياضي وحتى نهاية شهر يناير.",
      "club_id": "c1",
    },
    {
      "id": "n3",
      "title": "رحلة اليوم الواحد لمدينة الجلالة",
      "date": "20 يناير 2026",
      "image":
          "https://images.unsplash.com/photo-1544620347-c4fd4a3d5962?q=80&w=800",
      "description":
          "تنظم اللجنة الاجتماعية رحلة ترفيهية لمدينة الجلالة العالمية تشمل زيارة التلفريك والمدينة المائية.",
      "content":
          "تشمل الرحلة الانتقالات بأتوبيسات حديثة، وجبة غداء فاخرة، وتذاكر دخول كافة المزارات. الحجز متاح من خلال التطبيق أو السكرتارية.",
      "club_id": "c2",
    },
    {
      "id": "n4",
      "title": "تطوير ملاعب الكروقية",
      "date": "5 يناير 2026",
      "image":
          "https://images.unsplash.com/photo-1531415074968-036ba1b575da?q=80&w=800",
      "description":
          "انتهاء أعمال تطوير الإضاءة والنجيل الطبيعي بملاعب الكروكية بنادي التجديف.",
      "content":
          "أصبح بإمكان الأعضاء ممارسة رياضة الكروكية ليلاً بعد تركيب أعمدة الإنارة الليد الحديثة وتطوير منطقة الجلوس المحيطة بالملاعب.",
      "club_id": "c1",
    },
  ];

  // Events (Upcoming)
  static final List<Map<String, dynamic>> events = [
    {
      "id": "e1",
      "title": "حفل أم كلثوم (سينما)",
      "date": "25 يناير 2026",
      "time": "08:00 مساءً",
      "location": "المسرح الكبير - النادي الاجتماعي",
      "price": "50 جنيه",
      "description": "عرض سينمائي لأجمل حفلات كوكب الشرق أم كلثوم.",
      "club_id": "c1",
    },
    {
      "id": "e2",
      "title": "ندوة التوعية الغذائية",
      "date": "1 فبراير 2026",
      "time": "06:00 مساءً",
      "location": "قاعة المؤتمرات - نادي التجديف",
      "price": "مجاناً",
      "description":
          "ندوة مجانية للأعضاء للتعريف بأسس التغذية السليمة للرياضيين.",
      "club_id": "c2",
    },
  ];

  // Promos (Advertisements)
  static final List<Map<String, dynamic>> promos = [
    {
      "id": "p1",
      "title": "خصم 20% على المطاعم",
      "subtitle": "استمتع بوجباتك المفضلة",
      "image":
          "https://images.unsplash.com/photo-1504674900247-0877df9cc836?q=80&w=800",
      "color": "0xFF003A8F",
      "description": "استمتع بوجباتك المفضلة مع خصم حصري للأعضاء.",
      "content":
          "هذا العرض سارٍ لجميع أعضاء أندية هيئة قناة السويس في كافة المطاعم والكافيهات التابعة للهيئة. الخصم يشمل كافة المأكولات والمشروبات.",
    },
    {
      "id": "p2",
      "title": "بطولة الشطرنج السنوية",
      "subtitle": "بادر بالتسجيل الآن",
      "image":
          "https://images.unsplash.com/photo-1529699211952-734e80c4d42b?q=80&w=800",
      "color": "0xFFC9A24D",
      "description":
          "هل أنت بطل الشطرنج القادم؟ شارك في البطولة السنوية وتحدى أقوى اللاعبين.",
      "content":
          "تنظم اللجنة الرياضية بطولة الشطرنج السنوية الكبرى. البطولة مفتوحة لكافة الأعمار والمستويات. التسجيل متاح الآن وحتى نهاية الأسبوع.",
    },
    {
      "id": "p3",
      "title": "تجديد العضوية أونلاين",
      "subtitle": "وفر وقتك ومجهودك",
      "image":
          "https://images.unsplash.com/photo-1563013544-824ae1b704d3?q=80&w=800",
      "color": "0xFF2E7D32",
      "description":
          "يمكنك الآن تجديد عضويتك السنوية من خلال التطبيق بكل سهولة.",
      "content":
          "في إطار التحول الرقمي للهيئة، نطلق خدمة تجديد العضوية وسداد الاشتراكات عبر التطبيق. لا حاجة للانتظار في الطوابير، سدد عضويتك في ثوانٍ.",
    },
  ];

  // Invitations (Gate Pass)
  static final List<Map<String, dynamic>> invitations = [
    {
      "id": "inv1",
      "guest_name": "محمود أحمد",
      "national_id": "12345678901234",
      "date": "10/01/2026",
      "status": "inside", // Guest has entered
      "expiry": null,
      "guest_count": 1,
    },
    {
      "id": "inv2",
      "guest_name": "علي حسن",
      "national_id": "98765432109876",
      "date": "10/01/2026",
      "status": "inside", // Guest has entered
      "expiry": null,
      "guest_count": 1,
    },
    {
      "id": "inv3",
      "guest_name": "محمد خالد",
      "national_id": "28501011234567",
      "date": "11/01/2026",
      "status": "active",
      "expiry": "2026-01-11T18:00:00", // Valid until 6 PM
      "guest_count": 2,
    },
    {
      "id": "inv4",
      "guest_name": "سارة يوسف",
      "national_id": "29505051234567",
      "date": "20/01/2026",
      "status": "pending",
    },
  ];

  // Invitation Requests (Admin Only)
  static final List<Map<String, dynamic>> invitationRequests = [
    {
      "id": "req1",
      "member_id": "12345678",
      "member_name": "عطية عبدالله",
      "reason": "عزومة عائلية كبيرة",
      "count": 5,
      "date": "2026-01-10",
      "status": "pending",
      "club_id": "c1",
    },
    {
      "id": "req2",
      "member_id": "99999999",
      "member_name": "أحمد محمد علي",
      "reason": "أصدقاء من خارج الإسماعيلية",
      "count": 10,
      "date": "2026-01-09",
      "status": "approved",
      "club_id": "c2",
    },
  ];

  // Dining
  static final List<Map<String, dynamic>> restaurants = [
    {
      "id": "r1",
      "name": "المطعم الرئيسي",
      "image": "assets/images/restaurant_main.jpg",
      "description": "أشهى المأكولات الشرقية والغربية",
      "rating": 4.5,
      "delivery_time": "30-45 دقيقة",
      "club_id": "c1",
    },
    {
      "id": "r2",
      "name": "كافيه الشاطئ",
      "image": "assets/images/cafe_beach.jpg",
      "description": "مشروبات باردة وساخنة وسناكس",
      "rating": 4.2,
      "delivery_time": "15-20 دقيقة",
      "club_id": "c2",
    },
  ];

  static final List<Map<String, dynamic>> menuItems = [
    {
      "id": "m1",
      "restaurant_id": "r1",
      "name": "بيتزا مارجريتا",
      "description": "صوص طماطم، موزاريلا، ريحان",
      "price": 85.0,
      "image": "assets/images/pizza.jpg",
      "category": "بيتزا",
    },
    {
      "id": "m2",
      "restaurant_id": "r1",
      "name": "برجر دجاج",
      "description": "صدور دجاج مشوية، خس، طماطم، صوص خاص",
      "price": 110.0,
      "image": "assets/images/burger.jpg",
      "category": "سندوتشات",
    },
    {
      "id": "m3",
      "restaurant_id": "r1",
      "name": "كفتة مشوية",
      "description": "كفتة بلدي مشوية على الفحم مع أرز وبطاطس",
      "price": 145.0,
      "image": "assets/images/kofta.jpg",
      "category": "مشويات",
    },
    {
      "id": "m4",
      "restaurant_id": "r2",
      "name": "عصير برتقال فريش",
      "description": "عصير طبيعي 100%",
      "price": 40.0,
      "image": "assets/images/juice.jpg",
      "category": "مشروبات",
    },
    {
      "id": "m5",
      "restaurant_id": "r2",
      "name": "كابتشينو",
      "description": "قهوة إيطالية مع رغوة حليب كثيفة",
      "price": 55.0,
      "image": "assets/images/cap.jpg",
      "category": "مشروبات",
    },
  ];

  static final List<Map<String, dynamic>> familyMembers = [
    {
      "id": "12345678-01",
      "name": "نهى السيد",
      "relation": "زوجة",
      "image": "assets/images/user_placeholder.png",
      "age": 35,
      "national_id": "29101011234567",
      "expiry_date": "12/2026",
    },
    {
      "id": "12345678-02",
      "name": "يوسف عطية",
      "relation": "ابن",
      "image": "assets/images/user_placeholder.png",
      "age": 12,
      "national_id": "31201011234567",
      "expiry_date": "12/2026",
    },
    {
      "id": "12345678-03",
      "name": "ليلى عطية",
      "relation": "ابنة",
      "image": "assets/images/user_placeholder.png",
      "age": 8,
      "national_id": "31601011234567",
      "expiry_date": "12/2026",
    },
    {
      "id": "12345678-04",
      "name": "أحمد عطية",
      "relation": "ابن",
      "image": "assets/images/user_placeholder.png",
      "age": 5,
      "national_id": "31901011234567",
      "expiry_date": "12/2026",
    },
  ];

  // Bookings
  // Bookings
  static final List<Map<String, dynamic>> bookings = [
    {
      "id": "b1",
      "service_name": "ملعب كرة قدم خماسي",
      "date": "2026-01-12",
      "time": "06:00 م",
      "status": "مؤكد",
      "price": "150 ج.م",
      "club_id": "c1",
      "type": "sports",
    },
    {
      "id": "b5",
      "service_name": "جلسة تصوير فوتوغرافي",
      "date": "2026-01-20",
      "time": "12:00 م",
      "status": "مؤكد",
      "price": "500 ج.م",
      "club_id": "c2",
      "type": "photo_session",
      "is_self_booking": true,
      "attendees_count": 3,
    },
    {
      "id": "b6",
      "service_name": "تراك الجري",
      "date": "2026-01-14",
      "time": "06:00 ص",
      "status": "مكتمل",
      "price": "مجاناً",
      "club_id": "c1",
      "type": "sports",
    },
    {
      "id": "b7",
      "service_name": "صالة الألعاب الرياضية (Gym)",
      "date": "2026-01-15",
      "time": "05:00 م",
      "status": "مؤكد",
      "price": "50 ج.م",
      "club_id": "c1",
      "type": "gym",
    },
    {
      "id": "b8",
      "service_name": "ملعب تنس",
      "date": "2026-01-16",
      "time": "04:00 م",
      "status": "قيد الانتظار",
      "price": "100 ج.م",
      "club_id": "c1",
      "type": "sports",
    },
    {
      "id": "b9",
      "service_name": "حمام السباحة",
      "date": "2026-01-13",
      "time": "10:00 ص",
      "status": "مكتمل",
      "price": "75 ج.م",
      "club_id": "c1",
      "type": "pool",
    },
    {
      "id": "b10",
      "service_name": "ملعب بادل",
      "date": "2026-01-22",
      "time": "09:00 م",
      "status": "مؤكد",
      "price": "200 ج.م",
      "club_id": "c1",
      "type": "padel",
    },
    {
      "id": "b11",
      "service_name": "تنس",
      "date": "2026-01-14",
      "time": "05:00 م",
      "status": "مؤكد",
      "price": "100 ج.م",
      "club_id": "c1",
      "type": "sports",
    },
    {
      "id": "b12",
      "service_name": "سباحة",
      "date": "2026-01-15",
      "time": "09:00 ص",
      "status": "مكتمل",
      "price": "50 ج.م",
      "club_id": "c1",
      "type": "sports",
    },
    {
      "id": "b13",
      "service_name": "إسكواش",
      "date": "2026-01-16",
      "time": "06:00 م",
      "status": "قيد الانتظار",
      "price": "120 ج.م",
      "club_id": "c1",
      "type": "sports",
    },
    {
      "id": "b14",
      "service_name": "بادل",
      "date": "2026-01-17",
      "time": "08:00 م",
      "status": "مؤكد",
      "price": "200 ج.م",
      "club_id": "c1",
      "type": "sports",
    },
  ];

  // Membership Types
  static final List<String> membershipTypes = [
    "عضو عامل",
    "عضو تابع",
    "عضو معاشات",
    "عضو خارجى",
  ];

  // Map Locations (Relative coordinates 0.0 to 1.0)
  static final List<Map<String, dynamic>> mapLocations = [
    {
      "id": "loc1",
      "name": "المبنى الاجتماعي",
      "type": "building",
      "x": 0.5,
      "y": 0.4,
      "color": Colors.blue,
      "icon": Icons.apartment,
    },
    {
      "id": "loc2",
      "name": "حمام السباحة",
      "type": "pool",
      "x": 0.7,
      "y": 0.6,
      "color": Colors.cyan,
      "icon": Icons.pool,
    },
    {
      "id": "loc3",
      "name": "المطعم الرئيسي",
      "type": "food",
      "x": 0.3,
      "y": 0.6,
      "color": Colors.orange,
      "icon": Icons.restaurant,
    },
    {
      "id": "loc4",
      "name": "ملاعب التنس",
      "type": "sports",
      "x": 0.2,
      "y": 0.3,
      "color": Colors.green,
      "icon": Icons.sports_tennis,
    },
    {
      "id": "loc5",
      "name": "البوابة الرئيسية",
      "type": "gate",
      "x": 0.5,
      "y": 0.9,
      "color": Colors.red,
      "icon": Icons.door_front_door,
    },
    {
      "id": "loc6",
      "name": "صالة الألعاب الرياضية",
      "type": "sports",
      "x": 0.8,
      "y": 0.3,
      "color": Colors.blueGrey,
      "icon": Icons.fitness_center,
    },
    {
      "id": "loc7",
      "name": "منطقة الأطفال",
      "type": "sports",
      "x": 0.2,
      "y": 0.5,
      "color": Colors.purple,
      "icon": Icons.child_care,
    },
    {
      "id": "loc8",
      "name": "ساحة الانتظار",
      "type": "gate",
      "x": 0.1,
      "y": 0.8,
      "color": Colors.grey,
      "icon": Icons.local_parking,
    },
    {
      "id": "loc9",
      "name": "المسجد",
      "type": "building",
      "x": 0.6,
      "y": 0.7,
      "color": Colors.green[800],
      "icon": Icons.mosque,
    },
  ];

  // Activities & Schedules
  static final List<Map<String, dynamic>> activities = [
    {
      "id": "a1",
      "name": "تدريب الكاراتيه (أطفال)",
      "days": ["الأحد", "الثلاثاء", "الخميس"],
      "time": "05:00 م - 07:00 م",
      "location": "صالة الألعاب القتالية",
      "coach": "كابتن/ محمد صلاح",
      "category": "sports",
      "club_id": "c1",
    },
    {
      "id": "a2",
      "name": "تعليم السباحة (سيدات)",
      "days": ["السبت", "الاثنين", "الأربعاء"],
      "time": "09:00 ص - 11:00 ص",
      "location": "حمام السباحة المغطى",
      "coach": "كابتن/ سارة أحمد",
      "category": "sports",
      "club_id": "c1",
    },
    {
      "id": "a3",
      "name": "ورشة الرسم والزخرفة",
      "days": ["الجمعة"],
      "time": "02:00 م - 05:00 م",
      "location": "المبنى الاجتماعي - الدور الثاني",
      "coach": "أ/ نهى كمال",
      "category": "arts",
      "club_id": "c2",
    },
    {
      "id": "a4",
      "name": "كرة القدم (أكاديمية)",
      "days": ["يومياً"],
      "time": "04:00 م - 06:00 م",
      "location": "المبنى العام",
      "coach": "كابتن/ حسن شحاتة",
      "category": "sports",
      "club_id": "c2",
    },
    {
      "id": "a5",
      "name": "تدريب السباحة للناشئين",
      "days": ["الأحد", "الأربعاء"],
      "time": "03:00 م - 05:00 م",
      "location": "حمام السباحة الأوليمبي",
      "coach": "كابتن/ أحمد حلمي",
      "category": "sports",
      "club_id": "c1",
    },
    {
      "id": "a6",
      "name": "دورة تحسين الخط العربي",
      "days": ["السبت"],
      "time": "11:00 ص - 01:00 م",
      "location": "المكتبة",
      "coach": "أ/ محمود يحيى",
      "category": "arts",
      "club_id": "c2",
    },
  ];

  // Frequent Guests
  static final List<Map<String, dynamic>> frequentGuests = [
    {"id": "fg1", "name": "أحمد علي محمد", "national_id": "29012345678901"},
    {"id": "fg2", "name": "منى محمود حسن", "national_id": "29123456789012"},
  ];

  // Facility Courts & Booking Slots
  static final List<Map<String, dynamic>> courts = [
    {
      "id": "crt1",
      "name": "ملعب تنس 1",
      "type": "tennis",
      "image": "assets/images/court_tennis.jpg",
    },
    {
      "id": "crt2",
      "name": "ملعب تنس 2",
      "type": "tennis",
      "image": "assets/images/court_tennis.jpg",
    },
    {
      "id": "crt3",
      "name": "ملعب بادل 1",
      "type": "padel",
      "image": "assets/images/court_padel.jpg",
    },
    {
      "id": "crt4",
      "name": "ملعب كرة قدم 1",
      "type": "football",
      "image": "assets/images/court_football.jpg",
    },
  ];

  static final Map<String, List<Map<String, dynamic>>> bookingSlots = {
    "crt1": [
      {"time": "04:00 م", "is_available": true, "price": "100 ج.م"},
      {"time": "05:00 م", "is_available": false, "price": "100 ج.م"},
      {"time": "06:00 م", "is_available": true, "price": "120 ج.م"},
    ],
    "crt3": [
      {"time": "08:00 م", "is_available": true, "price": "200 ج.م"},
      {"time": "09:00 م", "is_available": true, "price": "200 ج.م"},
    ],
  };

  // Notifications
  static final List<Map<String, dynamic>> notifications = [
    // ... (rest of notifications)
    {
      "id": "not1",
      "title": "حجز ملعب القربب",
      "message":
          "تذكير: موعد حجز ملعب كرة القدم الخماسي الخاص بك سيبدأ بعد 30 دقيقة.",
      "time": "منذ 10 دقائق",
      "type": "booking", // booking, event, emergency, general
      "is_read": false,
    },
    {
      "id": "not2",
      "title": "فعالية جديدة بالنادي",
      "message":
          "تم الإعلان عن رحلة اليوم الواحد لمدينة الجلالة. بادر بالحجز الآن عبر قسم الفعاليات.",
      "time": "منذ ساعتين",
      "type": "event",
      "is_read": true,
    },
    {
      "id": "not3",
      "title": "تعليمات أمنية هامة",
      "message":
          "يرجى من السادة الأعضاء الالتزام بأماكن الانتظار المخصصة للسيارات لتسهيل حركة المرور داخل النادي.",
      "time": "منذ 5 ساعات",
      "type": "emergency",
      "is_read": false,
    },
    {
      "id": "not4",
      "title": "تجديد العضوية",
      "message":
          "عزيزي العضو، نود تذكيرك بأن موعد تجديد اشتراكك السنوي يقترب. يمكنك التجديد أونلاين لتوفير الوقت.",
      "time": "أمس",
      "type": "general",
      "is_read": true,
    },
  ];

  // Complaints (For Admin Dashboard)
  static final List<Map<String, dynamic>> complaints = [
    {
      "id": "1",
      "category": "صيانة مرافق",
      "content": "يوجد عطل في إضاءة ملعب التنس رقم 2، يرجى إصلاحه في أقرب وقت.",
      "status": "مفتوحة",
      "date": "10/01/2026",
      "club_id": "c1",
    },
    {
      "id": "2",
      "category": "خدمات اجتماعية",
      "content":
          "تأخر في تقديم الوجبات في مطعم النادي الرئيسي يوم الجمعة الماضي.",
      "status": "مكتملة",
      "date": "08/01/2026",
      "club_id": "c1",
    },
  ];

  // Admin Activity Logs
  static final List<Map<String, dynamic>> adminLogs = [
    {
      "id": "log1",
      "admin_name": "مدير النظام",
      "action": "إرسال إشعار جماعي",
      "target": "كافة الأعضاء",
      "time": "منذ 5 دقائق",
      "club_id": "global",
    },
    {
      "id": "log2",
      "admin_name": "مدير نادي التجديف",
      "action": "إغلاق ملعب تنس 1",
      "target": "ملعب تنس 1",
      "time": "منذ ساعة",
      "club_id": "c1",
    },
  ];

  // Staff & Coaches
  static final List<Map<String, dynamic>> staffMembers = [
    {
      "id": "s1",
      "name": "كابتن/ محمد صلاح",
      "role": "مدرب كاراتيه",
      "club_id": "c1",
      "phone": "0123456789",
      "rating": 4.8,
    },
    {
      "id": "s2",
      "name": "أ/ نهى كمال",
      "role": "مشرفة أنشطة اجتماعية",
      "club_id": "c2",
      "phone": "0112233445",
      "rating": 4.5,
    },
  ];

  // Pending Membership Verifications
  static final List<Map<String, dynamic>> pendingVerifications = [
    {
      "id": "v1",
      "name": "إسلام محمد علي",
      "national_id": "29501011234567",
      "membership_type": "عضو عامل",
      "club_id": "c1",
      "date": "2026-01-10",
      "status": "pending_documents",
    },
  ];

  // Security Staff & Shifts
  static final List<Map<String, dynamic>> securityStaff = [
    {
      "id": "sec1",
      "name": "م/ أحمد حسن",
      "gate": "البوابة الرئيسية",
      "shift": "صباحية",
      "club_id": "c1",
      "status": "on_duty",
    },
    {
      "id": "sec2",
      "name": "م/ محمود فرج",
      "gate": "بوابة الملاعب",
      "shift": "مسائية",
      "club_id": "c1",
      "status": "off_duty",
    },
  ];

  // Official Guests (VIPs)
  static final List<Map<String, dynamic>> officialGuests = [
    {
      "id": "vip1",
      "guest_name": "لواء/ أركان حرب فلان",
      "organization": "هيئة قناة السويس",
      "reason": "زيارة تفقدية",
      "date": "2026-01-15",
      "club_id": "c1",
      "entry_code": "VIP-9988",
    },
  ];

  // Invitation Cards (New)
  static final List<Map<String, dynamic>> invitationCards = [
    {
      "id": "card_001",
      "type": "الرصيد السنوي",
      "total": 30,
      "used": 12,
      "expiry": "2026-12-31",
      "color": "0xFF003A8F",
    },
    {
      "id": "card_002",
      "type": "كارت إضافي (1)",
      "total": 10,
      "used": 8,
      "expiry": "2026-03-15",
      "color": "0xFF2E7D32",
    },
    {
      "id": "card_003",
      "type": "عروض الصيف",
      "total": 5,
      "used": 0,
      "expiry": "2026-08-30",
      "color": "0xFFC9A24D",
    },
  ];
}
