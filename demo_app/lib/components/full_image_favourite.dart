import 'package:demo_app/models/art.dart';
import 'package:demo_app/models/tools.dart';
import 'package:demo_app/models/user.dart';
import 'package:demo_app/services/database.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:provider/provider.dart';

class FullScreenFavourite extends StatefulWidget {
  Art art;
  FullScreenFavourite({
    super.key,
    required this.art,
  });

  @override
  State<FullScreenFavourite> createState() => _FullScreenFavouriteState();
}

class _FullScreenFavouriteState extends State<FullScreenFavourite> {
  // remove art from favourite
  // void removeArtFromFavourite() {
  //   Provider.of<Favourite>(context, listen: false).removeFavourite(widget.art);
  // }

  Future<bool?> showDeleteConfirmDialog() {
    return showDialog<bool>(
        context: context,
        builder: (context) {
          return AlertDialog(
            title: const Text('Favourite removal confirm'),
            content: const Text(
                'Are you sure want to remove this art from your favourite list?'),
            actions: [
              TextButton(
                child: const Text('Cancel'),
                onPressed: () => Navigator.of(context).pop(),
              ),
              TextButton(
                child: const Text('Delete'),
                onPressed: () => Navigator.of(context).pop(true),
              ),
            ],
          );
        });
  }

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

              // Delete button in favourite page
              child: Padding(
                padding: const EdgeInsets.only(bottom: 36, right: 4),
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    shape: const CircleBorder(),
                    padding: const EdgeInsets.all(16),
                  ),
                  onPressed: () async {
                    bool? delete = await showDeleteConfirmDialog();
                    if (delete == null) {
                    } else {
                      await DatabaseService(uid: user!.uid)
                          .deleteUserData(widget.art);

                      setState(() => widget.art.isFav = false);
                      // removeArtFromFavourite();
                      Fluttertoast.showToast(
                        msg: 'Successfully deleted',
                        toastLength: Toast.LENGTH_SHORT,
                        gravity: ToastGravity.CENTER,
                      );

                      if (!mounted) {
                        return;
                      } else {
                        Navigator.pop(context);
                      }
                    }
                  },
                  child: const Icon(Icons.delete),
                ),
              ),
            ),
          )
        ],
      ),
    );
  }
}
