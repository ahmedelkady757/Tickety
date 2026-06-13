import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../../../core/router/app_router.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_text_styles.dart';
import '../widgets/event_card.dart';

class SearchScreen extends StatelessWidget {
  const SearchScreen({super.key});

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
          'Search',
          style: AppTextStyles.headlineMedium.copyWith(color: AppColors.textPrimary),
        ),
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24.0),
          child: Column(
            children: [
              // Search Input Row
              Row(
                children: [
                  const Icon(Icons.search, color: AppColors.primary, size: 24),
                  const SizedBox(width: 12),
                  const Expanded(
                    child: TextField(
                      decoration: InputDecoration(
                        hintText: 'Search...',
                        border: InputBorder.none,
                      ),
                    ),
                  ),
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
                    decoration: BoxDecoration(
                      color: AppColors.primary.withOpacity(0.1),
                      borderRadius: BorderRadius.circular(100),
                    ),
                    child: Row(
                      children: [
                        const Icon(Icons.tune, color: AppColors.primary, size: 16),
                        const SizedBox(width: 6),
                        Text(
                          'Filters',
                          style: AppTextStyles.labelLarge.copyWith(
                            color: AppColors.primary,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              const Divider(color: AppColors.divider),
              const SizedBox(height: 16),

              // Search Results List
              Expanded(
                child: ListView(
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
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
