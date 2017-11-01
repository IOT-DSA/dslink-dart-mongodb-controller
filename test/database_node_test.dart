import 'dart:async';
import 'package:dslink/dslink.dart';
import 'package:dslink_dslink_mongodb_management/mongo_dslink.dart';
import 'package:dslink_dslink_mongodb_management/nodes.dart';
import 'package:mockito/mockito.dart';
import 'package:test/test.dart';
import 'mocks.dart';

void main() {
  final path = '/pathName';
  SimpleNodeProvider provider;
  MongoClient mongoClient;

  DatabaseNode dbNode;

  setUp(() {
    mongoClient = new MongoClientMock();
    provider = new ProviderMock();
    dbNode = new DatabaseNode.withCustomProvider(path, mongoClient, provider);
  });

  test('create collections nodes', () async {
    final collections = ['collection1', 'collection2'];
    when(mongoClient.listCollections())
        .thenReturn(new Future.value(collections));

    await dbNode.onCreated();

    for (final collection in collections) {
      final collectionNodePath = '$path/$collection';
      final child = verify(provider.setNode(collectionNodePath, captureAny))
          .captured
          .first;
      expect(child, const isInstanceOf<CollectionNode>());
    }
  });
}