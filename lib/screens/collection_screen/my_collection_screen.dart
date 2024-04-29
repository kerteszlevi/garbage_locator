import 'dart:io';

import 'package:flutter/material.dart';
import 'package:garbage_locator/models/garbage.dart';
import 'package:garbage_locator/repository/data_source.dart';
import 'package:garbage_locator/screens/collection_screen/garbage_list_item.dart';
import 'package:provider/provider.dart';

class CollectionScreen extends StatefulWidget {
  static String route = '/collection_screen';

  const CollectionScreen({super.key});
  @override
  _CollectionScreenState createState() => _CollectionScreenState();
}

class _CollectionScreenState extends State<CollectionScreen> {
  @override
  Widget build(BuildContext context) {
    final dataSource = Provider.of<DataSource>(context);
    //final garbages = dataSource.getAllGarbage();
    return Scaffold(
      appBar: AppBar(
        title: const Text('My Collection'),
      ),
      body: FutureBuilder<List<Garbage>>(
        future: dataSource.getAllGarbage(),
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
                // return Container(
                //   height: 200,
                //   margin: const EdgeInsets.all(8.0),
                //   decoration: BoxDecoration(
                //     borderRadius: BorderRadius.circular(10),
                //     image: DecorationImage(
                //       image: FileImage(File(garbage.imagePath)),
                //       fit: BoxFit.cover,
                //     ),
                //   ),
                //   child: Column(
                //     mainAxisAlignment: MainAxisAlignment.end,
                //     children: [
                //       Container(
                //           color: Colors.white70,
                //           child: ListTile(
                //             title: Text(garbage.comment),
                //             subtitle: Text(garbage.location),
                //           ))
                //     ],
                //   ),
                // );
              },
            );
          }
        },
      ),
    );
  }
}
