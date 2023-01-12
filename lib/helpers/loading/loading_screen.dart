import 'dart:async';
import 'package:flutter/material.dart';
import 'package:hand_in_need/helpers/loading/loading_screen_controller.dart';

// this is our rendered loading screen after user logging in
class LoadingScreen {
  // singleton
  factory LoadingScreen() => _shared;
  static final LoadingScreen _shared = LoadingScreen._sharedInstance();
  LoadingScreen._sharedInstance();

  // get hold of loading screen controller
  LoadingScreenController? controller;

  // show function
  void show({
    required BuildContext context,
    required String text,
  }) {
    // if we have controller and can update it when pass text - just return
    if (controller?.update(text) ?? false) {
      return;
      // otherwise create new overlay and assign to controller property
    } else {
      controller = showOverlay(
        context: context,
        text: text,
      );
    }
  }

  // hide function purpose use internally
  void hide() {
    // if we have controller close it
    controller?.close();
    // set it to null
    controller = null;
  }

  // have function showOverlay
  // going return instance of LoadingScreen controller
  LoadingScreenController showOverlay({
    required BuildContext context,
    required String text,
  }) {
    // create stream controller that will have text passed to it
    final _text = StreamController<String>();
    _text.add(text);

    // Overylay.of(context) - overlays on top of screen in our case loading
    final state = Overlay.of(context);

    // overlays are placed on top eveything else they dont have intrinsic sizes
    // we need some sort of size to base overlay
    // renderbox - allow you extract available size overlay can have on screen
    final renderBox = context.findRenderObject() as RenderBox;
    final size = renderBox.size;

    // now we create our overlay - mean is overlay entry
    // to note - overlay dont have parent like scaffold -
    // if dont wrap this in material component like widget , overlay will have terrible style
    final overlay = OverlayEntry(
      builder: (context) {
        return Material(
          color: Colors.black.withAlpha(150),
          child: Center(
            child: Container(
                // container gonna place constraints on overlay max w and h
                constraints: BoxConstraints(
                  // this dialouge displayed consume at most 80 percent available width on screen
                  // width comes from RenderBox
                  maxWidth: size.width * 0.8,
                  maxHeight: size.height * 0.8,
                  minWidth: size.width * 0.5,
                ),
                // border
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(10.0),
                ),
                // reason child padding is single child scroll view
                // what if there small screen lot of text
                // cut text that y
                // scroll view - try not scroll if enough space if not then scroll
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: SingleChildScrollView(
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      // center content
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        // top margin from top column
                        const SizedBox(height: 10),
                        const CircularProgressIndicator(),
                        const SizedBox(height: 20),
                        // create text that could change because placed in stream
                        // so we will use stream builder
                        // grabbing stream from stream controller within our text
                        StreamBuilder(
                          stream: _text.stream,
                          builder: (context, snapshot) {
                            if (snapshot.hasData) {
                              return Text(
                                snapshot.data as String,
                                textAlign: TextAlign.center,
                              );
                            } else {
                              return Container();
                            }
                          },
                        ),
                      ],
                    ),
                  ),
                )),
          ),
        );
      },
    );

    // display overlay
    state?.insert(overlay);
    // return instance of loading screen controller - define our close and update for loading screen
    return LoadingScreenController(
      close: () {
        // have look at stream controller close it
        _text.close();
        // go to overlay and remove it from stream
        overlay.remove();
        // return true that has been close
        return true;
      },
      update: (text) {
        // add updated text to stream controller
        _text.add(text);
        // return true
        return true;
      },
    );
  }
}
