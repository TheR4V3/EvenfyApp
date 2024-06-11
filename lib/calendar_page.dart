import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:mobpro/firestore_service.dart';
import 'package:mobpro/helper/extensions.dart';
import 'package:mobpro/helper/navigators.dart';
import 'package:table_calendar/table_calendar.dart';
import 'main.dart';

class CalendarPage extends StatefulWidget {
  const CalendarPage({super.key});

  @override
  State<CalendarPage> createState() => _CalendarPageState();
}

class _CalendarPageState extends State<CalendarPage> {
  DateTime _selectedDay = DateTime.now();
  DateTime _focusedDay = DateTime.now();

  final FirestoreService _firestoreService = FirestoreService();

  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

  Future<List<Event>> fetch() async {
    var listEventIds = await _firestoreService.getUserEvents();
    return await _firestoreService.getEventsByIds(listEventIds);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFEEEEEE),
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        leading: IconButton(
            onPressed: () {
              Navigators.pop(context);
            },
            icon: const Icon(Icons.chevron_left)),
        title: const Text("Calender"),
        titleSpacing: 0,
      ),
      body: FutureBuilder(
        future: fetch(),
        builder: (context, snapshot) => snapshot.connectionState ==
                ConnectionState.waiting
            ? CircularProgressIndicator()
            : Column(children: [
                Container(
                  width: MediaQuery.of(context).size.width,
                  height: MediaQuery.of(context).size.height * 0.5,
                  margin: const EdgeInsets.all(20),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(10),
                    child: calendar(snapshot.data!),
                  ),
                ),
                Expanded(
                  child: SizedBox(
                    width: MediaQuery.of(context).size.width,
                    child: Card(
                      margin: EdgeInsets.zero,
                      color: Colors.white,
                      elevation: 0,
                      shape: const RoundedRectangleBorder(
                          borderRadius:
                              BorderRadius.vertical(top: Radius.circular(10))),
                      child: SingleChildScrollView(
                        child: ListTile(
                          contentPadding: const EdgeInsets.symmetric(
                              horizontal: 20, vertical: 20),
                          minVerticalPadding: 0,
                          dense: true,
                          title: Row(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              const Expanded(
                                  child: Text(
                                "Your Event",
                                textAlign: TextAlign.left,
                                style: TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.w600,
                                ),
                              )),
                              const SizedBox(width: 10),
                              Expanded(
                                  child: Text(
                                DateFormat("MMMM yyyy").format(DateTime.now()),
                                textAlign: TextAlign.right,
                                style: TextStyle(
                                  fontSize: 12,
                                  fontWeight: FontWeight.w600,
                                ),
                              )),
                            ],
                          ),
                          subtitle: ListView.separated(
                            padding: const EdgeInsets.only(top: 20),
                            shrinkWrap: true,
                            physics: const NeverScrollableScrollPhysics(),
                            itemCount: snapshot.data!.length,
                            itemBuilder: (context, index) {
                              var eventEntry = snapshot.data![index];
                              var date = eventEntry.dateAndTime;

                              return Card(
                                  margin: EdgeInsets.zero,
                                  color: Colors.white,
                                  elevation: 0,
                                  shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(10),
                                      side: BorderSide(
                                          color: Color(0xFFD9D9D9), width: 1)),
                                  child: InkWell(
                                    onTap: () {
                                      Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                          builder: (context) =>
                                              EventPage(event: eventEntry),
                                        ),
                                      );
                                    },
                                    borderRadius: BorderRadius.circular(10),
                                    child: Padding(
                                      padding: const EdgeInsets.all(10),
                                      child: Row(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.center,
                                        children: [
                                          Container(
                                            width: 40,
                                            height: 40,
                                            decoration: BoxDecoration(
                                                color: Colors.red,
                                                borderRadius:
                                                    BorderRadius.circular(10)),
                                            child: Center(
                                                child: Text(
                                              DateFormat("dd").format(date),
                                              style: TextStyle(
                                                  fontWeight: FontWeight.w600,
                                                  fontSize: 10,
                                                  color: Colors.white),
                                            )),
                                          ),
                                          SizedBox(width: 10),
                                          Expanded(
                                            child: Column(
                                              mainAxisAlignment:
                                                  MainAxisAlignment.center,
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.start,
                                              children: [
                                                Column(
                                                  crossAxisAlignment:
                                                      CrossAxisAlignment.start,
                                                  children: [
                                                    Row(
                                                      crossAxisAlignment:
                                                          CrossAxisAlignment
                                                              .center,
                                                      mainAxisAlignment:
                                                          MainAxisAlignment
                                                              .spaceBetween,
                                                      children: [
                                                        Expanded(
                                                            child: Text(
                                                          eventEntry.title,
                                                          textAlign:
                                                              TextAlign.left,
                                                          style: TextStyle(
                                                            fontSize: 14,
                                                            fontWeight:
                                                                FontWeight.w600,
                                                          ),
                                                        )),
                                                        const SizedBox(
                                                            width: 10),
                                                        Expanded(
                                                            child: Text(
                                                          "${eventEntry.dateAndTime.difference(DateTime.now()).inDays.toString()} days left",
                                                          textAlign:
                                                              TextAlign.right,
                                                          style: TextStyle(
                                                              fontSize: 8,
                                                              fontWeight:
                                                                  FontWeight
                                                                      .w500,
                                                              color: Color(
                                                                  0xFF4A4848)),
                                                        )),
                                                      ],
                                                    ),
                                                    Row(
                                                      crossAxisAlignment:
                                                          CrossAxisAlignment
                                                              .center,
                                                      mainAxisAlignment:
                                                          MainAxisAlignment
                                                              .spaceBetween,
                                                      children: [
                                                        Expanded(
                                                            child: Text(
                                                          eventEntry
                                                              .description,
                                                          textAlign:
                                                              TextAlign.left,
                                                          style: TextStyle(
                                                              fontSize: 10,
                                                              fontWeight:
                                                                  FontWeight
                                                                      .w600,
                                                              color: Color(
                                                                  0xFF4A4848)),
                                                        )),
                                                        const SizedBox(
                                                            width: 10),
                                                        Expanded(
                                                            child: Text(
                                                          "${DateFormat("HH.mm").format(eventEntry.dateAndTime)}-${DateFormat("HH.mm").format(eventEntry.dateAndTime)}",
                                                          textAlign:
                                                              TextAlign.right,
                                                          style: TextStyle(
                                                              fontSize: 10,
                                                              fontWeight:
                                                                  FontWeight
                                                                      .w600,
                                                              color: Color(
                                                                  0xFF4A4848)),
                                                        )),
                                                      ],
                                                    )
                                                  ],
                                                )
                                              ],
                                            ),
                                          )
                                        ],
                                      ),
                                    ),
                                  ));
                            },
                            separatorBuilder: (context, index) =>
                                const SizedBox(height: 20),
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
              ]),
      ),
    );
  }

  Widget defaultWidgetCalendar(DateTime day, double fontSize) {
    return Center(
      child: Text(
        DateFormat("dd").format(day).toString(),
        style: TextStyle(
            fontWeight: FontWeight.w600,
            fontSize: fontSize,
            color: Color(0xFF696969)),
      ),
    );
  }

  Widget _buildEventsMarker(DateTime date, List events) {
    return Container(
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        color: Colors.red,
      ),
      width: 16.0,
      height: 16.0,
      child: Center(
        child: Text(
          '${events.length}',
          style: TextStyle().copyWith(
            color: Colors.white,
            fontSize: 12.0,
          ),
        ),
      ),
    );
  }

  Map<DateTime, List<String>> _createEventsMap(List<Event> events) {
    Map<DateTime, List<String>> eventsMap = {};

    for (var event in events) {
      final date = DateTime.utc(event.dateAndTime.year, event.dateAndTime.month,
          event.dateAndTime.day);

      if (eventsMap.containsKey(date)) {
        eventsMap[date]!.add(event.title);
      } else {
        eventsMap[date] = [event.title];
      }
    }

    return eventsMap;
  }

  TableCalendar<dynamic> calendar(List<Event> events) {
    double fontSize = 10;
    Map<DateTime, List<String>> _events = _createEventsMap(events);

    return TableCalendar(
      firstDay: DateTime.utc(2010, 10, 16),
      lastDay: DateTime.utc(2030, 3, 14),
      focusedDay: DateTime.now(),
      calendarFormat: CalendarFormat.month,
      calendarBuilders: CalendarBuilders(
        dowBuilder: (context, day) {
          return Center(
            child: Text(
              DateFormat("EEE").format(day).toString().toUpperCase(),
              textAlign: TextAlign.center,
              style: TextStyle(
                  fontSize: fontSize,
                  fontWeight: FontWeight.w600,
                  color: Color(0xFF696969)),
            ),
          );
        },
        todayBuilder: (context, day, focusedDay) {
          return Stack(
            alignment: Alignment.bottomCenter,
            children: [
              defaultWidgetCalendar(day, fontSize),
              Icon(
                Icons.circle,
                size: 10,
                color: Colors.green,
              )
            ],
          );
        },
        defaultBuilder: (context, day, focusedDay) {
          return defaultWidgetCalendar(day, fontSize);
        },
        outsideBuilder: (context, day, focusedDay) {
          return Center(
              child: Text(
            DateFormat("dd").format(day).toString(),
            style: TextStyle(
                fontWeight: FontWeight.w600,
                fontSize: fontSize,
                color: Color(0xFFDCDCDC)),
          ));
        },
        markerBuilder: (context, date, events) {
          if (events.isNotEmpty) {
            return Positioned(
              right: 1,
              bottom: 1,
              child: _buildEventsMarker(date, events),
            );
          }
          return Container();
        },
      ),
      headerStyle: HeaderStyle(
          decoration: BoxDecoration(
              color: const Color(0xFFB70000).withOpacity(0.8),
              borderRadius: BorderRadius.circular(10)),
          headerPadding: const EdgeInsets.symmetric(vertical: 15),
          formatButtonShowsNext: false,
          formatButtonVisible: false,
          leftChevronVisible: false,
          rightChevronVisible: false,
          titleCentered: true,
          titleTextStyle: const TextStyle(
              fontWeight: FontWeight.w600, fontSize: 16, color: Colors.white)),
      calendarStyle: const CalendarStyle(
          markersMaxCount: 1,
          markerDecoration: BoxDecoration(
            color: Colors.red,
          ),
          selectedTextStyle: TextStyle(
            fontWeight: FontWeight.w600,
            fontSize: 12,
            color: Colors.white,
          )),
      daysOfWeekHeight: 50,
      selectedDayPredicate: (day) {
        return isSameDay(_selectedDay, day);
      },
      onDaySelected: (selectedDay, focusedDay) {
        return setState(() {
          _selectedDay = selectedDay;
          _focusedDay = focusedDay;
        });
      },
      eventLoader: (day) {
        return _events[day] ?? [];
      },
    );
  }
}

class EventModel {
  final String title;
  final String description;
  final DateTime startDate;
  final DateTime endDate;

  EventModel(
      {required this.title,
      required this.description,
      required this.startDate,
      required this.endDate});
}
