import 'package:flutter/material.dart';
import 'package:photo_manager/photo_manager.dart';

class MediaGalleryProvider with ChangeNotifier {
  List<AssetEntity> selectedMedias = <AssetEntity>[];
  final List<AssetType> mediaTypes = const <AssetType>[
    AssetType.image,
    AssetType.video,
  ];
  final int maxItems = 5;
  bool _isMultiple = false;

  bool get isMultiple => _isMultiple;
  set setMultiple(bool val) {
    _isMultiple = val;
    notifyListeners();
  }

  void add(AssetEntity media) {
    if (maxItems == null || selectedMedias.length < maxItems) {
      selectedMedias.add(media);
      notifyListeners();
    }
  }

  void remove(AssetEntity media) {
    selectedMedias.removeWhere((x) => x.id == media.id);
    notifyListeners();
  }

  void toggle(AssetEntity media) {
    if (contains(media)) {
      remove(media);
    } else {
      add(media);
    }
  }

  bool contains(AssetEntity media) {
    return selectedMedias.any((x) => x.id == media.id);
  }

  Future getMedias(int currentPage) async {
    var result = await PhotoManager.requestPermissionExtend();
    if (result.isAuth) {
      List<AssetPathEntity> albums =
          await PhotoManager.getAssetPathList(onlyAll: true);
      List<AssetEntity> media =
          await albums[0].getAssetListPaged(size: 100, page: currentPage);
      return media;
    } else {
      return await PhotoManager.openSetting();
    }
  }
}
