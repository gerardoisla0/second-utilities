import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:json_annotation/json_annotation.dart';
import 'package:native_video_view/native_video_view.dart';

void main() => runApp(const MaterialApp(home: MyApp()));

class MyApp extends StatefulWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Plugin example app'),
      ),
      body: _buildVideoPlayerWidget(context),
    );
  }

  LanguajesData languajesData = LanguajesData();

  static const platform = const MethodChannel('videoview0');

  static StreamController<String> _controller = StreamController.broadcast();

  static Stream get streamData => _controller.stream;

  Future<Null> demoFunction(BuildContext context) async {
    try {
      final String result =
          await platform.invokeMethod('s3_upload', // call the native function
              <String, dynamic>{
            // data to be passed to the function
            'data': 'sample data',
          });
      // result hold the response from plaform calls
    } on PlatformException catch (error) {
      // handle error
      print('Error: $error'); // here
    }
  }

  VideoViewController? controlador;
  Widget _buildVideoPlayerWidget(BuildContext context) {
    return Container(
        alignment: Alignment.center,
        child: Stack(children: <Widget>[
          Container(
            height: 300.0,
            width: 300.0,
            padding: EdgeInsets.only(top: 40),
            child: NativeVideoView(
              keepAspectRatio: true,
              showMediaController: true,
              enableVolumeControl: true,
              onCreated: (controller) {
                controller.setVideoSource(
                  'http://ns557370.ip-54-39-52.net:8024/pelis/2022dual/Umma_2022.mkv',
                  sourceType: VideoSourceType.network,
                  requestAudioFocus: true,
                );
              },
              onPrepared: (controller, info) {
                debugPrint('NativeVideoView: Video prepared');
                setState(() {
                  controlador = controller;
                  languajesData.languajes = info.languajes;
                });
                controller.play();
              },
              onError: (controller, what, extra, message) {
                debugPrint(
                    'NativeVideoView: Player Error ($what | $extra | $message)');
              },
              onCompletion: (controller) {
                debugPrint('NativeVideoView: Video completed');
              },
            ),
          ),
          Container(
              height: 300.0,
              width: 300.0,
              padding: EdgeInsets.only(bottom: 0),
              child: languajesData.languajes != null &&
                      languajesData.languajes!.isNotEmpty
                  ? Column(children: 
                      languajesData.languajes!.entries.map((k) {
                        return FloatingActionButton.extended(
                          label: Text("${k.key}"),
                          icon: const Icon(Icons.thumb_up),
                          backgroundColor: Colors.pink,
                          onPressed: () {
                            if (controlador != null) {
                              controlador!.changeAudio(k.key);
                            }
                          },
                        );
                      }).toList()
                    )
                  : FloatingActionButton.extended(
                      label: const Text('Defecto'),
                      icon: const Icon(Icons.thumb_up),
                      backgroundColor: Colors.pink,
                      onPressed: () {
                        _MyAppState.streamData.listen((event) {
                          print("========callbackFromKotlinToDart--------");
                        });
                        demoFunction(context);
                      },
                    ))
        ]));
  }
}

@JsonSerializable()
class LanguajesData {
  Map<int, String>? languajes;

  LanguajesData({this.languajes});
}
