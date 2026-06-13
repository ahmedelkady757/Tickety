import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../../../core/core.dart';
import '../widgets/auth_header.dart';

class SignUpScreen extends StatelessWidget {
  const SignUpScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new, color: AppColors.textPrimary),
          onPressed: () => context.pop(),
        ),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const AuthHeader(
                title: 'Sign up',
                subtitle: '',
              ),
              const SizedBox(height: 32),
              const AppTextField(
                labelText: 'Full Name',
                hintText: 'Enter your full name',
                prefixIcon: Icon(Icons.person_outline, color: AppColors.textSecondary),
              ),
              const SizedBox(height: 20),
              const AppTextField(
                labelText: 'Email Address',
                hintText: 'Enter your email',
                keyboardType: TextInputType.emailAddress,
                prefixIcon: Icon(Icons.email_outlined, color: AppColors.textSecondary),
              ),
              const SizedBox(height: 20),
              const AppTextField(
                labelText: 'Password',
                hintText: 'Create a password',
                isPassword: true,
                prefixIcon: Icon(Icons.lock_outline, color: AppColors.textSecondary),
              ),
              const SizedBox(height: 32),
              AppButton.primary(
                text: 'SIGN UP',
                hasArrow: true,
                onPressed: () => context.go(AppRoutes.signIn),

              ),
              const SizedBox(height: 32),
               Row(
                children: [
                  const Expanded(child: Divider(color: AppColors.border)),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    child: Text(
                      'Or sign up with',
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
                    'Already have an account? ',
                    style: AppTextStyles.bodyMedium,
                  ),
                  GestureDetector(
                    onTap: () => context.pop(),
                    child:  Text(
                      'Sign In',
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
