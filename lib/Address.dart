import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';
import 'package:mobpro/firestore_service.dart';
import 'package:mobpro/main.dart';
import 'package:sliding_up_panel/sliding_up_panel.dart';

class AddressPage extends StatefulWidget {
  @override
  _MapScreenState createState() => _MapScreenState();
}

class _MapScreenState extends State<AddressPage> {

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

  final List<PanelController> _panelControllers =
      List.generate(17, (index) => PanelController());
  int? _openPanelIndex;
  List<Event> filterEventsByLocation(String location) {
    return events.where((event) => event.location == location).toList();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Map'),
      ),
      body: Stack(
        children: [
          FlutterMap(
            options: MapOptions(
              center: LatLng(
                  -6.973007, 107.631683), // Coordinates for the map center
              zoom: 16.5,
            ),
            children: [
              TileLayer(
                urlTemplate:
                    'https://{s}.tile.openstreetmap.org/{z}/{x}/{y}.png',
                subdomains: ['a', 'b', 'c'],
              ),
              MarkerLayer(
                markers: [
                  Marker(
                    point: LatLng(-6.97195324142018, 107.63274365610546), // FEB
                    width: 60,
                    height: 60,
                    child: GestureDetector(
                      onTap: () {
                        setState(() {
                          _openPanelIndex = 0;
                        });
                        _panelControllers[0].open();
                      },
                      child: Icon(
                        Icons.location_pin,
                        size: 60,
                        color: Colors.red,
                      ),
                    ),
                  ),
                  Marker(
                    point:
                        LatLng(-6.9688182172252, 107.62794793976549), // TULT
                    width: 60,
                    height: 60,
                    child: GestureDetector(
                      onTap: () {
                        setState(() {
                          _openPanelIndex = 1;
                        });
                        _panelControllers[1].open();
                      },
                      child: Icon(
                        Icons.location_pin,
                        size: 60,
                        color: Colors.red,
                      ),
                    ),
                  ),
                  Marker(
                    point: LatLng(-6.971729415326058, 107.6325078401854), // Perpus
                    width: 60,
                    height: 60,
                    child: GestureDetector(
                      onTap: () {
                        setState(() {
                          _openPanelIndex = 2;
                        });
                        _panelControllers[2].open();
                      },
                      child: Icon(
                        Icons.location_pin,
                        size: 60,
                        color: Colors.red,
                      ),
                    ),
                  ),
                  // Marker indeks 3
                  Marker(
                    point: LatLng(-6.969894942299374, 107.6273795001638), // Kantin TULT
                    width: 60,
                    height: 60,
                    child: GestureDetector(
                      onTap: () {
                        setState(() {
                          _openPanelIndex = 3;
                        });
                        _panelControllers[3].open();
                      },
                      child: Icon(
                        Icons.location_pin,
                        size: 60,
                        color: Colors.red,
                      ),
                    ),
                  ),
                  // Marker indeks 4
                  Marker(
                    point: LatLng(-6.972057473522345, 107.63132290981962), // FIK
                    width: 60,
                    height: 60,
                    child: GestureDetector(
                      onTap: () {
                        setState(() {
                          _openPanelIndex = 4;
                        });
                        _panelControllers[4].open();
                      },
                      child: Icon(
                        Icons.location_pin,
                        size: 60,
                        color: Colors.red,
                      ),
                    ),
                  ),
                  // Marker indeks 5
                  Marker(
                    point: LatLng(-6.972875767546397, 107.6297212312019), // Gedung Nanas
                    width: 60,
                    height: 60,
                    child: GestureDetector(
                      onTap: () {
                        setState(() {
                          _openPanelIndex = 5;
                        });
                        _panelControllers[5].open();
                      },
                      child: Icon(
                        Icons.location_pin,
                        size: 60,
                        color: Colors.red,
                      ),
                    ),
                  ),
                  Marker(
                    point: LatLng(-6.9731430938841825, 107.63260786883194), // FIT
                    width: 60,
                    height: 60,
                    child: GestureDetector(
                      onTap: () {
                        setState(() {
                          _openPanelIndex = 6;
                        });
                        _panelControllers[6].open();
                      },
                      child: Icon(
                        Icons.location_pin,
                        size: 60,
                        color: Colors.red,
                      ),
                    ),
                  ),
                  Marker(
                    point: LatLng(-6.9748524727543515, 107.62999813599114), // Gedung Damar/Auditorium
                    width: 60,
                    height: 60,
                    child: GestureDetector(
                      onTap: () {
                        setState(() {
                          _openPanelIndex = 7;
                        });
                        _panelControllers[7].open();
                      },
                      child: Icon(
                        Icons.location_pin,
                        size: 60,
                        color: Colors.red,
                      ),
                    ),
                  ),
                  Marker(
                    point: LatLng(-6.976177801862156, 107.63029400686455), // GSG
                    width: 60,
                    height: 60,
                    child: GestureDetector(
                      onTap: () {
                        setState(() {
                          _openPanelIndex = 8;
                        });
                        _panelControllers[8].open();
                      },
                      child: Icon(
                        Icons.location_pin,
                        size: 60,
                        color: Colors.red,
                      ),
                    ),
                  ),
                  Marker(
                    point: LatLng(-6.9739858225705404, 107.6304761840555), //Rektorat
                    width: 60,
                    height: 60,
                    child: GestureDetector(
                      onTap: () {
                        setState(() {
                          _openPanelIndex = 9;
                        });
                        _panelControllers[9].open();
                      },
                      child: Icon(
                        Icons.location_pin,
                        size: 60,
                        color: Colors.red,
                      ),
                    ),
                  ),
                  Marker(
                    point: LatLng(-6.97440447286722, 107.62881391008607), // Ruang Riung
                    width: 60,
                    height: 60,
                    child: GestureDetector(
                      onTap: () {
                        setState(() {
                          _openPanelIndex = 10;
                        });
                        _panelControllers[10].open();
                      },
                      child: Icon(
                        Icons.location_pin,
                        size: 60,
                        color: Colors.red,
                      ),
                    ),
                  ),
                  Marker(
                    point: LatLng(-6.975678331653823, 107.6302934918168), // Lapangan Parkir GSG
                    width: 60,
                    height: 60,
                    child: GestureDetector(
                      onTap: () {
                        setState(() {
                          _openPanelIndex = 11;
                        });
                        _panelControllers[11].open();
                      },
                      child: Icon(
                        Icons.location_pin,
                        size: 60,
                        color: Colors.red,
                      ),
                    ),
                  ),
                  Marker(
                    point: LatLng(-6.97461208087511, 107.63106346676607), // Gedung Cacuk
                    width: 60,
                    height: 60,
                    child: GestureDetector(
                      onTap: () {
                        setState(() {
                          _openPanelIndex = 12;
                        });
                        _panelControllers[12].open();
                      },
                      child: Icon(
                        Icons.location_pin,
                        size: 60,
                        color: Colors.red,
                      ),
                    ),
                  ),
                  Marker(
                    point: LatLng(-6.971474162560262, 107.63100556687328), // TUCH
                    width: 60,
                    height: 60,
                    child: GestureDetector(
                      onTap: () {
                        setState(() {
                          _openPanelIndex = 13;
                        });
                        _panelControllers[13].open();
                      },
                      child: Icon(
                        Icons.location_pin,
                        size: 60,
                        color: Colors.red,
                      ),
                    ),
                  ),
                  Marker(
                    point: LatLng(-6.975697214083791, 107.63210088134541), // MSU
                    width: 60,
                    height: 60,
                    child: GestureDetector(
                      onTap: () {
                        setState(() {
                          _openPanelIndex = 14;
                        });
                        _panelControllers[14].open();
                      },
                      child: Icon(
                        Icons.location_pin,
                        size: 60,
                        color: Colors.red,
                      ),
                    ),
                  ),
                  Marker(
                    point:
                        LatLng(-6.971311805327252, 107.63200966945959), // FKB
                    width: 60,
                    height: 60,
                    child: GestureDetector(
                      onTap: () {
                        setState(() {
                          _openPanelIndex = 15;
                        });
                        _panelControllers[15].open();
                      },
                      child: Icon(
                        Icons.location_pin,
                        size: 60,
                        color: Colors.red,
                      ),
                    ),
                  ),
                  Marker(
                    point:
                        LatLng(-6.977308010295217, 107.62939825565225), // Student Center
                    width: 60,
                    height: 60,
                    child: GestureDetector(
                      onTap: () {
                        setState(() {
                          _openPanelIndex = 16;
                        });
                        _panelControllers[16].open();
                      },
                      child: Icon(
                        Icons.location_pin,
                        size: 60,
                        color: Colors.red,
                      ),
                    ),
                  ),
                  Marker(
                    point: LatLng(-6.970037776585711, 107.6291925762325), // Lapangan Sepakbola
                    width: 60,
                    height: 60,
                    child: GestureDetector(
                      onTap: () {
                        setState(() {
                          _openPanelIndex = 17;
                        });
                        _panelControllers[17].open();
                      },
                      child: Icon(
                        Icons.location_pin,
                        size: 60,
                        color: Colors.red,
                      ),
                    ),
                  ),
                  Marker(
                    point: LatLng(-6.973944266350676, 107.62945521206719), // JOGLO
                    width: 60,
                    height: 60,
                    child: GestureDetector(
                      onTap: () {
                        setState(() {
                          _openPanelIndex = 18;
                        });
                        _panelControllers[18].open();
                      },
                      child: Icon(
                        Icons.location_pin,
                        size: 60,
                        color: Colors.red,
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
          if (_openPanelIndex == 0)
            SlidingUpPanel(
              controller: _panelControllers[0],
              panel: ListView(
                // Menggunakan ListView sebagai child
                children: filterEventsByLocation('FEB')
                    .map((event) => ListTile(
                          title: Text(event.title),
                        ))
                    .toList(),
              ),
              onPanelClosed: () {
                setState(() {
                  _openPanelIndex = null;
                });
              },
            ),
          if (_openPanelIndex == 1)
            SlidingUpPanel(
              controller: _panelControllers[1],
              panel: ListView(
                // Menggunakan ListView sebagai child
                children: filterEventsByLocation('TULT')
                    .map((event) => ListTile(
                          title: Text(event.title),
                        ))
                    .toList(),
              ),
              onPanelClosed: () {
                setState(() {
                  _openPanelIndex = null;
                });
              },
            ),
          if (_openPanelIndex == 2)
            SlidingUpPanel(
              controller: _panelControllers[2],
              panel: ListView(
                // Menggunakan ListView sebagai child
                children: filterEventsByLocation('Perpus')
                    .map((event) => ListTile(
                          title: Text(event.title),
                        ))
                    .toList(),
              ),
              onPanelClosed: () {
                setState(() {
                  _openPanelIndex = null;
                });
              },
            ),
          if (_openPanelIndex == 3)
            SlidingUpPanel(
              controller: _panelControllers[3],
              panel: ListView(
                // Menggunakan ListView sebagai child
                children: filterEventsByLocation('Kantin TULT')
                    .map((event) => ListTile(
                          title: Text(event.title),
                        ))
                    .toList(),
              ),
              onPanelClosed: () {
                setState(() {
                  _openPanelIndex = null;
                });
              },
            ),
          if (_openPanelIndex == 4)
            SlidingUpPanel(
              controller: _panelControllers[4],
              panel: ListView(
                // Menggunakan ListView sebagai child
                children: filterEventsByLocation('FIK')
                    .map((event) => ListTile(
                          title: Text(event.title),
                        ))
                    .toList(),
              ),
              onPanelClosed: () {
                setState(() {
                  _openPanelIndex = null;
                });
              },
            ),
          if (_openPanelIndex == 5)
            SlidingUpPanel(
              controller: _panelControllers[5],
              panel: ListView(
                // Menggunakan ListView sebagai child
                children: filterEventsByLocation('Gedung Nanas')
                    .map((event) => ListTile(
                          title: Text(event.title),
                        ))
                    .toList(),
              ),
              onPanelClosed: () {
                setState(() {
                  _openPanelIndex = null;
                });
              },
            ),
          if (_openPanelIndex == 6)
            SlidingUpPanel(
              controller: _panelControllers[6],
              panel: ListView(
                // Menggunakan ListView sebagai child
                children: filterEventsByLocation('FIT')
                    .map((event) => ListTile(
                          title: Text(event.title),
                        ))
                    .toList(),
              ),
              onPanelClosed: () {
                setState(() {
                  _openPanelIndex = null;
                });
              },
            ),
          if (_openPanelIndex == 7)
            SlidingUpPanel(
              controller: _panelControllers[7],
              panel: ListView(
                // Menggunakan ListView sebagai child
                children: filterEventsByLocation('Gedung Damar/Auditorium')
                    .map((event) => ListTile(
                          title: Text(event.title),
                        ))
                    .toList(),
              ),
              onPanelClosed: () {
                setState(() {
                  _openPanelIndex = null;
                });
              },
            ),
          if (_openPanelIndex == 8)
            SlidingUpPanel(
              controller: _panelControllers[8],
              panel: ListView(
                // Menggunakan ListView sebagai child
                children: filterEventsByLocation('GSG')
                    .map((event) => ListTile(
                          title: Text(event.title),
                        ))
                    .toList(),
              ),
              onPanelClosed: () {
                setState(() {
                  _openPanelIndex = null;
                });
              },
            ),
          if (_openPanelIndex == 9)
            SlidingUpPanel(
              controller: _panelControllers[9],
              panel: ListView(
                // Menggunakan ListView sebagai child
                children: filterEventsByLocation('Rektorat')
                    .map((event) => ListTile(
                          title: Text(event.title),
                        ))
                    .toList(),
              ),
              onPanelClosed: () {
                setState(() {
                  _openPanelIndex = null;
                });
              },
            ),
          if (_openPanelIndex == 10)
            SlidingUpPanel(
              controller: _panelControllers[10],
              panel: ListView(
                // Menggunakan ListView sebagai child
                children: filterEventsByLocation('Ruang Riung')
                    .map((event) => ListTile(
                          title: Text(event.title),
                        ))
                    .toList(),
              ),
              onPanelClosed: () {
                setState(() {
                  _openPanelIndex = null;
                });
              },
            ),
          if (_openPanelIndex == 11)
            SlidingUpPanel(
              controller: _panelControllers[11],
              panel: ListView(
                // Menggunakan ListView sebagai child
                children: filterEventsByLocation('Lapangan Parkir GSG')
                    .map((event) => ListTile(
                          title: Text(event.title),
                        ))
                    .toList(),
              ),
              onPanelClosed: () {
                setState(() {
                  _openPanelIndex = null;
                });
              },
            ),
          if (_openPanelIndex == 12)
            SlidingUpPanel(
              controller: _panelControllers[12],
              panel: ListView(
                // Menggunakan ListView sebagai child
                children: filterEventsByLocation('LAC')
                    .map((event) => ListTile(
                          title: Text(event.title),
                        ))
                    .toList(),
              ),
              onPanelClosed: () {
                setState(() {
                  _openPanelIndex = null;
                });
              },
            ),
          if (_openPanelIndex == 13)
            SlidingUpPanel(
              controller: _panelControllers[13],
              panel: ListView(
                // Menggunakan ListView sebagai child
                children: filterEventsByLocation('TUCH')
                    .map((event) => ListTile(
                          title: Text(event.title),
                        ))
                    .toList(),
              ),
              onPanelClosed: () {
                setState(() {
                  _openPanelIndex = null;
                });
              },
            ),
          if (_openPanelIndex == 14)
            SlidingUpPanel(
              controller: _panelControllers[14],
              panel: ListView(
                // Menggunakan ListView sebagai child
                children: filterEventsByLocation('MSU')
                    .map((event) => ListTile(
                          title: Text(event.title),
                        ))
                    .toList(),
              ),
              onPanelClosed: () {
                setState(() {
                  _openPanelIndex = null;
                });
              },
            ),
          if (_openPanelIndex == 15)
            SlidingUpPanel(
              controller: _panelControllers[15],
              panel: ListView(
                // Menggunakan ListView sebagai child
                children: filterEventsByLocation('FKB')
                    .map((event) => ListTile(
                          title: Text(event.title),
                        ))
                    .toList(),
              ),
              onPanelClosed: () {
                setState(() {
                  _openPanelIndex = null;
                });
              },
            ),
          if (_openPanelIndex == 16)
            SlidingUpPanel(
              controller: _panelControllers[16],
              panel: ListView(
                // Menggunakan ListView sebagai child
                children: filterEventsByLocation('Student Center')
                    .map((event) => ListTile(
                          title: Text(event.title),
                        ))
                    .toList(),
              ),
              onPanelClosed: () {
                setState(() {
                  _openPanelIndex = null;
                });
              },
            ),
          if (_openPanelIndex == 17)
            SlidingUpPanel(
              controller: _panelControllers[17],
              panel: ListView(
                // Menggunakan ListView sebagai child
                children: filterEventsByLocation('Lapangan Sepakbola')
                    .map((event) => ListTile(
                          title: Text(event.title),
                        ))
                    .toList(),
              ),
              onPanelClosed: () {
                setState(() {
                  _openPanelIndex = null;
                });
              },
            ),
          if (_openPanelIndex == 18)
            SlidingUpPanel(
              controller: _panelControllers[18],
              panel: ListView(
                // Menggunakan ListView sebagai child
                children: filterEventsByLocation('JOGLO')
                    .map((event) => ListTile(
                          title: Text(event.title),
                        ))
                    .toList(),
              ),
              onPanelClosed: () {
                setState(() {
                  _openPanelIndex = null;
                });
              },
            ),
        ],
      ),
    );
  }
}
