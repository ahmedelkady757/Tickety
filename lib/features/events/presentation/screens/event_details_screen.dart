import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../../../core/core.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_text_styles.dart';
import '../widgets/event_header_image.dart';
import '../widgets/event_info_row.dart';
import '../widgets/event_about_section.dart';
import '../widgets/organizer_row.dart';
import '../widgets/bottom_cta_bar.dart';

class EventDetailsScreen extends StatelessWidget {
  const EventDetailsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: Stack(
        children: [
          SingleChildScrollView(
            padding: const EdgeInsets.only(bottom: 120),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                EventHeaderImage(
                  imagePath: 'assets/images/event_details_header.png',
                  goingCount: 20,
                  onBackTap: () => context.go(AppRoutes.signIn),
                  onInviteTap: () {},
                  onBookmarkTap: () {},
                ),

                const SizedBox(height: 50),

                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 24.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'International Band Music Concert',
                        style: AppTextStyles.displayMedium.copyWith(
                          color: AppColors.textPrimary,
                          fontSize: 32,
                        ),
                      ),
                      const SizedBox(height: 24),

                      const EventInfoRow(
                        icon: Icons.calendar_month,
                        title: '14 December, 2021',
                        subtitle: 'Tuesday, 4:00PM - 9:00PM',
                      ),
                      const SizedBox(height: 24),

                      const EventInfoRow(
                        icon: Icons.location_on,
                        title: 'Gala Convention Center',
                        subtitle: '36 Guild Street London, UK',
                      ),
                      const SizedBox(height: 24),

                      OrganizerRow(
                        name: 'Ashfak Sayem',
                        role: 'Organizer',
                        onFollowTap: () {},
                      ),
                      const SizedBox(height: 32),

                      EventAboutSection(
                        text:
                        'Enjoy your favorite dishes and a lovely time with your friends and family and have a great time. Food from local food trucks will be available for purchase.',
                        onReadMore: () {},
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),


          BottomCtaBar(
            label: 'BUY TICKET \$120',
            onPressed: () {},
          ),
        ],
      ),
    );
  }
}