import 'dart:io';
import 'dart:ui';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/painting.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/widgets.dart';

import '../../models/garbage.dart';

class GarbageListItem extends StatelessWidget {
  final Garbage garbage;

  const GarbageListItem({super.key, required this.garbage});

  @override
  Widget build(BuildContext context) {
    const outerRadius = 30.0;
    const borderThickness = 1.0;
    return Container(
      height: 200,
      margin: const EdgeInsets.only(left:35, right: 35, top: 10, bottom: 10),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(outerRadius),
        image: DecorationImage(
          image: FileImage(File(garbage.imagePath)),
          fit: BoxFit.cover,
        ),
        border: Border.all(
          color: Colors.grey,
          width: 1,
        )
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
                color: Colors.white70,
                child: Stack(
                  children: [
                    //TODO: rework this mess listtitle is not the way to go...
                    ListTile(
                      title: Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            //insert a green icon of location here
                            Icon(Icons.location_on, color: Theme.of(context).primaryColor,
                              size: 20,
                            ),
                            Text(garbage.location.toUpperCase(),
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 20,
                                color: Theme.of(context).primaryColor,
                              ),
                            ),
                          ]
                      ),
                      subtitle: Padding(
                        padding: const EdgeInsets.only(left:5.0),
                        child: Text(garbage.comment,
                          style: const TextStyle(
                            fontSize: 15,
                            fontWeight: FontWeight.normal,
                          ),
                        ),
                      ),
                    ),
                    Align(
                      alignment: Alignment.topRight,
                      child: ListTile(
                        title: Text('Score',
                          textAlign: TextAlign.right,
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 20,
                            color: Theme.of(context).primaryColor,
                          ),
                        ),
                        subtitle: Text('999',
                          textAlign: TextAlign.right,
                          style: const TextStyle(
                            fontSize: 15,
                            fontWeight: FontWeight.normal,
                          ),
                        ),
                      ),
                    )

                  ]
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}