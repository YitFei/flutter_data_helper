import 'dart:async';
import 'package:mt_data_helper/data_helper.dart';

abstract class MTDataSource<T extends MTData> {
  final Completer<void> initCompleter = Completer<void>();

  Future<void> get initialized => initCompleter.future;

  final MTDatasourceConfig<T> config;

  MTDataSource(this.config) {
    initialize().then((_) {
      initCompleter.complete();
    }).catchError((error) {
      initCompleter.completeError(error);
    });
  }

  Future<void> initialize();

  Future<List<T>> fetchData();

  Future<void> batchInsertData(List<MTDataRow<T>> datarows);

  Future<void> batchUpdateData(List<MTDataRow<T>> datarows);

  Future<void> batchDeleteData(List<MTDataRow<T>> datarows);
}

class MTDatasourceConfig<T extends MTData> {
  final String tableName;
  final String primaryKeyName;
  final T Function(Map<String, dynamic>) fromMap;
  MTDatasourceConfig(
      {required this.tableName,
      required this.primaryKeyName,
      required this.fromMap});
}
