import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../../../core/router/app_router.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_text_styles.dart';
import '../widgets/event_card.dart';

class SeeAllEventsScreen extends StatelessWidget {
  const SeeAllEventsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        backgroundColor: AppColors.background,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: AppColors.textPrimary),
          onPressed: () => context.pop(),
        ),
        title: Text(
          'Events',
          style: AppTextStyles.headlineMedium.copyWith(color: AppColors.textPrimary),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.more_vert, color: AppColors.textPrimary),
            onPressed: () {},
          ),
        ],
      ),
      body: SafeArea(
        child: ListView(
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
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
              title: 'Global Sports Championship 2026',
              dateDay: '18',
              dateMonth: 'Dec',
              location: 'Wembley Stadium, London',
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
    );
  }
}
