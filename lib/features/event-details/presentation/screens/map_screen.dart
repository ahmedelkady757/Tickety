import 'dart:ui' as ui;
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:go_router/go_router.dart';
import '../../../../core/router/app_router.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_text_styles.dart';
import '../../../home/domain/entities/event_entity.dart';
import '../cubit/map_cubit.dart';
import '../cubit/map_state.dart';
import '../widgets/map_event_card.dart';

class MapScreen extends StatefulWidget {
  final EventEntity? focusEvent;

  const MapScreen({super.key, this.focusEvent});

  @override
  State<MapScreen> createState() => _MapScreenState();
}

class _MapScreenState extends State<MapScreen> {
  GoogleMapController? _mapController;
  Set<Marker> _markers = {};

  static const _categories = [
    ('All', Icons.apps, AppColors.primary),
    ('Sports', Icons.sports_basketball, Color(0xFFF0635A)),
    ('Music', Icons.music_note, Color(0xFFF19E38)),
    ('Food', Icons.fastfood, Color(0xFF29D697)),
    ('Art', Icons.palette, Color(0xFF46CDFB)),
  ];

  @override
  void initState() {
    super.initState();
    if (widget.focusEvent == null) {
      context.read<MapCubit>().init();
    }
  }

  Future<void> _buildMarkers(List<EventEntity> events) async {
    final markers = <Marker>{};
    for (final event in events) {
      if (event.lat == null || event.lng == null) continue;
      final color = _colorForCategory(event.classification);
      final icon = await _markerIcon(color, _iconForCategory(event.classification));
      markers.add(Marker(
        markerId: MarkerId(event.id),
        position: LatLng(event.lat!, event.lng!),
        icon: icon,
        infoWindow: InfoWindow(title: event.name, snippet: event.venueName),
      ));
    }
    if (mounted) setState(() => _markers = markers);
  }

  Color _colorForCategory(String? classification) {
    final c = classification?.toLowerCase() ?? '';
    if (c.contains('sport')) return const Color(0xFFF0635A);
    if (c.contains('music')) return const Color(0xFFF19E38);
    if (c.contains('food')) return const Color(0xFF29D697);
    if (c.contains('art') || c.contains('theatre')) return const Color(0xFF46CDFB);
    return AppColors.primary;
  }

  IconData _iconForCategory(String? classification) {
    final c = classification?.toLowerCase() ?? '';
    if (c.contains('sport')) return Icons.sports_basketball;
    if (c.contains('music')) return Icons.music_note;
    if (c.contains('food')) return Icons.fastfood;
    if (c.contains('art') || c.contains('theatre')) return Icons.palette;
    return Icons.event;
  }

