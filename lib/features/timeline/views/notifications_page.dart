import 'package:flutter/material.dart';

class ActivityNotification extends StatefulWidget {
  const ActivityNotification({Key key}) : super(key: key);

  @override
  State<ActivityNotification> createState() => _ActivityNotificationState();
}

class _ActivityNotificationState extends State<ActivityNotification> {
  @override
  Widget build(BuildContext context) {
    return Container();
  }
}


// class ProfileSearchResult extends StatelessWidget {
//   const ProfileSearchResult({Key key}) : super(key: key);

//   @override
//   Widget build(BuildContext context) {
//     return Container(
//       margin: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
//       child: Row(
//         mainAxisAlignment: MainAxisAlignment.spaceBetween,
//         children: [
//           Expanded(
//             child: Row(
//               children: [
//                 '' == ''
//                     ? Container(
//                         width: 50,
//                         height: 50,
//                         padding: const EdgeInsets.all(2),
//                         decoration: const BoxDecoration(
//                             gradient: LinearGradient(
//                                 colors: [Colors.red, Colors.orangeAccent],
//                                 begin: Alignment.topCenter,
//                                 end: Alignment.bottomLeft),
//                             // border: Border.all(color: Colors.red),
//                             shape: BoxShape.circle),
//                         child: Container(
//                           decoration: BoxDecoration(
//                               shape: BoxShape.circle,
//                               border:
//                                   Border.all(color: Colors.white, width: 3)),
//                           child: ClipRRect(
//                               borderRadius: BorderRadius.circular(50),
//                               child: Image.network(
//                                   'https://images.unsplash.com/photo-1503185912284-5271ff81b9a8?ixid=MnwxMjA3fDB8MHxzZWFyY2h8NHx8Z2lybHxlbnwwfHwwfHw%3D&ixlib=rb-1.2.1&auto=format&fit=crop&w=800&q=60')),
//                         ),
//                       )
//                     : Container(
//                         width: 50,
//                         height: 50,
//                         decoration: BoxDecoration(
//                             shape: BoxShape.circle,
//                             border: Border.all(
//                                 color: Colors.grey.shade300, width: 1)),
//                         child: ClipRRect(
//                             borderRadius: BorderRadius.circular(50),
//                             child: Image.network(
//                                 'https://images.unsplash.com/photo-1503185912284-5271ff81b9a8?ixid=MnwxMjA3fDB8MHxzZWFyY2h8NHx8Z2lybHxlbnwwfHwwfHw%3D&ixlib=rb-1.2.1&auto=format&fit=crop&w=800&q=60')),
//                       ),
//                 const SizedBox(
//                   width: 10,
//                 ),
//                 Flexible(
//                   child: RichText(
//                       text: TextSpan(children: [
//                     const TextSpan(
//                         text: 'Emmanuel',
//                         style: TextStyle(
//                             color: Colors.black, fontWeight: FontWeight.bold)),
//                     const TextSpan(
//                         text: 'blah hlah',
//                         style: TextStyle(color: Colors.black)),
//                     TextSpan(
//                       text: '2h',
//                       style: TextStyle(color: Colors.grey.shade500),
//                     )
//                   ])),
//                 )
//               ],
//             ),
//           ),
//           '' != ''
//               ? SizedBox(
//                   width: 50,
//                   height: 50,
//                   child: ClipRRect(
//                       child: Image.network(
//                           'https://images.unsplash.com/photo-1503185912284-5271ff81b9a8?ixid=MnwxMjA3fDB8MHxzZWFyY2h8NHx8Z2lybHxlbnwwfHwwfHw%3D&ixlib=rb-1.2.1&auto=format&fit=crop&w=800&q=60')),
//                 )
//               : Container(
//                   height: 35,
//                   width: 110,
//                   decoration: BoxDecoration(
//                     color: Colors.blue[700],
//                     borderRadius: BorderRadius.circular(5),
//                   ),
//                   child: const Center(
//                       child: Text('Follow',
//                           style: TextStyle(color: Colors.white)))),
//         ],
//       ),
//     );
//   }
// }
