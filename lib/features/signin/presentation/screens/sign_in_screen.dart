import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import '../../../../core/core.dart';
import '../../../../core/widgets/auth_header.dart';
import '../../../auth/presentation/cubit/auth_cubit.dart';
import '../../../auth/presentation/cubit/auth_state.dart';
import '../../../../core/services/remember_me_service.dart';

class SignInScreen extends StatefulWidget {
  const SignInScreen({super.key});

  @override
  State<SignInScreen> createState() => _SignInScreenState();
}

class _SignInScreenState extends State<SignInScreen> {
  bool _rememberMe = false;
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  List<RememberedAccount> _accounts = const [];

  RememberMeService get _rememberMeService => getIt<RememberMeService>();

  @override
  void initState() {
    super.initState();
    _rememberMe = _rememberMeService.enabled;
    _accounts = _rememberMeService.getAccounts();
  }

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  void _handleSignIn() {
    if (_emailController.text.isEmpty || _passwordController.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please fill all fields'), backgroundColor: AppColors.error),
      );
      return;
    }
    context.read<AuthCubit>().signIn(_emailController.text, _passwordController.text);
  }

  Future<void> _handleAccountTap(String email) async {
    final pw = await _rememberMeService.getPassword(email);
    if (!mounted) return;
    if (pw == null || pw.isEmpty) {
      _emailController.text = email;
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Password not saved. Please enter password.')),
      );
      return;
    }
    _emailController.text = email;
    _passwordController.text = pw;
    context.read<AuthCubit>().signIn(email, pw);
  }

  Future<void> _handleRemoveAccount(String email) async {
    final confirm = await showDialog<bool>(
      context: context,
      useRootNavigator: true,
      builder: (dialogContext) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        titlePadding: const EdgeInsets.fromLTRB(24, 24, 24, 8),
        contentPadding: const EdgeInsets.fromLTRB(24, 0, 24, 8),
        actionsPadding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
        title: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(10),
              decoration: BoxDecoration(
                color: AppColors.error.withValues(alpha: 0.12),
                shape: BoxShape.circle,
              ),
              child: const Icon(Icons.person_remove_alt_1, color: AppColors.error),
            ),
            const SizedBox(width: 12),
            const Expanded(child: Text('Remove Saved Account')),
          ],
        ),
        content: Text(
          'This will remove $email from this device. You can add it again by signing in with Remember Me enabled.',
          style: const TextStyle(height: 1.4),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(dialogContext).pop(false),
            style: TextButton.styleFrom(
              foregroundColor: AppColors.textSecondary,
              padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 12),
            ),
            child: const Text('Cancel'),
          ),
          ElevatedButton.icon(
            onPressed: () => Navigator.of(dialogContext).pop(true),
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.error,
              foregroundColor: Colors.white,
              padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 12),
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
            ),
            icon: const Icon(Icons.delete_outline, size: 18),
            label: const Text('Remove'),
          ),
        ],
      ),
    );

    if (confirm != true) return;
    await _rememberMeService.removeAccount(email);
    if (!mounted) return;
    setState(() => _accounts = _rememberMeService.getAccounts());
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<AuthCubit, AuthState>(
      listener: (context, state) async {
        if (state is AuthSuccess) {
          if (_rememberMe) {
            await _rememberMeService.setEnabled(true);
            await _rememberMeService.saveAccount(
              email: _emailController.text,
              password: _passwordController.text,
            );
            if (mounted) {
              setState(() => _accounts = _rememberMeService.getAccounts());
            }
          } else {
            await _rememberMeService.setEnabled(false);
          }
          context.go(AppRoutes.home);
        } else if (state is AuthError) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text(state.message), backgroundColor: AppColors.error),
          );
        }
      },
      builder: (context, state) {
        final isLoading = state is AuthLoading;
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
                  if (_accounts.isNotEmpty) ...[
                    Text('Saved accounts', style: AppTextStyles.titleMedium.copyWith(fontWeight: FontWeight.bold)),
                    const SizedBox(height: 12),
                    SizedBox(
                      height: 80,
                      child: ListView.separated(
                        scrollDirection: Axis.horizontal,
                        itemCount: _accounts.length,
                        separatorBuilder: (_, __) => const SizedBox(width: 12),
                        itemBuilder: (_, i) {
                          final email = _accounts[i].email;
                          return GestureDetector(
                            onTap: () => _handleAccountTap(email),
                            onLongPress: () => _handleRemoveAccount(email),
                            child: Container(
                              width: 220,
                              padding: const EdgeInsets.all(14),
                              decoration: BoxDecoration(
                                color: Colors.white,
                                borderRadius: BorderRadius.circular(16),
                                border: Border.all(color: AppColors.border),
                              ),
                              child: Row(
                                children: [
                                  CircleAvatar(
                                    backgroundColor: AppColors.primarySurface,
                                    child: Text(email.isNotEmpty ? email[0].toUpperCase() : '?'),
                                  ),
                                  const SizedBox(width: 12),
                                  Expanded(
                                    child: Text(
                                      email,
                                      maxLines: 2,
                                      overflow: TextOverflow.ellipsis,
                                      style: AppTextStyles.bodyMedium,
                                    ),
                                  ),
                                  const SizedBox(width: 8),
                                  IconButton(
                                    tooltip: 'Remove',
                                    icon: const Icon(Icons.close, size: 18, color: AppColors.textSecondary),
                                    onPressed: () => _handleRemoveAccount(email),
                                  ),
                                ],
                              ),
                            ),
                          );
                        },
                      ),
                    ),
                    const SizedBox(height: 24),
                  ],
                  AppTextField(
                    controller: _emailController,
                    labelText: 'Email Address',
                    hintText: 'Enter your email',
                    keyboardType: TextInputType.emailAddress,
                    prefixIcon: const Icon(Icons.email_outlined, color: AppColors.textSecondary),
                  ),
                  const SizedBox(height: 20),
                  AppTextField(
                    controller: _passwordController,
                    labelText: 'Password',
                    hintText: 'Enter your password',
                    isPassword: true,
                    textInputAction: TextInputAction.done,
                    prefixIcon: const Icon(Icons.lock_outline, color: AppColors.textSecondary),
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
                              _rememberMeService.setEnabled(val);
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
                  isLoading
                      ? const Center(child: CircularProgressIndicator(color: AppColors.primary))
                      : AppButton.primary(
                          text: 'SIGN IN',
                          hasArrow: true,
                          onPressed: _handleSignIn,
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
                  AppButton.social(
                    text: 'Google',
                    iconPath: 'assets/icons/google.svg',
                    onPressed: () => context.read<AuthCubit>().signInWithGoogle(),
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
      },
    );
  }
}
