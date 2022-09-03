import 'dart:io';

import 'package:dio/dio.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_phosphor_icons/flutter_phosphor_icons.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:modal_bottom_sheet/modal_bottom_sheet.dart';
import 'package:mysocial_app/core/components/buttons/primaryButton.dart';
import 'package:mysocial_app/features/camera/camera.dart';
import 'package:path/path.dart';

class PuplishPostPage extends StatefulWidget {
  const PuplishPostPage({Key key}) : super(key: key);
  @override
  _PuplishPostPageState createState() => _PuplishPostPageState();
}

class _PuplishPostPageState extends State<PuplishPostPage> {
  final TextEditingController _captionController = TextEditingController();
  MediaController mediaController;
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    mediaController = MediaController();
  }

  @override
  void dispose() {
    super.dispose();
    _captionController?.dispose();
  }

  bool _allowComment = true;
  bool _notify = true;
  bool _isLoading = false;
  Map _whoCanSeeText = {'name': 'Everyone', 'value': 'everyone'};

  @override
  Widget build(BuildContext context) {
    //bool _isLoading = false;
    return SafeArea(
      top: false,
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Publish'),
          centerTitle: false,
          elevation: 0,
        ),
        body: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(vertical: 15, horizontal: 20),
          child: SizedBox(
            height: 0.9.sh,
            child: Column(
              children: <Widget>[
                SizedBox(
                  height: 1.sh * 0.17,
                  width: 1.sw,
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      SizedBox(
                        width: 100,
                        height: 140,
                        child: FutureBuilder(
                            future: mediaController.getLastImage(),
                            builder: (context, AsyncSnapshot<File> snapshot) {
                              // if(snapshot.connectionState())
                              if (!snapshot.hasData) {
                                return const Center(
                                  child: Text('No data.'),
                                );
                              }
                              return Stack(
                                children: [
                                  Positioned.fill(
                                    top: 0,
                                    left: 0,
                                    right: 0,
                                    bottom: 0,
                                    child: ClipRRect(
                                      borderRadius: BorderRadius.circular(4.0),
                                      child: Image.file(
                                        snapshot.data,
                                        fit: BoxFit.cover,
                                      ),
                                    ),
                                  ),
                                  Positioned(
                                    top: 10,
                                    left: 5,
                                    child: Container(
                                        //height: 10,
                                        padding: const EdgeInsets.all(8),
                                        decoration: BoxDecoration(
                                            color: Colors.white.withOpacity(.7),
                                            borderRadius:
                                                BorderRadius.circular(100)),
                                        child: const Text('5')),
                                  ),
                                ],
                              );
                            }),
                      ),
                      const SizedBox(
                        width: 10,
                      ),
                      Flexible(
                        flex: 8,
                        child: TextField(
                          controller: _captionController,
                          maxLines: 5,
                          keyboardType: TextInputType.multiline,
                          decoration: const InputDecoration(
                            hintText: 'Write a caption...',
                            border: OutlineInputBorder(
                              borderSide: BorderSide(width: 0),
                              // borderRadius: BorderRadius.circular(8)
                            ),
                          ),
                          onChanged: ((value) {}),
                        ),
                      ),
                    ],
                  ),
                ),
                Column(
                  children: [
                    ListTile(
                      dense: true,
                      contentPadding: const EdgeInsets.symmetric(horizontal: 0),
                      leading: const Icon(PhosphorIcons.user),
                      title: const Text('Who can see this post'),
                      trailing: SizedBox(
                        width: 100,
                        child: Row(
                            mainAxisAlignment: MainAxisAlignment.end,
                            children: [
                              Text(_whoCanSeeText['name']),
                              const Icon(PhosphorIcons.caret_right)
                            ]),
                      ),
                      onTap: () async {
                        var resp = await showMaterialModalBottomSheet(
                          context: context,
                          builder: (context) => const PostVisibilitySelector(),
                        );
                        if (resp != null) {
                          setState(() {
                            _whoCanSeeText = resp;
                          });
                        }
                      },
                    ),
                    ListTile(
                      dense: true,
                      contentPadding: const EdgeInsets.symmetric(horizontal: 0),
                      leading: const Icon(PhosphorIcons.chat),
                      title: const Text('Allow comments'),
                      trailing: CupertinoSwitch(
                        value: _allowComment,
                        onChanged: (value) {
                          setState(() {
                            _allowComment = value;
                          });
                        },
                        activeColor: Theme.of(context).primaryColor,
                      ),
                    ),
                    ListTile(
                      dense: true,
                      contentPadding: const EdgeInsets.symmetric(horizontal: 0),
                      leading: const Icon(PhosphorIcons.bell),
                      title: const Text('Notify my followers'),
                      trailing: CupertinoSwitch(
                        value: _notify,
                        onChanged: (value) {
                          setState(() {
                            _notify = value;
                          });
                        },
                        activeColor: Theme.of(context).primaryColor,
                      ),
                    ),
                  ],
                ),
                const Spacer(),
              ],
            ),
          ),
        ),
        bottomNavigationBar: Container(
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
          color: Colors.black,
          child: Row(
            children: [
              // Expanded(
              //   child: PrimaryButton(
              //     onPressed: () => null,
              //     text: 'Draft',
              //     type: "white",
              //   ),
              // ),
              // const SizedBox(
              //   width: 15,
              // ),
              Expanded(
                child: PrimaryButton(
                  isLoading: _isLoading,
                  onPressed: () async {
                    try {
                      setState(() => _isLoading = true);
                      var allImages = await mediaController.getAllImages();
                      var imageData = [];
                      for (var image in allImages) {
                        imageData.add(await MultipartFile.fromFile(image.path,
                            filename: basename(image.path)));
                      }
                      Map<String, dynamic> data = {
                        'caption': _captionController.text,
                        'image': imageData,
                        'audience': _whoCanSeeText['value'],
                        'allowcomment': _allowComment ? 'yes' : 'no',
                        'notify': _notify ? 'yes' : 'no'
                      };

                      var response =
                          await mediaController.createPost(data: data);
                      if (response['status'] != 'success') {
                        //seccess
                        await mediaController.cleanEditFolder();
                        Navigator.pushNamed(context, '/home');
                        return;
                      }
                      // print(allImages.length);
                      setState(() => _isLoading = false);
                      return;
                    } catch (e) {
                      setState(() => _isLoading = false);
                    }
                  },
                  text: 'Post',
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
