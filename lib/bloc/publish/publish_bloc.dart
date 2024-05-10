import 'dart:io';

import 'package:bloc/bloc.dart';
import 'package:exif/exif.dart';
import 'package:meta/meta.dart';
import 'package:path_provider/path_provider.dart';

import '../../models/garbage.dart';
import '../../repository/data_source.dart';

part 'publish_event.dart';
part 'publish_state.dart';

class PublishBloc extends Bloc<PublishEvent, PublishState> {
  final DataSource dataSource;
  PublishBloc(this.dataSource) : super(PublishInitialState()) {
    on<PublishGarbage>((event, emit) async {
      emit(PublishPublishingState());
      try {
        final imageFile = File(event.garbage.imagePath);
        final savedImage = await saveImage(imageFile);

        final exifData = await readExifData(savedImage.path);

        final garbage = Garbage(
          imagePath: savedImage.path,
          comment: event.garbage.comment,
          location: event.garbage.location,
          latitude: event.garbage.latitude,
          longitude: event.garbage.longitude,
        );

        await dataSource.insertGarbage(garbage);
        emit(PublishPublishedState(garbage));
      } catch (e) {
        emit(PublishInitialState());
      }
    });
  }

  Future<String> getApplicationDocumentsDirectoryPath() async {
    final directory = await getApplicationDocumentsDirectory();
    return directory.path;
  }

  Future<File> saveImage(File imageFile) async {
    final path = await getApplicationDocumentsDirectoryPath();
    final imageName = DateTime.now().millisecondsSinceEpoch;
    return await imageFile.copy('$path/$imageName.jpg');
  }
  Future<Map<String, IfdTag>> readExifData(String imagePath) async {
    final bytes = await File(imagePath).readAsBytes();
    return readExifFromBytes(bytes);
  }
  // Map<String, double> extractLocation(Map<String, IfdTag> data) {
  //   final gpsLat = data['GPS GPSLatitude'];
  //   final gpsLatRef = data['GPS GPSLatitudeRef'];
  //   final gpsLon = data['GPS GPSLongitude'];
  //   final gpsLonRef = data['GPS GPSLongitudeRef'];
  //
  //   double latitude = gpsLat != null ? convertRationalLatLon(gpsLat.values, gpsLatRef.printable) : 0.0;
  //   double longitude = gpsLon != null ? convertRationalLatLon(gpsLon.values, gpsLonRef.printable) : 0.0;
  //
  //   return {'latitude': latitude, 'longitude': longitude};
  // }
  // double convertRationalLatLon(List<Rational> rational, String ref) {
  //   double result = rational[0].toDouble() + rational[1].toDouble() / 60 + rational[2].toDouble() / 3600;
  //   return ref == 'S' || ref == 'W' ? -result : result;
  // }
}
