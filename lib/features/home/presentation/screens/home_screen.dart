import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../../../core/router/app_router.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_text_styles.dart';
import '../../../../core/widgets/event_card.dart';
import '../widgets/home_header.dart';
import '../widgets/categories_bar.dart';
import '../widgets/invite_banner.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      drawer: _buildDrawer(context),
      body: Stack(
        children: [
          SingleChildScrollView(
            padding: const EdgeInsets.only(bottom: 90), // Space for bottom nav
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _buildTopHeader(context),
                const SizedBox(height: 24),

                CategoriesBar(
                  onCategorySelected: (category) {
                    // Filter logic in the future
                  },
                ),
                const SizedBox(height: 24),

                _buildSectionHeader(
                  title: 'Upcoming Events',
                  onSeeAllTap: () => context.push(AppRoutes.seeAllEvents),
                ),
                const SizedBox(height: 16),

                SizedBox(
                  height: 270,
                  child: ListView(
                    scrollDirection: Axis.horizontal,
                    padding: const EdgeInsets.symmetric(horizontal: 24),
                    children: [
                      EventCard(
                        title: 'International Band Music Concert',
                        dateDay: '14',
                        dateMonth: 'Dec',
                        location: 'Gala Convention Center, London',
                        imagePath: 'assets/images/event_details_header.png',
                        onTap: () => context.push(AppRoutes.eventDetails),
                      ),
                      EventCard(
                        title: 'Global Sports Championship 2026',
                        dateDay: '18',
                        dateMonth: 'Dec',
                        location: 'Wembley Stadium, London',
                        onTap: () => context.push(AppRoutes.eventDetails),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 16),

                // Invite Banner
                const InviteBanner(),
                const SizedBox(height: 16),

                _buildSectionHeader(
                  title: 'Nearby You',
                  onSeeAllTap: () => context.push(AppRoutes.seeAllEvents),
                ),
                const SizedBox(height: 16),

                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 24),
                  child: Column(
                    children: [
                      EventCard(
                        title: 'Woodland Jazz Festival',
                        dateDay: '20',
                        dateMonth: 'Dec',
                        location: 'Hyde Park, London',
                        isHorizontal: false,
                        onTap: () => context.push(AppRoutes.eventDetails),
                      ),
                      EventCard(
                        title: 'Gourmet Food & Wine Tasting',
                        dateDay: '24',
                        dateMonth: 'Dec',
                        location: 'Chelsea Market, NY',
                        isHorizontal: false,
                        onTap: () => context.push(AppRoutes.eventDetails),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),

          Positioned(
            bottom: 0,
            left: 0,
            right: 0,
            child: _buildBottomNavBar(context),
          ),
        ],
      ),
    );
  }

  Widget _buildTopHeader(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        color: AppColors.primary,
        borderRadius: BorderRadius.only(
          bottomLeft: Radius.circular(36),
          bottomRight: Radius.circular(36),
        ),
      ),
      padding: const EdgeInsets.only(bottom: 24),
      child: Column(
        children: [
          const SizedBox(height: 24),
          Builder(
            builder: (context) {
              return HomeHeader(
                location: 'New York, USA',
                onMenuTap: () => Scaffold.of(context).openDrawer(),
              );
            }
          ),
          const SizedBox(height: 20),
          // Search Input Row
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 24.0),
            child: Row(
              children: [
                Expanded(
                  child: GestureDetector(
                    onTap: () => context.push(AppRoutes.search),
                    child: Container(
                      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                      decoration: BoxDecoration(
                        color: Colors.white.withOpacity(0.15),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: const Row(
                        children: [
                          Icon(Icons.search, color: Colors.white70, size: 22),
                          SizedBox(width: 12),
                          Text(
                            'Search...',
                            style: TextStyle(color: Colors.white70, fontSize: 16),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: 12),
                // Filter Button
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
                  decoration: BoxDecoration(
                    color: Colors.white.withOpacity(0.15),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: const Row(
                    children: [
                      Icon(Icons.tune, color: Colors.white, size: 18),
                      SizedBox(width: 6),
                      Text(
                        'Filters',
                        style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSectionHeader({required String title, required VoidCallback onSeeAllTap}) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 24.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            title,
            style: AppTextStyles.headlineMedium.copyWith(
              color: AppColors.textPrimary,
              fontWeight: FontWeight.bold,
            ),
          ),
          GestureDetector(
            onTap: onSeeAllTap,
            child: Row(
              children: [
                Text(
                  'See All',
                  style: AppTextStyles.labelLarge.copyWith(color: AppColors.textSecondary),
                ),
                const Icon(Icons.arrow_right, color: AppColors.textSecondary),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildBottomNavBar(BuildContext context) {
    return Container(
      height: 80,
      decoration: BoxDecoration(
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.06),
            blurRadius: 20,
            offset: const Offset(0, -4),
          ),
        ],
      ),
      child: Stack(
        clipBehavior: Clip.none,
        alignment: Alignment.center,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              _buildNavBarItem(
                icon: Icons.explore,
                label: 'Home',
                isActive: true,
                onTap: () {},
              ),
              _buildNavBarItem(
                icon: Icons.calendar_month,
                label: 'Events',
                onTap: () => context.push(AppRoutes.seeAllEvents),
              ),
              _buildNavBarItem(
                icon: Icons.person,
                label: 'Profile',
                onTap: () => context.push(AppRoutes.profile),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildNavBarItem({
    required IconData icon,
    required String label,
    bool isActive = false,
    required VoidCallback onTap,
  }) {
    final color = isActive ? AppColors.primary : AppColors.textSecondary.withOpacity(0.6);
    return GestureDetector(
      onTap: onTap,
      behavior: HitTestBehavior.opaque,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, color: color, size: 24),
          const SizedBox(height: 4),
          Text(
            label,
            style: TextStyle(color: color, fontSize: 12, fontWeight: isActive ? FontWeight.bold : FontWeight.normal),
          ),
        ],
      ),
    );
  }

  Widget _buildDrawer(BuildContext context) {
    return Drawer(
      backgroundColor: Colors.white,
      child: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 32.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const CircleAvatar(
                radius: 36,
                backgroundColor: AppColors.primaryLight,
                backgroundImage: AssetImage('assets/images/user_avatar.png'), // Or appropriate image
                child: Icon(Icons.person, color: Colors.white, size: 40),
              ),
              const SizedBox(height: 16),
              Text(
                'Ashfak Sayem',
                style: AppTextStyles.headlineMedium.copyWith(
                  fontWeight: FontWeight.bold,
                  color: AppColors.textPrimary,
                ),
              ),
              const SizedBox(height: 40),
              
              _buildDrawerItem(
                icon: Icons.person_outline,
                title: 'My Profile',
                onTap: () {
                  context.pop();
                  context.push(AppRoutes.profile);
                },
              ),
              _buildDrawerItem(
                icon: Icons.chat_bubble_outline,
                title: 'Massage',
                badgeCount: 3,
                onTap: () {},
              ),
              _buildDrawerItem(
                icon: Icons.calendar_today_outlined,
                title: 'Calender',
                onTap: () {},
              ),
              _buildDrawerItem(
                icon: Icons.bookmark_border,
                title: 'Bookmark',
                onTap: () {},
              ),
              _buildDrawerItem(
                icon: Icons.mail_outline,
                title: 'Contact Us',
                onTap: () {},
              ),
              _buildDrawerItem(
                icon: Icons.settings_outlined,
                title: 'Settings',
                onTap: () {},
              ),
              _buildDrawerItem(
                icon: Icons.help_outline,
                title: 'Helps & FAQs',
                onTap: () {},
              ),
              _buildDrawerItem(
                icon: Icons.logout,
                title: 'Sign Out',
                onTap: () {
                  context.pop();
                  context.go(AppRoutes.signIn);
                },
              ),

              const Spacer(),
              
              Container(
                width: 150,
                child: ElevatedButton.icon(
                  onPressed: () {},
                  icon: const Icon(Icons.workspace_premium, color: Colors.cyanAccent),
                  label: const Text('Upgrade Pro'),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.cyanAccent.withOpacity(0.15),
                    foregroundColor: Colors.cyanAccent,
                    elevation: 0,
                    padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 16),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildDrawerItem({
    required IconData icon,
    required String title,
    required VoidCallback onTap,
    int? badgeCount,
  }) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 12.0),
      child: InkWell(
        onTap: onTap,
        child: Row(
          children: [
            Stack(
              clipBehavior: Clip.none,
              children: [
                Icon(icon, color: AppColors.textSecondary, size: 28),
                if (badgeCount != null)
                  Positioned(
                    right: -4,
                    top: -4,
                    child: Container(
                      padding: const EdgeInsets.all(4),
                      decoration: const BoxDecoration(
                        color: Colors.orange,
                        shape: BoxShape.circle,
                      ),
                      child: Text(
                        badgeCount.toString(),
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 10,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),
              ],
            ),
            const SizedBox(width: 16),
            Text(
              title,
              style: AppTextStyles.titleMedium.copyWith(
                color: AppColors.textPrimary,
                fontWeight: FontWeight.w500,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
