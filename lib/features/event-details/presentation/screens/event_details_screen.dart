import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:url_launcher/url_launcher.dart';
import '../../../../core/core.dart';
import '../../../events/presentation/cubit/events_cubit.dart';
import '../../../events/presentation/cubit/events_state.dart';
import '../../../home/domain/entities/event_entity.dart';
import '../../../../core/favorites/favorites_cubit.dart';
import '../widgets/event_header_image.dart';
import '../../../../core/widgets/event_info_row.dart';
import '../widgets/event_about_section.dart';
import '../widgets/organizer_row.dart';
import '../widgets/bottom_cta_bar.dart';

class EventDetailsScreen extends StatefulWidget {
  final EventEntity? event;

  const EventDetailsScreen({super.key, this.event});

  @override
  State<EventDetailsScreen> createState() => _EventDetailsScreenState();
}

class _EventDetailsScreenState extends State<EventDetailsScreen> {
  bool _initialFavorite = false;

  @override
  void initState() {
    super.initState();
    if (widget.event != null) {
      context.read<EventsCubit>().loadEventDetails(widget.event!.id);
    }
    _primeFavorite();
  }

  Future<void> _primeFavorite() async {
    final event = widget.event;
    if (event == null) return;
    final fav = await context.read<FavoritesCubit>().check(event.id);
    if (!mounted) return;
    setState(() => _initialFavorite = fav);
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<FavoritesCubit, FavoritesState>(
      builder: (context, favState) {
        return BlocBuilder<EventsCubit, EventsState>(
          builder: (context, state) {
        if (state is EventDetailsLoading) {
          return const Scaffold(
            backgroundColor: AppColors.background,
            body: Center(child: CircularProgressIndicator(color: AppColors.primary)),
          );
        }

        if (state is EventDetailsError) {
          return Scaffold(
            backgroundColor: AppColors.background,
            appBar: AppBar(
              backgroundColor: AppColors.background,
              leading: IconButton(
                icon: const Icon(Icons.arrow_back, color: AppColors.textPrimary),
                onPressed: () => context.pop(),
              ),
            ),
            body: Center(
              child: Text(
                state.message,
                style: AppTextStyles.bodyLarge.copyWith(color: AppColors.error),
              ),
            ),
          );
        }

        final event = state is EventDetailsLoaded
            ? state.event
            : widget.event;

        if (event == null) {
          return Scaffold(
            backgroundColor: AppColors.background,
            appBar: AppBar(
              backgroundColor: AppColors.background,
              leading: IconButton(
                icon: const Icon(Icons.arrow_back, color: AppColors.textPrimary),
                onPressed: () => context.pop(),
              ),
            ),
            body: const Center(child: Text('Event not found')),
          );
        }

        return _buildContent(context, event, favState);
          },
        );
      },
    );
  }

  Widget _buildContent(BuildContext context, EventEntity event, FavoritesState favState) {
    final subtitle = event.time != null
        ? event.formattedTime
        : 'Time TBD';

    final venueSubtitle = [
      if (event.address != null) event.address,
      if (event.city != null) event.city,
      if (event.country != null) event.country,
    ].whereType<String>().join(', ');

    final aboutText = event.description ??
        'Discover ${event.name}${event.classification != null ? ' — a ${event.classification} event' : ''}. '
        'Get your tickets and enjoy an unforgettable experience.';

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
                  imagePath: event.imageUrl == null ? 'assets/images/event_details_header.png' : null,
                  imageUrl: event.imageUrl,
                  goingCount: 20,
                  isFavorite: favState.favoriteIds.contains(event.id) || _initialFavorite,
                  onBackTap: () {
                    if (context.canPop()) {
                      context.pop();
                    } else {
                      context.go(AppRoutes.home);
                    }
                  },
                  onInviteTap: () {},
                  onBookmarkTap: () => _toggleFavorite(context, event, favState),
                ),
                const SizedBox(height: 50),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 24.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        event.name,
                        style: AppTextStyles.displayMedium.copyWith(
                          color: AppColors.textPrimary,
                          fontSize: 32,
                        ),
                      ),
                      const SizedBox(height: 24),
                      EventInfoRow(
                        icon: Icons.calendar_month,
                        title: event.formattedDate,
                        subtitle: subtitle,
                      ),
                      const SizedBox(height: 24),
                      EventInfoRow(
                        icon: Icons.location_on,
                        title: event.venueName ?? 'Venue TBD',
                        subtitle: venueSubtitle.isNotEmpty ? venueSubtitle : event.locationLabel,
                        onTap: () => context.go(AppRoutes.map, extra: event),
                      ),
                      const SizedBox(height: 24),
                      OrganizerRow(
                        name: event.organizer ?? 'Event Organizer',
                        role: event.classification ?? 'Organizer',
                        onFollowTap: () {},
                      ),
                      const SizedBox(height: 32),
                      EventAboutSection(
                        text: aboutText,
                        onReadMore: () {},
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          BottomCtaBar(
            label: event.priceLabel,
            onPressed: () => _openTicketUrl(event.url),
          ),
        ],
      ),
    );
  }

  Future<void> _toggleFavorite(BuildContext context, EventEntity event, FavoritesState favState) async {
    final cubit = context.read<FavoritesCubit>();
    final isFav = favState.favoriteIds.contains(event.id) || _initialFavorite;
    if (!isFav) {
      await cubit.add(event);
      if (mounted) setState(() => _initialFavorite = true);
      return;
    }

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
              child: const Icon(Icons.favorite, color: AppColors.error),
            ),
            const SizedBox(width: 12),
            const Expanded(child: Text('Remove Favorite')),
          ],
        ),
        content: const Text(
          'Do you want to remove this event from your favorites?',
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

    if (confirm == true) {
      await cubit.remove(event.id);
      if (mounted) setState(() => _initialFavorite = false);
    }
  }

  Future<void> _openTicketUrl(String? url) async {
    if (url == null) return;
    final uri = Uri.parse(url);
    if (await canLaunchUrl(uri)) {
      await launchUrl(uri, mode: LaunchMode.externalApplication);
    }
  }
}
