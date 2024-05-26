import 'dart:ui';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/painting.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_svg/svg.dart';

import '../../models/garbage.dart';

class GarbageMapListItem extends StatelessWidget {
  final Garbage garbage;

  const GarbageMapListItem({super.key, required this.garbage});

  @override
  Widget build(BuildContext context) {
    const outerRadius = 30.0;
    const borderThickness = 1.0;
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
                        SvgPicture.asset(
                          'assets/vector/uparrow.svg',
                          height: 20,
                          width: 20,
                        ),
                        const SizedBox(width: 5),
                        const Text(
                          '999',
                          //TODO: font doesnt look right
                          style: TextStyle(
                            fontSize: 15,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(width: 5),
                        SvgPicture.asset(
                          'assets/vector/downarrow.svg',
                          height: 20,
                          width: 20,
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
