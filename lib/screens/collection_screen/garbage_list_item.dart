import 'dart:ui';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/painting.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/widgets.dart';

import '../../models/garbage.dart';
import '../map_screen/map_screen.dart';

class GarbageListItem extends StatelessWidget {
  final Garbage garbage;

  const GarbageListItem({super.key, required this.garbage});

  @override
  Widget build(BuildContext context) {
    const outerRadius = 30.0;
    const borderThickness = 1.0;
    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => MapScreen(garbagePassed: garbage),
          ),
        );
      },
      child: Container(
        height: 200,
        margin: const EdgeInsets.only(left: 35, right: 35, top: 10, bottom: 10),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(outerRadius),
          image: DecorationImage(
            //image: FileImage(File(garbage.imagePath)),
            image: NetworkImage(garbage.imagePath),
            fit: BoxFit.cover,
          ),
          border: Border.all(
            color: Colors.grey,
            width: 1,
          ),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            ClipRRect(
              borderRadius: const BorderRadius.only(
                bottomLeft: Radius.circular(28.5),
                bottomRight: Radius.circular(28.5),
              ),
              child: BackdropFilter(
                filter: ImageFilter.blur(sigmaX: 5, sigmaY: 5),
                child: Container(
                  color: Colors
                      .white, //TODO:blur not looking great remains white for now
                  child: Padding(
                    padding: const EdgeInsets.only(
                        left: 15, right: 15, top: 5, bottom: 5),
                    child: Row(children: [
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.start,
                              children: [
                                //insert a green icon of location here
                                Icon(
                                  Icons.location_on,
                                  color: Theme.of(context).primaryColor,
                                  size: 20,
                                ),
                                Flexible(
                                  child: Text(
                                    garbage.location.toUpperCase(),
                                    maxLines: 2,
                                    overflow: TextOverflow.ellipsis,
                                    style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      fontSize: 20,
                                      color: Theme.of(context).primaryColor,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                            Padding(
                              padding: const EdgeInsets.only(left: 7),
                              child: Text(
                                garbage.comment,
                                style: const TextStyle(
                                  fontSize: 15,
                                  fontWeight: FontWeight.normal,
                                ),
                              ),
                            )
                          ],
                        ),
                      ),
                      Column(
                        children: [
                          Text(
                            'Score',
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 20,
                              color: Theme.of(context).primaryColor,
                            ),
                          ),
                          // const Text(
                          //   '999',
                          //   //TODO: font doesnt look right
                          //   style: TextStyle(
                          //     fontSize: 15,
                          //     fontWeight: FontWeight.bold,
                          //   ),
                          // ),
                          StreamBuilder<DocumentSnapshot>(
                            stream: FirebaseFirestore.instance.collection('garbage').doc(garbage.id).snapshots(),
                            builder: (context, snapshot) {
                              if (!snapshot.hasData) {
                                return CircularProgressIndicator();
                              }

                              final updatedGarbage = Garbage.fromJson(snapshot.data!.data() as Map<String, dynamic>);
                              final score = updatedGarbage.likes.length - updatedGarbage.dislikes.length;
                              return Text(
                                '$score',
                                style: const TextStyle(
                                  fontSize: 15,
                                  fontWeight: FontWeight.bold,
                                ),
                              );
                            },
                          ),
                        ],
                      )
                    ]),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
