import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_phosphor_icons/flutter_phosphor_icons.dart';
import 'package:mysocial_app/core/components/buttons/primaryButton.dart';
import 'package:mysocial_app/features/camera/camera.dart';
import 'package:mysocial_app/features/camera/views/publish_page.dart';

import 'package:path/path.dart' as path;
import 'package:photo_manager/photo_manager.dart';
import 'package:provider/provider.dart';
import 'package:video_player/video_player.dart';

class CameraPreviewPage extends StatefulWidget {
  List<AssetEntity> selectedMedias;
  CameraPreviewPage({this.selectedMedias});

  @override
  State<CameraPreviewPage> createState() => _CameraPreviewPageState();
}

class _CameraPreviewPageState extends State<CameraPreviewPage> {
  MediaGalleryProvider mediaGalleryProvider;
  MediaController mediaController = MediaController();
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
  }

  @override
  void didChangeDependencies() {
    // TODO: implement didChangeDependencies
    super.didChangeDependencies();
    mediaGalleryProvider = context.read<MediaGalleryProvider>();
  }

  String currentFile;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: SafeArea(
        top: false,
        child: Column(
          children: [
            Expanded(
              child: Stack(
                children: [
                  FutureBuilder(
                    future: mediaController.processAllImages(
                        media: widget.selectedMedias),
                    builder: (context,
                        AsyncSnapshot<List<FileSystemEntity>> snapshot) {
                      // if (snapshot.connectionState == ConnectionState.waiting) {
                      //   return const Center(
                      //     child: CircularProgressIndicator(),
                      //   );
                      // } else {
                      //   if (snapshot.error != null) {
                      //     return const Center(
                      //       child: Text('An error occured'),
                      //     );
                      //   } else {
                      //     return null;
                      //   }
                      // }
                      if (!snapshot.hasData || snapshot.data.isEmpty) {
                        return const Center(
                          child: Text('No data.'),
                        );
                      }
                      if (snapshot.data.isEmpty) {
                        return const Center(
                          child: Text('No images found.'),
                        );
                      }
                      return PageView.builder(
                        itemCount: snapshot.data.length,
                        itemBuilder: (context, index) {
                          currentFile = snapshot.data[index].path;
                          var extension =
                              path.extension(snapshot.data[index].path);
                          if (extension == '.jpeg' ||
                              extension == '.jpg' ||
                              extension == '.png' ||
                              extension == '.webp') {
                            return Container(
                              height: 300,
                              padding: const EdgeInsets.only(bottom: 8.0),
                              child: Image.file(
                                File(snapshot.data[index].path),
                                fit: BoxFit.cover,
                              ),
                            );
                          } else {
                            return VideoPreview(
                              videoPath: snapshot.data[index].path,
                            );
                          }
                        },
                      );
                    },
                  ),
                  Padding(
                    padding: const EdgeInsets.only(
                        top: 60, bottom: 20, left: 10, right: 10),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Align(
                          alignment: Alignment.topLeft,
                          child: Container(
                            height: 40,
                            width: 40,
                            decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(25),
                                color: Colors.black.withOpacity(0.3)),
                            child: IconButton(
                                padding: const EdgeInsets.all(0),
                                icon: const Icon(PhosphorIcons.x_bold,
                                    size: 23, color: Colors.white),
                                onPressed: () {
                                  mediaController.cleanEditFolder();
                                  Navigator.pop(context);
                                }),
                          ),
                        ),
                        Align(
                          alignment: Alignment.topRight,
                          child: Container(
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 0, vertical: 17),
                              decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(25),
                                  color: Colors.black.withOpacity(0.3)),
                              child: SingleChildScrollView(
                                child: Column(
                                  children: [
                                    IconButton(
                                        icon: const Icon(Icons.crop_rotate,
                                            size: 27, color: Colors.white),
                                        onPressed: () {}),
                                    IconButton(
                                        icon: const Icon(
                                            Icons.emoji_emotions_outlined,
                                            size: 27,
                                            color: Colors.white),
                                        onPressed: () {}),
                                    IconButton(
                                        icon: const Icon(Icons.title,
                                            size: 27, color: Colors.white),
                                        onPressed: () {}),
                                    IconButton(
                                        icon: const Icon(Icons.edit,
                                            size: 27, color: Colors.white),
                                        onPressed: () {}),
                                    IconButton(
                                        icon: const Icon(Icons.delete,
                                            size: 27, color: Colors.white),
                                        onPressed: () {
                                          mediaController
                                              .deleteFile(currentFile);
                                        }),
                                  ],
                                ),
                              )),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
              color: Colors.black,
              child: Row(
                children: [
                  Expanded(
                    child: PrimaryButton(
                      onPressed: () => null,
                      text: 'Post to Story',
                      type: "white",
                    ),
                  ),
                  const SizedBox(
                    width: 15,
                  ),
                  Expanded(
                    child: PrimaryButton(
                      onPressed: () => Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (builder) => const PuplishPostPage())),
                      text: 'Next',
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class VideoPreview extends StatefulWidget {
  const VideoPreview({this.videoPath});

  final String videoPath;
  @override
  _VideoPreviewState createState() => _VideoPreviewState();
}

class _VideoPreviewState extends State<VideoPreview>
    with SingleTickerProviderStateMixin {
  AnimationController _animationController;
  VideoPlayerController _controller;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 300),
    );
    _controller = VideoPlayerController.file(File(widget.videoPath))
      ..initialize().then(
        (_) {
          setState(() {});
        },
      );
  }

  @override
  void dispose() {
    _animationController?.dispose();
    _controller?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    if (_controller.value.isInitialized) {
      return Stack(
        children: <Widget>[
          ClipRect(
            child: Container(
              child: Transform.scale(
                scale: _controller.value.aspectRatio / size.aspectRatio,
                child: Center(
                  child: AspectRatio(
                    aspectRatio: _controller.value.aspectRatio,
                    child: VideoPlayer(_controller),
                  ),
                ),
              ),
            ),
          ),
          Positioned(
            bottom: 0,
            left: 0,
            right: 0,
            child: VideoControls(
              videoController: _controller,
            ),
          ),
        ],
      );
    } else {
      return Container();
    }
  }
}

class VideoControls extends StatefulWidget {
  const VideoControls({this.videoController});

  final VideoPlayerController videoController;

  @override
  _VideoControlsState createState() => _VideoControlsState();
}

class _VideoControlsState extends State<VideoControls>
    with SingleTickerProviderStateMixin {
  AnimationController _animationController;

  @override
  void initState() {
    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 300),
    );
    widget.videoController.addListener(_videoListener);
    widget.videoController.setLooping(true);
    super.initState();
  }

  @override
  void dispose() {
    _animationController?.dispose();
    widget.videoController?.removeListener(_videoListener);
    super.dispose();
  }

  void _videoListener() {
    (widget.videoController.value.isPlaying)
        ? _animationController.forward()
        : _animationController.reverse();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 80,
      color: const Color(0x40000000),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: <Widget>[
          Padding(
            padding: const EdgeInsets.only(left: 16.0, right: 16.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: <Widget>[
                const Text(
                  '0:00',
                  style: TextStyle(color: Colors.white),
                ),
                Expanded(
                  child: VideoProgressIndicator(
                    widget.videoController,
                    allowScrubbing: true,
                    padding: const EdgeInsets.only(left: 8.0, right: 8.0),
                    colors: const VideoProgressColors(
                      playedColor: Colors.white,
                    ),
                  ),
                ),
                Text(
                  timeFormatter(widget.videoController.value.duration),
                  style: const TextStyle(color: Colors.white),
                ),
              ],
            ),
          ),
          Center(
            child: IconButton(
              iconSize: 40,
              icon: AnimatedIcon(
                icon: AnimatedIcons.play_pause,
                progress: _animationController,
                color: Colors.white,
              ),
              onPressed: _handleOnPressed,
            ),
          )
        ],
      ),
    );
  }

  String timeFormatter(Duration duration) {
    return [
      if (duration.inHours != 0) duration.inHours,
      duration.inMinutes,
      duration.inSeconds,
    ].map((seg) => seg.remainder(60).toString().padLeft(2, '0')).join(':');
  }

  void _handleOnPressed() {
    widget.videoController.value.isPlaying ? _pauseVideo() : _playVideo();
  }

  void _playVideo() {
    _animationController.forward();
    widget.videoController.play();
  }

  void _pauseVideo() {
    _animationController.reverse();
    widget.videoController.pause();
  }
}
