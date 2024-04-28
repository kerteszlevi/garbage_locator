// import 'package:flutter/material.dart';
// import 'package:flutter/rendering.dart';
// import 'package:garbage_locator/services/photo_service.dart';

// class PhotoProvider extends InheritedWidget {
//   final PhotoService photoService;

//   PhotoProvider({
//     required this.photoService,
//     required Widget child,
//   }) : super(child: child);

//   static PhotoService of(BuildContext context) {
//     final provider =
//         context.dependOnInheritedWidgetOfExactType<PhotoProvider>();
//     return provider!.photoService;
//   }

//   @override
//   bool updateShouldNotify(PhotoProvider oldWidget) {
//     return oldWidget.photoService != photoService;
//   }
// }
