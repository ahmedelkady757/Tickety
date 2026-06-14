import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../../../core/widgets/event_card.dart';
import '../../../../core/router/app_router.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_text_styles.dart';
import '../widgets/profile_header.dart';
import '../widgets/review_item_tile.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 3,
      child: Scaffold(
        backgroundColor: AppColors.background,
        appBar: AppBar(
          backgroundColor: Colors.transparent,
          elevation: 0,
          leading: IconButton(
            icon: const Icon(Icons.arrow_back, color: Colors.black),
            onPressed: () {
              if (context.canPop()) {
                context.pop();
              } else {
                context.go(AppRoutes.home);
              }
            },
          ),
          title: Text(
            '',
          ),
          actions: [
            IconButton(
              icon: const Icon(Icons.more_vert, color: Colors.black),
              onPressed: () {},
            ),
          ],
        ),
        body: Column(
          children: [
            const ProfileHeader(
              name: 'David Silbia',
              followingCount: '350',
              followersCount: '346',
            ),
            const SizedBox(height: 16),

            TabBar(
              labelColor: AppColors.primary,
              unselectedLabelColor: AppColors.textSecondary,
              labelStyle: AppTextStyles.labelLarge.copyWith(fontWeight: FontWeight.bold),
              unselectedLabelStyle: AppTextStyles.labelLarge,
              indicatorColor: AppColors.primary,
              indicatorSize: TabBarIndicatorSize.label,
              tabs: const [
                Tab(text: 'ABOUT'),
                Tab(text: 'EVENTS'),
                Tab(text: 'REVIEWS'),
              ],
            ),
            const Divider(height: 1, color: AppColors.divider),

            Expanded(
              child: TabBarView(
                children: [
                  _buildAboutTab(),
                  _buildEventsTab(context),
                  _buildReviewsTab(),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildAboutTab() {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(24.0),
      child: Text(
        'Ashfak Sayem is an accomplished event organizer specializing in music concerts, sports tournaments, and food festivals. With over 8 years of experience, he has managed high-profile events across London and New York. His primary goal is to bring the community together through memorable entertainment experiences.',
        style: AppTextStyles.bodyLarge.copyWith(
          color: AppColors.textSecondary,
          height: 1.5,
        ),
      ),
    );
  }

  Widget _buildEventsTab(BuildContext context) {
    return ListView(
      padding: const EdgeInsets.all(24.0),
      children: [
        EventCard(
          title: 'International Band Music Concert',
          dateDay: '14',
          dateMonth: 'Dec',
          location: 'Gala Convention Center, London',
          imagePath: 'assets/images/event_details_header.png',
          isHorizontal: false,
          onTap: () => context.push(AppRoutes.eventDetails),
        ),
        EventCard(
          title: 'Woodland Jazz Festival',
          dateDay: '20',
          dateMonth: 'Dec',
          location: 'Hyde Park, London',
          isHorizontal: false,
          onTap: () => context.push(AppRoutes.eventDetails),
        ),
      ],
    );
  }

  Widget _buildReviewsTab() {
    return ListView(
      padding: const EdgeInsets.all(24.0),
      children: const [
        ReviewItemTile(
          userName: 'Zenilsis',
          rating: 5,
          timeAgo: '10 Feb',
          comment: 'Outstanding events! The band selection is always great and security/parking is incredibly well organized.',
        ),
        ReviewItemTile(
          userName: 'Barkat U.',
          rating: 4,
          timeAgo: '20 Jan',
          comment: 'Had a wonderful time at the Gala Convention concert. Highly recommend checking out the events hosted here.',
        ),
      ],
    );
  }
}
