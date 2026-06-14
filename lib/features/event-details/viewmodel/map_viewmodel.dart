import 'dart:ui' as ui;
import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class MapEvent {
  final String id;
  final String title;
  final String date;
  final String location;
  final String imagePath;
  final LatLng coordinate;
  final String category; // 'Sports', 'Music', 'Food'

  MapEvent({
    required this.id,
    required this.title,
    required this.date,
    required this.location,
    required this.imagePath,
    required this.coordinate,
    required this.category,
  });
}

class MapViewModel extends ChangeNotifier {
  GoogleMapController? _mapController;

  final CameraPosition initialCameraPosition = const CameraPosition(
    target: LatLng(47.6101, -122.2015), // Approx NE 8th St, Bellevue from image
    zoom: 14.0,
  );

  String _selectedCategory = 'All';
  String get selectedCategory => _selectedCategory;

  final List<MapEvent> _allEvents = [
    MapEvent(
      id: '1',
      title: 'Jo Malone London\'s Mother\'s Day Presents',
      date: 'Wed, Apr 28 • 5:30 PM',
      location: 'Radius Gallery • Santa Cruz, CA',
      imagePath: 'assets/images/event_details_header.png', // Fallback to an existing image
      coordinate: const LatLng(47.6051, -122.2005),
      category: 'Food',
    ),
    MapEvent(
      id: '2',
      title: 'Acoustic Night',
      date: 'Fri, Apr 30 • 7:00 PM',
      location: 'Downtown Stage • Bellevue, WA',
      imagePath: 'assets/images/event_details_header.png',
      coordinate: const LatLng(47.6151, -122.2115),
      category: 'Music',
    ),
    MapEvent(
      id: '3',
      title: 'Local Basketball Tournament',
      date: 'Sat, May 1 • 10:00 AM',
      location: 'Community Center • Bellevue, WA',
      imagePath: 'assets/images/event_details_header.png',
      coordinate: const LatLng(47.6101, -122.1955),
      category: 'Sports',
    ),
  ];

  List<MapEvent> get filteredEvents {
    if (_selectedCategory == 'All') return _allEvents;
    return _allEvents.where((e) => e.category == _selectedCategory).toList();
  }

  Set<Marker> _markers = {};
  Set<Marker> get markers => _markers;

  void setMapController(GoogleMapController controller) {
    _mapController = controller;
    _generateMarkers();
  }

  void selectCategory(String category) {
    if (_selectedCategory == category) {
      _selectedCategory = 'All';
    } else {
      _selectedCategory = category;
    }
    _generateMarkers();
    notifyListeners();
  }

  void _generateMarkers() async {
    _markers.clear();
    for (var event in filteredEvents) {
      Color markerColor;
      IconData iconData;

      switch (event.category) {
        case 'Sports':
          markerColor = Colors.redAccent;
          iconData = Icons.sports_basketball;
          break;
        case 'Music':
          markerColor = Colors.blueAccent;
          iconData = Icons.music_note;
          break;
        case 'Food':
          markerColor = Colors.teal;
          iconData = Icons.restaurant;
          break;
        default:
          markerColor = Colors.grey;
          iconData = Icons.event;
      }

      final icon = await _getCustomMarker(markerColor, iconData);

      _markers.add(
        Marker(
          markerId: MarkerId(event.id),
          position: event.coordinate,
          icon: icon,
          onTap: () {
            // Handle marker tap, maybe scroll to event card
          },
        ),
      );
    }
    notifyListeners();
  }

  Future<BitmapDescriptor> _getCustomMarker(Color color, IconData iconData) async {
    final ui.PictureRecorder pictureRecorder = ui.PictureRecorder();
    final Canvas canvas = Canvas(pictureRecorder);
    const double size = 100.0; // Scaled up for clarity

    // Draw shadow
    final Paint shadowPaint = Paint()..color = Colors.black.withOpacity(0.2);
    canvas.drawRRect(
      RRect.fromRectAndRadius(const Rect.fromLTWH(5, 5, size - 10, size - 10), const Radius.circular(20)),
      shadowPaint,
    );

    // Draw bubble background
    final Paint paint = Paint()..color = Colors.white;
    canvas.drawRRect(
      RRect.fromRectAndRadius(const Rect.fromLTWH(0, 0, size, size), const Radius.circular(25)),
      paint,
    );

    // Draw inner colored circle
    final Paint innerPaint = Paint()..color = color;
    canvas.drawCircle(const Offset(size / 2, size / 2), size / 2 - 10, innerPaint);

    // Draw triangle for speech bubble effect
    final Path path = Path();
    path.moveTo(size / 2 - 10, size);
    path.lineTo(size / 2 + 10, size);
    path.lineTo(size / 2, size + 15);
    path.close();
    canvas.drawPath(path, paint);

    // Draw icon
    TextPainter textPainter = TextPainter(textDirection: TextDirection.ltr);
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
        Offset((size - textPainter.width) / 2,
            (size - textPainter.height) / 2));

    final ui.Image image = await pictureRecorder.endRecording().toImage(size.toInt(), (size + 15).toInt());
    final ByteData? byteData = await image.toByteData(format: ui.ImageByteFormat.png);
    
    if (byteData == null) {
      return BitmapDescriptor.defaultMarker;
    }
    return BitmapDescriptor.fromBytes(byteData.buffer.asUint8List());
  }
}
