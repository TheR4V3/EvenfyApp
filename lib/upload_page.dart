import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_multi_formatter/flutter_multi_formatter.dart';
import 'package:mobpro/Address.dart';
import 'package:mobpro/helper/dialogs.dart';
import 'package:mobpro/helper/generals.dart';
import 'package:mobpro/helper/navigators.dart';
import 'main.dart';
import 'home_page.dart';
import 'calendar_page.dart';
import 'firestore_service.dart';

class UploadPage extends StatefulWidget {
  @override
  _UploadPageState createState() => _UploadPageState();
}

class _UploadPageState extends State<UploadPage> {
  final FirestoreService _firestoreService = FirestoreService();
  late ScrollController _scrollController;
  late List<Event> _events;
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    _scrollController = ScrollController();
    _events = [];
    _loadEvents();
    _scrollController.addListener(_scrollListener);
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  void _loadEvents() async {
    setState(() {
      _isLoading = true;
    });
    final List<Event>? events = await _firestoreService.getEvents();
    if (events != null) {
      setState(() {
        _events.addAll(events);
        _isLoading = false;
      });
    } else {
      
    }
  }

  void _scrollListener() {
    if (!_isLoading &&
        _scrollController.position.pixels ==
            _scrollController.position.maxScrollExtent) {
      _loadEvents();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Your Uploaded Events'),
      ),
      body: _buildEventList(),
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          await Navigators.push(context, AddUploadEvent());
          setState(() {
          });
        },
        backgroundColor: Colors.red,
        child: Icon(Icons.add, color: Colors.white),
      ),
      bottomNavigationBar: BottomAppBar(
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            IconButton(
              onPressed: () {
                Navigators.pop(context);
              },
              icon: Icon(Icons.home),
            ),
            IconButton(
              onPressed: () {
                Navigators.push(context, CalendarPage());
              },
              icon: Icon(Icons.calendar_month),
            ),
            IconButton(
              onPressed: () {
                Navigators.push(context, AddressPage());
              },
              icon: Icon(Icons.map_outlined),
            ),
            IconButton(
              onPressed: () {
                Navigators.push(context, ReviewPage());
              },
              icon: Icon(Icons.star),
            ),
          ],
        ),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
    );
  }

  Widget _buildEventList() {
    return ListView.builder(
      itemCount: _events.length + 1,
      itemBuilder: (context, index) {
        if (index == _events.length) {
          return _buildLoader();
        } else {
          final event = _events[index];
          if (event.title == 'placeholder') {
            return SizedBox.shrink();
          }
          return ListTile(
            title: Text(event.title),
            subtitle: Text(event.formattedDateTime()),
            trailing: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                IconButton(
                  icon: Icon(Icons.edit),
                  onPressed: () async {
                    await Navigators.push(context, EditEventPage(event));
                    setState(() {
                    });
                  },
                ),
                IconButton(
                  icon: Icon(Icons.delete),
                  onPressed: () {
                    _showDeleteConfirmationDialog(event);
                  },
                ),
              ],
            ),
            onTap: () {
            },
          );
        }
      },
      controller: _scrollController,
    );
  }

  Widget _buildLoader() {
    return _isLoading
        ? Center(child: CircularProgressIndicator())
        : Container();
  }

  void _showDeleteConfirmationDialog(Event event) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text("Confirm Delete"),
          content: Text("Are you sure you want to delete this event?"),
          actions: <Widget>[
            TextButton(
              onPressed: () => Navigators.pop(context),
              child: Text("Cancel"),
            ),
            TextButton(
              onPressed: () {
                _deleteEvent(event);
                setState(() {});
                Navigators.pop(context);
              },
              child: Text("Delete"),
            ),
          ],
        );
      },
    );
  }

  void _deleteEvent(Event event) async {
    try {
      await _firestoreService.deleteEvent(event);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text("Event deleted successfully"),
        ),
      );
      setState(() {});
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text("Error deleting event: $e"),
        ),
      );
    }
  }
}

class AddUploadEvent extends StatefulWidget {
  const AddUploadEvent({super.key});

  @override
  State<AddUploadEvent> createState() => _AddUploadEventState();
}

class _AddUploadEventState extends State<AddUploadEvent> {
  final TextEditingController titleController = TextEditingController();

  final TextEditingController descriptionController = TextEditingController();

  final ValueNotifier<DateTime?> startDateController =
      ValueNotifier<DateTime?>(null);

  final TextEditingController locationController = TextEditingController();

  final TextEditingController priceController = TextEditingController();

  final FirestoreService _firestoreService = FirestoreService();

  Uint8List? bytes;

