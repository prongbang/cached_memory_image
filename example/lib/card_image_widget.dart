import 'package:flutter/material.dart';

class CardImageWidget extends StatelessWidget {
  final String title;
  final Widget child;

  const CardImageWidget({
    Key? key,
    required this.title,
    required this.child,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Padding(
            padding: EdgeInsets.all(8.0),
            child: Text('With Bytes Provider'),
          ),
          AspectRatio(
            aspectRatio: 4 / 3,
            child: Stack(
              children: <Widget>[
                const Center(child: CircularProgressIndicator()),
                Center(
                  child: child,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
