import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class ProfileWidget extends StatelessWidget {
  final String imagePath;
  final VoidCallback onClicked;
  final bool isEdit;

  // ignore: use_key_in_widget_constructors
  const ProfileWidget({
    // Key? key,
    required this.imagePath,
    required this.onClicked,
    this.isEdit = false,
  });
  // : super(key: key);

  @override
  Widget build(BuildContext context) {
    // final c = Theme.of(context).colorScheme.primary;

    return Center(
      child: Stack(
        children: [
          buildImage(),
          Positioned(
            bottom: 0,
            right: 4,
            child: buildEditIcon(),
          ),
        ],
      ),
    );
  }

  Widget buildImage() {
    final image = AssetImage(imagePath);

    return ClipOval(
      child: Material(
        color: Colors.transparent,
        child: Ink.image(
          image: image,
          fit: BoxFit.cover,
          width: 128,
          height: 128,
          child: InkWell(onTap: onClicked),
        ),
      ),
    );
  }

// Widget buildEditIcon () {
//   return ClipOval(
//     child: Material(
//       color: Colors.black, // button color
//       child: InkWell(
//         splashColor: Colors.white, // inkwell color
//         child: SizedBox(width: 35, height: 35, child: Icon(CupertinoIcons.pen, size: 20, color: Color(0xff3BB143),)),
//         onTap: () {},
//       ),
//     ),
//   );
// }

  Widget buildEditIcon() => ClipOval(
      child: Material(
        elevation: 15.0,
        shadowColor: Colors.black,
        color: Colors.black, // button color
        child: InkWell(
          splashColor: Colors.white, // inkwell color
          child: SizedBox(
            width: 35, height: 35, 
            child: Icon(
              isEdit ? CupertinoIcons.add_circled_solid : CupertinoIcons.gear_alt_fill, 
              size: 28, 
              color: Color(0xff3BB143),)
          ),
          onTap: onClicked,
        ),
      ),
    );

  Widget buildCircle({
    required Widget child,
    required double all,
    required Color color,
  }) =>
  ClipOval(
    child: Container(
      padding: EdgeInsets.all(all),
      color: color,
      child: child,
    ),
  );
}