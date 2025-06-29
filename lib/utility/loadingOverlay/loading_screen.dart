import 'dart:async';

import 'package:finshyt/constants/app_colors.dart';
import 'package:finshyt/utility/loadingOverlay/loading_screen_controller.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class LoadingScreen {
  factory LoadingScreen() => _shared;
  static final LoadingScreen _shared = LoadingScreen._sharedInstance();
  LoadingScreen._sharedInstance();

  LoadingScreenController? controller;

  void show({required BuildContext context, required String text}){
    if(controller?.update(text) ?? false){
      return;
    } else{
      controller = showOverlay(context: context, text: text);
    }
  }
  
  void hide(){
    controller?.close();
    controller = null;
  }

  LoadingScreenController showOverlay({
    required BuildContext context,
    required String text,
  }) {
    final _text = StreamController<String>();
    _text.add(text);

    final state = Overlay.of(context);
    final renderBox = context.findRenderObject() as RenderBox;
    final size = renderBox.size;

    final overlay = OverlayEntry(
      builder: (context) {
        return Material(
          color: Colors.black.withAlpha(150),
          child: Center(
            child: Container(
              constraints: BoxConstraints(
                maxHeight: size.height * 0.8,
                maxWidth: size.width * 0.8,
                minWidth: size.width * 0.5,
              ),
              decoration: BoxDecoration(
                color: AppColors.background,
                borderRadius: BorderRadius.circular(10.0),
              ),
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: SingleChildScrollView(
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const SizedBox(height: 10),
                      const CircularProgressIndicator(
                        color: AppColors.secondaryButton,
                      ),
                      const SizedBox(height: 10),
                      StreamBuilder(
                        stream: _text.stream,
                        builder: (context, snapshot) {
                          if(snapshot.hasData){
                            return Text(
                              snapshot.data as String,
                              textAlign: TextAlign.center,
                              style: GoogleFonts.inter(color: AppColors.text, fontSize: 16),
                            );
                          } else {
                            return Container();
                          }
                        },
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        );
      },
    );
  
    state.insert(overlay);

    return LoadingScreenController(close:() {
      _text.close();
      overlay.remove();
      return true;
    }, update:(text) {
      _text.add(text);
      return true;
    },);
  
  }
}
