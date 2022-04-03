import 'dart:convert';

import 'package:gofile_dart/src/gofile_exception.dart';

import 'gofile_folder_option.dart';

import 'gofile_const.dart';
import 'gofile_response.dart';

import 'package:http/http.dart' as http;
import 'dart:io';

/// The [GoFileClient] class is a wrapper around the gofile API
/// It provide a simple implementation of the methods available in the API
/// See [Gofile API documentation](https://gofile.io/api) for more information
class GoFileClient {
  /// The API key used to authenticate the requests
  final String token;

  /// The client used for making the request
  /// It is initialized with the [token]
  GoFileClient(this.token);

  /// Returns the best server available to receive files.
  ///  Throw exception if the request failed
  Future<String> getServer() async {
    final uri = Uri.parse('$baseUrl/getServer');

    final response = await http.get(uri);
    if (response.statusCode == 200) {
      final goFileResponse =
          GoFileResponse.fromJson(json.decode(response.body));

      if (goFileResponse.status == 'ok') {
        return goFileResponse.data['server'];
      } else {
        throw GoFileException.fromJson(json.decode(response.body));
      }
    } else {
      throw Exception('Failed to get server');
    }
  }

  /// Upload one file on a specific [server].
  /// If you specify a [folderId], the file will be added to this folder.
  /// [server] must be obtain from [getServer]
  /// If [useToken] is true, the file will be added to this account.
  /// If undefined, a guest account will be created to receive the file.
  /// [folderId] require [useToken] set to true
  Future<Map<String, dynamic>> uploadFile(String server, File file,
      {bool useToken = true, String? folderId}) async {
    if (server.isEmpty) {
      throw ArgumentError('Server is empty');
    }

    if (!await file.exists()) {
      throw ArgumentError('File ${file.path} does not exist');
    }

    if (useToken && token.isEmpty) {
      throw ArgumentError('API key is empty');
    }

    final uri = Uri.parse('https://$server.gofile.io/uploadFile');

    final bodyFields = <String, String>{
      ...useToken ? {'token': token} : {},
      ...folderId != null && useToken ? {'folderId': folderId} : {},
    };

    final request = http.MultipartRequest('POST', uri)
      ..fields.addAll(bodyFields);

    request.files.add(await http.MultipartFile.fromPath('file', file.path));

    final response = await request.send();

    if (response.statusCode == 200) {
      final body = await response.stream.transform(utf8.decoder).join();

      final goFileResponse = GoFileResponse.fromJson(json.decode(body));

      if (goFileResponse.status == 'ok') {
        return goFileResponse.data;
      } else {
        throw GoFileException.fromJson(json.decode(body));
      }
    } else {
      throw Exception('Failed to upload file');
    }
  }

  /// Get a specific content details
  /// [contentID] is the id of the content
  ///  Will throw an [ArgumentError] if the [token] is empty
  Future<Map<String, dynamic>> getContent(String contentId) async {
    if (contentId.isEmpty) {
      throw ArgumentError('Content id is empty');
    }

    if (token.isEmpty) {
      throw ArgumentError('API key is empty');
    }

    final uri =
        Uri.parse('$baseUrl/getContent?contentId=$contentId&token=$token');

    final response = await http.get(uri);

    if (response.statusCode == 200) {
      final goFileResponse =
          GoFileResponse.fromJson(json.decode(response.body));

      if (goFileResponse.status == 'ok') {
        return goFileResponse.data;
      } else {
        throw GoFileException.fromJson(json.decode(response.body));
      }
    } else {
      throw Exception('Failed to get content');
    }
  }

  /// Create a new folder
  /// [parentFolderId] is the id of the parent folder
  /// [folderName] is the name of the folder to be created
  /// Will throw an [ArgumentError] if [parentFolderId], [folderName] or [token] is empty
  Future<bool> createFolder(String parentFolderId, String folderName) async {
    if (parentFolderId.isEmpty) {
      throw ArgumentError('Parent folder id is empty');
    }

    if (folderName.isEmpty) {
      throw ArgumentError('Folder name is empty');
    }

    if (token.isEmpty) {
      throw ArgumentError('API key is empty');
    }

    final uri = Uri.parse('$baseUrl/createFolder');

    final bodyFields = <String, String>{
      'token': token,
      'parentFolderId': parentFolderId,
      'folderName': folderName,
    };

    final response = await http.put(uri, body: bodyFields);

    if (response.statusCode == 200) {
      final goFileResponse =
          GoFileResponse.fromJson(json.decode(response.body));

      if (goFileResponse.status == 'ok') {
        return true;
      } else {
        throw GoFileException.fromJson(json.decode(response.body));
      }
    } else {
      throw Exception('Failed to create folder');
    }
  }