  Future<BitmapDescriptor> _markerIcon(Color color, IconData iconData) async {
    final recorder = ui.PictureRecorder();
    final canvas = Canvas(recorder);
    const size = 100.0;

    final paint = Paint()..color = Colors.white;
    canvas.drawRRect(
      RRect.fromRectAndRadius(const Rect.fromLTWH(0, 0, size, size), const Radius.circular(25)),
      paint,
    );

    final innerPaint = Paint()..color = color;
    canvas.drawCircle(const Offset(size / 2, size / 2), size / 2 - 10, innerPaint);

    final textPainter = TextPainter(textDirection: TextDirection.ltr);
    textPainter.text = TextSpan(
      text: String.fromCharCode(iconData.codePoint),
      style: TextStyle(
        fontSize: size / 2,
        fontFamily: iconData.fontFamily,
        package: iconData.fontPackage,
        color: Colors.white,
      ),
    );
    textPainter.layout();
    textPainter.paint(
      canvas,
      Offset((size - textPainter.width) / 2, (size - textPainter.height) / 2),
    );

    final image = await recorder.endRecording().toImage(size.toInt(), size.toInt());
    final byteData = await image.toByteData(format: ui.ImageByteFormat.png);
    if (byteData == null) return BitmapDescriptor.defaultMarker;
    return BitmapDescriptor.bytes(byteData.buffer.asUint8List());
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<MapCubit, MapState>(
      listener: (context, state) {
        if (state is MapLoaded) {
          _buildMarkers(state.mappableEvents);
          _mapController?.animateCamera(
            CameraUpdate.newCameraPosition(state.cameraPosition),
          );
        }
      },
      builder: (context, state) {
        if (state is MapLoading || state is MapInitial) {
          return const Scaffold(
            body: Center(child: CircularProgressIndicator(color: AppColors.primary)),
          );
        }

        if (state is MapError) {
          return Scaffold(
            body: Center(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(state.message, style: const TextStyle(color: AppColors.error)),
                  const SizedBox(height: 12),
                  TextButton(
                    onPressed: () => context.read<MapCubit>().init(focusEvent: widget.focusEvent),
                    child: const Text('Retry'),
                  ),
                ],
              ),
            ),
          );
        }

        if (state is! MapLoaded) return const SizedBox.shrink();

        return Scaffold(
          body: Stack(
            children: [
              GoogleMap(
                initialCameraPosition: state.cameraPosition,
                markers: _markers,
                myLocationEnabled: true,
                myLocationButtonEnabled: false,
                zoomControlsEnabled: false,
                mapToolbarEnabled: false,
                onMapCreated: (controller) => _mapController = controller,
              ),
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
                              icon: const Icon(Icons.search, color: AppColors.primary, size: 22),
                              onPressed: () => context.push(AppRoutes.search),
                            ),
                            Expanded(
                              child: Text(
                                'Events near you',
                                style: AppTextStyles.bodyMedium.copyWith(color: AppColors.textSecondary),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                    const SizedBox(width: 12),
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
                          _mapController?.animateCamera(
                            CameraUpdate.newCameraPosition(
                              CameraPosition(target: LatLng(state.lat, state.lng), zoom: 12),
                            ),
                          );
                        },
                      ),
                    ),
                  ],
                ),
              ),
              Positioned(
                top: MediaQuery.of(context).padding.top + 88,
                left: 0,
                right: 0,
                child: SizedBox(
                  height: 44,
                  child: ListView.builder(
                    scrollDirection: Axis.horizontal,
                    padding: const EdgeInsets.symmetric(horizontal: 24),
                    itemCount: _categories.length,
                    itemBuilder: (context, index) {
                      final (label, icon, color) = _categories[index];
                      final isSelected = (state.selectedCategory ?? 'All') == label;
                      return GestureDetector(
                        onTap: () => context.read<MapCubit>().filterByCategory(
                              label == 'All' ? null : label,
                            ),
                        child: Container(
                          margin: const EdgeInsets.only(right: 12),
                          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                          decoration: BoxDecoration(
                            color: isSelected ? color : Colors.white,
                            borderRadius: BorderRadius.circular(24),
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
                              Icon(icon, color: isSelected ? Colors.white : color, size: 18),
                              const SizedBox(width: 6),
                              Text(
                                label,
                                style: AppTextStyles.labelLarge.copyWith(
                                  color: isSelected ? Colors.white : AppColors.textPrimary,
                                  fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
                                ),
                              ),
                            ],
                          ),
                        ),
                      );
                    },
                  ),
                ),
              ),
              if (state.events.isEmpty)
                const Positioned(
                  bottom: 160,
                  left: 24,
                  right: 24,
                  child: Center(
                    child: Text('No events found nearby.', style: TextStyle(color: AppColors.textSecondary)),
                  ),
                )
              else
                Positioned(
                  bottom: 24,
                  left: 0,
                  right: 0,
                  child: SizedBox(
                    height: 120,
                    child: ListView.builder(
                      scrollDirection: Axis.horizontal,
                      padding: const EdgeInsets.only(left: 24),
                      itemCount: state.events.length,
                      itemBuilder: (context, index) {
                        final event = state.events[index];
                        return MapEventCard(
                          title: event.name,
                          date: '${event.day} ${event.month}${event.time != null ? ' • ${event.formattedTime}' : ''}',
                          location: event.locationLabel,
                          imageUrl: event.imageUrl,
                          onTap: () => context.push(AppRoutes.eventDetails, extra: event),
                        );
                      },
                    ),
                  ),
                ),
            ],
          ),
        );
      },
    );
  }
}
