import 'package:flutter/material.dart';
import '../../../../../core/theme/app_colors.dart';
import '../../../../../core/theme/app_text_styles.dart';

class OrganizerRow extends StatelessWidget {
  final String name;
  final String role;
  final VoidCallback? onFollowTap;

  const OrganizerRow({
    super.key,
    required this.name,
    this.role = 'Organizer',
    this.onFollowTap,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Container(
          width: 48,
          height: 48,
          decoration: const BoxDecoration(
            shape: BoxShape.circle,
            color: AppColors.primaryLight,
          ),
          child: const Icon(Icons.person, color: Colors.white, size: 28),
        ),
        const SizedBox(width: 16),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                name,
                style: AppTextStyles.titleMedium.copyWith(
                  color: AppColors.textPrimary,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 4),
              Text(
                role,
                style: AppTextStyles.labelLarge.copyWith(color: AppColors.textSecondary),
              ),
            ],
          ),
        ),
        GestureDetector(
          onTap: onFollowTap,
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            decoration: BoxDecoration(
              color: AppColors.primarySurface,
              borderRadius: BorderRadius.circular(8),
            ),
            child: Text(
              'Follow',
              style: AppTextStyles.labelLarge.copyWith(color: AppColors.primary),
            ),
          ),
        ),
      ],
    );
  }
}
