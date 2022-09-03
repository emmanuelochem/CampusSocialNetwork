import 'package:flutter/material.dart';

class AddStoryCard extends StatelessWidget {
  const AddStoryCard({
    Key key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Stack(
          children: [
            const CircleAvatar(
              backgroundColor: Colors.pink,
              radius: 33,
              backgroundImage: NetworkImage(
                  'https://images.unsplash.com/photo-1503185912284-5271ff81b9a8?ixid=MnwxMjA3fDB8MHxzZWFyY2h8NHx8Z2lybHxlbnwwfHwwfHw%3D&ixlib=rb-1.2.1&auto=format&fit=crop&w=800&q=60'),
            ),
            Positioned(
                top: 42,
                left: 40,
                child: Container(
                  height: 25,
                  width: 25,
                  decoration: BoxDecoration(
                    border: Border.all(color: Colors.white, width: 3),
                    borderRadius: BorderRadius.circular(15),
                    color: Colors.blue,
                  ),
                  child: IconButton(
                    onPressed: () => {},
                    padding: EdgeInsets.zero,
                    icon: const Icon(Icons.add),
                    iconSize: 20,
                    color: Colors.white,
                  ),
                ))
          ],
        ),
        const Spacer(),
        const Text(
          'Add story',
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
          style: TextStyle(
            color: Colors.black,
          ),
        )
      ],
    );
  }
}
