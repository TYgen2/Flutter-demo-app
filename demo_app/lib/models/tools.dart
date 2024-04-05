import 'package:demo_app/models/art.dart';
import 'package:flutter/material.dart';

class Favourite extends ChangeNotifier {
  // list of artworks
  List<Art> trendingArts = [
    Art(
        name: 'Chiori',
        artist: 'Torinoaqua',
        imagePath: 'lib/images/chiori2.jpg',
        isFav: false),
    Art(
        name: 'Navia',
        artist: 'Torinoaqua',
        imagePath: 'lib/images/navia.jpg',
        isFav: false),
    Art(
        name: 'Furina',
        artist: 'Torinoaqua',
        imagePath: 'lib/images/furina.jpg',
        isFav: false),
    Art(
        name: 'Chlorine',
        artist: 'Torinoaqua',
        imagePath: 'lib/images/chlorine.jpg',
        isFav: false),
    Art(
        name: 'Navia 2',
        artist: 'Torinoaqua',
        imagePath: 'lib/images/navia2.jpg',
        isFav: false),
    Art(
        name: 'Yunjin',
        artist: 'Jeanbean',
        imagePath: 'lib/images/yunjin.jpg',
        isFav: false),
  ];

  // get list of trending arts
  List<Art> getArtList() {
    return trendingArts;
  }

  // list of favourites
  // List<Art> userFavourite = [];

  // get user favourites
  // List<Art> getUserFavourite() {
  //   return userFavourite;
  // }

  // add favourite
  // void addArtToFavourite(Art art) {
  //   userFavourite.add(art);
  //   notifyListeners();
  // }

  // remove favourite
  // void removeFavourite(Art art) {
  //   userFavourite.remove(art);
  //   notifyListeners();
  // }
}
