import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../../../core/core.dart';
import '../../../../core/widgets/app_button.dart';
import '../../../../core/widgets/auth_header.dart';

class ForgotPasswordScreen extends StatelessWidget {
  const ForgotPasswordScreen({super.key});

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
        child: Padding(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const AuthHeader(
                title: 'Reset Password',
                subtitle: 'Please enter your email address to request a password reset',
              ),
              const SizedBox(height: 32),
              const AppTextField(
                labelText: 'Email Address',
                hintText: 'Enter your email',
                keyboardType: TextInputType.emailAddress,
                prefixIcon: Icon(Icons.email_outlined, color: AppColors.textSecondary),
              ),
              const SizedBox(height: 32),
              AppButton.primary(
                text: 'SEND',
                hasArrow: true,
                onPressed: () {
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
