import 'dart:io';

import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';
import 'package:path_provider/path_provider.dart';
import 'package:provider/provider.dart';

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

        final garbage = Garbage(
          imagePath: savedImage.path,
          comment: event.garbage.comment,
          location: event.garbage.location,
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
}
