import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:sca_members_clubs/core/theme/app_colors.dart';
import 'package:sca_members_clubs/core/widgets/custom_text_field.dart';
import 'package:sca_members_clubs/core/widgets/primary_button.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sca_members_clubs/features/auth/presentation/cubit/auth_cubit.dart';
import 'package:sca_members_clubs/features/auth/presentation/cubit/auth_state.dart';
import 'package:sca_members_clubs/core/services/biometric_service.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _formKey = GlobalKey<FormState>();
  final _usernameController = TextEditingController();
  final _passwordController = TextEditingController();
  bool _isPasswordVisible = false;
  final BiometricService _biometricService = BiometricService();
  bool _canCheckBiometrics = false;

  @override
  void initState() {
    super.initState();
    _checkBiometrics();
  }

  Future<void> _checkBiometrics() async {
    final available = await _biometricService.isBiometricAvailable();
    if (mounted) {
      setState(() {
        _canCheckBiometrics = available;
      });
    }
  }

  Future<void> _onBiometricLoginPressed(BuildContext context) async {
    final authenticated = await _biometricService.authenticate();
    if (authenticated && mounted) {
      // For mock purposes, we login with a default member account
      // In a real app, we would use stored credentials or a refresh token
      context.read<AuthCubit>().login("member@club.com", "123456");
    }
  }

  void _onLoginPressed(BuildContext context) {
    if (_formKey.currentState!.validate()) {
      context.read<AuthCubit>().login(
        _usernameController.text,
        _passwordController.text,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<AuthCubit, AuthState>(
      listener: (context, state) {
        if (state is AuthAuthenticated) {
          final user = state.user;
          if (user.role == 'security') {
            Navigator.pushReplacementNamed(context, '/security_dashboard');
          } else if (user.role == 'admin') {
            Navigator.pushReplacementNamed(context, '/admin');
          } else {
            Navigator.pushReplacementNamed(context, '/home');
          }
        } else if (state is AuthError) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(state.message, style: GoogleFonts.cairo()),
              backgroundColor: AppColors.error,
            ),
          );
        }
      },
      builder: (context, state) {
        return Scaffold(
          backgroundColor: AppColors.background,
          body: Stack(
            children: [
              // Top Decoration
              Positioned(
                top: 0,
                left: 0,
                right: 0,
                height: 300,
                child: Container(
                  decoration: const BoxDecoration(
                    color: AppColors.primary,
                    borderRadius: BorderRadius.vertical(
                      bottom: Radius.circular(32),
                    ),
                  ),
                  child: Stack(
                    children: [
                      Positioned(
                        right: -50,
                        top: -50,
                        child: Icon(
                          Icons.anchor,
                          size: 200,
                          color: Colors.white.withOpacity(0.05),
                        ),
                      ),
                    ],
                  ),
                ),
              ),

              SafeArea(
                child: Center(
                  child: SingleChildScrollView(
                    padding: const EdgeInsets.all(24.0),
                    child: Card(
                      elevation: 8,
                      shadowColor: Colors.black26,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(24),
                      ),
                      child: Padding(
                        padding: const EdgeInsets.all(32.0),
                        child: Form(
                          key: _formKey,
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            crossAxisAlignment: CrossAxisAlignment.stretch,
                            children: [
                              // Logo
                              Center(
                                child: Container(
                                  width: 80,
                                  height: 80,
                                  decoration: BoxDecoration(
                                    color: Colors.white,
                                    shape: BoxShape.circle,
                                    border: Border.all(
                                      color: AppColors.background,
                                      width: 4,
                                    ),
                                    boxShadow: const [
                                      BoxShadow(
                                        color: Colors.black12,
                                        blurRadius: 10,
                                        offset: Offset(0, 4),
                                      ),
                                    ],
                                  ),
                                  child: Image.asset(
                                    'assets/images/logo.png',
                                    width: 40,
                                    height: 40,
                                  ),
                                ),
                              ),
                              const SizedBox(height: 24),

                              // Title
                              Text(
                                "تسجيل الدخول",
                                textAlign: TextAlign.center,
                                style: GoogleFonts.cairo(
                                  fontSize: 24,
                                  fontWeight: FontWeight.bold,
                                  color: AppColors.textPrimary,
                                ),
                              ),
                              const SizedBox(height: 8),
                              Text(
                                "مرحباً بك في تطبيق النادي العام لهيئة قناة السويس",
                                textAlign: TextAlign.center,
                                style: GoogleFonts.cairo(
                                  fontSize: 14,
                                  color: AppColors.textSecondary,
                                ),
                              ),
                              const SizedBox(height: 32),

                              // Fields
                              CustomTextField(
                                label: "اسم المستخدم",
                                hint: "أدخل اسم المستخدم",
                                controller: _usernameController,
                                prefixIcon: Icons.person_outline,
                                validator: (value) {
                                  if (value == null || value.isEmpty) {
                                    return 'يرجى إدخال البيانات المطلوبة';
                                  }
                                  return null;
                                },
                              ),
                              const SizedBox(height: 16),
                              CustomTextField(
                                label: "كلمة المرور",
                                hint: "********",
                                controller: _passwordController,
                                prefixIcon: Icons.lock_outline,
                                obscureText: !_isPasswordVisible,
                                validator: (value) {
                                  if (value == null || value.isEmpty) {
                                    return 'يرجى إدخال كلمة المرور';
                                  }
                                  return null;
                                },
                                suffixIcon: IconButton(
                                  icon: Icon(
                                    _isPasswordVisible
                                        ? Icons.visibility
                                        : Icons.visibility_off,
                                    color: AppColors.textSecondary,
                                  ),
                                  onPressed: () {
                                    setState(() {
                                      _isPasswordVisible = !_isPasswordVisible;
                                    });
                                  },
                                ),
                              ),

                              const SizedBox(height: 24),

                              state is AuthLoading
                                  ? const Center(
                                      child: CircularProgressIndicator(
                                        color: AppColors.primary,
                                      ),
                                    )
                                  : Column(
                                      children: [
                                        PrimaryButton(
                                          text: "دخول",
                                          onPressed: () =>
                                              _onLoginPressed(context),
                                        ),
                                        if (_canCheckBiometrics) ...[
                                          const SizedBox(height: 16),
                                          OutlinedButton.icon(
                                            onPressed: () =>
                                                _onBiometricLoginPressed(
                                                  context,
                                                ),
                                            icon: const Icon(
                                              Icons.fingerprint,
                                              color: AppColors.primary,
                                            ),
                                            label: Text(
                                              "الدخول بالبصمة",
                                              style: GoogleFonts.cairo(
                                                color: AppColors.primary,
                                                fontWeight: FontWeight.bold,
                                              ),
                                            ),
                                            style: OutlinedButton.styleFrom(
                                              padding:
                                                  const EdgeInsets.symmetric(
                                                    vertical: 12,
                                                    horizontal: 24,
                                                  ),
                                              side: const BorderSide(
                                                color: AppColors.primary,
                                              ),
                                              shape: RoundedRectangleBorder(
                                                borderRadius:
                                                    BorderRadius.circular(12),
                                              ),
                                            ),
                                          ),
                                        ],
                                      ],
                                    ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}
