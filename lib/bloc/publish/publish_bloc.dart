import 'dart:async';
import 'dart:io';

import 'package:bloc/bloc.dart';
import 'package:exif/exif.dart';
import 'package:meta/meta.dart';
import 'package:path_provider/path_provider.dart';
import 'package:uuid/uuid.dart';

import '../../models/garbage.dart';
import '../../repository/data_source.dart';
import '../../utils.dart';

part 'publish_event.dart';
part 'publish_state.dart';

class PublishBloc extends Bloc<PublishEvent, PublishState> {
  final DataSource dataSource;
  PublishBloc(this.dataSource) : super(PublishInitialState()) {
    on<PublishGarbage>((event, emit) async {
      emit(PublishPublishingState());
      try {
        emit(PublishSavingImageState());
        final imageFile = File(event.garbage.imagePath);
        final savedImage = await saveImage(imageFile);

        final exifData = await readExifData(savedImage.path);
        //TODO: extract location from image exif, or disable gallery import option alltogether

        //get location of the user
        emit(PublishGettingLocationState());
        final locationData = await getCurrentLocation();
        String placemarkString;
        emit(PublishGettingPlacemarkState());
        placemarkString = await getPlacemarkString(
            locationData?.latitude, locationData?.longitude);

        final garbage = Garbage(
          imagePath: savedImage.path,
          comment: event.garbage.comment,
          location: placemarkString,
          latitude: locationData?.latitude,
          longitude: locationData?.longitude,
          id: const Uuid().v4(),
        );

        emit(PublishUploadingState());
        await dataSource.insertGarbage(garbage);
        emit(PublishPublishedState());
        print("publish supposed to be done");
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
}
