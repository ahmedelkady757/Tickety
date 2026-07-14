import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../../../../core/widgets/event_card.dart';
import '../../../../core/router/app_router.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_text_styles.dart';
import '../../../../core/favorites/favorites_cubit.dart';
import '../widgets/profile_header.dart';
import '../widgets/review_item_tile.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final user = FirebaseAuth.instance.currentUser;
    final displayName = _resolveDisplayName(user);
    
    return DefaultTabController(
      length: 3,
      child: Scaffold(
        backgroundColor: AppColors.background,
        appBar: AppBar(
          backgroundColor: Colors.transparent,
          elevation: 0,
          automaticallyImplyLeading: false,
          title: const Text(''),
          actions: [
            IconButton(
              icon: const Icon(Icons.more_vert, color: Colors.black),
              onPressed: () {},
            ),
          ],
        ),
        body: Column(
          children: [
            ProfileHeader(
              name: displayName,
              email: user?.email,
              avatarImageUrl: user?.photoURL,
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

  String _resolveDisplayName(User? user) {
    final name = user?.displayName?.trim();
    if (name != null && name.isNotEmpty) return name;
    final email = user?.email?.trim();
    if (email != null && email.isNotEmpty) {
      return email.split('@').first;
    }
    return 'Anonymous User';
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
    return BlocBuilder<FavoritesCubit, FavoritesState>(
      builder: (context, state) {
        final parentContext = context;
        if (state.isLoading) {
          return const Center(child: CircularProgressIndicator(color: AppColors.primary));
        }
        final favorites = state.favorites;
        if (favorites.isEmpty) {
          return Center(
            child: Text(
              'No favorites yet.',
              style: AppTextStyles.bodyLarge.copyWith(color: AppColors.textSecondary),
            ),
          );
        }

        return ListView.builder(
          padding: const EdgeInsets.all(24.0),
          itemCount: favorites.length,
          itemBuilder: (context, index) {
            final event = favorites[index];
            return Dismissible(
              key: ValueKey('fav-${event.id}'),
              direction: DismissDirection.endToStart,
              confirmDismiss: (_) => _confirmRemoveFavorite(parentContext),
              onDismissed: (_) => parentContext.read<FavoritesCubit>().remove(event.id),
              background: Container(
                margin: const EdgeInsets.only(bottom: 16),
                padding: const EdgeInsets.symmetric(horizontal: 20),
                alignment: Alignment.centerRight,
                decoration: BoxDecoration(
                  color: AppColors.error,
                  borderRadius: BorderRadius.circular(16),
                ),
                child: const Icon(Icons.delete, color: Colors.white),
              ),
              child: EventCard(
                title: event.name,
                dateDay: event.day,
                dateMonth: event.month,
                location: event.locationLabel,
                imageUrl: event.imageUrl,
                isHorizontal: false,
                onTap: () => parentContext.push(AppRoutes.eventDetails, extra: event),
              ),
            );
          },
        );
      },
    );
  }

  Future<bool> _confirmRemoveFavorite(BuildContext context) async {
    final res = await showDialog<bool>(
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
              child: const Icon(Icons.delete_outline, color: AppColors.error),
            ),
            const SizedBox(width: 12),
            const Expanded(child: Text('Remove Favorite')),
          ],
        ),
        content: const Text(
          'This event will be removed from your favorites list. You can add it again anytime.',
          style: TextStyle(height: 1.4),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(dialogContext).pop(false),
            style: TextButton.styleFrom(
              foregroundColor: AppColors.textSecondary,
              padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 12),
            ),
            child: const Text('Keep'),
          ),
          ElevatedButton.icon(
            onPressed: () => Navigator.of(dialogContext).pop(true),
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.error,
              foregroundColor: Colors.white,
              padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 12),
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
            ),
            icon: const Icon(Icons.delete, size: 18),
            label: const Text('Remove'),
          ),
        ],
      ),
    );
    return res ?? false;
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
