import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:intl/intl.dart';
import 'package:mobpro/storage_service.dart';
import 'package:shared_preferences/shared_preferences.dart';

class FirestoreService {
  final CollectionReference events =
      FirebaseFirestore.instance.collection('/events');
  final FirebaseFirestore _db = FirebaseFirestore.instance;

  Future<void> addEvent({
    required String title,
    required String description,
    required DateTime dateAndTime,
    File? images,
    required String location,
    required String price,
    required bool isReviewed,
  }) async {
    try {
      String imageUrl = "";

      if (images != null) {
        imageUrl = await StorageService()
            .uploadImageEvents(photo: images, title: title);
      }

      await events.add({
        'title': title,
        'description': description,
        'dateAndTime': Timestamp.fromDate(dateAndTime),
        'imageUrl': imageUrl,
        'location': location,
        'price': price,
        'isReviewed': false,
      });
    } catch (e) {
      throw 'Error adding event: $e';
    }
  }

  Future<List<Event>> getEvents() async {
    try {
      QuerySnapshot querySnapshot = await events
          .orderBy('dateAndTime')
          .startAfter([Timestamp.fromDate(DateTime.now())]).get();
      List<Event> eventsList =
          querySnapshot.docs.map((doc) => Event.fromSnapshot(doc)).toList();
      return eventsList;
    } catch (e) {
      throw 'Error fetching events: $e';
    }
  }

  Future<List<Event>> getEventsPaginated({
    required int pageNumber,
    required int pageSize,
  }) async {
    try {
      // Hitung jumlah dokumen yang akan dilewati
      int documentsToSkip = (pageNumber - 1) * pageSize;

      // Buat query untuk mendapatkan dokumen dengan paging
      Query query = events.orderBy('dateAndTime').startAfter([
        Timestamp.fromDate(DateTime.now())
      ]).limit(pageSize +
          1); // Ambil dokumen satu lebih banyak untuk menentukan apakah ada halaman berikutnya

      if (documentsToSkip > 0) {
        QuerySnapshot snapshot = await query.get();
        DocumentSnapshot lastDocument = snapshot.docs.last;
        query = query.startAfterDocument(lastDocument);
      }

      // Eksekusi query
      QuerySnapshot querySnapshot = await query.get();

      // Ekstrak data dari dokumen
      List<Event> eventsList =
          querySnapshot.docs.map((doc) => Event.fromSnapshot(doc)).toList();

      // Periksa apakah ada halaman berikutnya
      bool hasNextPage = eventsList.length > pageSize;
      if (hasNextPage) {
        eventsList
            .removeLast(); // Hapus dokumen tambahan jika ada halaman berikutnya
      }

      return eventsList;
    } catch (e) {
      throw 'Error fetching paginated events: $e';
    }
  }

  Future<void> updateEvent(
    String eventId, {
    String? title,
    String? description,
    File? images,
    String? location,
    String? price,
  }) async {
    try {
      String? imageUrl;

      if (images != null) {
        imageUrl = await StorageService()
            .uploadImageEvents(photo: images, title: title ?? "update");
      }

      await events.doc(eventId).update({
        if (title != null) 'title': title,
        if (description != null) 'description': description,
        if (imageUrl != null) 'imageUrl': imageUrl,
        if (location != null) 'location': location,
        if (price != null) 'price': price,
      });
    } catch (e) {
      throw 'Error updating event: $e';
    }
  }

  Future<void> deleteEvent(Event event) async {
    try {
      await events.doc(event.id).delete();
    } catch (e) {
      throw 'Error deleting event: $e';
    }
  }

  Future<void> addUser({
    required String fullname,
    required String email,
    required String date,
    required String username,
    required String password,
  }) async {
    await _db.collection('users').add({
      'fullname': fullname,
      'email': email,
      'date': date,
      'username': username,
      'password': password,
    });
  }

  // Fetch user by username and password
  Future<QuerySnapshot> getUserByUsernameAndPassword(
      String username, String password) {
    return _db
        .collection('users')
        .where('username', isEqualTo: username)
        .where('password', isEqualTo: password)
        .get();
  }

  Future<void> addUserEvent(String eventId) async {
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    String? userId = await sharedPreferences.getString('docIds');
    print(userId);
    try {
      await _db.collection('user_event').add({
        'event_id': eventId,
        'user_id': userId,
      });
    } catch (e) {
      throw 'Error adding user event: $e';
    }
  }

  Future<List<Event>> getEventsByIds(List<String> eventIds) async {
    try {
      List<Event> events = [];

      for (String eventId in eventIds) {
        DocumentSnapshot eventSnapshot =
            await _db.collection('events').doc(eventId).get();

        if (eventSnapshot.exists) {
          events.add(Event.fromSnapshot(eventSnapshot));
        }
      }

      return events;
    } catch (e) {
      throw 'Error fetching events by IDs: $e';
    }
  }

  Future<List<String>> getUserEvents() async {
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    String? userId = await sharedPreferences.getString('docIds');
    try {
      QuerySnapshot querySnapshot = await _db
          .collection('user_event')
          .where('user_id', isEqualTo: userId)
          .get();

      List<String> eventIds =
          querySnapshot.docs.map((doc) => doc['event_id'] as String).toList();
      return eventIds;
    } catch (e) {
      throw 'Error fetching user events: $e';
    }
  }
}

class Event {
  final String id;
  final String title;
  final String description;
  String? imageUrl;
  final DateTime dateAndTime;
  final String location;
  final String price;
  final bool isReviewed;

  Event({
    required this.id,
    required this.title,
    required this.description,
    this.imageUrl,
    required this.dateAndTime,
    required this.location,
    required this.price,
    required this.isReviewed,
  });

  String formattedDateTime() {
    return DateFormat('yyyy-MM-dd HH:mm').format(dateAndTime);
  }

  factory Event.fromSnapshot(DocumentSnapshot snapshot) {
    Map<String, dynamic> data = snapshot.data() as Map<String, dynamic>;
    return Event(
        id: snapshot.id,
        title: data['title'],
        description: data['description'],
        imageUrl: data['imageUrl'] ?? "",
        dateAndTime: (data['dateAndTime'] as Timestamp).toDate(),
        location: data['location'],
        price: data['price'],
        isReviewed: data['isReviewed']);
  }
}
