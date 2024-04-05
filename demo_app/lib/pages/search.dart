import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:demo_app/components/full_image_artwork.dart';
import 'package:demo_app/components/full_image_favourite.dart';
import 'package:demo_app/models/user.dart';
import 'package:demo_app/services/database.dart';
import 'package:flutter/material.dart';
import 'package:demo_app/models/art.dart';
import 'package:demo_app/models/tools.dart';
import 'package:provider/provider.dart';

class SearchPage extends StatefulWidget {
  @override
  State<SearchPage> createState() => _SearchPageState();
}

class _SearchPageState extends State<SearchPage> {
  late List<Art> displayList = getArtList();

  // void addArtToFavourite(Art art) {
  //   Provider.of<Favourite>(context, listen: false).addArtToFavourite(art);
  // }

  List<Art> getArtList() {
    return Provider.of<Favourite>(context, listen: false).getArtList();
  }

  var items = ['By name', 'By artist'];
  String? selectedValue = 'By name';

  void updateListByName(String val) {
    setState(() {
      displayList = getArtList()
          .where((element) =>
              element.name.toLowerCase().contains(val.toLowerCase()))
          .toList();
    });
  }

  void updateListByArtist(String val) {
    setState(() {
      displayList = getArtList()
          .where((element) =>
              element.artist.toLowerCase().contains(val.toLowerCase()))
          .toList();
    });
  }

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

        final List<String> artName = [];

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

        return Scaffold(
          appBar: AppBar(
            scrolledUnderElevation: 0,
            elevation: 0,
            title: const Text(
              'Search',
            ),
            backgroundColor: Theme.of(context).colorScheme.background,
          ),
          body: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text(
                      'Search for an Artwork',
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 20,
                      ),
                    ),
                    DropdownButtonHideUnderline(
                      child: DropdownButton(
                          borderRadius: BorderRadius.circular(8),
                          iconEnabledColor: Colors.blue,
                          style: const TextStyle(
                            color: Colors.blue,
                            fontSize: 14,
                          ),
                          value: selectedValue,
                          icon: const Icon(Icons.keyboard_arrow_down),
                          items: items.map((String items) {
                            return DropdownMenuItem(
                              value: items,
                              child: Text(items),
                            );
                          }).toList(),
                          onChanged: (String? newValue) {
                            setState(() {
                              selectedValue = newValue!;
                            });
                          }),
                    ),
                  ],
                ),

                // Search text field
                (selectedValue == 'By name') // Search by name
                    ? TextField(
                        onChanged: (value) => updateListByName(value),
                        style: const TextStyle(color: Colors.black),
                        decoration: InputDecoration(
                          filled: true,
                          fillColor: Colors.grey[300],
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(8),
                            borderSide: BorderSide.none,
                          ),
                          hintText: 'e.g. chiori',
                          hintStyle: TextStyle(color: Colors.grey[400]),
                          prefixIcon: const Icon(Icons.search),
                          prefixIconColor: Colors.grey[400],
                        ),
                      )
                    // Search by artist
                    : TextField(
                        onChanged: (value) => updateListByArtist(value),
                        style: const TextStyle(color: Colors.black),
                        decoration: InputDecoration(
                          filled: true,
                          fillColor: Colors.grey[300],
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(8),
                            borderSide: BorderSide.none,
                          ),
                          hintText: 'e.g. torinoaqua',
                          hintStyle: TextStyle(color: Colors.grey[400]),
                          prefixIcon: const Icon(Icons.search),
                          prefixIconColor: Colors.grey[400],
                        )),
                const SizedBox(height: 10),
                Consumer<Favourite>(
                  builder: (context, value, child) => Expanded(
                    child: displayList.isEmpty
                        ? Center(
                            child: Text(
                              'No match found',
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                                color: Theme.of(context).colorScheme.secondary,
                                fontSize: 24,
                              ),
                            ),
                          )
                        : ListView.builder(
                            itemCount: displayList.length,
                            itemBuilder: (context, index) {
                              return ListTile(
                                contentPadding: const EdgeInsets.all(6),
                                tileColor:
                                    Theme.of(context).colorScheme.background,
                                title: Text(
                                  displayList[index].name,
                                  style: TextStyle(
                                    color:
                                        Theme.of(context).colorScheme.primary,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                subtitle: Text(
                                  displayList[index].artist,
                                  style: TextStyle(
                                    color:
                                        Theme.of(context).colorScheme.secondary,
                                  ),
                                ),
                                trailing: SizedBox(
                                  width: 240,
                                  height: 60,
                                  child: Image(
                                    image: AssetImage(
                                      displayList[index].imagePath,
                                    ),
                                    fit: BoxFit.cover,
                                  ),
                                ),
                                onTap: (artName.contains(
                                            displayList[index].name) ==
                                        false)
                                    ? () {
                                        Navigator.push(context,
                                            MaterialPageRoute(builder: (_) {
                                          return FullScreenArt(
                                              art: displayList[index]);
                                        }));
                                      }
                                    : () {
                                        Navigator.push(context,
                                            MaterialPageRoute(builder: (_) {
                                          return FullScreenFavourite(
                                              art: displayList[index]);
                                        }));
                                      },
                              );
                            }),
                  ),
                ),
              ],
            ),
          ),
          backgroundColor: Theme.of(context).colorScheme.background,
        );
      },
    );
  }
}
