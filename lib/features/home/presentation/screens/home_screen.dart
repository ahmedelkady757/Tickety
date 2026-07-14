import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:go_router/go_router.dart';
import '../../../../core/constants/app_constants.dart';
import '../../../../core/router/app_router.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_text_styles.dart';
import '../../../../core/widgets/event_card.dart';
import '../../../auth/presentation/cubit/auth_cubit.dart';
import '../../../auth/presentation/cubit/auth_state.dart';
import '../../domain/entities/event_entity.dart';
import '../../../events/domain/entities/see_all_config.dart';
import '../cubit/home_cubit.dart';
import '../cubit/home_state.dart';
import '../widgets/home_header.dart';
import '../widgets/categories_bar.dart';
import '../widgets/invite_banner.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  @override
  void initState() {
    super.initState();
    context.read<HomeCubit>().init();
  }

  @override
  Widget build(BuildContext context) {
    return MultiBlocListener(
      listeners: [
        BlocListener<AuthCubit, AuthState>(
          listener: (context, state) {
            if (state is AuthInitial) context.go(AppRoutes.signIn);
          },
        ),
        BlocListener<HomeCubit, HomeState>(
          listener: (context, state) {
            if (state is HomeLocationDenied) {
              _showLocationDialog(context, isPermanent: state.isPermanent);
            }
          },
        ),
      ],
      child: Scaffold(
        backgroundColor: AppColors.background,
        drawer: _buildDrawer(context),
        body: BlocBuilder<HomeCubit, HomeState>(
          builder: (context, state) {
            return Stack(
              children: [
                SingleChildScrollView(
                  padding: const EdgeInsets.only(bottom: 24),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      _buildTopHeader(context, state),
                      const SizedBox(height: 24),
                      CategoriesBar(
                        selectedLabel: _selectedCategory(state),
                        onCategorySelected: (category) =>
                            context.read<HomeCubit>().filterByCategory(category.label),
                      ),
                      const SizedBox(height: 24),
                      _buildUpcomingSection(context, state),
                      const SizedBox(height: 16),
                      const InviteBanner(),
                      const SizedBox(height: 16),
                      _buildNearbySection(context, state),
                    ],
                  ),
                ),
              ],
            );
          },
        ),
      ),
    );
  }







  void _showLocationDialog(BuildContext context, {required bool isPermanent}) {
    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        title: const Text('Location Access'),
        content: Text(
          isPermanent
              ? 'Location permission is permanently denied. Please enable it in app settings to see events near you.'
              : 'Enable location access to discover events happening near you.',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Later'),
          ),
          ElevatedButton(
            style: ElevatedButton.styleFrom(backgroundColor: AppColors.primary),
            onPressed: () {
              Navigator.pop(context);
              context.read<HomeCubit>().locationService.openAppSettings();
            },
            child: const Text('Go to Settings', style: TextStyle(color: Colors.white)),
          ),
        ],
      ),
    );
  }

  // ─── Top header ──────────────────────────────────────────────────────────
  Widget _buildTopHeader(BuildContext context, HomeState state) {
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
            builder: (ctx) => HomeHeader(
              location: _cityLabel(state),
              onMenuTap: () => Scaffold.of(ctx).openDrawer(),
            ),
          ),
          const SizedBox(height: 20),
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
                          Text('Search...', style: TextStyle(color: Colors.white70, fontSize: 16)),
                        ],
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: 12),
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
                      Text('Filters', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
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

  // ─── Upcoming Events section ──────────────────────────────────────────────
  Widget _buildUpcomingSection(BuildContext context, HomeState state) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildSectionHeader(
          title: 'Upcoming Events',
          onSeeAllTap: () => context.go(_seeAllUri(state, SeeAllType.upcoming)),
        ),
        const SizedBox(height: 16),
        SizedBox(
          height: 270,
          child: _buildUpcomingList(context, state),
        ),
      ],
    );
  }

  Widget _buildUpcomingList(BuildContext context, HomeState state) {
    if (state is HomeLoading) {
      if (state.hasStaleData) return _buildUpcomingEventList(state.staleUpcoming!);
      return _buildHorizontalShimmer();
    }

    if (state is HomeError) {
      return Center(
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(state.message, style: const TextStyle(color: AppColors.error)),
              const SizedBox(height: 12),
              TextButton(
                onPressed: () => context.read<HomeCubit>().init(),
                child: const Text('Retry'),
              ),
            ],
          ),
        ),
      );
    }

    List<EventEntity> events = [];
    if (state is HomeLoaded) events = state.upcomingEvents;
    if (state is HomeLocationDenied) events = state.upcomingEvents;

    return _buildUpcomingEventList(events);
  }

  Widget _buildUpcomingEventList(List<EventEntity> events) {
    if (events.isEmpty) {
      return const Center(
        child: Padding(
          padding: EdgeInsets.all(24),
          child: Text('No upcoming events found.', style: TextStyle(color: AppColors.textSecondary)),
        ),
      );
    }

    return ListView.builder(
      scrollDirection: Axis.horizontal,
      padding: const EdgeInsets.symmetric(horizontal: 24),
      itemCount: events.length,
      itemBuilder: (context, index) {
        final e = events[index];
        return EventCard(
          title: e.name,
          dateDay: e.day,
          dateMonth: e.month,
          location: e.locationLabel,
          imageUrl: e.imageUrl,
          onTap: () => context.push(AppRoutes.eventDetails, extra: e),
        );
      },
    );
  }

  // ─── Nearby Events section ────────────────────────────────────────────────
  Widget _buildNearbySection(BuildContext context, HomeState state) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildSectionHeader(
          title: 'Nearby You',
          onSeeAllTap: () => context.go(_seeAllUri(state, SeeAllType.nearby)),
        ),
        const SizedBox(height: 16),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24),
          child: _buildNearbyList(context, state),
        ),
      ],
    );
  }

  Widget _buildNearbyList(BuildContext context, HomeState state) {
    if (state is HomeLoading) {
      if (state.staleNearby != null) return _buildNearbyEventList(context, state.staleNearby!);
      return _buildVerticalShimmer();
    }

    if (state is HomeError) return const SizedBox.shrink();

    if (state is HomeLocationDenied) {
      return _buildLocationPrompt(context);
    }

    List<EventEntity> events = [];
    if (state is HomeLoaded) events = state.nearbyEvents;

    return _buildNearbyEventList(context, events);
  }

  Widget _buildNearbyEventList(BuildContext context, List<EventEntity> events) {
    if (events.isEmpty) {
      return const Padding(
        padding: EdgeInsets.all(16),
        child: Text('No nearby events found.', style: TextStyle(color: AppColors.textSecondary)),
      );
    }

    return Column(
      children: events
          .take(4)
          .map((e) => EventCard(
                title: e.name,
                dateDay: e.day,
                dateMonth: e.month,
                location: e.locationLabel,
                imageUrl: e.imageUrl,
                isHorizontal: false,
                onTap: () => context.push(AppRoutes.eventDetails, extra: e),
              ))
          .toList(),
    );
  }

  Widget _buildLocationPrompt(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: AppColors.primarySurface,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppColors.primary.withOpacity(0.2)),
      ),
      child: Row(
        children: [
          const Icon(Icons.location_off, color: AppColors.primary, size: 32),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('Enable Location',
                    style: AppTextStyles.titleMedium.copyWith(fontWeight: FontWeight.bold)),
                const SizedBox(height: 4),
                Text('Allow location access to see events near you.',
                    style: AppTextStyles.bodyMedium.copyWith(color: AppColors.textSecondary)),
              ],
            ),
          ),
          TextButton(
            onPressed: () => context.read<HomeCubit>().locationService.openAppSettings(),
            child: const Text('Enable'),
          ),
        ],
      ),
    );
  }

  // ─── Shimmer placeholders ─────────────────────────────────────────────────
  Widget _buildHorizontalShimmer() {
    return ListView.builder(
      scrollDirection: Axis.horizontal,
      padding: const EdgeInsets.symmetric(horizontal: 24),
      itemCount: 3,
      itemBuilder: (_, __) => Container(
        width: 270,
        margin: const EdgeInsets.only(right: 16),
        decoration: BoxDecoration(
          color: Colors.grey.shade200,
          borderRadius: BorderRadius.circular(18),
        ),
        child: _shimmerAnimation(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(height: 130, color: Colors.grey.shade300),
              const SizedBox(height: 12),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 10),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(height: 14, width: 180, color: Colors.grey.shade300),
                    const SizedBox(height: 8),
                    Container(height: 12, width: 120, color: Colors.grey.shade300),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildVerticalShimmer() {
    return Column(
      children: List.generate(
        2,
        (_) => Container(
          margin: const EdgeInsets.only(bottom: 16),
          height: 100,
          decoration: BoxDecoration(
            color: Colors.grey.shade200,
            borderRadius: BorderRadius.circular(16),
          ),
          child: _shimmerAnimation(
            child: Row(
              children: [
                Container(width: 100, color: Colors.grey.shade300),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Container(height: 12, width: 140, color: Colors.grey.shade300),
                      const SizedBox(height: 8),
                      Container(height: 12, width: 100, color: Colors.grey.shade300),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _shimmerAnimation({required Widget child}) {
    return TweenAnimationBuilder<double>(
      tween: Tween(begin: 0.5, end: 1.0),
      duration: const Duration(milliseconds: 800),
      builder: (_, value, __) => Opacity(opacity: value, child: child),
      onEnd: () {},
    );
  }

  // ─── Section header ───────────────────────────────────────────────────────
  Widget _buildSectionHeader({required String title, required VoidCallback onSeeAllTap}) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 24.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(title,
              style: AppTextStyles.headlineMedium
                  .copyWith(color: AppColors.textPrimary, fontWeight: FontWeight.bold)),
          GestureDetector(
            onTap: onSeeAllTap,
            child: Row(
              children: [
                Text('See All',
                    style: AppTextStyles.labelLarge.copyWith(color: AppColors.textSecondary)),
                const Icon(Icons.arrow_right, color: AppColors.textSecondary),
              ],
            ),
          ),
        ],
      ),
    );
  }

  String _cityLabel(HomeState state) {
    if (state is HomeLoaded) return state.cityLabel;
    if (state is HomeLoading) return state.cityLabel;
    if (state is HomeLocationDenied) return state.cityLabel;
    if (state is HomeError) return state.cityLabel;
    return AppConstants.defaultCity;
  }

  String _selectedCategory(HomeState state) {
    if (state is HomeLoaded) return state.selectedCategory;
    if (state is HomeLoading) return state.selectedCategory;
    if (state is HomeLocationDenied) return state.selectedCategory;
    if (state is HomeError) return state.selectedCategory;
    return 'All';
  }

  String _seeAllUri(HomeState state, SeeAllType type) {
    final params = <String, String>{
      'type': type == SeeAllType.nearby ? 'nearby' : 'upcoming',
    };

    if (state is HomeLoaded) {
      if (state.selectedCategory != 'All') {
        params['category'] = state.selectedCategory;
      }
      if (state.lat != null) params['lat'] = state.lat!.toString();
      if (state.lng != null) params['lng'] = state.lng!.toString();
      params['city'] = state.cityLabel.split(',').first.trim();
    } else if (state is HomeLocationDenied) {
      if (state.selectedCategory != 'All') {
        params['category'] = state.selectedCategory;
      }
      params['lat'] = AppConstants.defaultLat.toString();
      params['lng'] = AppConstants.defaultLng.toString();
      params['city'] = AppConstants.defaultCity;
    }

    final query = params.entries
        .map((e) => '${e.key}=${Uri.encodeComponent(e.value)}')
        .join('&');
    return '${AppRoutes.seeAllEvents}?$query';
  }

  // ─── Drawer ───────────────────────────────────────────────────────────────
  Widget _buildDrawer(BuildContext context) {
    final user = FirebaseAuth.instance.currentUser;
    final displayName = _resolveDisplayName(user);
    final photoUrl = user?.photoURL;
    final initial = displayName.isNotEmpty ? displayName[0].toUpperCase() : '?';

    return Drawer(
      backgroundColor: Colors.white,
      child: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 32.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              CircleAvatar(
                radius: 36,
                backgroundColor: AppColors.primaryLight,
                backgroundImage: photoUrl != null ? NetworkImage(photoUrl) : null,
                child: photoUrl == null
                    ? Text(initial, style: const TextStyle(fontSize: 32, color: Colors.white))
                    : null,
              ),
              const SizedBox(height: 16),
              Text(displayName,
                  style: AppTextStyles.headlineMedium.copyWith(
                      fontWeight: FontWeight.bold, color: AppColors.textPrimary)),
              if (user?.email != null) ...[
                const SizedBox(height: 4),
                Text(user!.email!,
                    style: AppTextStyles.bodyMedium.copyWith(color: AppColors.textSecondary)),
              ],
              const SizedBox(height: 40),
              _buildDrawerItem(icon: Icons.person_outline, title: 'My Profile', onTap: () {
                context.pop();
                context.go(AppRoutes.profile);
              }),
              _buildDrawerItem(icon: Icons.mail_outline, title: 'Contact Us', onTap: () {}),
              _buildDrawerItem(icon: Icons.settings_outlined, title: 'Settings', onTap: () {}),
              _buildDrawerItem(icon: Icons.help_outline, title: 'Helps & FAQs', onTap: () {}),
              _buildDrawerItem(
                icon: Icons.logout,
                title: 'Sign Out',
                onTap: () {
                  context.pop();
                  context.read<AuthCubit>().signOut();
                },
              ),
              const Spacer(),
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
                      decoration: const BoxDecoration(color: Colors.orange, shape: BoxShape.circle),
                      child: Text(badgeCount.toString(),
                          style: const TextStyle(color: Colors.white, fontSize: 10, fontWeight: FontWeight.bold)),
                    ),
                  ),
              ],
            ),
            const SizedBox(width: 16),
            Text(title,
                style: AppTextStyles.titleMedium.copyWith(
                    color: AppColors.textPrimary, fontWeight: FontWeight.w500)),
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
}
