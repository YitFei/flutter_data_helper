import 'dart:async';

abstract class IDataSource<T> {
  final Completer<void> initCompleter = Completer<void>();

  Future<void> get initialized => initCompleter.future;

  final DatasourceConfig config;

  IDataSource(this.config) {
    initialize().then((_) {
      initCompleter.complete();
    }).catchError((error) {
      initCompleter.completeError(error);
    });
  }

  Future<void> initialize();

  Future<List<T>> fetchData();

  Future<void> insertData(T data);

  Future<void> updateData(T data);

  Future<void> deleteData(T data);
}

class DatasourceConfig {
  final String tableName;
  final String primaryKeyName;
  DatasourceConfig({
    required this.tableName,
    required this.primaryKeyName,
  });
}
