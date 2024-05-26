import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:garbage_locator/main.dart';
import 'package:garbage_locator/models/garbage.dart';
import 'package:garbage_locator/repository/data_source.dart';
import 'package:garbage_locator/screens/collection_screen/garbage_list_item.dart';
import 'package:garbage_locator/screens/map_screen/map_screen.dart';
import 'package:provider/provider.dart';

import '../camera_screen.dart';
import '../initial_screen.dart';
import 'garbage_navigation_bar.dart';

class CollectionScreen extends StatefulWidget {
  static String route = '/collection_screen';

  const CollectionScreen({super.key});
  @override
  _CollectionScreenState createState() => _CollectionScreenState();
}

class _CollectionScreenState extends State<CollectionScreen> {
  Stream<List<Garbage>>? garbageStream;
  List<Garbage>? initialGarbages;
  int _selectedIndex = 0;

  @override
  void initState() {
    super.initState();
    final dataSource = Provider.of<DataSource>(context, listen: false);
    garbageStream = dataSource
        .getAllAuthorGarbageStream(FirebaseAuth.instance.currentUser!.email!);
    dataSource
        .getAllAuthorGarbage(FirebaseAuth.instance.currentUser!.email!)
        .then((garbages) {
      setState(() {
        initialGarbages = garbages;
      });
    });
  }

  Widget _flightShuttleBuilder(
      BuildContext flightContext,
      Animation<double> animation,
      HeroFlightDirection flightDirection,
      BuildContext fromHeroContext,
      BuildContext toHeroContext,
      ) {
    return DefaultTextStyle(
      style: DefaultTextStyle.of(toHeroContext).style,
      child: toHeroContext.widget,
    );
  }

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });

    switch (index) {
      case 0:
        Navigator.replaceRouteBelow(context,
            anchorRoute: ModalRoute.of(context)!,
            newRoute:
                MaterialPageRoute(builder: (context) => HomeScreenRenderer()));
        Navigator.pop(context);
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
    return AnnotatedRegion<SystemUiOverlayStyle>(
      value: SystemUiOverlayStyle(
        statusBarColor: Colors.transparent,
        statusBarIconBrightness: Brightness.dark, // For Android
        statusBarBrightness: Brightness.light, // For iOS
        systemNavigationBarColor: Theme.of(context).primaryColor,
      ),
      child: Scaffold(
        bottomNavigationBar: GarbageNavigationBar(onTap: _onItemTapped),
        appBar: AppBar(
          title: const Text('My Collection'),
        ),
        body: Hero(
          flightShuttleBuilder: _flightShuttleBuilder,
          tag: 'myGarbageCollection',
          child: FutureBuilder<List<Garbage>>(
            future: dataSource
                .getAllAuthorGarbage(FirebaseAuth.instance.currentUser!.email!),
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return const Center(
                  child: CircularProgressIndicator(),
                );
              } else if (snapshot.hasError) {
                return const Center(
                  child: Text('An error occurred!'),
                );
              } else {
                initialGarbages = snapshot.data;
                return StreamBuilder<List<Garbage>>(
                  stream: garbageStream,
                  builder: (context, snapshot) {
                    final garbages = snapshot.data ?? initialGarbages;
                    return ListView.builder(
                      itemCount: garbages!.length,
                      itemBuilder: (context, index) {
                        final garbage = garbages[index];
                        return GarbageListItem(garbage: garbage);
                      },
                    );
                  },
                );
              }
            },
          ),
        ),
      ),
    );
  }
}
