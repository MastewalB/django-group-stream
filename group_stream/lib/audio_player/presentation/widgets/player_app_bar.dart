import 'package:flutter/material.dart';

class PlayerAppBar extends StatelessWidget {
  const PlayerAppBar({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(20),
      child: Row(
        textDirection: TextDirection.ltr,
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          GestureDetector(
            child: Padding(
              padding: const EdgeInsets.all(5.0),
              child: Icon(
                Icons.keyboard_arrow_down,
                textDirection: TextDirection.ltr,
                color: Colors.white,
                size: 25,
              ),
            ),
            onTap: () {
              Navigator.pop(context);
            },
          ),
          // Icon(
          //   Icons.more_horiz,
          //   textDirection: TextDirection.ltr,
          //   color: Colors.white,
          // ),
        ],
      ),
    );
  }
}
