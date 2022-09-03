// //Animation de Logo Audio TikTok
// class AnimatedLogo extends StatefulWidget {
//   const AnimatedLogo({Key? key}) : super(key: key);

//   @override
//   _AnimatedLogoState createState() => _AnimatedLogoState();
// }

// class _AnimatedLogoState extends State<AnimatedLogo> 
//       with SingleTickerProviderStateMixin
// {
//   late AnimationController _controller;

//   @override
//   void initState(){
//     _controller = AnimationController(
//       duration: const Duration(milliseconds: 4000),
//       vsync: this,
//     );
//     _controller.repeat();
//     super.initState();
//   }

//   @override
//   void dispose(){
//     _controller.dispose();
//     super.dispose();
//   }

//   @override
//   Widget build(BuildContext context) {
//     return AnimatedBuilder(
//       animation: _controller, 
//       builder: (_, child){
//         return Transform.rotate(
//           angle: _controller.value * 2 * math.pi,
//           child: child,
//           );
//       },

//       child: Container(
//         height: 45,
//         width: 45,
//         padding: const EdgeInsets.all(5),
//         decoration: BoxDecoration(
//           borderRadius: BorderRadius.circular(25),
//           image: const DecorationImage(
//             image: AssetImage("assets/images/disc_icon.png"),
//           ),
//         ),

//         child: Image.asset('assets/images/tiktok_icon.png'),
//       ),
//       );
//   }
// }
//class FontSize {
//   static double s10 = 10;
//   static double s12 = 12;
//   static double s14 = 14;
//   static double s15 = 15;
//   static double s16 = 16;
//   static double s18 = 18;
//   static double s20 = 20;
//   static double s22 = 22;
//   static double s24 = 24;
//   static double s28 = 28;
//   static double s34 = 34;
// }
/**class AppColors {
  static Color backgroundColor = Colors.black;
  static Color primary = const Color.fromARGB(255, 108, 103, 102);
  static Color secondary = const Color.fromARGB(255, 108, 103, 102);
  static Color white = const Color.fromARGB(255, 255, 255, 255);
  static Color black = const Color.fromARGB(255, 0, 0, 0);
  static Color grey = const Color.fromARGB(255, 106, 103, 103);
  static Color red = const Color.fromARGB(255, 130, 49, 49);
} */

