import 'dart:async';

import 'package:flutter/material.dart';
import 'package:inotes/helpers/loading/loading_screen_controller.dart';

class LoadingScreen {
  static final LoadingScreen _singleton = LoadingScreen._internal();

  factory LoadingScreen() {
    return _singleton;
  }

  LoadingScreen._internal();

  LoadingScreenController? controller;

  void hide() {
    if (controller != null) {
      controller!.close();
    }
    controller = null;
  }

  void show({
    required String text,
    required BuildContext context,
  }) {
    if (controller?.update(text) ?? false) {
      return;
    } else {
      controller = showOverlay(
        text: text,
        context: context,
      );
    }
  }

  LoadingScreenController showOverlay({
    required String text,
    required BuildContext context,
  }) {
    final text0 = StreamController<String>();

    text0.add(text);

    final state = Overlay.of(context);
    final renderBox = context.findRenderObject() as RenderBox;
    final size = renderBox.size;

    final overlayEntry = OverlayEntry(
      builder: (context) {
        return Material(
          color: Colors.black.withAlpha(150),
          child: Center(
              child: Container(
            constraints: BoxConstraints(
              maxWidth: size.width * 0.8,
              maxHeight: size.height * 0.8,
              minWidth: size.width * 0.5,
            ),
            decoration: BoxDecoration(
              color: Theme.of(context).scaffoldBackgroundColor,
              borderRadius: BorderRadius.circular(10),
            ),
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: SingleChildScrollView(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const SizedBox(height: 10),
                    const CircularProgressIndicator(),
                    const SizedBox(height: 16),
                    StreamBuilder(
                        stream: text0.stream,
                        builder: (context, snapshot) {
                          if (snapshot.hasData) {
                            return Text(
                              snapshot.data.toString(),
                              textAlign: TextAlign.center,
                            );
                          } else {
                            return const SizedBox();
                          }
                        }),
                  ],
                ),
              ),
            ),
          )),
        );
      },
    );

    state.insert(overlayEntry);

    return LoadingScreenController(
      close: () {
        text0.close();
        overlayEntry.remove();
        return true;
      },
      update: (text) {
        text0.add(text);
        return true;
      },
    );
  }
}
