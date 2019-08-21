import 'dart:async';
import 'dart:typed_data';
import 'dart:ui' as ui;
import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

String username = "Player";
String msg = "Test message";
String filterName = "Default";
BitmapDescriptor userIcon;
BitmapDescriptor othersIcon;

void loadPinIcons() {
  BitmapDescriptor.fromAssetImage(
          ImageConfiguration(size: Size(1, 1)), 'assets/user.png')
      .then((onValue) {
    userIcon = onValue;
  });
  BitmapDescriptor.fromAssetImage(
          ImageConfiguration(size: Size(1, 1)), 'assets/others.png')
      .then((onValue) {
    othersIcon = onValue;
  });
}

Future<Uint8List> getBytesFromAsset(String path, int width) async {
  ByteData data = await rootBundle.load(path);
  ui.Codec codec = await ui.instantiateImageCodec(data.buffer.asUint8List(),
      targetWidth: width);
  ui.FrameInfo fi = await codec.getNextFrame();
  return (await fi.image.toByteData(format: ui.ImageByteFormat.png))
      .buffer
      .asUint8List();
}

Future<Uint8List> getBytesFromCanvas(double escala, urlAsset) async {
  final ui.PictureRecorder pictureRecorder = ui.PictureRecorder();
  final Canvas canvas = Canvas(pictureRecorder);
  final ByteData datai = await rootBundle.load(urlAsset);
  var imaged = await loadImage(new Uint8List.view(datai.buffer));
  double width = ((imaged.width.toDouble() * escala).toInt()).toDouble();
  double height = ((imaged.height.toDouble() * escala).toInt()).toDouble();
  canvas.drawImageRect(
    imaged,
    Rect.fromLTRB(0.0, 0.0, imaged.width.toDouble(), imaged.height.toDouble()),
    Rect.fromLTRB(0.0, 0.0, width, height),
    new Paint(),
  );

  final img = await pictureRecorder
      .endRecording()
      .toImage(width.toInt(), height.toInt());
  final data = await img.toByteData(format: ui.ImageByteFormat.png);
  return data.buffer.asUint8List();
}

Future<ui.Image> loadImage(List<int> img) async {
  final Completer<ui.Image> completer = new Completer();
  ui.decodeImageFromList(img, (ui.Image img) {
    return completer.complete(img);
  });
  return completer.future;
}
