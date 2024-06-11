import 'package:flutter/material.dart';

class ReviewPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Review Page'),
      ),
      body: ListView.builder(
        itemCount: events.length,
        itemBuilder: (context, index) {
          return EventCard(
            event: events[index],
            onTap: () {
              _showEventDetails(context, events[index]);
            },
          );
        },
      ),
    );
  }

  void _showEventDetails(BuildContext context, Event event) {
    showModalBottomSheet(
      context: context,
      builder: (BuildContext context) {
        return EventDetailsSheet(event: event);
      },
    );
  }
}

class Event {
  final String name;
  final String dateAndTime;
  final String location;
  final bool isReviewed;

  Event({
    required this.name,
    required this.dateAndTime,
    required this.location,
    required this.isReviewed,
  });
}

// Daftar contoh event
List<Event> events = [
  Event(
    name: 'Webinar flutter',
    dateAndTime: 'April 10, 2024 - 10:00',
    location: 'TULT',
    isReviewed: true,
  ),
  Event(
    name: 'Webinar Scrum Master',
    dateAndTime: 'April 15, 2024 - 14:00',
    location: 'GKU',
    isReviewed: false,
  ),
];

class EventCard extends StatelessWidget {
  final Event event;
  final VoidCallback onTap;

  EventCard({required this.event, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: EdgeInsets.all(10),
      child: ListTile(
        title: Text(event.name),
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(Icons.access_time),
                SizedBox(width: 5),
                Text(event.dateAndTime),
              ],
            ),
            Row(
              children: [
                Icon(Icons.location_on),
                SizedBox(width: 5),
                Text(event.location),
              ],
            ),
          ],
        ),
        trailing: Container(
          padding: EdgeInsets.symmetric(vertical: 6, horizontal: 12),
          decoration: BoxDecoration(
            color: event.isReviewed ? Colors.green : Colors.orange,
            borderRadius: BorderRadius.circular(20),
          ),
          child: Text(
            event.isReviewed ? 'Reviewed' : 'Pending',
            style: TextStyle(color: Colors.white),
          ),
        ),
        onTap: onTap, // Open details when tapped
      ),
    );
  }
}

class EventDetailsSheet extends StatefulWidget {
  final Event event;

  EventDetailsSheet({required this.event});

  @override
  _EventDetailsSheetState createState() => _EventDetailsSheetState();
}

class _EventDetailsSheetState extends State<EventDetailsSheet> {
  int _userRating = 0;
  String _userReview = '';

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Padding(
        padding: EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Event Details',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 20),
            Text('Name: ${widget.event.name}'),
            SizedBox(height: 10),
            Text('Date and Time: ${widget.event.dateAndTime}'),
            SizedBox(height: 10),
            Text('Location: ${widget.event.location}'),
            SizedBox(height: 20),
            Text(
              'Review Event',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 10),
            Text('Rating:'),
            _buildRatingStars(),
            SizedBox(height: 10),
            TextField(
              decoration: InputDecoration(
                labelText: 'Write your review',
                border: OutlineInputBorder(),
              ),
              onChanged: (value) {
                setState(() {
                  _userReview = value;
                });
              },
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                // Save review logic here
                Navigator.pop(context);
                // You can save the review data and update the event's review status
                // For demonstration, I'm just printing the data
                print('User Rating: $_userRating');
                print('User Review: $_userReview');
              },
              child: Text('Submit Review'),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildRatingStars() {
    return Row(
      children: List.generate(5, (index) {
        return IconButton(
          icon: Icon(
            index < _userRating ? Icons.star : Icons.star_border,
            color: Colors.yellow,
          ),
          onPressed: () {
            setState(() {
              _userRating = index + 1;
            });
          },
        );
      }),
    );
  }
}
