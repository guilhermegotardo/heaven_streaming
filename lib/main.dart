import 'package:flutter/material.dart';
import 'app/app_widget.dart';
import 'package:media_kit/media_kit.dart';
import 'package:video_player_media_kit/video_player_media_kit.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  MediaKit.ensureInitialized();
  VideoPlayerMediaKit.ensureInitialized(
    windows: true,
  );
  runApp(const AppWidget());

}
