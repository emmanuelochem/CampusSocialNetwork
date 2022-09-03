import 'package:flutter/material.dart';
import 'package:flutter_phosphor_icons/flutter_phosphor_icons.dart';
import 'package:mysocial_app/features/camera/camera.dart';
import 'package:provider/provider.dart';

class PostVisibilitySelector extends StatefulWidget {
  const PostVisibilitySelector({Key key}) : super(key: key);

  @override
  State<PostVisibilitySelector> createState() => _PostVisibilitySelectorState();
}

class _PostVisibilitySelectorState extends State<PostVisibilitySelector> {
  setSelectedRadio(BuildContext context, String option) {
    Navigator.pop(context, option);
  }

  PublishDataProvider publishDataProvider;
  @override
  void didChangeDependencies() {
    // TODO: implement didChangeDependencies
    super.didChangeDependencies();

    publishDataProvider = context.watch<PublishDataProvider>();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      top: false,
      child: Container(
        decoration: const BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(15.0),
            topRight: Radius.circular(15.0),
          ),
        ),
        child: SingleChildScrollView(
          child: Column(
            children: [
              Padding(
                padding: const EdgeInsets.all(3),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const SizedBox(),
                    Text(
                      'Who can see this post',
                      style: TextStyle(
                          fontSize: 16,
                          color: Theme.of(context).primaryColor,
                          fontWeight: FontWeight.w800),
                    ),
                    IconButton(
                        onPressed: () {
                          Navigator.pop(context, publishDataProvider.audience);
                        },
                        icon: const Icon(PhosphorIcons.x_bold))
                  ],
                ),
              ),
              const Divider(
                height: 0,
              ),
              Padding(
                padding: const EdgeInsets.all(18.0),
                child: Column(
                  children: [
                    RadioListTile(
                      dense: true,
                      controlAffinity: ListTileControlAffinity.trailing,
                      contentPadding: const EdgeInsets.all(0),
                      title: const Text('Everyone'),
                      subtitle: const Text(
                          'The entire university comunity can see this'),
                      groupValue: publishDataProvider.audience,
                      value: const {'name': 'Everyone', 'value': 'everyone'},
                      onChanged: (value) {
                        publishDataProvider.setAudience = value;
                        Navigator.pop(context, publishDataProvider.audience);
                      },
                    ),
                    RadioListTile(
                      dense: true,
                      controlAffinity: ListTileControlAffinity.trailing,
                      //secondary: const Icon(Icons.sd_storage),
                      toggleable: true,
                      contentPadding: const EdgeInsets.all(0),
                      title: const Text('Friends'),
                      subtitle: const Text(
                          'Friends that you follow you can see this'),
                      groupValue: publishDataProvider.audience,
                      value: const {'name': 'My Friends', 'value': 'followers'},
                      onChanged: (value) {
                        publishDataProvider.setAudience = value;
                        Navigator.pop(context, publishDataProvider.audience);
                      },
                    ),
                    RadioListTile(
                      dense: true,
                      controlAffinity: ListTileControlAffinity.trailing,
                      contentPadding: const EdgeInsets.all(0),
                      title: const Text('Only me'),
                      subtitle: const Text('Only you can see this'),
                      groupValue: publishDataProvider.audience,
                      value: const {'name': 'Only me', 'value': 'me'},
                      onChanged: (value) {
                        publishDataProvider.setAudience = value;
                        Navigator.pop(context, publishDataProvider.audience);
                      },
                    ),
                    const SizedBox(
                      height: 15,
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
