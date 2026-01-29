// event_data.dart

class EventData {
  final String title;
  final String date;
  final String time;
  final String venue;
  final String imageUrl;
  final String generalPrice;
  final String vipPrice;

  EventData({
    required this.title,
    required this.date,
    required this.time,
    required this.venue,
    required this.imageUrl,
    required this.generalPrice,
    required this.vipPrice,
  });
}
