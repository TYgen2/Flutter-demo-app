import 'package:demo_app/components/full_image_favourite.dart';
import 'package:flutter/material.dart';
import 'package:demo_app/models/art.dart';

class FavouriteItem extends StatefulWidget {
  Art art;
  FavouriteItem({
    super.key,
    required this.art,
  });

  @override
  State<FavouriteItem> createState() => _FavouriteItemState();
}

class _FavouriteItemState extends State<FavouriteItem> {
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      child: Image.asset(widget.art.imagePath, fit: BoxFit.cover),
      onTap: () {
        Navigator.push(context, MaterialPageRoute(builder: (_) {
          return FullScreenFavourite(art: widget.art);
        }));
      },
    );
  }
}
