import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_phosphor_icons/flutter_phosphor_icons.dart';
import 'package:mysocial_app/features/camera/camera.dart';
import 'package:mysocial_app/features/camera/views/preview_screen.dart';
import 'package:photo_manager/photo_manager.dart';
import 'package:provider/provider.dart';

class GalleryScreen extends StatefulWidget {
  @override
  _MediaGridState createState() => _MediaGridState();
}

class _MediaGridState extends State<GalleryScreen> {
  final List<Widget> _mediaList = [];
  int currentPage = 0;
  int lastPage;
  @override
  void initState() {
    super.initState();
    _cleanUp();
  }

  MediaGalleryProvider mediaGalleryProvider;

  MediaController mediaController = MediaController();
  @override
  Future<void> didChangeDependencies() {
    super.didChangeDependencies();
    _fetchNewMedia();
  }

  _cleanUp() async {
    await mediaController.cleanEditFolder();
  }

  _handleScrollEvent(ScrollNotification scroll) {
    if (scroll.metrics.pixels / scroll.metrics.maxScrollExtent > 0.33) {
      if (currentPage != lastPage) {
        _fetchNewMedia();
      }
    }
  }

  _fetchNewMedia() async {
    lastPage = currentPage;
    mediaGalleryProvider = context.watch<MediaGalleryProvider>();
    var media = await mediaGalleryProvider.getMedias(currentPage);
    List<Widget> temp = [];
    for (var asset in media) {
      temp.add(
        FutureBuilder(
          future: asset.thumbnailDataWithSize(const ThumbnailSize(200, 100)),
          builder: (BuildContext context, snapshot) {
            if (snapshot.connectionState == ConnectionState.done) {
              return AnimatedBuilder(
                  key: Key(asset.id),
                  animation: mediaGalleryProvider,
                  builder: (context, _) {
                    return GestureDetector(
                      onTap: () {
                        if (mediaGalleryProvider.isMultiple) {
                          mediaGalleryProvider.toggle(asset);
                          if (mediaGalleryProvider.selectedMedias.isEmpty) {
                            mediaGalleryProvider.setMultiple = false;
                          }
                        } else {
                          mediaGalleryProvider.toggle(asset);
                          if (mediaGalleryProvider.selectedMedias.isEmpty) {
                            return;
                          }
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (builder) => CameraPreviewPage(
                                        selectedMedias:
                                            mediaGalleryProvider.selectedMedias,
                                      )));
                        }
                        if (asset.type == AssetType.image) {
                        } else {}
                      },
                      onLongPress: () {
                        if (mediaGalleryProvider.isMultiple) return;
                        if (mediaGalleryProvider.selectedMedias.isNotEmpty) {
                          return;
                        }
                        mediaGalleryProvider.setMultiple = true;
                        mediaGalleryProvider.toggle(asset);
                        //if selected list is empty and miltiselect = false
                        //seyt multiselect to true
                        //add current item to selected list
                      },
                      child: Selectable(
                        isSelected: mediaGalleryProvider.contains(asset),
                        child: Stack(
                          children: <Widget>[
                            Positioned.fill(
                              child: Image.memory(
                                snapshot.data,
                                fit: BoxFit.cover,
                              ),
                            ),
                            if (asset.type == AssetType.video)
                              const Align(
                                alignment: Alignment.bottomRight,
                                child: Padding(
                                  padding: EdgeInsets.only(right: 5, bottom: 5),
                                  child: Icon(
                                    Icons.videocam,
                                    color: Colors.white,
                                  ),
                                ),
                              ),
                          ],
                        ),
                      ),
                    );
                  });
            }
            return Container();
          },
        ),
      );
    }
    setState(() {
      _mediaList.addAll(temp);
      currentPage++;
    });
  }

  @override
  Widget build(BuildContext context) {
    final selection = context.watch<MediaGalleryProvider>();
    return NotificationListener<ScrollNotification>(
      onNotification: (ScrollNotification scroll) {
        _handleScrollEvent(scroll);
        return;
      },
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: selection.selectedMedias.isEmpty
              ? Colors.transparent
              : Theme.of(context).primaryColor,
          iconTheme: IconThemeData(
              color: selection.selectedMedias.isEmpty
                  ? Theme.of(context).primaryColor
                  : Colors.white),
          centerTitle: false,
          title: Text(
            selection.selectedMedias.isEmpty
                ? 'Gallery'
                : '${selection.selectedMedias.length} selected',
            style: TextStyle(
                color: selection.selectedMedias.isEmpty
                    ? Theme.of(context).primaryColor
                    : Colors.white),
          ),
          leading: TextButton(
            onPressed: () {
              Navigator.pop(context);
            },
            child: Platform.isAndroid
                ? Icon(Icons.arrow_back,
                    color: selection.selectedMedias.isEmpty
                        ? Theme.of(context).primaryColor
                        : Colors.white)
                : Icon(Icons.arrow_back_ios,
                    color: selection.selectedMedias.isEmpty
                        ? Theme.of(context).primaryColor
                        : Colors.white),
          ),
          automaticallyImplyLeading: false,
          elevation: 0,
          actions: [
            TextButton(
              onPressed: selection.selectedMedias.isEmpty
                  ? null
                  : () {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (builder) => CameraPreviewPage(
                                    selectedMedias: selection.selectedMedias,
                                  )));
                    },
              child: selection.selectedMedias.isEmpty
                  ? Icon(PhosphorIcons.list_checks_bold,
                      color: selection.selectedMedias.isEmpty
                          ? Theme.of(context).primaryColor
                          : Colors.white)
                  : Text(
                      'OK',
                      style: TextStyle(
                          color: selection.selectedMedias.isEmpty
                              ? Theme.of(context).primaryColor
                              : Colors.white),
                    ),
            )
          ],
        ),
        body: GridView.builder(
            itemCount: _mediaList.length,
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 3),
            itemBuilder: (BuildContext context, int index) {
              return _mediaList[index];
            }),
      ),
    );
  }
}

class Selectable extends StatelessWidget {
  final bool isSelected;
  final Widget child;

  const Selectable({
    Key key,
    @required this.isSelected,
    @required this.child,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    const minScale = 0.75;
    const duration = Duration(milliseconds: 100);
    //final theme = Theme.of(context);
    return LayoutBuilder(
      builder: (context, constraints) {
        final translate = isSelected ? (1.0 - minScale) * 0.5 : 0.0;
        return AnimatedContainer(
          duration: duration,
          curve: Curves.easeInOutCubic,
          alignment: Alignment.center,
          transform: Matrix4.identity()
            ..translate(translate, translate)
            ..scale(isSelected ? 1.0 : 1.0),
          child: Stack(
            children: <Widget>[
              Positioned.fill(
                child: child,
              ),
              Positioned.fill(
                child: AnimatedContainer(
                  duration: duration,
                  curve: Curves.easeInOut,
                  color: Colors.grey.withOpacity(isSelected ? 0.4 : 0),
                ),
              ),
              AnimatedOpacity(
                duration: duration,
                opacity: isSelected ? 1.0 : 0.0,
                child: const Center(
                  child: Padding(
                    padding: EdgeInsets.all(4.0),
                    child: Icon(
                      Icons.check,
                      key: Key("checkmark"),
                      color: Colors.white,
                      size: 32,
                    ),
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}
