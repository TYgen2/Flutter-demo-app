import 'package:demo_app/components/art_tile.dart';
import 'package:demo_app/models/art.dart';
import 'package:demo_app/models/tools.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:provider/provider.dart';

class ArtPage extends StatefulWidget {
  const ArtPage({super.key});

  @override
  State<ArtPage> createState() => _ArtPageState();
}

class _ArtPageState extends State<ArtPage> {
  // add art to favourite
  // void addArtToFavourite(Art art) {
  //   Provider.of<Favourite>(context, listen: false).addArtToFavourite(art);
  // }

  @override
  Widget build(BuildContext context) {
    return Consumer<Favourite>(
      builder: (context, value, child) => Column(
        children: [
          const Padding(
            padding: EdgeInsets.symmetric(horizontal: 25),
            child: Row(
              children: [
                Text(
                  'Trending Arts 🔥',
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 24,
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 10),
          Expanded(
            child: ListView.builder(
              itemCount: value.getArtList().length,
              scrollDirection: Axis.horizontal,
              padding: const EdgeInsets.only(right: 20),
              itemBuilder: (context, index) {
                Art art = value.getArtList()[index]; // local art gallery
                return ArtTile(
                  art: art,
                  onTap: () {
                    // addArtToFavourite(art);
                    Fluttertoast.showToast(
                      msg: 'Successfully added!',
                      toastLength: Toast.LENGTH_SHORT,
                      gravity: ToastGravity.CENTER,
                    );
                  },
                );
              },
            ),
          ),
          const SizedBox(height: 10),
        ],
      ),
    );
  }
}
