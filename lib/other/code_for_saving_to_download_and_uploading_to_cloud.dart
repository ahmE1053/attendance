// await QrPainter(data: 'hello', version: QrVersions.auto)
//     .toImageData(500);
// Directory generalDownloadDir =
//     Directory('/storage/emulated/0/Download');
// final path = join(
//     (await getApplicationDocumentsDirectory()).path,
//     'image${qrKey.substring(0, 5)}.png');
// File downloadImage =
//     await File('${generalDownloadDir.path}/myImage.png')
//         .create();
// await downloadImage.writeAsBytes(image!.buffer.asUint8List());
//
// final imageFile = await File(path).writeAsBytes(
//   image!.buffer.asUint8List(
//     image.offsetInBytes,
//     image.lengthInBytes,
//   ),
// );
// final cloudStorage = FirebaseStorage.instance;
// final ref = cloudStorage.ref();
// final fileRef = ref.child('image${qrKey.substring(0, 5)}.png');
// fileRef
//     .putFile(imageFile)
//     .snapshotEvents
//     .listen((taskSnapshot) async {
//   switch (taskSnapshot.state) {
//     case TaskState.running:
//       final progress = 100.0 *
//           (taskSnapshot.bytesTransferred /
//               taskSnapshot.totalBytes);
//       print('Upload is $progress% complete.');
//       break;
//     case TaskState.paused:
//       print('Upload is paused.');
//       break;
//     case TaskState.canceled:
//       print('Upload was canceled');
//       break;
//     case TaskState.error:
//       // Handle unsuccessful uploads
//       break;
//     case TaskState.success:
//       print(await taskSnapshot.ref.getDownloadURL());
//       // Handle successful uploads on complete
//       // ...
//       break;
//   }
// });

//************************************************************************//

// FutureBuilder(
//     future: (<String>() async {
//       final path = await getApplicationDocumentsDirectory();
//       final imagePath = join(path.path, 'image.png');
//       print(await File(imagePath).exists());
//       return imagePath;
//     }).call(),
//     builder: (context, snap) {
//       return Image(
//         image: FileImage(File(snap.data!)),
//       );
//     }),
