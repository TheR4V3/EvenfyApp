// ignore_for_file: use_build_context_synchronously

import 'package:camera/camera.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:mobpro/helper/navigators.dart';
import 'package:mobpro/widgets/camera_page.dart';

class Dialogs {
  static Future<void> image({
    required BuildContext context,
    required bool multiple,
    required bool allowGallery,
    required void Function(List<Uint8List> files) callback,
  }) async {
    if (allowGallery) {
      List<Widget> actions = [
        TextButton(
          child: const Text("Tutup"),
          onPressed: () => Navigators.pop(context),
        ),
      ];

      BoxDecoration boxDecoration = BoxDecoration(
        border: Border.all(
          color: Theme.of(context).colorScheme.primary,
          width: 1.5,
        ),
        borderRadius: BorderRadius.circular(8),
      );

      await showDialog(
        context: context,
        builder: (BuildContext buildContext) {
          return AlertDialog(
            title: const Text("Pilih sumber foto"),
            content: Row(
              children: [
                Expanded(
                  child: Container(
                    height: 100,
                    decoration: boxDecoration,
                    child: InkWell(
                      onTap: () async {
                        List<Uint8List> files = [];

                        List<XFile> xFiles = await ImagePicker().pickMultiImage(
                          imageQuality: 20,
                        );

                        for (XFile xFile in xFiles) {
                          Uint8List bytesFile = Uint8List.fromList(await xFile.readAsBytes());

                          files.add(
                            bytesFile,
                          );
                        }

                        Navigators.pop(context);

                        callback.call(files);
                      },
                      child: const Center(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [Icon(Icons.photo), Text("Gallery")],
                        ),
                      ),
                    ),
                  ),
                ),
                const SizedBox(
                  width: 10,
                ),
                Expanded(
                  child: Container(
                    height: 100,
                    decoration: boxDecoration,
                    child: InkWell(
                      onTap: () async {
                        List<Uint8List> byteList = [];

                        await availableCameras().then((value) {
                          Navigators.push(
                            context,
                            CameraPage(
                                cameraDescriptions: value,
                                callback: (bytes) async {
                                  byteList.add(
                                    bytes,
                                  );

                                  Navigators.pop(context);

                                  callback.call(byteList);
                                },
                              )
                          );
                        });
                      },
                      child: const Center(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [Icon(Icons.camera_alt), Text("Kamera")],
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
            actions: actions,
          );
        },
      );
    } else {
      List<Uint8List> byteList = [];

      await availableCameras().then((value) {
        Navigators.push(
          context,
          CameraPage(
              cameraDescriptions: value,
              callback: (bytes) async {
                byteList.add(
                  bytes,
                );

                callback.call(byteList);
              },
        )
        );
      });
    }
  }
}