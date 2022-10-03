import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class ShareOptionItem extends StatelessWidget {
  const ShareOptionItem({
    @required this.title,
    @required this.icon,
    @required this.primaryColor,
    @required this.secondaryColor,
    @required this.onTapped,
  });

  final String title;
  final IconData icon;
  final Color primaryColor;
  final Color secondaryColor;
  final Function onTapped;
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Container(
          width: 60,
          height: 60,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: secondaryColor.withOpacity(0.15),
          ),
          child: Icon(
            icon,
            color: primaryColor,
            size: 25.sp,
          ),
        ),
        SizedBox(
          height: 0.01.sh,
        ),
        Text(
          title,
          style: const TextStyle(
            color: Colors.black54,
            fontSize: 13,
            fontWeight: FontWeight.w600,
          ),
        )
      ],
    );
  }
}
