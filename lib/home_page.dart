import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:mobpro/helper/extensions.dart';
import 'package:mobpro/helper/navigators.dart';

import 'calendar_page.dart';
import 'firestore_service.dart';
import 'main.dart';
import 'upload_page.dart';
import 'Address.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final TextEditingController _searchController = TextEditingController();
  final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
      FlutterLocalNotificationsPlugin();

  FirestoreService _firestoreService = FirestoreService();

  List<Event> eventsList = [];
  List<Event> filteredList = [];

  @override
  void initState() {
    super.initState();
    getData();
    scheduleNotification();
  }

  Future<void> scheduleNotification() async {
    print("scheduled");
    const AndroidNotificationDetails androidPlatformChannelSpecifics =
        AndroidNotificationDetails(
      'your_channel_id',
      'your_channel_name',
      importance: Importance.max,
      priority: Priority.high,
    );
    const NotificationDetails platformChannelSpecifics =
        NotificationDetails(android: androidPlatformChannelSpecifics);

    var ids = await _firestoreService.getUserEvents();
    List<Event> events = await _firestoreService.getEventsByIds(ids);

    final DateTime now = DateTime.now();

    for (var event in events) {
      await flutterLocalNotificationsPlugin.show(
        0, 
        'Event Reminder',
        event.title + " pada tanggal ${event.dateAndTime.day} yaa",
        platformChannelSpecifics,
      );
    }
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  List<Event> filteredEvents() {
    return eventsList.where((element) {
      String pattern =
          "${element.title}${element.description}${element.location}";
      return pattern
          .toLowerCase()
          .contains(_searchController.text.toLowerCase());
    }).toList();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Column(
          children: [
            Card(
              color: const Color(0xFFB70000).withOpacity(0.8),
              shape: const RoundedRectangleBorder(
                  borderRadius:
                      BorderRadius.vertical(bottom: Radius.circular(20))),
              margin: EdgeInsets.zero,
              child: SafeArea(
                child: Padding(
                  padding: const EdgeInsets.all(20),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          const Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                "Welcome back,",
                                style: TextStyle(
                                    fontSize: 24,
                                    fontWeight: FontWeight.w500,
                                    color: Color(0xFF4A4848),
                                    fontFamily: "Montserrat"),
                              ),
                              Text(
                                "Admin",
                                style: TextStyle(
                                    fontSize: 24,
                                    fontWeight: FontWeight.w500,
                                    color: Colors.white,
                                    fontFamily: "Montserrat"),
                              ),
                            ],
                          ),
                          GestureDetector(
                            onTap: () {
                              Navigators.push(context, ProfilePage());
                            },
                            child: SizedBox.square(
                              dimension: 50,
                              child: ClipOval(
                                child: Image.asset(
                                  "assets/images/cat.jpg",
                                  fit: BoxFit.cover,
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 30),
                      TextField(
                        controller: _searchController,
                        onChanged: (value) {
                          setState(() {});
                        },
                        decoration: InputDecoration(
                            filled: true,
                            fillColor: Colors.white,
                            isDense: true,
                            border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(20),
                                borderSide: BorderSide.none),
                            prefixIcon: const Icon(Icons.search),
                            hintText: "Cari Event di Sekitarmu..."),
                      )
                    ],
                  ),
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Column(
                children: [
                  const SizedBox(height: 20),
                  ListTile(
                    contentPadding: EdgeInsets.zero,
                    minVerticalPadding: 0,
                    dense: true,
                    title: Row(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Expanded(
                            flex: 3,
                            child: Text(
                              "Trending",
                              textAlign: TextAlign.left,
                              style: TextStyle(
                                fontSize: 24,
                                fontWeight: FontWeight.w500,
                              ),
                            )),
                        const SizedBox(width: 10),
                      ],
                    ),
                    subtitle: ListView.separated(
                      padding: const EdgeInsets.only(top: 20),
                      shrinkWrap: true,
                      physics: const NeverScrollableScrollPhysics(),
                      itemCount: filteredEvents().length,
                      itemBuilder: (context, index) {
                        Event event = filteredEvents()[index];

                        return GestureDetector(
                          onTap: () {
                            Navigators.push(context, EventPage(event: event));
                          },
                          child: SizedBox(
                            height: MediaQuery.of(context).size.height * 0.25,
                            width: MediaQuery.of(context).size.width,
                            child: Stack(
                              alignment: Alignment.bottomCenter,
                              children: [
                                SizedBox(
                                  width: MediaQuery.of(context).size.width,
                                  child: ClipRRect(
                                    borderRadius: BorderRadius.circular(10),
                                    child: event.imageUrl != null &&
                                            event.imageUrl != ""
                                        ? Image.network(
                                            event.imageUrl!,
                                            fit: BoxFit.cover,
                                            errorBuilder:
                                                (context, error, stackTrace) {
                                              return Column(
                                                children: [
                                                  Icon(Icons.broken_image),
                                                  Text(error.toString())
                                                ],
                                              );
                                            },
                                          )
                                        : Image.asset(
                                            "assets/images/presentation.jpg",
                                            fit: BoxFit.cover,
                                          ),
                                  ),
                                ),
                                Container(
                                  margin: const EdgeInsets.only(
                                    bottom: 15,
                                    left: 10,
                                    right: 10,
                                  ),
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 20, vertical: 10),
                                  decoration: BoxDecoration(
                                      color: Colors.white,
                                      borderRadius: BorderRadius.circular(10)),
                                  child: Column(
                                    mainAxisSize: MainAxisSize.min,
                                    children: [
                                      Row(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.center,
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceBetween,
                                        children: [
                                          Expanded(
                                            child: Text(
                                              event.title,
                                              textAlign: TextAlign.left,
                                              style: TextStyle(
                                                  fontSize: 18,
                                                  fontWeight: FontWeight.w600,
                                                  color: Colors.black),
                                            ),
                                          ),
                                          SizedBox(width: 10),
                                          Expanded(
                                            child: Text(
                                              "Rp. ${num.parse(event.price).currency()}",
                                              textAlign: TextAlign.right,
                                              style: TextStyle(
                                                  fontSize: 12,
                                                  fontWeight: FontWeight.w600,
                                                  color: Colors.red),
                                            ),
                                          ),
                                        ],
                                      ),
                                      Row(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.center,
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceBetween,
                                        children: [
                                          Expanded(
                                            child: Text(
                                              event.location,
                                              textAlign: TextAlign.left,
                                              style: TextStyle(
                                                  fontSize: 12,
                                                  fontWeight: FontWeight.w500),
                                            ),
                                          ),
                                          SizedBox(width: 10),
                                          Expanded(
                                            child: Text(
                                              event.formattedDateTime(),
                                              textAlign: TextAlign.right,
                                              style: TextStyle(
                                                  fontSize: 10,
                                                  fontWeight: FontWeight.w500),
                                            ),
                                          ),
                                        ],
                                      ),
                                    ],
                                  ),
                                )
                              ],
                            ),
                          ),
                        );
                      },
                      separatorBuilder: (context, index) =>
                          const SizedBox(height: 20),
                    ),
                  ),
                  const SizedBox(height: 30),
                  ListTile(
                    contentPadding: EdgeInsets.zero,
                    minVerticalPadding: 0,
                    dense: true,
                    title: Row(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Expanded(
                            flex: 3,
                            child: Text(
                              "Events",
                              textAlign: TextAlign.left,
                              style: TextStyle(
                                fontSize: 24,
                                fontWeight: FontWeight.w500,
                              ),
                            )),
                        const SizedBox(width: 10),
                        SingleChildScrollView(
                          scrollDirection: Axis.horizontal,
                          child: SizedBox(
                            width: 220,
                            child: Row(
                              children: List.generate(
                                10, 
                                (index) => Expanded(
                                  child: TextButton(
                                    onPressed: () {
                                      getData(pageNumber: (index + 1));
                                    },
                                    child: Text(
                                      "${index + 1}", 
                                      textAlign: TextAlign.center,
                                      style: TextStyle(
                                        fontSize: 12,
                                        fontWeight: FontWeight.w500,
                                        color: Colors.red,
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          ),
                        )
                      ],
                    ),
                    subtitle: GridView.builder(
                      padding: const EdgeInsets.symmetric(vertical: 5),
                      gridDelegate:
                          const SliverGridDelegateWithFixedCrossAxisCount(
                              crossAxisCount: 2,
                              childAspectRatio: 0.575,
                              crossAxisSpacing: 15,
                              mainAxisSpacing: 15),
                      shrinkWrap: true,
                      physics: const NeverScrollableScrollPhysics(),
                      itemCount: filteredEvents().length,
                      itemBuilder: (context, index) {
                        Event event = filteredEvents()[index];
                        return GestureDetector(
                          onTap: () {
                            Navigators.push(context, EventPage(event: event));
                          },
                          child: Card(
                            margin: EdgeInsets.zero,
                            surfaceTintColor: Colors.white,
                            elevation: 5,
                            child: Padding(
                              padding: const EdgeInsets.all(10),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Container(
                                    height: 200,
                                    child: ClipRRect(
                                      borderRadius: BorderRadius.circular(5),
                                      child: event.imageUrl != null &&
                                              event.imageUrl != ""
                                          ? Image.network(
                                              event.imageUrl!,
                                              fit: BoxFit.cover,
                                              errorBuilder:
                                                  (context, error, stackTrace) {
                                                return Column(
                                                  children: [
                                                    Icon(Icons.broken_image),
                                                    Text(error.toString())
                                                  ],
                                                );
                                              },
                                            )
                                          : Image.asset(
                                              "assets/images/presentation.jpg",
                                              fit: BoxFit.cover,
                                            ),
                                    ),
                                  ),
                                  SizedBox(height: 10),
                                  Text(
                                    maxLines: 1,
                                    overflow: TextOverflow.ellipsis,
                                    event.title,
                                    style: TextStyle(
                                        fontSize: 12,
                                        fontWeight: FontWeight.w500,
                                        color: Colors.black),
                                  ),
                                  SizedBox(height: 5),
                                  Expanded(
                                    child: RichText(
                                      overflow: TextOverflow.ellipsis,
                                      maxLines: 1,
                                      text: TextSpan(
                                        style: TextStyle(
                                          fontSize: 8,
                                          fontWeight: FontWeight.w500,
                                          color: const Color(0xFF747474),
                                        ),
                                        children: [
                                          TextSpan(
                                              text: event.formattedDateTime()),
                                          TextSpan(text: " • "),
                                          TextSpan(text: event.location),
                                        ],
                                      ),
                                    ),
                                  ),
                                  SizedBox(height: 10),
                                  Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        mainAxisAlignment:
                                            MainAxisAlignment.end,
                                        children: [
                                          Text(
                                            "Start From:",
                                            style: TextStyle(
                                                fontSize: 8,
                                                fontWeight: FontWeight.w500,
                                                color: Color(0xFF747474)),
                                          ),
                                          SizedBox(height: 5),
                                          Text(
                                            "Rp.${num.parse(event.price).currency()}",
                                            style: TextStyle(
                                                fontSize: 12,
                                                fontWeight: FontWeight.w600,
                                                color: Colors.red),
                                          ),
                                          SizedBox(height: 10),
                                        ],
                                      ),
                                      SizedBox(
                                        height: 30,
                                        child: ElevatedButton(
                                          onPressed: () {},
                                          style: ElevatedButton.styleFrom(
                                              padding:
                                                  const EdgeInsets.symmetric(
                                                      horizontal: 15),
                                              backgroundColor:
                                                  const Color(0xFFB70000)
                                                      .withOpacity(0.8),
                                              foregroundColor: Colors.white),
                                          child: Text(
                                            "Register",
                                            style: TextStyle(
                                                fontSize: 10,
                                                fontWeight: FontWeight.w600,
                                                fontFamily: "Montserrat"),
                                          ),
                                        ),
                                      )
                                    ],
                                  )
                                ],
                              ),
                            ),
                          ),
                        );
                      },
                    ),
                  ),
                ],
              ),
            )
          ],
        ),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      floatingActionButton: Container(
        width: 40,
        height: 40,
        decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(10),
            gradient: const LinearGradient(
              colors: [Color(0xFFB70000), Color(0xFFFF6B00)],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            )),
        child: FloatingActionButton.extended(
          onPressed: () async {
            await Navigators.push(context, UploadPage());

            getData();
          },
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10),
          ),
          backgroundColor: Colors.transparent,
          foregroundColor: Colors.white,
          elevation: 0,
          label: const Icon(Icons.add),
        ),
      ),
      bottomNavigationBar: BottomAppBar(
          shape: const CircularNotchedRectangle(),
          padding: EdgeInsets.zero,
          surfaceTintColor: const Color(0xFFF6F6F6),
          color: const Color(0xFFF6F6F6),
          notchMargin: 0,
          height: kBottomNavigationBarHeight,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            mainAxisSize: MainAxisSize.max,
            children: <Widget>[
              Expanded(
                child:
                    IconButton(onPressed: () {}, icon: const Icon(Icons.home)),
              ),
              Expanded(
                child: IconButton(
                    onPressed: () {
                      Navigators.push(context, const CalendarPage());
                    },
                    icon: const Icon(Icons.calendar_month)),
              ),
              const Expanded(child: SizedBox()),
              Expanded(
                child: IconButton(
                    onPressed: () {
                      Navigators.push(context, ReviewPage());
                    },
                    icon: const Icon(Icons.star)),
              ),
              Expanded(
                child: IconButton(
                    onPressed: () {
                      Navigators.push(context, AddressPage());
                    },
                    icon: const Icon(Icons.map)),
              ),
            ],
          )),
    );
  }

  Future<void> getData({int pageNumber = 0, int pageSize = 10}) async {
    eventsList.clear();
    List<Event> data = await FirestoreService()
        .getEventsPaginated(pageNumber: pageNumber, pageSize: pageSize);
    print(data);
    setState(() {
      eventsList = data;
    });
  }
}
