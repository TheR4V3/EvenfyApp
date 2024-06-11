import 'package:flutter/material.dart';

class Event {
  final String name;
  final String dateAndTime;
  final String location;
  final String price;
  final bool isReviewed;

  Event({
    required this.name,
    required this.dateAndTime,
    required this.location,
    required this.price,
    required this.isReviewed,
  });
}

List<Event> events = [
  Event(
    name: 'Webinar flutter',
    dateAndTime: 'April 10, 2024 - 10:00',
    location: 'TULT',
    price: '20.000',
    isReviewed: true,
  ),
  Event(
    name: 'Webinar Scrum Master',
    dateAndTime: 'April 15, 2024 - 14:00',
    location: 'GKU',
    price: '20.000',
    isReviewed: false,
  ),
];

class SearchPage extends StatefulWidget {
  @override
  _SearchPageState createState() => _SearchPageState();
}

class _SearchPageState extends State<SearchPage> {
  List<Event> filteredEvents = [];

  @override
  void initState() {
    super.initState();
    filteredEvents = events;
  }

  void _search(String value) {
    setState(() {
      filteredEvents = events.where((event) {
        return event.name.toLowerCase().contains(value.toLowerCase());
      }).toList();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Search"),
      ),
      body: Column(
        children: [
          TextField(
            onChanged: _search,
            decoration: InputDecoration(
              filled: true,
              fillColor: Colors.white,
              isDense: true,
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(20),
                borderSide: BorderSide.none,
              ),
              prefixIcon: Icon(Icons.search),
              hintText: "Search Events...",
            ),
          ),
          Expanded(
            child: ListView.builder(
              itemCount: filteredEvents.length,
              itemBuilder: (context, index) {
                final event = filteredEvents[index];
                return ListTile(
                  title: Text(event.name),
                  subtitle: Text("${event.dateAndTime}, ${event.location}"),
                  onTap: () {
                    // Handle onTap event for each search result
                  },
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
