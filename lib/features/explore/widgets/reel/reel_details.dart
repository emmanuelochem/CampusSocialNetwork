import 'package:expandable_text/expandable_text.dart';
import 'package:flutter/material.dart';
import 'package:flutter_phosphor_icons/flutter_phosphor_icons.dart';
import 'package:marquee/marquee.dart';

class ReelDetails extends StatelessWidget {
  const ReelDetails({Key key, @required this.post}) : super(key: key);
  final Map post;
  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        ListTile(
            dense: true,
            minLeadingWidth: 0,
            horizontalTitleGap: 12,
            title: Row(
              children: [
                Text(
                  '${post['user']['nickname']}',
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 15,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                const SizedBox(
                  width: 20,
                ),
                Container(
                    alignment: Alignment.center,
                    padding: const EdgeInsets.symmetric(
                        horizontal: 14, vertical: 10),
                    decoration: BoxDecoration(
                      border: Border.all(color: Colors.grey.shade400),
                      borderRadius: BorderRadius.circular(5),
                      //color: Colors.blue
                    ),
                    child: const Text(
                      'Follow',
                      style: TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.w600,
                          color: Colors.white),
                    )),
              ],
            ),
            leading: CircleAvatar(
              radius: 14,
              backgroundImage: NetworkImage(post['image']),
            ),
            contentPadding: EdgeInsets.zero),
        const SizedBox(
          height: 15,
        ),
        ExpandableText(
          '${post['caption']}',
          style: const TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.w400,
            color: Colors.white,
          ),
          expandOnTextTap: true,
          collapseOnTextTap: true,
          expandText: 'more',
          collapseText: 'less',
          maxLines: 1,
          linkColor: Colors.grey,
        ),
        ListTile(
          dense: true,
          minLeadingWidth: 0,
          horizontalTitleGap: 5,
          contentPadding: EdgeInsets.zero,
          title: Row(
            children: [
              SizedBox(
                height: 20,
                width: 200,
                child: Marquee(
                  scrollAxis: Axis.horizontal,
                  velocity: 40,
                  text: 'Level - Department',
                  style: const TextStyle(
                      color: Colors.white, fontWeight: FontWeight.w500),
                ),
              ),
              const Padding(
                padding: EdgeInsets.only(left: 12),
                child: Icon(
                  PhosphorIcons.caret_right,
                  color: Colors.white,
                  size: 16,
                ),
              ),
            ],
          ),
          // leading: const Icon(
          //   PhosphorIcons.fire,
          //   color: Colors.white,
          //   size: 16,
          // ),
        ),
      ],
    );
  }
}
