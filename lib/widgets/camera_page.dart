// ignore_for_file: cascade_invocations, always_put_required_named_parameters_first, always_specify_types, require_trailing_commas, use_build_context_synchronously

import "dart:typed_data";

import "package:camera/camera.dart";
import "package:flutter/material.dart";
import "package:flutter_image_compress/flutter_image_compress.dart";
import "package:mobpro/helper/navigators.dart";
import "package:mobpro/widgets/camera_preview_page.dart";

class CameraPage extends StatefulWidget {
  final List<CameraDescription>? cameraDescriptions;
  final void Function(Uint8List bytes) callback;

  const CameraPage({
    super.key,
    required this.cameraDescriptions,
    required this.callback,
  });

  @override
  State<CameraPage> createState() => CameraPageState();
}

class CameraPageState extends State<CameraPage> {
  bool holdCamera = false;
  bool rearCameraSelected = true;

  late CameraController cameraController;

  @override
  void initState() {
    super.initState();

    initCamera(widget.cameraDescriptions![0]);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Stack(
          children: [
            body(),
            Visibility(
              visible: holdCamera,
              child: Align(
                alignment: Alignment.center,
                child: Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(10),
                    color: Colors.white,
                  ),
                  child: const Text(
                    "Tahan Posisi Kamera",
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
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
                  children: [
                    Expanded(
                      child: IconButton(
                        padding: EdgeInsets.zero,
                        iconSize: 30,
                        icon: Icon(
                          rearCameraSelected ? Icons.switch_camera : Icons.switch_camera_outlined,
                          color: Colors.white,
                        ),
                        onPressed: () {
                          setState(
                            () => rearCameraSelected = !rearCameraSelected,
                          );

                          initCamera(
                            widget.cameraDescriptions![rearCameraSelected ? 0 : 1],
                          );
                        },
                      ),
                    ),
                    Expanded(
                      child: IconButton(
                        onPressed: takePicture,
                        iconSize: 50,
                        padding: EdgeInsets.zero,
                        constraints: const BoxConstraints(),
                        icon: const Icon(
                          Icons.circle,
                          color: Colors.white,
                        ),
                      ),
                    ),
                    const Spacer()
                  ],
                ),
              ),
            )
          ],
        ),
      ),
    );
  }

  @override
  void dispose() {
    cameraController.dispose();

    super.dispose();
  }

  Widget body() {
    if (cameraController.value.isInitialized) {
      return CameraPreview(cameraController);
    } else {
      return Container(
        color: Colors.black,
        child: const Center(child: CircularProgressIndicator()),
      );
    }
  }

  Future takePicture() async {
    if (!cameraController.value.isInitialized) {
      return null;
    }

    if (cameraController.value.isTakingPicture) {
      return null;
    }

    try {
      setState(() {
        holdCamera = true;
      });

      await cameraController.setFlashMode(FlashMode.off);

      XFile xFile = await cameraController.takePicture();

      Uint8List bytesFile = Uint8List.fromList(
        await xFile.readAsBytes(),
      );

      Uint8List compressedBytes = await FlutterImageCompress.compressWithList(
        bytesFile,
      );

      Navigators.pushReplacement(
        context,
        CameraPreviewPage(
          bytes: compressedBytes,
          cameraDescriptions: widget.cameraDescriptions,
          callback: widget.callback,
        ),
      );
    } on CameraException catch (e) {
      debugPrint("Error occured while taking picture: $e");

      return null;
    } finally {
      setState(() {
        holdCamera = false;
      });
    }
  }

  Future<void> initCamera(CameraDescription cameraDescription) async {
    cameraController = CameraController(
      cameraDescription,
      ResolutionPreset.high,
      enableAudio: false,
    );

    cameraController.setFocusMode(FocusMode.auto);
    cameraController.setExposureMode(ExposureMode.auto);

    try {
      await cameraController.initialize().then((_) {
        if (!mounted) {
          return;
        }

        setState(() {});
      });
    } on CameraException catch (e) {
      debugPrint("camera error $e");
    }
  }
}
