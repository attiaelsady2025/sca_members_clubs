import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:sca_members_clubs/core/theme/app_colors.dart';
import 'package:sca_members_clubs/core/services/firebase_service.dart';
import 'package:sca_members_clubs/core/widgets/sca_app_bar.dart';
import 'package:sca_members_clubs/core/widgets/custom_text_field.dart';

class AdminUsersScreen extends StatefulWidget {
  const AdminUsersScreen({super.key});

  @override
  State<AdminUsersScreen> createState() => _AdminUsersScreenState();
}

class _AdminUsersScreenState extends State<AdminUsersScreen> {
  late Future<List<Map<String, dynamic>>> _usersFuture;
  Map<String, dynamic>? _adminProfile;

  @override
  void initState() {
    super.initState();
    _usersFuture = _loadUsers();
  }

  Future<List<Map<String, dynamic>>> _loadUsers() async {
    final profile = await FirebaseService().getUserProfile();
    _adminProfile = profile;
    return FirebaseService().getUsers(clubId: profile['club_id']);
  }

  void _showCreateUserDialog() {
    final nameController = TextEditingController();
    final emailController = TextEditingController();
    final membershipIdController = TextEditingController();
    String selectedRole = 'member';
    String? selectedClub;

    showDialog(
      context: context,
      builder: (context) => StatefulBuilder(
        builder: (context, setDialogState) => AlertDialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20),
          ),
          title: Text(
            "إنشاء مستخدم جديد",
            style: GoogleFonts.cairo(fontWeight: FontWeight.bold),
          ),
          content: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                CustomTextField(
                  label: "الاسم الكامل",
                  controller: nameController,
                  hint: "مثال: أحمد محمد علي",
                  prefixIcon: Icons.person,
                ),
                const SizedBox(height: 12),
                CustomTextField(
                  label: "البريد الإلكتروني",
                  controller: emailController,
                  hint: "example@email.com",
                  prefixIcon: Icons.email,
                  keyboardType: TextInputType.emailAddress,
                ),
                const SizedBox(height: 12),
                CustomTextField(
                  label: "رقم العضوية",
                  controller: membershipIdController,
                  hint: "12345678",
                  prefixIcon: Icons.badge,
                  keyboardType: TextInputType.number,
                ),
                const SizedBox(height: 16),
                if (_adminProfile?['club_id'] == "global") ...[
                  Text(
                    "نوع الحساب",
                    style: GoogleFonts.cairo(
                      fontWeight: FontWeight.bold,
                      fontSize: 14,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 12),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(color: Colors.grey.withOpacity(0.2)),
                    ),
                    child: DropdownButtonHideUnderline(
                      child: DropdownButton<String>(
                        value: selectedRole,
                        isExpanded: true,
                        onChanged: (val) =>
                            setDialogState(() => selectedRole = val!),
                        items: const [
                          DropdownMenuItem(value: "member", child: Text("عضو")),
                          DropdownMenuItem(
                            value: "club_admin",
                            child: Text("مدير نادي"),
                          ),
                          DropdownMenuItem(
                            value: "admin",
                            child: Text("مدير نظام"),
                          ),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(height: 12),
                ],
                if (selectedRole != "admin") ...[
                  Text(
                    "النادي التابع له",
                    style: GoogleFonts.cairo(
                      fontWeight: FontWeight.bold,
                      fontSize: 14,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 12),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(color: Colors.grey.withOpacity(0.2)),
                    ),
                    child: DropdownButtonHideUnderline(
                      child: DropdownButton<String>(
                        value:
                            selectedClub ??
                            ((_adminProfile?['club_id'] as String?) != "global"
                                ? (_adminProfile?['club_id'] as String?)
                                : null),
                        hint: Text(
                          "اختر النادي",
                          style: GoogleFonts.cairo(fontSize: 14),
                        ),
                        isExpanded: true,
                        onChanged: _adminProfile?['club_id'] == "global"
                            ? (val) => setDialogState(() => selectedClub = val)
                            : null,
                        items: const [
                          DropdownMenuItem(
                            value: "c1",
                            child: Text("نادي التجديف"),
                          ),
                          DropdownMenuItem(
                            value: "c2",
                            child: Text("نادي الفيروز"),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ],
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: Text(
                "إلغاء",
                style: GoogleFonts.cairo(color: Colors.grey),
              ),
            ),
            ElevatedButton(
              onPressed: () async {
                if (nameController.text.isEmpty ||
                    emailController.text.isEmpty) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text("يرجى ملء جميع الحقول الإلزامية"),
                    ),
                  );
                  return;
                }

                final clubId = selectedRole == "admin"
                    ? "global"
                    : (selectedClub ?? _adminProfile?['club_id']);

                await FirebaseService().createUser({
                  "name": nameController.text,
                  "email": emailController.text,
                  "membership_id": membershipIdController.text,
                  "role": selectedRole,
                  "club_id": clubId,
                });

                if (mounted) {
                  Navigator.pop(context);
                  setState(() {
                    _usersFuture = _loadUsers();
                  });
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text("تم إنشاء المستخدم بنجاح")),
                  );
                }
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.primary,
                foregroundColor: Colors.white,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
              child: Text(
                "إنشاء",
                style: GoogleFonts.cairo(fontWeight: FontWeight.bold),
              ),
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: const ScaAppBar(title: "إدارة المستخدمين"),
      body: FutureBuilder<List<Map<String, dynamic>>>(
        future: _usersFuture,
        builder: (context, snapshot) {
          if (!snapshot.hasData) {
            return const Center(child: CircularProgressIndicator());
          }
          final users = snapshot.data!;

          return ListView.separated(
            padding: const EdgeInsets.all(16),
            itemCount: users.length,
            separatorBuilder: (context, index) => const SizedBox(height: 12),
            itemBuilder: (context, index) {
              final user = users[index];
              return Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(16),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.02),
                      blurRadius: 10,
                    ),
                  ],
                ),
                child: Row(
                  children: [
                    CircleAvatar(
                      radius: 25,
                      backgroundColor: _getRoleColor(
                        user['role'],
                      ).withOpacity(0.1),
                      child: Icon(
                        _getRoleIcon(user['role']),
                        color: _getRoleColor(user['role']),
                      ),
                    ),
                    const SizedBox(width: 16),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            user['name'] ?? "مستخدم",
                            style: GoogleFonts.cairo(
                              fontWeight: FontWeight.bold,
                              fontSize: 14,
                            ),
                          ),
                          Text(
                            _getRoleLabel(user['role']),
                            style: GoogleFonts.cairo(
                              fontSize: 12,
                              color: Colors.grey[600],
                            ),
                          ),
                          if (user['email'] != null)
                            Text(
                              user['email'],
                              style: GoogleFonts.cairo(
                                fontSize: 11,
                                color: Colors.grey[500],
                              ),
                            ),
                        ],
                      ),
                    ),
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 8,
                        vertical: 4,
                      ),
                      decoration: BoxDecoration(
                        color: _getRoleColor(user['role']).withOpacity(0.1),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Text(
                        user['membership_id'] ?? "N/A",
                        style: GoogleFonts.cairo(
                          fontSize: 10,
                          fontWeight: FontWeight.bold,
                          color: _getRoleColor(user['role']),
                        ),
                      ),
                    ),
                  ],
                ),
              );
            },
          );
        },
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: _showCreateUserDialog,
        backgroundColor: AppColors.primary,
        icon: const Icon(Icons.person_add, color: Colors.white),
        label: Text(
          "مستخدم جديد",
          style: GoogleFonts.cairo(
            color: Colors.white,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
    );
  }

  Color _getRoleColor(String? role) {
    switch (role) {
      case 'admin':
        return Colors.red;
      case 'club_admin':
        return Colors.orange;
      default:
        return AppColors.primary;
    }
  }

  IconData _getRoleIcon(String? role) {
    switch (role) {
      case 'admin':
        return Icons.admin_panel_settings;
      case 'club_admin':
        return Icons.manage_accounts;
      default:
        return Icons.person;
    }
  }

  String _getRoleLabel(String? role) {
    switch (role) {
      case 'admin':
        return "مدير النظام";
      case 'club_admin':
        return "مدير نادي";
      default:
        return "عضو";
    }
  }
}
