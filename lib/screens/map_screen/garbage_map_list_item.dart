import 'dart:ui';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../models/garbage.dart';
import '../../repository/data_source.dart';

class GarbageMapListItem extends StatelessWidget {
  final Garbage garbage;

  const GarbageMapListItem({super.key, required this.garbage});

  @override
  Widget build(BuildContext context) {
    final userId = FirebaseAuth.instance.currentUser!.uid;
    final dataSource = Provider.of<DataSource>(context, listen: false);

    const outerRadius = 30.0;
    return Container(
      height: 200,
      width: 300,
      margin: const EdgeInsets.only(left: 10, right: 10, top: 10, bottom: 10),
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
                    left: 15,
                    right: 15,
                    top: 5,
                    bottom: 5,
                  ),
                  child: Row(children: [
                    Expanded(
                      child: Text(
                        garbage.comment,
                        style: const TextStyle(
                          fontSize: 15,
                          fontWeight: FontWeight.normal,
                        ),
                      ),
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        //up arrow icon
                        IconButton(
                          icon: StreamBuilder<DocumentSnapshot>(
                            stream: FirebaseFirestore.instance
                                .collection('garbage')
                                .doc(garbage.id)
                                .snapshots(),
                            builder: (context, snapshot) {
                              if (!snapshot.hasData) {
                                return const CircularProgressIndicator();
                              }

                              final updatedGarbage = Garbage.fromJson(
                                  snapshot.data!.data()
                                      as Map<String, dynamic>);
                              return Icon(
                                updatedGarbage.likes.contains(userId)
                                    ? Icons.thumb_up
                                    : Icons.thumb_up_outlined,
                                color: Colors.green,
                              );
                            },
                          ),
                          onPressed: () =>
                              dataSource.likeGarbage(garbage.id!, userId),
                        ),
                        const SizedBox(width: 5),
                        StreamBuilder<DocumentSnapshot>(
                          stream: FirebaseFirestore.instance
                              .collection('garbage')
                              .doc(garbage.id)
                              .snapshots(),
                          builder: (context, snapshot) {
                            if (!snapshot.hasData) {
                              return const CircularProgressIndicator();
                            }

                            final updatedGarbage = Garbage.fromJson(
                                snapshot.data!.data() as Map<String, dynamic>);
                            final score = updatedGarbage.likes.length -
                                updatedGarbage.dislikes.length;
                            return Text(
                              '$score',
                              style: const TextStyle(
                                fontSize: 15,
                                fontWeight: FontWeight.bold,
                              ),
                            );
                          },
                        ),
                        const SizedBox(width: 5),
                        //down arrow icon
                        IconButton(
                          icon: StreamBuilder<DocumentSnapshot>(
                            stream: FirebaseFirestore.instance
                                .collection('garbage')
                                .doc(garbage.id)
                                .snapshots(),
                            builder: (context, snapshot) {
                              if (!snapshot.hasData) {
                                return const CircularProgressIndicator();
                              }

                              final updatedGarbage = Garbage.fromJson(
                                  snapshot.data!.data()
                                      as Map<String, dynamic>);
                              return Icon(
                                updatedGarbage.dislikes.contains(userId)
                                    ? Icons.thumb_down
                                    : Icons.thumb_down_outlined,
                                color: Colors.red,
                              );
                            },
                          ),
                          onPressed: () =>
                              dataSource.dislikeGarbage(garbage.id!, userId),
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
    );
  }
}
