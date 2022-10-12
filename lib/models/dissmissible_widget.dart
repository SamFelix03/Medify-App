import 'package:flutter/material.dart';

class DissmissibleWidget extends StatelessWidget {
  final Widget child;
  Object? item;
  Function onDismissed;

  DissmissibleWidget(
      {super.key,
      required this.child,
      required this.item,
      required this.onDismissed});

  @override
  Widget build(BuildContext context) => Dismissible(
        direction: DismissDirection.endToStart,
        key: ObjectKey(item),
        background: buildSwiupeActionRight(),
        child: child,
        onDismissed: ((direction) => onDismissed(item)),
      );
}

Widget buildSwiupeActionRight() => Container(
      alignment: Alignment.centerRight,
      padding: EdgeInsets.symmetric(horizontal: 20),
      color: Colors.red,
      child: const Icon(
        Icons.delete_forever,
        color: Colors.white,
      ),
    );
