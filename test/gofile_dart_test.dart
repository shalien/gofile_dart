import 'dart:io';

import 'package:dotenv/dotenv.dart';
import 'package:gofile_dart/gofile_dart.dart';
import 'package:test/test.dart';

void main() {
  late GoFileClient client;

  late String rootFolderId;
  late String chosenServer;
  late String testFolderId;

  setUp(() {
    load();
    client = GoFileClient(env['API_KEY'].toString());
  });

  group('GoFile API Test', () {
    test('Get account details', () async {
      final accountDetails = await client.getAccountDetails();

      rootFolderId = accountDetails['rootFolder'];

      expect(accountDetails, isMap);
    });

    test('Create a new folder', () async {
      final isCreated = await client.createFolder(rootFolderId, 'testFolder');

      expect(isCreated, true);
    });

    test('Find the test folder id', () async {
      final rootContent = await client.getContent(rootFolderId);

      testFolderId = rootContent['contents']
          .entries
          .firstWhere((entry) =>
              entry.value['type'] == 'folder' &&
              entry.value['name'] == 'testFolder')
          .key;

      expect(testFolderId, isNotNull);
    });

    test('Get a server', () async {
      final server = await client.getServer();

      chosenServer = server;

      expect(server, isNotNull);
    });

    test('Upload file', () async {
      final file = File('test/test.txt');

      final response = await client.uploadFile(chosenServer, file,
          useToken: true, folderId: testFolderId);

      expect(response, isNotNull);
    });
  });
}
