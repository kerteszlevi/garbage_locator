import 'package:dio_cache_interceptor_hive_store/dio_cache_interceptor_hive_store.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:flutter_map_animations/flutter_map_animations.dart';
import 'package:flutter_map_cache/flutter_map_cache.dart';
import 'package:garbage_locator/models/garbage.dart';
import 'package:garbage_locator/themes/my_colors.dart';
import 'package:latlong2/latlong.dart';
import 'package:location/location.dart';
import 'package:path_provider/path_provider.dart';
import 'package:provider/provider.dart';
import 'package:garbage_locator/utils.dart';

import '../../repository/data_source.dart';
import '../collection_screen/garbage_navigation_bar.dart';
import 'garbage_map_list_item.dart';

class MapScreen extends StatefulWidget {
  final Garbage? garbagePassed;
  static String route = '/map_screen';

  const MapScreen({super.key, this.garbagePassed});
  @override
  State<MapScreen> createState() => _MapScreenState();
}

class _MapScreenState extends State<MapScreen> with TickerProviderStateMixin {
  List<AnimatedMarker> markers = [];
  LatLng? initialCenter;
  Location location = Location();

  ValueNotifier<bool> isLoadingLocation = ValueNotifier<bool>(false);
  ValueNotifier<Garbage?> selectedGarbage = ValueNotifier<Garbage?>(null);
  ValueNotifier<List<Garbage>> sameLocationGarbages =
      ValueNotifier<List<Garbage>>([]);

  final bool _useTransformer = true;
  static const _useTransformerId = 'useTransformerId';
  late AnimationController _animationController;
  late final _animatedMapController = AnimatedMapController(
    vsync: this,
    duration: const Duration(milliseconds: 500),
    curve: Curves.easeInOut,
  );
  ScrollController scrollController = ScrollController();

  Future<String> getPath() async {
    final cacheDirectory = await getTemporaryDirectory();
    return cacheDirectory.path;
  }

