import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import '../../../../core/router/app_router.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_text_styles.dart';
import '../../../../core/widgets/event_card.dart';
import '../../domain/entities/event_entity.dart';
import '../../domain/entities/see_all_config.dart';
import '../cubit/events_cubit.dart';
import '../cubit/events_state.dart';

class SeeAllEventsScreen extends StatefulWidget {
  final SeeAllConfig config;

  const SeeAllEventsScreen({super.key, required this.config});

  @override
  State<SeeAllEventsScreen> createState() => _SeeAllEventsScreenState();
}

class _SeeAllEventsScreenState extends State<SeeAllEventsScreen> {
  final ScrollController _scrollController = ScrollController();
  bool _isLoadingMore = false;

  @override
  void initState() {
    super.initState();
    context.read<EventsCubit>().loadSeeAll(widget.config);
    _scrollController.addListener(_onScroll);
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  Future<void> _onScroll() async {
    if (_isLoadingMore) return;
    if (_scrollController.position.pixels <
        _scrollController.position.maxScrollExtent - 200) {
      return;
    }

    final cubit = context.read<EventsCubit>();
    final state = cubit.state;
    if (state is! EventsLoaded) return;
    if (state.currentPage >= state.totalPages - 1) return;

    setState(() => _isLoadingMore = true);
    await cubit.loadMoreSeeAll();
    if (mounted) setState(() => _isLoadingMore = false);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        backgroundColor: AppColors.background,
        elevation: 0,
        automaticallyImplyLeading: false,
        title: Text(
          widget.config.title,
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
        child: BlocBuilder<EventsCubit, EventsState>(
          builder: (context, state) {
            if (state is EventsLoading) {
              return const Center(child: CircularProgressIndicator(color: AppColors.primary));
            }

            if (state is EventsEmpty) {
              return Center(
                child: Text(
                  widget.config.type == SeeAllType.nearby
                      ? 'No nearby events found.'
                      : 'No upcoming events found.',
                  style: AppTextStyles.bodyLarge.copyWith(color: AppColors.textSecondary),
                ),
              );
            }

            if (state is EventsError) {
              return Center(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(state.message, style: AppTextStyles.bodyLarge.copyWith(color: AppColors.error)),
                    const SizedBox(height: 12),
                    TextButton(
                      onPressed: () => context.read<EventsCubit>().loadSeeAll(widget.config),
                      child: const Text('Retry'),
                    ),
                  ],
                ),
              );
            }

            if (state is EventsLoaded) {
              return ListView.builder(
                controller: _scrollController,
                padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
                itemCount: state.events.length + (_isLoadingMore ? 1 : 0),
                itemBuilder: (context, index) {
                  if (index >= state.events.length) {
                    return const Padding(
                      padding: EdgeInsets.all(16),
                      child: Center(child: CircularProgressIndicator(color: AppColors.primary)),
                    );
                  }
                  return _buildEventCard(state.events[index]);
                },
              );
            }

            return const SizedBox.shrink();
          },
        ),
      ),
    );
  }

  Widget _buildEventCard(EventEntity event) {
    return EventCard(
      title: event.name,
      dateDay: event.day,
      dateMonth: event.month,
      location: event.locationLabel,
      imageUrl: event.imageUrl,
      isHorizontal: false,
      onTap: () => context.push(AppRoutes.eventDetails, extra: event),
    );
  }
}
