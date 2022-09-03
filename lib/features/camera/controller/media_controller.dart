import 'dart:io';
import 'dart:typed_data';
import 'package:mysocial_app/features/camera/api/camera_api.dart';
import 'package:path_provider/path_provider.dart';
import 'package:photo_manager/photo_manager.dart';
import 'package:path/path.dart' as path;
import 'package:video_thumbnail/video_thumbnail.dart';

class MediaController {
  Future createPost({Map<String, dynamic> data}) async {
    CameraApi postsApi = CameraApi();
    return await postsApi.createPost(data: data);
  }

  Future<File> getLastImage() async {
    final Directory extDir = await getApplicationDocumentsDirectory();
    final String dirPath = '${extDir.path}/media';
    final myDir = Directory(dirPath);
    List<FileSystemEntity> _images;
    _images = myDir.listSync(recursive: true, followLinks: false);
    _images.sort((a, b) {
      return b.path.compareTo(a.path);
    });
    var lastFile = _images[0];
    var extension = path.extension(lastFile.path);
    if (extension == '.jpeg') {
      return lastFile;
    } else {
      Uint8List thumb = await VideoThumbnail.thumbnailData(
          video: lastFile.path, imageFormat: ImageFormat.JPEG, quality: 30);
      return File.fromRawPath(thumb);
    }
  }

  Future<void> deleteFile(String path) async {
    final dir = Directory(path);
    dir.deleteSync(recursive: true);
    final Directory extDir = await getApplicationDocumentsDirectory();
    final String dirPath = '${extDir.path}/media';
    final myDir = Directory(dirPath);
    List<FileSystemEntity> _img;
    _img = myDir.listSync(recursive: true, followLinks: false);
    return _img;
  }

  Future<void> cleanEditFolder() async {
    final Directory extDir = await getApplicationDocumentsDirectory();
    final String dirPath = '${extDir.path}/media';
    final myDir = Directory(dirPath);
    //return myDir.deleteSync(recursive: true);
  }

  Future<List<Map>> copyFiles({List<AssetEntity> files}) async {
    List<Map> _images = [];
    for (var media in files) {
      await media.file.then((value) async {
        if (media == null) return null;
        final Directory appDir = await getApplicationDocumentsDirectory();
        final String dirPath = '${appDir.path}/media';
        await Directory(dirPath).create(recursive: true);
        String filePath = value.path.toString();
        String fileName = DateTime.now().millisecondsSinceEpoch.toString();
        File tmpFile = File(filePath);
        String type;
        String ext;
        String extension = path.extension(value.path);
        if (extension == '.jpeg' ||
            extension == '.jpg' ||
            extension == '.png' ||
            extension == '.webp') {
          type = 'image';
          ext = 'jpeg';
        }
        if (extension == '.3gp' ||
            extension == '.avi' ||
            extension == '.webmd' ||
            extension == '.mp4') {
          type = 'video';
          ext = 'mp4';
        }
        if (type == null || type == null) return;
        File file = await tmpFile.copy('$dirPath/$fileName.$ext');
        _images.add({
          'name': fileName,
          'path': filePath,
          'size': file.lengthSync(),
          'type': type,
          'ext': ext,
        });
      });
    }
    return _images;
  }

  Future<List<FileSystemEntity>> processAllImages(
      {List<AssetEntity> media}) async {
    List<Map> copiedFiles = await copyFiles(files: media);
    if (copiedFiles.isEmpty) return null;
    return await getAllImages();
  }

  Future<List<FileSystemEntity>> getAllImages() async {
    final Directory extDir = await getApplicationDocumentsDirectory();
    final String dirPath = '${extDir.path}/media';
    final myDir = Directory(dirPath);
    List<FileSystemEntity> _images;
    _images = myDir.listSync(recursive: true, followLinks: false);
    _images.sort((a, b) {
      return b.path.compareTo(a.path);
    });
    return _images;
  }
  //void compressImage() async {
  // print('starting compression');
  // final tempDir = await getTemporaryDirectory();
  // final path = tempDir.path;
  // int rand = Random().nextInt(10000);

  // Im.Image image = Im.decodeImage(widget.imageFile.readAsBytesSync());
  // Im.copyResize(image, 500);

  // var newim2 = new File('$path/img_$rand.jpg')
  //   ..writeAsBytesSync(Im.encodeJpg(image, quality: 85));

  // setState(() {
  //   widget.imageFile = newim2;
  // });
  // print('done');
// }

  //Future<List<Address>> locateUser() async {
  //   LocationData currentLocation;
  //   Future<List<Address>> addresses;

  //   var location = new Location();

  //   // Platform messages may fail, so we use a try/catch PlatformException.
  //   try {
  //     currentLocation = await location.getLocation();

  //     print(
  //         'LATITUDE : ${currentLocation.latitude} && LONGITUDE : ${currentLocation.longitude}');

  //     // From coordinates
  //     final coordinates =
  //         new Coordinates(currentLocation.latitude, currentLocation.longitude);

  //     addresses = Geocoder.local.findAddressesFromCoordinates(coordinates);
  //   } on PlatformException catch (e) {
  //     print('ERROR : $e');
  //     if (e.code == 'PERMISSION_DENIED') {
  //       print('Permission denied');
  //     }
  //     currentLocation = null;
  //   }
  //   return addresses;
  // }
}
