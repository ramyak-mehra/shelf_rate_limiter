import 'package:shelf_rate_limiter/src/storage/memory_storage.dart';
import 'package:test/test.dart';

void main() {
  group('MemStorage', () {
    test('should return null when key is not found', () {
      var storage = MemStorage();
      expect(storage.getItem('key'), isNull);
    });

    test('should return value when key is found', () {
      var storage = MemStorage();

      storage.add('key', Duration(seconds: 1));
      expect(storage.getItem('key')!.accessCount, 1);
      expect(storage.getItem('key')!.key, 'key');
    });

    test('return all items in the storage', () {
      var storage = MemStorage();

      storage.add('key', Duration(seconds: 1));
      storage.add('key2', Duration(seconds: 1));
      storage.add('key3', Duration(seconds: 1));

      expect(storage.getItems().length, 3);
      expect(storage.getItems().isEmpty, false);
    });
    test('should should update the access count.', () {
      var storage = MemStorage();

      storage.add('key', Duration(seconds: 1));
      storage.updateCount('key');
      storage.updateCount('key');
      storage.updateCount('key');
      expect(storage.getItem('key')!.accessCount, 4);
    });

    test(
        'should update the access count instead of adding the item if it already contains the key',
        () {
      var storage = MemStorage();
      storage.add('key', Duration(seconds: 1));
      storage.updateCount('key');
      storage.updateCount('key');
      expect(storage.getItem('key')!.accessCount, 3);
      storage.add('key', Duration(seconds: 1));

      expect(storage.getItem('key')!.accessCount, 4);
    });

    test('reset access count to 1', () {
      var storage = MemStorage();
      storage.add('key', Duration(seconds: 1));
      storage.updateCount('key');
      storage.updateCount('key');
      storage.updateCount('key');
      storage.resetIp('key', Duration(seconds: 1));
      expect(storage.getItem('key')!.accessCount, 1);
    });

    test('reset all items access count to 1', () {
      var storage = MemStorage();
      storage.add('key', Duration(seconds: 1));
      storage.updateCount('key');
      storage.updateCount('key');
      storage.updateCount('key');
      storage.add('key2', Duration(seconds: 1));
      storage.updateCount('key2');
      storage.updateCount('key2');
      storage.updateCount('key2');
      expect(storage.getItem('key')!.accessCount, 4);
      expect(storage.getItem('key2')!.accessCount, 4);
      storage.resetAll(Duration(seconds: 1));
      expect(storage.getItem('key')!.accessCount, 1);
      expect(storage.getItem('key2')!.accessCount, 1);
    });

    test('should remove the item if key is found', () {
      var storage = MemStorage();

      storage.add('key', Duration(seconds: 1));
      expect(storage.getItem('key')!.accessCount, 1);
      expect(storage.getItem('key')!.key, 'key');
      storage.remove('key');
      expect(storage.getItem('key'), isNull);
    });

    test('remove all items in the storage', () {
      var storage = MemStorage();

      storage.add('key', Duration(seconds: 1));
      storage.add('key2', Duration(seconds: 1));
      storage.add('key3', Duration(seconds: 1));

      expect(storage.getItems().length, 3);
      expect(storage.getItems().isEmpty, false);
      storage.removeAll();
      expect(storage.getItems().isEmpty, true);
    });
  });
}
