
import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:garbage_locator/models/garbage.dart';
import 'package:latlong2/latlong.dart';
import 'package:url_launcher/url_launcher.dart';

import 'collection_screen/garbage_navigation_bar.dart';

class MapScreen extends StatelessWidget {
  static String route = '/map_screen';

  const MapScreen({super.key});

  void _onItemTapped(int index, BuildContext context) {
    switch (index) {
      case 0:
        Navigator.popUntil(context, (route) => route.isFirst);
        break;
      case 1:
        Navigator.pushNamed(context, '/camera_screen');
        break;
      case 2:
        //already on map screen
        break;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      bottomNavigationBar: GarbageNavigationBar(onTap: (index) => _onItemTapped(index, context)),
      body: FlutterMap(
        options: const MapOptions(
          initialCenter: LatLng(51.509364, -0.128928),
          initialZoom: 9.2,
        ),
        children: [
          TileLayer(
            urlTemplate: 'https://tile.openstreetmap.org/{z}/{x}/{y}.png',
            userAgentPackageName: 'com.example.app',
          ),
          RichAttributionWidget(
            attributions: [
              TextSourceAttribution(
                'OpenStreetMap contributors',
                onTap: () => launchUrl(Uri.parse('https://openstreetmap.org/copyright')),
              ),
            ],
          ),
        ],
      ),
    );
  }
}