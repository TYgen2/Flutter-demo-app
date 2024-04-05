import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:demo_app/components/full_image_artwork.dart';
import 'package:demo_app/components/full_image_favourite.dart';
import 'package:demo_app/models/tools.dart';
import 'package:demo_app/models/user.dart';
import 'package:demo_app/pages/favourite_page.dart';
import 'package:flutter/material.dart';
import 'package:demo_app/models/art.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:provider/provider.dart';
import 'package:demo_app/services/database.dart';

class ArtTile extends StatefulWidget {
  Art art;
  void Function()? onTap;
  ArtTile({super.key, required this.art, required this.onTap});

  @override
  State<ArtTile> createState() => _ArtTileState();
}

class _ArtTileState extends State<ArtTile> {
  // void removeArtFromFavourite() {
  //   Provider.of<Favourite>(context, listen: false).removeFavourite(widget.art);
  // }

  @override
  Widget build(BuildContext context) {
    final user = Provider.of<myUser?>(context);

    return StreamBuilder<DocumentSnapshot>(
      stream: DatabaseService(uid: user!.uid)
          .userFavourite
          .doc(user.uid)
          .snapshots(),
      builder: (context, snapshot) {
        if (snapshot.data == null) {
          return Container();
        }
        // store the converted map data as a list of art
        final List<String> artName = [];

        // for logged in user to access their favourite list
        if (user.isGuest == false) {
          final DocumentSnapshot document = snapshot.data as DocumentSnapshot;
          final Map<String, dynamic> docData =
              document.data() as Map<String, dynamic>;

          final List<Map<String, dynamic>> favList = (docData['art'] as List)
              .map((doc) => doc as Map<String, dynamic>)
              .toList();

          // store the converted map data as a list of art
          final List<Art> fav = <Art>[];

          for (Map<String, dynamic> data in favList) {
            fav.add(Art(
              name: data['name'],
              artist: data['artist'],
              imagePath: data['imagePath'],
              isFav: data['status'],
            ));
          }

          // store the names of art in favourite list in another
          // list for controlling the favourite icon
          for (var art in fav) {
            artName.add(art.name);
          }
        }

        return Container(
          margin: const EdgeInsets.only(left: 25),
          width: 280,
          decoration: BoxDecoration(
            color: Colors.black,
            borderRadius: BorderRadius.circular(12),
          ),
          child: Column(
            children: [
              // artworks
              GestureDetector(
                onLongPress: () {
                  (artName.contains(widget.art.name) == false)
                      ? Navigator.push(context, MaterialPageRoute(builder: (_) {
                          return FullScreenArt(art: widget.art);
                        }))
                      : Navigator.push(context, MaterialPageRoute(builder: (_) {
                          return FullScreenFavourite(art: widget.art);
                        }));
                },
                child: Image.asset(
                  widget.art.imagePath,
                  fit: BoxFit.cover,
                  height: 420,
                  width: 400,
                ),
              ),

              const SizedBox(height: 10),

              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: Row(
                  children: [
                    Row(
                      children: [
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              widget.art.name,
                              style: const TextStyle(
                                  color: Colors.white,
                                  fontWeight: FontWeight.bold),
                            ),
                            Text(widget.art.artist,
                                style: const TextStyle(color: Colors.white)),
                          ],
                        ),

                        // Favourite button
                        const SizedBox(width: 142),

                        GestureDetector(
                          onTap: (user.isGuest ==
                                  true) // Favourite function not avaiable for guest mode
                              ? () => Fluttertoast.showToast(
                                    msg:
                                        'Sign in to use the Favourite function.',
                                    toastLength: Toast.LENGTH_LONG,
                                    gravity: ToastGravity.CENTER,
                                  )
                              : (artName.contains(widget.art.name) == false)
                                  ? () async {
                                      // Default is not favourited yet
                                      // setState(() => widget.art.isFav = true);
                                      widget.onTap!();

                                      await DatabaseService(uid: user.uid)
                                          .updateUserData(widget.art);
                                    }
                                  : () async {
                                      // Favourited, now unfavourite it

                                      // Put the delete function above the setState for
                                      // isFav, because the whole Art object have to be
                                      // exactly the same in order to delete in firebase
                                      await DatabaseService(uid: user.uid)
                                          .deleteUserData(widget.art);

                                      // setState(() => widget.art.isFav = false);
                                      // removeArtFromFavourite();
                                      Fluttertoast.showToast(
                                        msg: 'Successfully deleted',
                                        toastLength: Toast.LENGTH_SHORT,
                                        gravity: ToastGravity.CENTER,
                                      );
                                    },
                          child: Icon(
                            // Determined by favourited or unfavourite
                            (artName.contains(widget.art.name) == false)
                                ? Icons.favorite_border
                                : Icons.favorite,
                            color: Colors.redAccent,

                            // (widget.art.isFav == false)
                            //     ? Icons.favorite_border
                            //     : Icons.favorite,
                            // color: Colors.redAccent,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}
