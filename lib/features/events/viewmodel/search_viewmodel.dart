class SearchViewModel {
  bool isLoading = false;
  List<Map<String, dynamic>> results = [];

  final List<Map<String, dynamic>> _hardcodedEvents = [
    {
      'title': 'International Band Music Concert',
      'dateDay': '14',
      'dateMonth': 'Dec',
      'location': 'Gala Convention Center',
      'imagePath': 'assets/images/event_details_header.png',
    },
    {
      'title': 'Jazz in the Park',
      'dateDay': '20',
      'dateMonth': 'Dec',
      'location': 'Hyde Park, London',
      'imagePath': null,
    },
    {
      'title': 'Global Sports Championship 2026',
      'dateDay': '18',
      'dateMonth': 'Dec',
      'location': 'Wembley Stadium, London',
      'imagePath': null,
    },
    {
      'title': 'Gourmet Food & Wine Tasting',
      'dateDay': '24',
      'dateMonth': 'Dec',
      'location': 'Chelsea Market, NY',
      'imagePath': null,
    },
  ];

  Future<void> searchEvents(String query) async {
    isLoading = true;
    results = [];
    
    await Future.delayed(const Duration(milliseconds: 500)); // Simulate delay
    
    if (query.trim().isEmpty) {
      isLoading = false;
      return;
    }

    final lowerQuery = query.toLowerCase();
    results = _hardcodedEvents.where((event) {
      return event['title'].toLowerCase().contains(lowerQuery) || 
             event['location'].toLowerCase().contains(lowerQuery);
    }).toList();

    isLoading = false;
  }
}
