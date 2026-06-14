import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:go_router/go_router.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_text_styles.dart';
import '../../viewmodel/map_viewmodel.dart';
import '../widgets/map_event_card.dart';

class MapScreen extends StatefulWidget {
  const MapScreen({super.key});

  @override
  State<MapScreen> createState() => _MapScreenState();
}

class _MapScreenState extends State<MapScreen> {
  final MapViewModel _viewModel = MapViewModel();

  @override
  void initState() {
    super.initState();
    _viewModel.addListener(() {
      setState(() {});
    });
  }

  @override
  void dispose() {
    _viewModel.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          // 1. Google Map
          GoogleMap(
            initialCameraPosition: _viewModel.initialCameraPosition,
            markers: _viewModel.markers,
            myLocationEnabled: true,
            myLocationButtonEnabled: false,
            zoomControlsEnabled: false,
            mapToolbarEnabled: false,
            onMapCreated: (controller) {
              _viewModel.setMapController(controller);
            },
          ),

          // 2. Top Search Bar and Target Button
          Positioned(
            top: MediaQuery.of(context).padding.top + 16,
            left: 24,
            right: 24,
            child: Row(
              children: [
                Expanded(
                  child: Container(
                    height: 56,
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(16),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.05),
                          blurRadius: 10,
                          offset: const Offset(0, 4),
                        ),
                      ],
                    ),
                    child: Row(
                      children: [
                        IconButton(
                          icon: const Icon(Icons.arrow_back_ios_new, color: AppColors.textPrimary, size: 20),
                          onPressed: () => context.pop(),
                        ),
                        const Expanded(
                          child: TextField(
                            decoration: InputDecoration(
                              hintText: 'Find for food or restaurant...',
                              hintStyle: TextStyle(color: AppColors.textSecondary, fontSize: 14),
                              border: InputBorder.none,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                const SizedBox(width: 16),
                Container(
                  height: 56,
                  width: 56,
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(16),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.05),
                        blurRadius: 10,
                        offset: const Offset(0, 4),
                      ),
                    ],
                  ),
                  child: IconButton(
                    icon: const Icon(Icons.my_location, color: AppColors.primary),
                    onPressed: () {
                      // Move camera to current location (mock)
                    },
                  ),
                ),
              ],
            ),
          ),

          // 3. Category Chips
          Positioned(
            top: MediaQuery.of(context).padding.top + 88,
            left: 0,
            right: 0,
            child: SizedBox(
              height: 44,
              child: ListView(
                scrollDirection: Axis.horizontal,
                padding: const EdgeInsets.symmetric(horizontal: 24),
                children: [
                  _buildCategoryChip('Sports', Icons.sports_basketball, Colors.redAccent),
                  _buildCategoryChip('Music', Icons.music_note, Colors.blueAccent),
                  _buildCategoryChip('Food', Icons.restaurant, Colors.teal),
                ],
              ),
            ),
          ),

          // 4. Floating Action Button (Menu/Filter)
          Positioned(
            bottom: 160,
            right: 24,
            child: Container(
              height: 56,
              width: 56,
              decoration: BoxDecoration(
                color: AppColors.primary,
                shape: BoxShape.circle,
                boxShadow: [
                  BoxShadow(
                    color: AppColors.primary.withOpacity(0.4),
                    blurRadius: 12,
                    offset: const Offset(0, 4),
                  ),
                ],
              ),
              child: IconButton(
                icon: const Icon(Icons.filter_list, color: Colors.white),
                onPressed: () {
                  // Show filters
                },
              ),
            ),
          ),

          // 5. Event Cards ListView
          Positioned(
            bottom: 24,
            left: 0,
            right: 0,
            child: SizedBox(
              height: 120,
              child: ListView.builder(
                scrollDirection: Axis.horizontal,
                padding: const EdgeInsets.only(left: 24),
                itemCount: _viewModel.filteredEvents.length,
                itemBuilder: (context, index) {
                  final event = _viewModel.filteredEvents[index];
                  return MapEventCard(
                    title: event.title,
                    date: event.date,
                    location: event.location,
                    imagePath: event.imagePath,
                    onTap: () {
                      // Navigate to event details
                    },
                  );
                },
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildCategoryChip(String label, IconData icon, Color color) {
    final isSelected = _viewModel.selectedCategory == label;
    return GestureDetector(
      onTap: () => _viewModel.selectCategory(label),
      child: Container(
        margin: const EdgeInsets.only(right: 12),
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(24),
          border: Border.all(
            color: isSelected ? color : Colors.transparent,
            width: 1.5,
          ),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.05),
              blurRadius: 8,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Row(
          children: [
            Icon(icon, color: color, size: 20),
            const SizedBox(width: 8),
            Text(
              label,
              style: AppTextStyles.labelLarge.copyWith(
                color: isSelected ? AppColors.textPrimary : AppColors.textSecondary,
                fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
