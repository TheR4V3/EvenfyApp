import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'firestore_service.dart';

class HistoryPage extends StatefulWidget {
  const HistoryPage({super.key});

  @override
  _HistoryPageState createState() => _HistoryPageState();
}

class _HistoryPageState extends State<HistoryPage> {
   final FirestoreService _firestoreService = FirestoreService();

  @override
  void dispose() {
    super.dispose();
  }

  Future<List<Event>> fetch() async {
    var listEventIds = await _firestoreService.getUserEvents();
    return await _firestoreService.getEventsByIds(listEventIds);
  }
  
  late String previousMonth;
  final List<Event> events = []; 

  @override
  void initState() {
    super.initState();
    DateTime now = DateTime.now();
    previousMonth = DateFormat('MMMM').format(now);
  }

  @override
  Widget build(BuildContext context) {
    DateTime now = DateTime.now();
    String currentMonth = DateFormat('MMMM').format(now);

    if (currentMonth != previousMonth) {
      previousMonth = currentMonth;
    }

    String formattedDate = DateFormat('MMMM y').format(now);

    return Scaffold(
      appBar: AppBar(
        title: const Text('History'),
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Text(
            'History Page',
            style: TextStyle(fontSize: 20),
          ),
          const SizedBox(height: 20), 

          Container(
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(
              color: Colors.blue,
              borderRadius: BorderRadius.circular(10),
            ),
            child: Text(
              formattedDate,
              style: const TextStyle(
                color: Colors.white,
                fontSize: 16,
              ),
            ),
          ),
          const SizedBox(height: 20),
          Expanded(
            child: ListView.builder(
              itemCount: events.length,
              itemBuilder: (context, index) {
                return EventCardHistory(
                  event: events[index],
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}

class EventCardHistory extends StatelessWidget {
  final Event event;

  const EventCardHistory({super.key, required this.event});

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.all(10),
      child: ListTile(
        title: Text(event.title),
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                const Icon(Icons.access_time),
                const SizedBox(width: 5),
                Text(event.formattedDateTime()),
              ],
            ),
            Row(
              children: [
                const Icon(Icons.location_on),
                const SizedBox(width: 5),
                Text(event.location),
              ],
            ),
          ],
        ),
        onTap: () {

        },
      ),
    );
  }
}

