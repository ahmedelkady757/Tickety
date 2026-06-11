import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../../../core/core.dart';
import '../widgets/auth_header.dart';

class SignInScreen extends StatefulWidget {
  const SignInScreen({super.key});

  @override
  State<SignInScreen> createState() => _SignInScreenState();
}

class _SignInScreenState extends State<SignInScreen> {
  bool _rememberMe = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Center(
                child: Column(
                  children: [
                    Image.asset(
                      'assets/images/splash_logo.png',
                      height: 100, // Adjusted to match design
                      width: 150,
                      fit: BoxFit.contain,
                      errorBuilder: (context, error, stackTrace) =>
                          const Icon(Icons.event, size: 80, color: AppColors.primary),
                    ),
                    const SizedBox(height: 8),
                    const Text(
                      'Tickety',
                      style: TextStyle(
                        fontSize: 36,
                        fontWeight: FontWeight.w800,
                        color: AppColors.primary,
                        letterSpacing: -0.5,
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 32),
              const AuthHeader(
                title: 'Sign in',
                subtitle: '',
              ),
              const SizedBox(height: 32),
              const AppTextField(
                labelText: 'Email Address',
                hintText: 'Enter your email',
                keyboardType: TextInputType.emailAddress,
                prefixIcon: Icon(Icons.email_outlined, color: AppColors.textSecondary),
              ),
              const SizedBox(height: 20),
              const AppTextField(
                labelText: 'Password',
                hintText: 'Enter your password',
                isPassword: true,
                textInputAction: TextInputAction.done,
                prefixIcon: Icon(Icons.lock_outline, color: AppColors.textSecondary),
              ),
              const SizedBox(height: 12),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Row(
                    children: [
                      Switch(
                        value: _rememberMe,
                        onChanged: (val) {
                          setState(() {
                            _rememberMe = val;
                          });
                        },
                        activeColor: AppColors.primary,
                      ),
                      Text(
                        'Remember Me',
                        style: AppTextStyles.bodyMedium.copyWith(color: AppColors.textPrimary),
                      ),
                    ],
                  ),
                  TextButton(
                    onPressed: () => context.push(AppRoutes.forgotPassword),
                    child: Text(
                      'Forgot Password?',
                      style: AppTextStyles.bodyMedium.copyWith(color: AppColors.textPrimary),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 24),
              AppButton.primary(
                text: 'SIGN IN',
                hasArrow: true,
                onPressed: () {
                  // Logic phase: AuthCubit.signIn()
                },
              ),
              const SizedBox(height: 32),
              Row(
                children: [
                  const Expanded(child: Divider(color: AppColors.border)),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    child: Text(
                      'Or sign in with',
                      style: AppTextStyles.bodyMedium,
                    ),
                  ),
                  const Expanded(child: Divider(color: AppColors.border)),
                ],
              ),
              const SizedBox(height: 32),
              Row(
                children: [
                  Expanded(
                    child: AppButton.social(
                      text: 'Google',
                      iconPath: 'assets/icons/google.svg',
                      onPressed: () {},
                    ),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: AppButton.social(
                      text: 'Apple',
                      iconPath: 'assets/icons/apple.svg',
                      onPressed: () {},
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 32),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    "Don't have an account? ",
                    style: AppTextStyles.bodyMedium,
                  ),
                  GestureDetector(
                    onTap: () => context.push(AppRoutes.signUp),
                    child: Text(
                      'Sign Up',
                      style: AppTextStyles.link,
                    ),
                  ),
                ],
              ),

            ],
          ),
        ),
      ),
    );
  }
}
