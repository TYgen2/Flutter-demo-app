import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:demo_app/components/favourite_item.dart';
import 'package:demo_app/models/art.dart';
import 'package:demo_app/models/tools.dart';
import 'package:demo_app/models/user.dart';
import 'package:demo_app/services/database.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class FavouritePage extends StatefulWidget {
  const FavouritePage({super.key});

  @override
  State<FavouritePage> createState() => _FavouritePageState();
}

class _FavouritePageState extends State<FavouritePage> {
  @override
  Widget build(BuildContext context) {
    final user = Provider.of<myUser?>(context);

    if (user!.isGuest == false) {
      return Consumer<Favourite>(
        builder: (context, value, child) => Padding(
          padding: const EdgeInsets.symmetric(horizontal: 25.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // heading
              const Text(
                'My Favourites ❤',
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 24,
                ),
              ),

              const SizedBox(height: 10),

              StreamBuilder<DocumentSnapshot>(
                stream: DatabaseService(uid: user.uid)
                    .userFavourite
                    .doc(user.uid)
                    .snapshots(),
                builder: (context, snapshot) {
                  if (snapshot.data == null) {
                    return Container();
                  }
                  // get the user document snapshot to access the favourite list
                  final DocumentSnapshot document =
                      snapshot.data as DocumentSnapshot;
                  final Map<String, dynamic> docData =
                      document.data() as Map<String, dynamic>;

                  final List<Map<String, dynamic>> favList =
                      (docData['art'] as List)
                          .map((doc) => doc as Map<String, dynamic>)
                          .toList();

                  // store the converted map data as a list of art
                  final List<Art> fav = <Art>[];

                  return Expanded(
                    child: (favList.isNotEmpty)
                        ? GridView.builder(
                            gridDelegate:
                                const SliverGridDelegateWithFixedCrossAxisCount(
                              crossAxisCount: 2,
                              mainAxisSpacing: 6,
                              crossAxisSpacing: 6,
                              childAspectRatio: 1,
                            ),
                            itemCount: favList.length,
                            itemBuilder: (context, index) {
                              // convert map data to list of art
                              for (Map<String, dynamic> data in favList) {
                                fav.add(Art(
                                  name: data['name'],
                                  artist: data['artist'],
                                  imagePath: data['imagePath'],
                                  isFav: data['status'],
                                ));
                              }

                              Art individualArt = fav[index];

                              // return the favourite list
                              return FavouriteItem(art: individualArt);
                            },
                          )
                        : Center(
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                const Text(
                                  'No favourited art yet',
                                  style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    fontSize: 30,
                                  ),
                                ),
                                const SizedBox(height: 10),
                                Text(
                                  'Go browse some gorgerous art and \nadd it to Favaourites now!',
                                  style: TextStyle(
                                    color:
                                        Theme.of(context).colorScheme.secondary,
                                    fontSize: 14,
                                  ),
                                  textAlign: TextAlign.center,
                                ),
                              ],
                            ),
                          ),
                  );
                },
              )
            ],
          ),
        ),
      );
    } else {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Text(
              'Opps!',
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 30,
              ),
            ),
            const SizedBox(height: 10),
            Text(
              'Sign in to use the Favourites function.',
              style: TextStyle(
                color: Theme.of(context).colorScheme.secondary,
                fontSize: 14,
              ),
            ),
          ],
        ),
      );
    }
  }
}
