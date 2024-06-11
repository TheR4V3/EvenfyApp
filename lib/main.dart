import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:intl/intl.dart';
import 'package:mobpro/firebase_options.dart';
import 'package:mobpro/helper/navigators.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'edit_profile_page.dart';
import 'firestore_service.dart';
import 'home_page.dart';
import 'Login.dart';
import 'Address.dart';
import 'historyPage.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await initNotifications();
  await Firebase.initializeApp();
  runApp(MyApp());
}

Future<void> initNotifications() async {
  final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
      FlutterLocalNotificationsPlugin();
  const AndroidInitializationSettings initializationSettingsAndroid =
      AndroidInitializationSettings('@mipmap/ic_launcher');

  final InitializationSettings initializationSettings = InitializationSettings(
    android: initializationSettingsAndroid,
  );
  await flutterLocalNotificationsPlugin.initialize(initializationSettings);
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
        fontFamily: "Poppins",
      ),
      home: const DismissKeyboard(child: HomePage()),
    );
  }
}

class DismissKeyboard extends StatelessWidget {
  final Widget child;

  const DismissKeyboard({required this.child, Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        FocusScopeNode currentFocus = FocusScope.of(context);
        if (!currentFocus.hasPrimaryFocus &&
            currentFocus.focusedChild != null) {
          FocusManager.instance.primaryFocus?.unfocus();
        }
      },
      child: child,
    );
  }
}

class EventCardWithImage extends StatelessWidget {
  final Event event;
  final ImageProvider image;
  final VoidCallback onTap;

  EventCardWithImage(
      {required this.event, required this.image, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: EdgeInsets.all(10),
      child: ListTile(
        leading: Container(
          width: 50,
          height: 50,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(25),
            image: DecorationImage(
              image: image,
              fit: BoxFit.cover,
            ),
          ),
        ),
        title: Text(event.title),
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(Icons.access_time),
                SizedBox(width: 5),
                Text(event.formattedDateTime()),
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
        onTap: onTap,
      ),
    );
  }
}

class NavigationMenu extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      width: 200.0,
      decoration: BoxDecoration(
        color: Colors.red,
      ),
    );
  }
}

class ProfilePage extends StatefulWidget {
  @override
  _ProfilePageState createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  String _name = 'Juher';
  int _age = 21;
  String _job = 'UI/UX Designer';
  String _imagePath = 'profile/assets/cat.jpg';