  Future<void> _selectStartDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(2000),
      lastDate: DateTime(2101),
    );
    if (picked != null) {
      final TimeOfDay? selectedTime = await showTimePicker(
        context: context,
        initialTime: TimeOfDay.now(),
      );
      if (selectedTime != null) {
        final DateTime combinedDateTime = DateTime(
          picked.year,
          picked.month,
          picked.day,
          selectedTime.hour,
          selectedTime.minute,
        );
        setState(() {
          startDateController.value = combinedDateTime;
        });
      }
    }
  }

  void _submitEvent(BuildContext context) async {
    String title = titleController.text;
    String description = descriptionController.text;
    File? images;
    DateTime? dateAndTime = startDateController.value;
    String location = locationController.text;
    String price = priceController.text.replaceAll(".", "");

    print('--> submit event');

    if (dateAndTime == null) {
      return;
    }
    print('--> submit event1');

    if (bytes != null) {
      images = await Generals.writeToFile(bytes!);
    }
    print('--> submit event2');

    try {
      await _firestoreService.addEvent(
        title: title,
        description: description,
        images: images,
        dateAndTime: dateAndTime,
        location: location,
        price: price,
        isReviewed: false,
      );

      Navigators.pop(context);
    } catch (e) {
      print('Error: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Add Event'),
      ),
      body: SingleChildScrollView(
        physics: const AlwaysScrollableScrollPhysics(),
        child: Padding(
          padding: EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Center(
                child: Card(
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                        side: BorderSide(width: 2)),
                    margin: EdgeInsets.zero,
                    child: InkWell(
                      onTap: () async {
                        await Dialogs.image(
                          context: context,
                          multiple: false,
                          allowGallery: true,
                          callback: (files) {
                            if (files.isNotEmpty) {
                              setState(() {
                                bytes = files[0];
                              });
                            }
                          },
                        );
                      },
                      child: Padding(
                        padding: EdgeInsets.all(15),
                        child: imagePreview(),
                      ),
                    )),
              ),
              TextField(
                controller: titleController,
                decoration: InputDecoration(
                  labelText: 'Title',
                ),
              ),
              TextField(
                controller: descriptionController,
                decoration: InputDecoration(
                  labelText: 'Description',
                ),
              ),
              InkWell(
                onTap: () => _selectStartDate(context),
                child: InputDecorator(
                  decoration: InputDecoration(
                    labelText: 'Start Date',
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: <Widget>[
                      Text(startDateController.value?.toString() ??
                          'Select Start Date'),
                      Icon(Icons.calendar_today),
                    ],
                  ),
                ),
              ),
              TextField(
                controller: locationController,
                decoration: InputDecoration(
                  labelText: 'Location',
                ),
              ),
              TextField(
                controller: priceController,
                inputFormatters: [
                  CurrencyInputFormatter(
                      mantissaLength: 0,
                      thousandSeparator: ThousandSeparator.Period)
                ],
                keyboardType: TextInputType.number,
                decoration: InputDecoration(
                  labelText: 'Price',
                ),
              ),
              SizedBox(height: 20),
              ElevatedButton(
                onPressed: () => _submitEvent(context),
                child: Text('Submit'),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget imagePreview() {
    if (bytes != null) {
      return Image.memory(
        bytes!,
        width: MediaQuery.of(context).size.width * 0.375,
        height: MediaQuery.of(context).size.width * 0.375,
        fit: BoxFit.cover,
      );
    }

    return Column(
      children: [
        Icon(Icons.upload, size: 95),
        SizedBox(height: 5),
        Text(
          'Upload Gambar',
          style: TextStyle(
            fontSize: 12,
            fontWeight: FontWeight.w600,
          ),
        )
      ],
    );
  }
}

class EditEventPage extends StatefulWidget {
  final Event event;

  EditEventPage(this.event);

  @override
  _EditEventPageState createState() => _EditEventPageState();
}

class _EditEventPageState extends State<EditEventPage> {
  final TextEditingController titleController = TextEditingController();
  final TextEditingController descriptionController = TextEditingController();
  final TextEditingController locationController = TextEditingController();
  final TextEditingController priceController = TextEditingController();

  final FirestoreService _firestoreService = FirestoreService();

  @override
  void initState() {
    super.initState();
    titleController.text = widget.event.title;
    descriptionController.text = widget.event.description;
    locationController.text = widget.event.location;
    priceController.text = widget.event.price;
  }

  void _submitChanges(BuildContext context) async {
    String title = titleController.text;
    String description = descriptionController.text;
    String location = locationController.text;
    String price = priceController.text;

    try {
      await _firestoreService.updateEvent(
        widget.event.id,
        title: title,
        description: description,
        location: location,
        price: price,
      );
      Navigators.pop(context);
    } catch (e) {
      print('Error updating event: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Edit Event'),
      ),
      body: Padding(
        padding: EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            TextField(
              controller: titleController,
              decoration: InputDecoration(
                labelText: 'Title',
              ),
            ),
            TextField(
              controller: descriptionController,
              decoration: InputDecoration(
                labelText: 'Description',
              ),
            ),
            TextField(
              controller: locationController,
              decoration: InputDecoration(
                labelText: 'Location',
              ),
            ),
            TextField(
              controller: priceController,
              decoration: InputDecoration(
                labelText: 'Price',
              ),
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: () => _submitChanges(context),
              child: Text('Save Changes'),
            ),
          ],
        ),
      ),
    );
  }
}
