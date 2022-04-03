# GOFILE DART

This package wrap the [Gofile](https://gofile.io) API.
It allow to use the API in a simple way.

## Features

 - Implements all the current endpoint of the API
 - Allow to easily request the API without having to write the request

## Getting started

You will need  to create an account on [Gofile](https://gofile.io) and get your API token from your profile.

Then you can install the library with: 
    ```dart
    dart pub add gofile_dart
    ```

## Usage

```dart
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
```

## Additional information

The Gofile API is still in beta, this package will be updated as soon as possible.
Some endpoint require a Gofile subscription

## Disclaimer 
The name and the logo of Gofile are used with the written authorization of the gofile team.
This package isn't affiliated with the gofile team in anyway