import 'package:flutter/material.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_text_styles.dart';

class ProfileHeader extends StatelessWidget {
  final String name;
  final String followersCount;
  final String followingCount;
  final String reviewsCount;
  final String? coverImagePath;
  final String? avatarImagePath;

  const ProfileHeader({
    super.key,
    required this.name,
    required this.followersCount,
    required this.followingCount,
    required this.reviewsCount,
    this.coverImagePath,
    this.avatarImagePath,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        // Cover & Avatar Stack
        Stack(
          clipBehavior: Clip.none,
          alignment: Alignment.center,
          children: [
            // Cover Image with gradient
            Container(
              height: 160,
              width: double.infinity,
              decoration: const BoxDecoration(
                gradient: LinearGradient(
                  colors: [AppColors.primary, AppColors.primaryLight],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
              ),
              child: coverImagePath != null
                  ? Image.asset(
                      coverImagePath!,
                      fit: BoxFit.cover,
                      errorBuilder: (c, e, s) => const SizedBox(),
                    )
                  : const SizedBox(),
            ),
            // Avatar (overlapping the bottom of the cover banner)
            Positioned(
              bottom: -45,
              child: Container(
                padding: const EdgeInsets.all(4),
                decoration: const BoxDecoration(
                  color: Colors.white,
                  shape: BoxShape.circle,
                ),
                child: CircleAvatar(
                  radius: 45,
                  backgroundColor: AppColors.primaryLight,
                  child: avatarImagePath != null
                      ? ClipOval(
                          child: Image.asset(
                            avatarImagePath!,
                            width: 90,
                            height: 90,
                            fit: BoxFit.cover,
                            errorBuilder: (c, e, s) => const Icon(Icons.person, size: 50, color: Colors.white),
                          ),
                        )
                      : const Icon(Icons.person, size: 50, color: Colors.white),
                ),
              ),
            ),
          ],
        ),
        const SizedBox(height: 55), // Space for overlapping avatar

        // Profile Name
        Text(
          name,
          style: AppTextStyles.headlineMedium.copyWith(
            color: AppColors.textPrimary,
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 16),

        // Stats Row (Followers, Following, Reviews)
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            _buildStatItem('Followers', followersCount),
            _buildDivider(),
            _buildStatItem('Following', followingCount),
            _buildDivider(),
            _buildStatItem('Reviews', reviewsCount),
          ],
        ),
      ],
    );
  }

  Widget _buildStatItem(String label, String value) {
    return Column(
      children: [
        Text(
          value,
          style: AppTextStyles.titleMedium.copyWith(
            color: AppColors.textPrimary,
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 4),
        Text(
          label,
          style: AppTextStyles.labelLarge.copyWith(
            color: AppColors.textSecondary,
          ),
        ),
      ],
    );
  }

  Widget _buildDivider() {
    return Container(
      height: 32,
      width: 1,
      color: AppColors.divider,
      margin: const EdgeInsets.symmetric(horizontal: 24),
    );
  }
}
