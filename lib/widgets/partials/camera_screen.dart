import 'package:camera/camera.dart';
import 'package:flutter/material.dart';

class CameraScreen extends StatelessWidget {
  const CameraScreen({super.key, required this.controller});
  final CameraController controller;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        backgroundColor: Colors.black,
        foregroundColor: Colors.white,
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Expanded(child: CameraPreview(controller)),
            Padding(
              padding: const EdgeInsets.all(24),
              child: IconButton.filled(
                iconSize: 48,
                onPressed: () async {
                  final file = await controller.takePicture();
                  if (context.mounted) Navigator.of(context).pop(file);
                },
                icon: const Icon(Icons.camera_alt),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
