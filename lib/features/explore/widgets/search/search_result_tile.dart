import 'package:flutter/material.dart';
import 'package:mysocial_app/features/profile/views/profile_page.dart';

class ProfileSearchResult extends StatelessWidget {
  const ProfileSearchResult({Key key, @required this.result}) : super(key: key);

  final Map result;

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Expanded(
            child: GestureDetector(
              onTap: () => Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => ProfilePage(
                            profileId: result['id'],
                          ))),
              child: Row(
                children: [
                  Container(
                    width: 50,
                    height: 50,
                    decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        border:
                            Border.all(color: Colors.grey.shade300, width: 1)),
                    child: ClipRRect(
                        borderRadius: BorderRadius.circular(50),
                        child: Image.network('${result['photo']}')),
                  ),
                  const SizedBox(
                    width: 10,
                  ),
                  Flexible(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          '${result['nickname']}',
                          style: const TextStyle(
                              color: Colors.black,
                              fontWeight: FontWeight.bold,
                              fontSize: 14),
                        ),
                        const SizedBox(height: 3),
                        Row(
                          children: [
                            Text(
                              '500L',
                              style: TextStyle(
                                  color: Colors.grey.shade500, fontSize: 13),
                            ),
                            const SizedBox(width: 6),
                            Text(
                              '•',
                              style: TextStyle(
                                  color: Colors.grey.shade500, fontSize: 13),
                            ),
                            const SizedBox(width: 6),
                            Text(
                              'Mechanical Engineering',
                              style: TextStyle(
                                  color: Colors.grey.shade500, fontSize: 13),
                            ),
                          ],
                        ),
                      ],
                    ),
                  )
                ],
              ),
            ),
          ),
          GestureDetector(
            onTap: () {
              print('follow');
            },
            child: Container(
                height: 35,
                width: 110,
                decoration: BoxDecoration(
                  color: Colors.blue[700],
                  borderRadius: BorderRadius.circular(5),
                ),
                child: const Center(
                    child:
                        Text('Follow', style: TextStyle(color: Colors.white)))),
          ),
        ],
      ),
    );
  }
}
