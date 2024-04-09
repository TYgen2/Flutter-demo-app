import 'dart:math';

import 'package:demo_app/components/art_tile.dart';
import 'package:demo_app/models/art.dart';
import 'package:demo_app/models/tools.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:provider/provider.dart';

class RandomPage extends StatefulWidget {
  const RandomPage({super.key});

  @override
  State<RandomPage> createState() => _RandomPageState();
}

class _RandomPageState extends State<RandomPage>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller = AnimationController(
    duration: const Duration(seconds: 1),
    vsync: this,
    value: 1, // first enter random no animation, 1 is the upperbound
  );

  late final Animation<Offset> _offsetAnimation = Tween<Offset>(
    begin: const Offset(0, 0.05),
    end: const Offset(0, 0),
  ).animate(CurvedAnimation(
    parent: _controller,
    curve: Curves.fastLinearToSlowEaseIn,
  ));

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: const Text(
          'Random art 🎲',
          style: TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 24,
          ),
        ),
        backgroundColor: Colors.transparent,
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 20),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(40),
              child: Material(
                child: InkWell(
                  child: const Icon(
                    Icons.refresh,
                    size: 30,
                  ),
                  onTap: () {
                    setState(() {
                      _controller.reset();
                      _controller.forward();
                    });
                  },
                ),
              ),
            ),
          )
        ],
      ),
      body: Consumer<Favourite>(
        builder: (context, value, child) => Center(
          child: ListView.builder(
            padding: const EdgeInsets.fromLTRB(0, 20, 25, 20),
            shrinkWrap: true,
            itemCount: 1,
            scrollDirection: Axis.horizontal,
            itemBuilder: (context, index) {
              int listLength = value.getArtList().length;
              Art art = value.getArtList()[Random().nextInt(listLength - 1)];
              return SlideTransition(
                position: _offsetAnimation,
                child: ArtTile(
                  art: art,
                  onTap: () {
                    Fluttertoast.showToast(
                      msg: 'Successfully added!',
                      toastLength: Toast.LENGTH_SHORT,
                      gravity: ToastGravity.CENTER,
                    );
                  },
                ),
              );
            },
          ),
        ),
      ),
    );
  }
}