  /// Set an option on a folder
  /// [folderId] is the id of the folder
  /// [option] is the option to be set, only one option can be set at a time
  /// [value] is the value of the option, the value **will be not** validated before sending the request
  Future<bool> setFolderOption(
      String folderId, GoFileFolderOption option, String value) async {
    if (folderId.isEmpty) {
      throw ArgumentError('Folder id is empty');
    }

    if (token.isEmpty) {
      throw ArgumentError('API key is empty');
    }

    final uri = Uri.parse('$baseUrl/setFolderOption');

    final bodyFields = <String, String>{
      'token': token,
      'folderId': folderId,
      'option': option.toString().split('.').last,
      'value': value,
    };

    final response = await http.put(uri, body: bodyFields);

    if (response.statusCode == 200) {
      final goFileResponse =
          GoFileResponse.fromJson(json.decode(response.body));

      if (goFileResponse.status == 'ok') {
        return true;
      } else {
        throw GoFileException.fromJson(json.decode(response.body));
      }
    } else {
      throw Exception('Failed to set folder option');
    }
  }

  /// Copy one or multiple contents to another folder
  /// [contentIds] is the list of content ids to be copied
  /// [destinationFolderId] is the id of the destination folder
  /// Will throw an [ArgumentError] if [contentIds], [destinationFolderId] or [token] is empty
  Future<bool> copyContent(List<String> contentsId, String folderIdDest) async {
    if (contentsId.isEmpty) {
      throw ArgumentError('Contents id is empty');
    }

    if (folderIdDest.isEmpty) {
      throw ArgumentError('Folder id is empty');
    }

    if (token.isEmpty) {
      throw ArgumentError('API key is empty');
    }

    final uri = Uri.parse('$baseUrl/copyContent');

    final bodyFields = <String, String>{
      'token': token,
      'contentsId': contentsId.join(','),
      'folderIdDest': folderIdDest,
    };

    final response = await http.put(uri, body: bodyFields);

    if (response.statusCode == 200) {
      final goFileResponse =
          GoFileResponse.fromJson(json.decode(response.body));

      if (goFileResponse.status == 'ok') {
        return true;
      } else {
        throw GoFileException.fromJson(json.decode(response.body));
      }
    } else {
      throw Exception('Failed to copy content');
    }
  }

  /// Delete one or multiple files/folders
  /// [contentIds] is the list of content ids to be deleted
  /// Will throw an [ArgumentError] if [contentIds] or [token] is empty
  Future<bool> deleteContent(List<String> contentsId) async {
    if (contentsId.isEmpty) {
      throw ArgumentError('Contents id is empty');
    }

    if (token.isEmpty) {
      throw ArgumentError('API key is empty');
    }

    final uri = Uri.parse('$baseUrl/deleteContent');

    final bodyFields = <String, String>{
      'token': token,
      'contentsId': contentsId.join(','),
    };

    final response = await http.delete(uri, body: bodyFields);

    if (response.statusCode == 200) {
      final goFileResponse =
          GoFileResponse.fromJson(json.decode(response.body));

      if (goFileResponse.status == 'ok') {
        return true;
      } else {
        throw GoFileException.fromJson(json.decode(response.body));
      }
    } else {
      throw Exception('Failed to delete content');
    }
  }

  /// Retrieving specific account information
  /// If [allDetails] is all details will be returned.
  Future<Map<String, dynamic>> getAccountDetails(
      {bool allDetails = false}) async {
    if (token.isEmpty) {
      throw ArgumentError('API key is empty');
    }

    final uri = Uri.parse(
        '$baseUrl/getAccountDetails?token=$token&allDetails=$allDetails');

    final response = await http.get(uri);

    if (response.statusCode == 200) {
      final goFileResponse =
          GoFileResponse.fromJson(json.decode(response.body));

      if (goFileResponse.status == 'ok') {
        return goFileResponse.data;
      } else {
        throw GoFileException.fromJson(json.decode(response.body));
      }
    } else {
      throw Exception('Failed to get account details');
    }
  }
}