  void centerMapOnMarkers(List<AnimatedMarker> markers) {
    if (markers.length < 2) return;

    final points = markers.map((m) => m.point).toList();
    _animatedMapController.animatedFitCamera(
      cameraFit: CameraFit.coordinates(
        coordinates: points,
        padding: const EdgeInsets.all(50),
        maxZoom: 18.0,
      ),
      rotation: 0,
      customId: _useTransformer ? _useTransformerId : null,
    );
  }

//TODO: also open the list when the garbage is clicke
//TODO: also animate maplistitems
  void animateToPassedGarbage() {
    if (widget.garbagePassed != null) {
      _animatedMapController.animateTo(
        dest: LatLng(
          widget.garbagePassed!.latitude!,
          widget.garbagePassed!.longitude!,
        ),
        customId: _useTransformer ? _useTransformerId : null,
        zoom: 17.0,
      );
    }
  }

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 500),
    );
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      final dataSource = Provider.of<DataSource>(context, listen: false);
      final garbages = await dataSource.getAllGarbage();
      final currentLocation = await getCurrentLocation();
      initialCenter =
          LatLng(currentLocation!.latitude!, currentLocation.longitude!);

      setState(() {
        markers = garbages.map((garbage) {
          return AnimatedMarker(
            width: 80.0,
            height: 80.0,
            point: LatLng(garbage.latitude!, garbage.longitude!),
            rotate: true,
            builder: (BuildContext context, Animation<double> animation) {
              return ValueListenableBuilder<Garbage?>(
                valueListenable: selectedGarbage,
                builder: (context, value, child) {
                  return Transform.translate(
                    offset: const Offset(0, -20.0),
                    child: IconButton(
                      icon: const Icon(Icons.location_on),
                      color: value == garbage
                          ? MyColors.darkerPrimary
                          : Theme.of(context).primaryColor,
                      iconSize: 40.0,
                      onPressed: () {
                        _animatedMapController.animateTo(
                          zoom: 15.0,
                          dest: LatLng(garbage.latitude!, garbage.longitude!),
                          customId: _useTransformer ? _useTransformerId : null,
                        );
                        selectedGarbage.value = garbage;
                        sameLocationGarbages.value = garbages
                            .where((g) => g.location == garbage.location)
                            .toList();
                        sameLocationGarbages.value.remove(garbage);
                        sameLocationGarbages.value.insert(0, garbage);
                        scrollController.animateTo(
                          0.0,
                          duration: const Duration(milliseconds: 500),
                          curve: Curves.easeOut,
                        );
                      },
                    ),
                  );
                },
              );
            },
          );
        }).toList();
        markers.add(
          AnimatedMarker(
            width: 80.0,
            height: 80.0,
            point: initialCenter!,
            rotate: true,
            builder: (BuildContext context, Animation<double> animation) {
              return Transform.translate(
                offset: const Offset(0, -20.0),
                child: const Icon(
                  Icons.boy,
                  color: Colors.blue,
                  size: 40,
                ),
              );
            },
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
    return AnnotatedRegion<SystemUiOverlayStyle>(
      value: SystemUiOverlayStyle(
        statusBarColor: Colors.transparent,
        statusBarIconBrightness: Brightness.dark,
        systemNavigationBarColor: Theme.of(context).primaryColor,
      ),
      child: Scaffold(
        body: Hero(
          tag: 'mapScreen',
          child: Container(
            child: initialCenter == null
                ? AnnotatedRegion<SystemUiOverlayStyle>(
                    value: const SystemUiOverlayStyle(
                      statusBarColor: Colors.transparent,
                      statusBarIconBrightness: Brightness.dark,
                      systemNavigationBarColor: Colors.white,
                    ),
                    child:
                        Center(child: Image.asset('assets/gifs/location.gif')))
                : Stack(
                    children: [
                      FutureBuilder(
                        future: getPath(),
                        builder: (context, snapshot) {
                          if (snapshot.connectionState ==
                              ConnectionState.waiting) {
                            return const Center(
                              child: CircularProgressIndicator(),
                            );
                          }
                          final path = snapshot.data as String;
                          return Column(
                            children: [
                              Expanded(
                                child: Stack(
                                  children: [
                                    FlutterMap(
                                      mapController:
                                          _animatedMapController.mapController,
                                      options: MapOptions(
                                        initialCenter: initialCenter!,
                                        initialZoom: 13.0,
                                        onTap: (_, point) {
                                          selectedGarbage.value = null;
                                        },
                                        onMapReady: () {
                                          animateToPassedGarbage();
                                        },
                                      ),
                                      children: [
                                        TileLayer(
                                          urlTemplate:
                                              'https://tile.openstreetmap.org/{z}/{x}/{y}.png',
                                          userAgentPackageName:
                                              'com.example.garbage_locator',
                                          tileProvider: CachedTileProvider(
                                            maxStale: const Duration(days: 30),
                                            store: HiveCacheStore(
                                              path,
                                              hiveBoxName: 'HiveCacheStore',
                                            ),
                                          ),
                                        ),
                                        AnimatedMarkerLayer(markers: markers),
                                      ],
                                    ),
                                    Align(
                                      alignment: Alignment.bottomRight,
                                      child: Padding(
                                        padding: const EdgeInsets.all(15.0),
                                        child: Wrap(
                                          direction: Axis.vertical,
                                          spacing: 15.0,
                                          children: [
                                            FloatingActionButton(
                                              heroTag: null,
                                              tooltip:
                                                  'Center on Your Location',
                                              onPressed: () async {
                                                isLoadingLocation.value = true;
                                                final currentLocation =
                                                    await getCurrentLocation();
                                                //TODO: avoid setState
                                                setState(() {
                                                  markers.last = AnimatedMarker(
                                                    width: 80.0,
                                                    height: 80.0,
                                                    point: LatLng(
                                                      currentLocation!
                                                          .latitude!,
                                                      currentLocation
                                                          .longitude!,
                                                    ),
                                                    rotate: true,
                                                    builder:
                                                        (BuildContext context,
                                                            Animation<double>
                                                                animation) {
                                                      return Transform
                                                          .translate(
                                                        offset: const Offset(
                                                            0, -20.0),
                                                        child: const Icon(
                                                          Icons.boy,
                                                          color: Colors.blue,
                                                          size: 40,
                                                        ),
                                                      );
                                                    },
                                                  );
                                                });
                                                _animatedMapController
                                                    .animateTo(
                                                  dest: LatLng(
                                                    currentLocation!.latitude!,
                                                    currentLocation.longitude!,
                                                  ),
                                                  customId: _useTransformer
                                                      ? _useTransformerId
                                                      : null,
                                                );
                                                isLoadingLocation.value = false;
                                              },
                                              child:
                                                  ValueListenableBuilder<bool>(
                                                valueListenable:
                                                    isLoadingLocation,
                                                builder:
                                                    (context, value, child) {
                                                  return value
                                                      ? const CircularProgressIndicator(
                                                          backgroundColor:
                                                              Colors.white,
                                                        )
                                                      : const Icon(
                                                          Icons.my_location);
                                                },
                                              ),
                                            ),
                                            FloatingActionButton(
                                              heroTag: null,
                                              tooltip: 'Center on markers',
                                              onPressed: () =>
                                                  centerMapOnMarkers(markers),
                                              child: const Icon(
                                                  Icons.center_focus_strong),
                                            ),
                                          ],
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              GarbageNavigationBar(
                                onTap: (index) => _onItemTapped(index, context),
                              ),
                            ],
                          );
                        },
                      ),
                      //Bottom part
                      ValueListenableBuilder<Garbage?>(
                        valueListenable: selectedGarbage,
                        builder: (context, value, child) {
                          if (value == null) {
                            _animationController.reverse();
                            //TODO: we are not waiting for the animation to finish and return a SizedBox.shrink() instead,
                            //this is causing problems becouse then garbage would be null for the listitem
                            return const SizedBox.shrink();
                          }
                          _animationController.forward();
                          return AnnotatedRegion<SystemUiOverlayStyle>(
                            value: const SystemUiOverlayStyle(
                              statusBarColor: Colors.transparent,
                              statusBarIconBrightness: Brightness.dark,
                              systemNavigationBarColor: Colors.white,
                            ),
                            child: SlideTransition(
                              position: Tween<Offset>(
                                begin: const Offset(0, 1),
                                end: Offset.zero,
                              ).animate(_animationController),
                              child: Align(
                                alignment: Alignment.bottomCenter,
                                child: Container(
                                  decoration: const BoxDecoration(
                                    color: Colors.white,
                                    borderRadius: BorderRadius.only(
                                      topLeft: Radius.circular(20),
                                      topRight: Radius.circular(20),
                                    ),
                                  ),
                                  child: SafeArea(
                                    top: false,
                                    right: false,
                                    left: false,
                                    minimum: const EdgeInsets.all(10),
                                    child: Wrap(
                                      children: [
                                        Row(
                                          children: [
                                            Icon(
                                              Icons.location_on,
                                              color: Theme.of(context)
                                                  .primaryColor,
                                            ),
                                            Text(
                                              selectedGarbage.value!.location,
                                              style: TextStyle(
                                                fontWeight: FontWeight.bold,
                                                fontSize: 20,
                                                color: Theme.of(context)
                                                    .primaryColor,
                                              ),
                                            ),
                                          ],
                                        ),
                                        Container(
                                          height: MediaQuery.of(context)
                                                  .size
                                                  .height *
                                              0.3,
                                          width:
                                              MediaQuery.of(context).size.width,
                                          child: ListView.builder(
                                            controller: scrollController,
                                            scrollDirection: Axis.horizontal,
                                            itemCount: sameLocationGarbages
                                                .value.length,
                                            itemBuilder: (context, index) {
                                              return GarbageMapListItem(
                                                  garbage: sameLocationGarbages
                                                      .value[index]);
                                            },
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          );
                        },
                      ),
                    ],
                  ),
          ),
        ),
      ),
    );
  }
}
