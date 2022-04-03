import 'dart:io';

import 'package:gofile_dart/gofile_dart.dart';

void main() async {
  // We create a client to be used with the API
  // The token authenticate the account used for the request
  final client = GoFileClient('dQzZDTAB4QzgLUPFxxriGtKkGdabPEzF');

  // Each request may throw either an Exception or a GoFileException
  // Exception a throw when the request failed
  // GoFileException a throw when the request status is not 'ok'
  try {
    // Get the best server available to receive files
    final server = await client.getServer();

    // The file to be uploaded
    // You can only upload ONE file at a time
    // If you want to upload multiple files, you need recursively call the method
    // and pass the parentFolder attribute from the first request inside the folderId parameter
    final file = File('example/example_upload.txt');

    // Using a list to store the file to be uploaded
    List<File> files = [file, file, file, file, file];

    // This will be the folder created by the first upload
    String? folderId;

    for (var file in files) {
      // If folderId is null , we're going to upload the first file
      if (folderId == null) {
        final uploadedFileData = await client.uploadFile(server, file);
        // Getting the parentFolder's id to upload the others file in the same folder
        folderId = uploadedFileData['parentFolder'];
      } else {
        final uploadedFileData =
            await client.uploadFile(server, file, folderId: folderId);
      }
    }
  } on GoFileException catch (e) {
    // In case of an error, we can get the status returned by the api
    print(e.status);
  }
}
