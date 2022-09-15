import 'dart:developer';
import 'dart:io';

import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:modal_bottom_sheet/modal_bottom_sheet.dart';
import 'package:mysocial_app/core/constants/constants.dart';
import 'package:mysocial_app/features/camera/camera.dart';
import 'package:mysocial_app/features/camera/views/gallery_screen.dart';
import 'package:path_provider/path_provider.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:video_player/video_player.dart';

class CameraScreen extends StatefulWidget {
  @override
  _CameraScreenState createState() => _CameraScreenState();
}

class _CameraScreenState extends State<CameraScreen>
    with WidgetsBindingObserver {
  CameraController controller;
  VideoPlayerController videoController;

  // Initial values
  bool _isCameraInitialized = false;
  bool _isCameraPermissionGranted = false;
  bool _isFrontCamera = true;
  bool _isRecording = false;

  double _minAvailableZoom = 1.0;
  double _maxAvailableZoom = 1.0;

  // Current values
  double _currentZoomLevel = 1.0;
  bool _flash = false;

  ResolutionPreset currentResolutionPreset = ResolutionPreset.max;

  getPermissionStatus() async {
    await Permission.camera.request();
    await Permission.camera.status.then((status) {
      if (status.isGranted) {
        setState(() {
          _isCameraPermissionGranted = true;
        });
        // Set and initialize the new camera
        onNewCameraSelected(cameras[0]);
        refreshAlreadyCapturedImages();
      } else {
        log('Camera Permission: DENIED');
      }
    });
  }

  List<File> allFileList = [];
  File _imageFile;
  File _videoFile;
  refreshAlreadyCapturedImages() async {
    final directory = await getApplicationDocumentsDirectory();
    List<FileSystemEntity> fileList = await directory.list().toList();
    allFileList.clear();
    List<Map<int, dynamic>> fileNames = [];

    for (var file in fileList) {
      if (file.path.contains('.jpeg') ||
          file.path.contains('.jpg') ||
          file.path.contains('.mp4')) {
        allFileList.add(File(file.path));

        String name = file.path.split('/').last.split('.').first;
        fileNames.add({0: name.toString(), 1: file.path.split('/').last});
      }
    }

    if (fileNames.isNotEmpty) {
      final recentFile =
          fileNames.reduce((curr, next) => curr[0] > next[0] ? curr : next);
      String recentFileName = recentFile[1];
      if (recentFileName.contains('.mp4')) {
        _videoFile = File('${directory.path}/$recentFileName');
        _imageFile = null;
        _startVideoPlayer();
      } else {
        _imageFile = File('${directory.path}/$recentFileName');
        _videoFile = null;
      }
      setState(() {});
    }
  }

  Future<void> _startVideoPlayer() async {
    //final previousCameraController = controller;
    if (_videoFile != null) {
      videoController = VideoPlayerController.file(_videoFile);
      await videoController.initialize().then((_) {
        // Ensure the first frame is shown after the video is initialized,
        // even before the play button has been pressed.
        setState(() {});
      });
      await videoController.setLooping(true);
      await videoController.play();
    }
  }

  Future<void> startVideoRecording() async {
    if (!controller.value.isInitialized || controller.value.isRecordingVideo) {
      return;
    }

    try {
      await controller.startVideoRecording();
      _timerKey.currentState.startTimer();
      setState(() => _isRecording = true);
    } on CameraException catch (e) {
      print('Error starting to record video: $e');
    }
  }

  Future<void> takePhoto() async {
    final CameraController cameraController = controller;
    if (!cameraController.value.isInitialized ||
        cameraController.value.isTakingPicture) return;
    SystemSound.play(SystemSoundType.click);
    await cameraController.takePicture().then((XFile image) async {
      if (image == null) return null;
      File tmpFile = File(image.path);
      //String fileName = image.path.split('/').last;
      final Directory appDir = await getApplicationDocumentsDirectory();
      final String dirPath = '${appDir.path}/media';
      await Directory(dirPath).create(recursive: true);
      String currentUnix = DateTime.now().millisecondsSinceEpoch.toString();
      File file = await tmpFile.copy('$dirPath/$currentUnix.jpeg');
      // return Navigator.push(context,
      //     MaterialPageRoute(builder: (builder) => const CameraPreviewPage()));
    });

    //refreshAlreadyCapturedImages();
  }

  Future<void> stopVideoRecording() async {
    // _startVideoPlayer();
    if (!controller.value.isRecordingVideo) return;
    _timerKey.currentState.stopTimer();
    setState(() => _isRecording = false);
    try {
      await controller.stopVideoRecording().then((XFile video) async {
        if (video == null) return null;
        File tmpFile = File(video.path);
        //String fileName = video.path.split('/').last;
        final Directory appDir = await getApplicationDocumentsDirectory();
        final String dirPath = '${appDir.path}/media';
        await Directory(dirPath).create(recursive: true);
        String currentUnix = DateTime.now().millisecondsSinceEpoch.toString();
        File file = await tmpFile.copy('$dirPath/$currentUnix.mp4');
      });
    } on CameraException catch (e) {
      print('Error stopping video recording: $e');
      return;
    }
  }

  Future<void> pauseVideoRecording() async {
    if (!controller.value.isRecordingVideo) {
      return;
    }

    try {
      await controller.pauseVideoRecording();
    } on CameraException catch (e) {
      print('Error pausing video recording: $e');
    }
  }

  Future<void> resumeVideoRecording() async {
    if (!controller.value.isRecordingVideo) {
      return;
    }

    try {
      await controller.resumeVideoRecording();
    } on CameraException catch (e) {
      print('Error resuming video recording: $e');
    }
  }

  void resetCameraValues() async {
    _currentZoomLevel = 1.0;
  }

  void onNewCameraSelected(CameraDescription cameraDescription) async {
    final previousCameraController = controller;

    final CameraController cameraController = CameraController(
      cameraDescription,
      currentResolutionPreset,
      imageFormatGroup: ImageFormatGroup.jpeg,
    );

    await previousCameraController?.dispose();

    resetCameraValues();

    if (mounted) {
      setState(() {
        controller = cameraController;
      });
    }

    // Update UI if controller updated
    cameraController.addListener(() {
      if (mounted) setState(() {});
    });

    try {
      await cameraController.initialize();
      await Future.wait([
        // cameraController
        //     .getMinExposureOffset()
        //     .then((value) => _minAvailableExposureOffset = value),
        // cameraController
        //     .getMaxExposureOffset()
        //     .then((value) => _maxAvailableExposureOffset = value),
        cameraController
            .getMaxZoomLevel()
            .then((value) => _maxAvailableZoom = value),
        cameraController
            .getMinZoomLevel()
            .then((value) => _minAvailableZoom = value),
      ]);

      _flash = false;
    } on CameraException catch (e) {
      print('Error initializing camera: $e');
    }

    if (mounted) {
      setState(() {
        _isCameraInitialized = controller.value.isInitialized;
      });
    }
  }

//focuser
  void onViewFinderTap(TapDownDetails details, BoxConstraints constraints) {
    if (controller == null) {
      return;
    }
    final offset = Offset(
      details.localPosition.dx / constraints.maxWidth,
      details.localPosition.dy / constraints.maxHeight,
    );
    controller.setExposurePoint(offset);
    controller.setFocusPoint(offset);
  }

  @override
  void initState() {
    //Hide the status bar in Android
    SystemChrome.setEnabledSystemUIMode(SystemUiMode.manual, overlays: []);
    getPermissionStatus();
    super.initState();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    final CameraController cameraController = controller;

    // App state changed before we got the chance to initialize.
    if (cameraController == null || !cameraController.value.isInitialized) {
      return;
    }

    if (state == AppLifecycleState.inactive) {
      cameraController.dispose();
    } else if (state == AppLifecycleState.resumed) {
      onNewCameraSelected(cameraController.description);
    }
  }

  @override
  void dispose() {
    controller.dispose();
    videoController.dispose();
    super.dispose();
  }

  @override
  bool get wantKeepAlive => true;

  final _timerKey = GlobalKey<VideoTimerState>();

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return Scaffold(
        backgroundColor: Colors.black,
        body: SafeArea(
          top: false,
          child: _isCameraPermissionGranted
              ? _isCameraInitialized
                  ? Stack(
                      children: [
                        ClipRect(
                          child: Container(
                            child: Transform.scale(
                              scale: controller.value.aspectRatio /
                                  size.aspectRatio,
                              child: Center(
                                child: AspectRatio(
                                  aspectRatio: controller.value.aspectRatio,
                                  child: CameraPreview(
                                    controller,
                                    child: LayoutBuilder(builder:
                                        (BuildContext context,
                                            BoxConstraints constraints) {
                                      return GestureDetector(
                                        behavior: HitTestBehavior.opaque,
                                        onTapDown: (details) => onViewFinderTap(
                                            details, constraints),
                                      );
                                    }),
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ),

                        // CameraPreview(
                        //   controller,
                        //   child: LayoutBuilder(builder: (BuildContext context,
                        //       BoxConstraints constraints) {
                        //     return GestureDetector(
                        //       behavior: HitTestBehavior.opaque,
                        //       onTapDown: (details) =>
                        //           onViewFinderTap(details, constraints),
                        //     );
                        //   }),
                        // ),
                        Container(
                          padding: const EdgeInsets.only(
                              left: 20, right: 20, top: 20, bottom: 8),
                          child: Column(
                            children: [
                              if (!_isRecording)
                                Align(
                                  alignment: Alignment.topCenter,
                                  child: VideoTimer(
                                    key: _timerKey,
                                  ),
                                ),
                              Align(
                                alignment: Alignment.topRight,
                                child: Container(
                                    padding: const EdgeInsets.symmetric(
                                        horizontal: 7, vertical: 17),
                                    decoration: BoxDecoration(
                                        borderRadius: BorderRadius.circular(25),
                                        color: Colors.black.withOpacity(0.2)),
                                    child: Column(
                                      children: [
                                        InkWell(
                                          onTap: () async {
                                            setState(() {
                                              _flash = !_flash;
                                            });
                                            _flash
                                                ? await controller.setFlashMode(
                                                    FlashMode.torch)
                                                : await controller.setFlashMode(
                                                    FlashMode.off);
                                            await controller.setFlashMode(
                                              FlashMode.off,
                                            );
                                          },
                                          child: Column(
                                            children: [
                                              Icon(
                                                _flash
                                                    ? Icons.flash_on
                                                    : Icons.flash_off,
                                                color: _flash
                                                    ? Colors.amber
                                                    : Colors.white,
                                                size: 20,
                                              ),
                                              Text(
                                                'Flash',
                                                style: TextStyle(
                                                    fontSize: 11,
                                                    color: _flash
                                                        ? Colors.amber
                                                        : Colors.white),
                                              )
                                            ],
                                          ),
                                        ),
                                        Column(
                                          children: [
                                            RotatedBox(
                                              quarterTurns: 3,
                                              child: SizedBox(
                                                height: 30,
                                                width: 150,
                                                child: Slider(
                                                  value: _currentZoomLevel,
                                                  min: _minAvailableZoom,
                                                  max: _maxAvailableZoom,
                                                  activeColor: Colors.white,
                                                  inactiveColor: Colors.white30,
                                                  onChanged: (value) async {
                                                    setState(() {
                                                      _currentZoomLevel = value;
                                                    });
                                                    await controller
                                                        .setZoomLevel(value);
                                                  },
                                                ),
                                              ),
                                            ),
                                            const Text(
                                              'Zoom',
                                              style: TextStyle(
                                                  fontSize: 11,
                                                  color: Colors.white),
                                            ),
                                            const SizedBox(
                                              height: 5,
                                            ),
                                            Container(
                                              decoration: BoxDecoration(
                                                color: Colors.black87,
                                                borderRadius:
                                                    BorderRadius.circular(10.0),
                                              ),
                                              child: Padding(
                                                padding:
                                                    const EdgeInsets.symmetric(
                                                        horizontal: 6.0,
                                                        vertical: 4),
                                                child: Text(
                                                  _currentZoomLevel
                                                          .toStringAsFixed(0) +
                                                      'x',
                                                  style: const TextStyle(
                                                    color: Colors.white,
                                                    fontSize: 11,
                                                  ),
                                                ),
                                              ),
                                            ),
                                          ],
                                        ),
                                      ],
                                    )),
                              ),
                              const Spacer(),
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  InkWell(
                                    onTap: () {
                                      showMaterialModalBottomSheet(
                                        context: context,
                                        builder: (context) => GalleryScreen(),
                                      );
                                    },
                                    child: Column(
                                      children: [
                                        Container(
                                          width: 40,
                                          height: 40,
                                          decoration: BoxDecoration(
                                            color: Colors.black,
                                            borderRadius:
                                                BorderRadius.circular(10.0),
                                            border: Border.all(
                                              color: Colors.white,
                                              width: 2,
                                            ),
                                            image: _imageFile != null
                                                ? DecorationImage(
                                                    image:
                                                        FileImage(_imageFile),
                                                    fit: BoxFit.cover,
                                                  )
                                                : null,
                                          ),
                                          child: videoController != null &&
                                                  videoController
                                                      .value.isInitialized
                                              ? ClipRRect(
                                                  borderRadius:
                                                      BorderRadius.circular(
                                                          8.0),
                                                  child: AspectRatio(
                                                    aspectRatio: videoController
                                                        .value.aspectRatio,
                                                    child: VideoPlayer(
                                                        videoController),
                                                  ),
                                                )
                                              : Container(),
                                        ),
                                        const SizedBox(
                                          height: 5,
                                        ),
                                        const Text(
                                          "Upload",
                                          style: TextStyle(
                                            color: Colors.white,
                                          ),
                                          textAlign: TextAlign.center,
                                        )
                                      ],
                                    ),
                                  ),
                                  GestureDetector(
                                    onLongPress: () async {
                                      if (!_isRecording) {
                                        await startVideoRecording();
                                      }
                                    },
                                    onTap: () async {
                                      if (_isRecording) {
                                        await stopVideoRecording();
                                      } else {
                                        await takePhoto();
                                      }
                                    },
                                    child: Stack(
                                      alignment: Alignment.center,
                                      children: [
                                        Icon(
                                          Icons.circle,
                                          color: _isRecording
                                              ? Colors.white
                                              : Colors.white38,
                                          size: 80,
                                        ),
                                        Icon(
                                          Icons.circle,
                                          color: _isRecording
                                              ? Colors.red
                                              : Colors.white,
                                          size: 65,
                                        ),
                                        _isRecording
                                            ? const Icon(
                                                Icons.stop_rounded,
                                                color: Colors.white,
                                                size: 32,
                                              )
                                            : Container(),
                                      ],
                                    ),
                                  ),
                                  InkWell(
                                    onTap: _isRecording
                                        ? () async {
                                            if (controller
                                                .value.isRecordingPaused) {
                                              await resumeVideoRecording();
                                            } else {
                                              await pauseVideoRecording();
                                            }
                                          }
                                        : () {
                                            setState(() {
                                              _isCameraInitialized = false;
                                            });
                                            onNewCameraSelected(cameras[
                                                _isFrontCamera ? 1 : 0]);
                                            setState(() {
                                              _isFrontCamera = !_isFrontCamera;
                                            });
                                          },
                                    child: Stack(
                                      alignment: Alignment.center,
                                      children: [
                                        const Icon(
                                          Icons.circle,
                                          color: Colors.black38,
                                          size: 60,
                                        ),
                                        _isRecording
                                            ? controller.value.isRecordingPaused
                                                ? const Icon(
                                                    Icons.play_arrow,
                                                    color: Colors.white,
                                                    size: 30,
                                                  )
                                                : const Icon(
                                                    Icons.pause,
                                                    color: Colors.white,
                                                    size: 30,
                                                  )
                                            : Icon(
                                                _isFrontCamera
                                                    ? Icons.camera_front
                                                    : Icons.camera_rear,
                                                color: Colors.white,
                                                size: 30,
                                              ),
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                              const SizedBox(
                                height: 10,
                              ),
                              const Text(
                                "Hold for Video, tap for photo",
                                style: TextStyle(
                                  color: Colors.white,
                                ),
                                textAlign: TextAlign.center,
                              )
                            ],
                          ),
                        ),
                      ],
                    )
                  : const Center(
                      child: CircularProgressIndicator(),
                    )
              : Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Row(),
                    const Text(
                      'Permission denied',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 24,
                      ),
                    ),
                    const SizedBox(height: 24),
                    ElevatedButton(
                      onPressed: () {
                        getPermissionStatus();
                      },
                      child: const Padding(
                        padding: EdgeInsets.all(8.0),
                        child: Text(
                          'Give permission',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 24,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
        ));
  }
}
