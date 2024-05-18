import 'package:flutter/material.dart';
import 'package:garbage_locator/models/garbage.dart';
import 'package:garbage_locator/repository/data_source.dart';
import 'package:garbage_locator/screens/collection_screen/garbage_list_item.dart';
import 'package:garbage_locator/screens/map_screen/map_screen.dart';
import 'package:provider/provider.dart';

import '../camera_screen.dart';
import 'garbage_navigation_bar.dart';

class CollectionScreen extends StatefulWidget {
  static String route = '/collection_screen';

  const CollectionScreen({super.key});
  @override
  _CollectionScreenState createState() => _CollectionScreenState();
}

class _CollectionScreenState extends State<CollectionScreen> {
  int _selectedIndex = 0;

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });

    switch (index) {
      case 0:
        Navigator.popUntil(context, (route) => route.isFirst);
        break;
      case 1:
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => const CameraScreen(),
          ),
        );
        break;
      case 2:
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => const MapScreen(),
          ),
        );
        break;
    }
  }

  @override
  Widget build(BuildContext context) {
    final dataSource = Provider.of<DataSource>(context);
    return Scaffold(
      bottomNavigationBar: GarbageNavigationBar(onTap: _onItemTapped),
      appBar: AppBar(
        title: const Text('My Collection'),
      ),
      body: Hero(
        tag: 'myGarbageCollection',
        child: StreamBuilder<List<Garbage>>(
          stream: dataSource.allGarbageStream,
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(
                child: CircularProgressIndicator(),
              );
            }
            if (snapshot.hasError) {
              return const Center(
                child: Text('An error occurred!'),
              );
            } else {
              final garbages = snapshot.data!;
              return ListView.builder(
                itemCount: garbages.length,
                itemBuilder: (context, index) {
                  final garbage = garbages[index];
                  return GarbageListItem(garbage: garbage);
                },
              );
            }
          },
        ),
      ),
    );
  }
}
