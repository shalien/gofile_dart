import 'dart:io';

import 'package:gofile_dart/gofile_dart.dart';

void main() async {
  // We create a client to be used with the API
  // The token authenticate the account used for the request
  final client = GoFileClient('token');

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

    /// Upload a file and return the meta data about the upload file
    final uploadedFileData = await client.uploadFile(server, file);

    print(uploadedFileData);
  } on GoFileException catch (e) {
    // In case of an error, we can get the status returned by the api
    print(e.status);
  }
}
