import 'package:demo_app/models/art.dart';
import 'package:demo_app/models/tools.dart';
import 'package:demo_app/models/user.dart';
import 'package:demo_app/services/database.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:provider/provider.dart';

class FullScreenArt extends StatefulWidget {
  Art art;
  FullScreenArt({
    super.key,
    required this.art,
  });

  @override
  State<FullScreenArt> createState() => _FullScreenArtState();
}

class _FullScreenArtState extends State<FullScreenArt> {
  // add art to favourite
  // void addArtToFavourite(Art art) {
  //   Provider.of<Favourite>(context, listen: false).addArtToFavourite(art);
  // }

  @override
  Widget build(BuildContext context) {
    final user = Provider.of<myUser?>(context);

    return GestureDetector(
      onTap: () => Navigator.pop(context),
      child: Stack(
        alignment: AlignmentDirectional.center,
        children: [
          Image.asset(widget.art.imagePath),
          Padding(
            padding: const EdgeInsets.only(bottom: 4),
            child: Align(
              alignment: AlignmentDirectional.bottomEnd,

              // Favourite button
              child: Padding(
                padding: const EdgeInsets.only(bottom: 36, right: 4),
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    shape: const CircleBorder(),
                    padding: const EdgeInsets.all(16),
                  ),
                  onPressed: () async {
                    (user!.isGuest == false)
                        ? {
                            setState(() => widget.art.isFav = true),
                            Fluttertoast.showToast(
                              msg: 'Successfully added!',
                              toastLength: Toast.LENGTH_SHORT,
                              gravity: ToastGravity.CENTER,
                            ),
                            // addArtToFavourite(widget.art),
                            Navigator.pop(context),
                            await DatabaseService(uid: user.uid)
                                .updateUserData(widget.art),
                          }
                        : {
                            Fluttertoast.showToast(
                              msg: 'Sign in to use the Favourite function.',
                              toastLength: Toast.LENGTH_LONG,
                              gravity: ToastGravity.CENTER,
                            )
                          };
                  },
                  child: const Icon(
                    Icons.favorite,
                    color: Colors.redAccent,
                  ),
                ),
              ),
            ),
          )
        ],
      ),
    );
  }
}
