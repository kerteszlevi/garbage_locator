// import 'dart:io';

// import 'package:flutter/material.dart';
// import 'package:garbage_locator/models/garbage.dart';
// import 'package:garbage_locator/repository/photo_provider.dart';

// class CollectionScreen extends StatefulWidget {
//   static String route = '/collection_screen';
//   @override
//   _CollectionScreenState createState() => _CollectionScreenState();
// }

// class _CollectionScreenState extends State<CollectionScreen> {
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//         appBar: AppBar(
//           title: Text('My Collection'),
//         ),
//         body: ListView.builder(
//             itemCount: photos.length,
//             itemBuilder: (context, index) {
//               final photo = photos[index];
//               return Container(
//                 height: 200,
//                 margin: EdgeInsets.all(8.0),
//                 decoration: BoxDecoration(
//                   borderRadius: BorderRadius.circular(10),
//                   image: DecorationImage(
//                     image: FileImage(File(photo.imagePath)),
//                     fit: BoxFit.cover,
//                   ),
//                 ),
//                 child: Column(
//                   mainAxisAlignment: MainAxisAlignment.end,
//                   children: [
//                     Container(
//                         color: Colors.white70,
//                         child: ListTile(
//                           title: Text(photo.comment),
//                           subtitle: Text(photo.location),
//                         ))
//                   ],
//                 ),
//               );
//             }));
//   }
// }