  void _updateProfile(String name, int age, String job, String imagePath) {
    setState(() {
      _name = name;
      _age = age;
      _job = job;
      _imagePath = imagePath;
    });
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Scaffold(
        body: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Container(
                height: 200,
                decoration: BoxDecoration(
                  color: Colors.red,
                  borderRadius: BorderRadius.only(
                    bottomLeft: Radius.circular(20),
                    bottomRight: Radius.circular(20),
                  ),
                ),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    // Gambar profile
                    Container(
                      width: 120,
                      height: 120,
                      margin: EdgeInsets.only(bottom: 10),
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        border: Border.all(color: Colors.white, width: 3),
                        image: DecorationImage(
                          image: _imagePath.startsWith('profile')
                              ? AssetImage(_imagePath)
                              : FileImage(File(_imagePath)) as ImageProvider,
                          fit: BoxFit.cover,
                        ),
                      ),
                    ),
                    Text(
                      '$_name, $_age',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                        fontFamily: 'Montserat',
                      ),
                    ),
                    Text(
                      _job,
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 16,
                        fontWeight: FontWeight.normal,
                        fontFamily: 'Poppins',
                      ),
                    ),
                  ],
                ),
              ),
              SizedBox(height: 20),
              Container(
                padding: EdgeInsets.all(20),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Card 1: Edit User Profile
                    InkWell(
                      onTap: () async {
                        final updatedProfile = await Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => EditProfilePage(
                              name: _name,
                              age: _age,
                              job: _job,
                              imagePath: _imagePath,
                            ),
                          ),
                        );

                        if (updatedProfile != null) {
                          _updateProfile(
                            updatedProfile['name'],
                            updatedProfile['age'],
                            updatedProfile['job'],
                            updatedProfile['imagePath'],
                          );
                        }
                      },
                      child: Container(
                        padding: EdgeInsets.all(10),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(10),
                          border: Border.all(color: Colors.grey),
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text("Edit User Profile"),
                            Icon(Icons.edit),
                          ],
                        ),
                      ),
                    ),
                    SizedBox(height: 20),
                    InkWell(
                      onTap: () {
                        Navigator.push(context, MaterialPageRoute(builder: (context)=>HistoryPage()));
                      },
                      child: Container(
                        padding: EdgeInsets.all(10),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(10),
                          border: Border.all(color: Colors.grey),
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text("History Event"),
                            Icon(Icons.history),
                          ],
                        ),
                      ),
                    ),
                    SizedBox(height: 20),
                    ElevatedButton(
                      onPressed: () async {
                        SharedPreferences sharedPreferences =
                            await SharedPreferences.getInstance();
                        sharedPreferences.clear();
                        Navigator.pushReplacement(
                          context,
                          MaterialPageRoute(builder: (context) => LoginPage()),
                        );
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.red,
                        padding: EdgeInsets.symmetric(vertical: 15),
                        textStyle: TextStyle(fontSize: 18),
                      ),
                      child: Center(
                        child: Text(
                          'Logout',
                          style: TextStyle(
                            fontFamily: "Montserrat",
                            color: Colors.white,
                            fontSize: 16,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class HistoryPage extends StatefulWidget {
  const HistoryPage({super.key});

  @override
  // ignore: library_private_types_in_public_api
  _HistoryPageState createState() => _HistoryPageState();
}

class _HistoryPageState extends State<HistoryPage> {
  late String previousMonth;
  final List<Event> events = []; // Populate this list with your events

  @override
  void initState() {
    super.initState();
    // Initialize previousMonth with the current month
    DateTime now = DateTime.now();
    previousMonth = DateFormat('MMMM').format(now);
  }

  @override
  Widget build(BuildContext context) {
    // Get the current date
    DateTime now = DateTime.now();
    String currentMonth = DateFormat('MMMM').format(now);

    // Check if the month has changed
    if (currentMonth != previousMonth) {
      // Update previousMonth with the current month
      previousMonth = currentMonth;
    }

    // Get the formatted date for the current month
    String formattedDate = DateFormat('MMMM y').format(now);

    return Scaffold(
      appBar: AppBar(
        title: const Text('History'),
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          // Text displaying the history page
          const Text(
            'History Page',
            style: TextStyle(fontSize: 20),
          ),
          const SizedBox(height: 20), // Adding some space

          // Container displaying the current date
          Container(
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(
              color: Colors.blue, // Example color
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
          // Display event cards
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
          // Action when tapping on the card
        },
      ),
    );
  }
}

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

List<Event> events = [
  Event(
    id: '',
    title: 'Webinar flutter',
    dateAndTime: DateTime.now(),
    imageUrl: '',
    description: 'webinar flutter',
    location: 'TULT',
    price: '20.000',
    isReviewed: true,
  ),
  Event(
    id: '',
    title: 'Webinar Scrum Master',
    dateAndTime: DateTime.now(),
    imageUrl: '',
    description: 'webinar scrum master',
    location: 'GKU',
    price: '20.000',
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
        title: Text(event.title),
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(Icons.access_time),
                SizedBox(width: 5),
                Text(DateFormat('yyyy-MM-dd HH:mm').format(event.dateAndTime)),
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
        onTap: onTap,
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
            Text('Name: ${widget.event.title}'),
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
                Navigator.pop(context);
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

class EventPage extends StatelessWidget {
  final Event event;

  EventPage({required this.event});

  FirestoreService _firestoreService = FirestoreService();

  @override
  Widget build(BuildContext context) {
    String formattedDate =
        "${event.dateAndTime.day} ${_getMonthName(event.dateAndTime.month)} ${event.dateAndTime.year}";
    String formattedTime =
        "${event.dateAndTime.hour}:${event.dateAndTime.minute.toString().padLeft(2, '0')}";
    double price = double.parse(event.price);

    return Scaffold(
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Stack(
              children: [
                event.imageUrl != null && event.imageUrl!.isNotEmpty
                    ? Image.network(
                        event.imageUrl!,
                        fit: BoxFit.cover,
                        width: double.infinity,
                        height: 200,
                        errorBuilder: (context, error, stackTrace) {
                          return Container(
                            width: double.infinity,
                            height: 200,
                            color: Colors.grey[200],
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Icon(Icons.broken_image, color: Colors.grey),
                                SizedBox(height: 8),
                                Text('Failed to load image'),
                              ],
                            ),
                          );
                        },
                      )
                    : Image.asset(
                        'assets/images/presentation.jpg',
                        fit: BoxFit.cover,
                        width: double.infinity,
                        height: 200,
                      ),
                Positioned(
                  top: 10,
                  left: 10,
                  child: Container(
                    width: 28,
                    height: 35,
                    decoration: BoxDecoration(
                      color: Colors.white,
                      shape: BoxShape.circle,
                    ),
                    child: Center(
                      child: IconButton(
                        iconSize: 18,
                        icon: Icon(Icons.arrow_back_ios,
                            color: Colors.black.withOpacity(0.5)),
                        onPressed: () {
                          Navigator.pop(context);
                        },
                      ),
                    ),
                  ),
                ),
              ],
            ),
            Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(20.0),
                  topRight: Radius.circular(20.0),
                ),
                color: Colors.white,
                boxShadow: [
                  BoxShadow(
                    color: Colors.grey.withOpacity(0.5),
                    spreadRadius: 5,
                    blurRadius: 7,
                    offset: Offset(0, 3),
                  ),
                ],
              ),
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      event.title,
                      style: TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                        fontFamily: "Poppins",
                      ),
                    ),
                    SizedBox(height: 10),
                    Row(
                      children: [
                        Icon(Icons.location_on, color: Colors.grey),
                        SizedBox(width: 5),
                        Text(event.location),
                        SizedBox(width: 20),
                        Icon(Icons.calendar_today, color: Colors.grey),
                        SizedBox(width: 5),
                        Text(formattedDate),
                        SizedBox(width: 20),
                        Icon(Icons.access_time, color: Colors.grey),
                        SizedBox(width: 5),
                        Text(formattedTime),
                      ],
                    ),
                    SizedBox(height: 20),
                    GestureDetector(
                      onTap: () {
                        Navigators.push(context, AddressPage());
                      },
                      child: Container(
                        padding: EdgeInsets.all(10),
                        decoration: BoxDecoration(
                          border: Border.all(color: Colors.grey),
                          borderRadius: BorderRadius.circular(5),
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Row(
                              children: [
                                Icon(Icons.map, color: Colors.grey),
                                SizedBox(width: 10),
                                Text(
                                  'See Location on maps',
                                  style: TextStyle(
                                    fontSize: 18,
                                    fontWeight: FontWeight.bold,
                                    fontFamily: "Poppins",
                                    decoration: TextDecoration.underline,
                                  ),
                                ),
                              ],
                            ),
                            ClipRRect(
                              borderRadius: BorderRadius.circular(5),
                              child: Image.asset(
                                'assets/images/alamat.png',
                                width: 60,
                                height: 60,
                                fit: BoxFit.cover,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                    SizedBox(height: 20),
                    Text(
                      'About Event',
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                        fontFamily: "Poppins",
                      ),
                    ),
                    SizedBox(height: 10),
                    Text(
                      event.description,
                      style: TextStyle(fontSize: 16, fontFamily: "Poppins"),
                    ),
                    SizedBox(height: 20),
                    GestureDetector(
                      onTap: () {},
                      child: Container(
                        padding: EdgeInsets.all(10),
                        decoration: BoxDecoration(
                          border: Border.all(color: Colors.grey),
                          borderRadius: BorderRadius.circular(5),
                        ),
                        child: Row(
                          children: [
                            Image.asset(
                              'assets/images/Gopay_logo.svg.png',
                              height: 17.5,
                            ),
                            Expanded(child: SizedBox(width: 80)),
                            Expanded(
                              flex: 1,
                              child: Align(
                                alignment: Alignment.centerRight,
                                child: Icon(Icons.more_horiz_rounded),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                    SizedBox(height: 20),
                    ElevatedButton(
                      onPressed: () async {
                        await _firestoreService.addUserEvent(event.id);
                        showDialog(
                          context: context,
                          builder: (BuildContext context) {
                            return AlertDialog(
                              title: Text('Registration Success'),
                              content: Text(
                                  'You have successfully registered for this event.'),
                              actions: [
                                TextButton(
                                  onPressed: () {
                                    Navigator.pop(context);
                                  },
                                  child: Text('OK'),
                                ),
                              ],
                            );
                          },
                        );
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.red,
                        padding: EdgeInsets.symmetric(vertical: 15),
                        textStyle: TextStyle(fontSize: 18),
                      ),
                      child: Center(
                        child: Text(
                          'Register - Rp ${NumberFormat('#,###').format(price)}',
                          style: TextStyle(
                              fontFamily: "Montserrat",
                              color: Colors.white,
                              fontSize: 16,
                              fontWeight: FontWeight.w600),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  String _getMonthName(int month) {
    const List<String> monthNames = [
      'January',
      'February',
      'March',
      'April',
      'May',
      'June',
      'July',
      'August',
      'September',
      'October',
      'November',
      'December'
    ];
    return monthNames[month - 1];
  }
}
