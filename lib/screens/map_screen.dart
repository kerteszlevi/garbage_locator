
import 'dart:io';

import 'package:dio_cache_interceptor_hive_store/dio_cache_interceptor_hive_store.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:flutter_map_animations/flutter_map_animations.dart';
import 'package:flutter_map_cache/flutter_map_cache.dart';
import 'package:garbage_locator/models/garbage.dart';
import 'package:garbage_locator/screens/collection_screen/garbage_list_item.dart';
import 'package:garbage_locator/themes/my_colors.dart';
import 'package:latlong2/latlong.dart';
import 'package:location/location.dart';
import 'package:path_provider/path_provider.dart';
import 'package:provider/provider.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:garbage_locator/utils.dart';

import '../repository/data_source.dart';
import 'collection_screen/garbage_navigation_bar.dart';

class MapScreen extends StatefulWidget {
  static String route = '/map_screen';

  const MapScreen({super.key});
    @override
    _MapScreenState createState() => _MapScreenState();
  }


class _MapScreenState extends State<MapScreen> /*with TickerProviderStateMixin*/ {
  List<Marker> markers = [];
  LatLng? initialCenter;
  Location location = Location();
  // late final _animatedMapController = AnimatedMapController(
  //   vsync: this,
  //   duration: const Duration(milliseconds: 500),
  //   curve: Curves.easeInOut,
  // );// TODO: animated markers

  //Garbage? selectedGarbage;
  ValueNotifier<Garbage?> selectedGarbage = ValueNotifier<Garbage?>(null);

  Future<String> getPath() async {
    final cacheDirectory = await getTemporaryDirectory();
    return cacheDirectory.path;
  }

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance!.addPostFrameCallback((_) async {
      final dataSource = Provider.of<DataSource>(context, listen: false);
      final garbages = await dataSource.getAllGarbage();
      final currentLocation = await getCurrentLocation();
      initialCenter = LatLng(currentLocation!.latitude!, currentLocation.longitude!);

      setState(() {
        markers = garbages.map((garbage) {
          return Marker(
            width: 80.0,
            height: 80.0,
            point: LatLng(garbage.latitude!, garbage.longitude!),
            rotate: true,
            child:
            ValueListenableBuilder<Garbage?>(
              valueListenable: selectedGarbage,
              builder: (context, value, child) {
                return Transform.translate(
                  offset: const Offset(0, -20.0),
                  child: IconButton(
                    icon: const Icon(Icons.location_on),
                    color: value == garbage ? MyColors.darkerPrimary : Theme.of(context).primaryColor,
                    iconSize: 40.0,
                    onPressed: () {
                      selectedGarbage.value = garbage;
                    },
                  ),
                );
              }
            ),
          );
        }).toList();

        markers.add(
          Marker(
            width: 80.0,
            height: 80.0,
            point: initialCenter!,
            rotate: true,
            child:
            Builder(
              builder: (ctx) =>
                  Transform.translate(
                    offset: const Offset(0, -20.0),
                    child: const Icon(Icons.boy,
                      color: Colors.blue,
                      size: 40,),
                  ),
            ),
          ),
        );
      });
    });
  }

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
      body: initialCenter == null ? const Center(child: CircularProgressIndicator()) :
      Stack(

        children: [
          FutureBuilder(

            future: getPath(),
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return const Center(
                  child: CircularProgressIndicator(),
                );
              }
              final path = snapshot.data as String;
              return FlutterMap(
                // mapController: _animatedMapController.mapController,
                options: MapOptions(
                  initialCenter: initialCenter!,
                  initialZoom: 13.0,
                ),
                children: [
                  TileLayer(
                    urlTemplate: 'https://tile.openstreetmap.org/{z}/{x}/{y}.png',
                    userAgentPackageName: 'com.example.app',
                    tileProvider: CachedTileProvider(
                      maxStale: const Duration(days: 30),
                      store: HiveCacheStore(
                        path,
                        hiveBoxName: 'HiveCacheStore',
                      ),
                    ),
                  ),
                  RichAttributionWidget(
                    attributions: [
                      TextSourceAttribution(
                        'OpenStreetMap contributors',
                        onTap: () => launchUrl(Uri.parse('https://openstreetmap.org/copyright')),
                      ),
                    ],
                  ),
                  MarkerLayer(markers: markers),
                ],
              );
            },
          ),
          ValueListenableBuilder<Garbage?>(
            valueListenable: selectedGarbage,
            builder: (context, value, child) {
              if (value == null) return const SizedBox.shrink();
              return Align(
                alignment: Alignment.bottomCenter,
                child: Container(
                  height: 200,
                  color: Colors.grey,
                  child: GarbageListItem(garbage: value),
                ),
              );
            },
          ),
        ]
      ),
    );
  }
}