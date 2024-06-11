// ignore_for_file: require_trailing_commas, always_specify_types, always_put_required_named_parameters_first

import "dart:typed_data";

import "package:camera/camera.dart";
import "package:flutter/material.dart";
import "package:mobpro/helper/navigators.dart";
import "package:mobpro/widgets/camera_page.dart";

class CameraPreviewPage extends StatefulWidget {
  final Uint8List bytes;
  final List<CameraDescription>? cameraDescriptions;
  final void Function(Uint8List bytes) callback;

  const CameraPreviewPage({
    super.key,
    required this.bytes,
    required this.cameraDescriptions,
    required this.callback,
  });

  @override
  State<CameraPreviewPage> createState() => CameraPreviewPageState();
}

class CameraPreviewPageState extends State<CameraPreviewPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Stack(
          children: [
            Image.memory(
              widget.bytes,
              fit: BoxFit.cover,
              width: MediaQuery.of(context).size.width,
            ),
            Align(
              alignment: Alignment.bottomCenter,
              child: Container(
                height: MediaQuery.of(context).size.height * 0.20,
                decoration: const BoxDecoration(
                  borderRadius: BorderRadius.vertical(
                    top: Radius.circular(24),
                  ),
                  color: Colors.black,
                ),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        IconButton(
                          iconSize: 30,
                          icon: const Icon(
                            Icons.refresh,
                            color: Colors.white,
                          ),
                          onPressed: () {
                            Navigators.pushReplacement(
                              context,
                              CameraPage(
                                cameraDescriptions: widget.cameraDescriptions,
                                callback: widget.callback,
                              ),
                            );
                          },
                        ),
                        const Text(
                          "Foto Ulang",
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                          ),
                        )
                      ],
                    ),
                    const SizedBox(
                      width: 30,
                    ),
                    Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        IconButton(
                          iconSize: 30,
                          icon: const Icon(
                            Icons.check,
                            color: Colors.white,
                          ),
                          onPressed: () {
                            Navigators.pop(context);

                            widget.callback.call(widget.bytes);
                          },
                        ),
                        const Text(
                          "Gunakan Foto",
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                          ),
                        )
                      ],
                    )
                  ],
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}
