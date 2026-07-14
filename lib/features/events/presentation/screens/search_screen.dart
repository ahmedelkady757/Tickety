import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import '../../../../core/router/app_router.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_text_styles.dart';
import '../../../../core/widgets/event_card.dart';
import '../../domain/entities/event_entity.dart';
import '../cubit/events_cubit.dart';
import '../cubit/events_state.dart';
import '../widgets/search_filter_sheet.dart';

class SearchScreen extends StatefulWidget {
  const SearchScreen({super.key});

  @override
  State<SearchScreen> createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {
  final TextEditingController _searchController = TextEditingController();
  Timer? _debounce;

  @override
  void initState() {
    super.initState();
    context.read<EventsCubit>().loadDefaultEvents();
  }

  @override
  void dispose() {
    _debounce?.cancel();
    _searchController.dispose();
    super.dispose();
  }

  void _onSearchChanged(String query) {
    _debounce?.cancel();
    _debounce = Timer(const Duration(milliseconds: 500), () {
      context.read<EventsCubit>().search(query);
    });
  }

  Future<void> _openFilters() async {
    final cubit = context.read<EventsCubit>();
    final result = await SearchFilterSheet.show(context, cubit.activeFilters);
    if (result != null && mounted) {
      await cubit.applyFilters(result);
    }
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<EventsCubit, EventsState>(
      builder: (context, state) {
        final cubit = context.read<EventsCubit>();
        final hasFilters = cubit.activeFilters.hasActiveFilters;

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
                  Row(
                    children: [
                      const Icon(Icons.search, color: AppColors.primary, size: 24),
                      const SizedBox(width: 12),
                      Expanded(
                        child: TextField(
                          controller: _searchController,
                          onChanged: _onSearchChanged,
                          decoration: const InputDecoration(
                            hintText: 'Search events...',
                            border: InputBorder.none,
                          ),
                        ),
                      ),
                      GestureDetector(
                        onTap: _openFilters,
                        child: Container(
                          padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
                          decoration: BoxDecoration(
                            color: hasFilters
                                ? AppColors.primary
                                : AppColors.primary.withOpacity(0.1),
                            borderRadius: BorderRadius.circular(100),
                          ),
                          child: Row(
                            children: [
                              Icon(
                                Icons.tune,
                                color: hasFilters ? Colors.white : AppColors.primary,
                                size: 16,
                              ),
                              const SizedBox(width: 6),
                              Text(
                                'Filters',
                                style: AppTextStyles.labelLarge.copyWith(
                                  color: hasFilters ? Colors.white : AppColors.primary,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                  const Divider(color: AppColors.divider),
                  const SizedBox(height: 16),
                  Expanded(child: _buildBody(state)),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  Widget _buildBody(EventsState state) {
    if (state is EventsLoading) {
      return const Center(child: CircularProgressIndicator(color: AppColors.primary));
    }

    if (state is EventsEmpty) {
      return Center(
        child: Text(
          'No events found.',
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
              onPressed: () => context.read<EventsCubit>().loadDefaultEvents(),
              child: const Text('Retry'),
            ),
          ],
        ),
      );
    }

    if (state is EventsLoaded) {
      return ListView.builder(
        itemCount: state.events.length,
        itemBuilder: (context, index) => _buildEventCard(state.events[index]),
      );
    }

    return const SizedBox.shrink();
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
