import 'dart:async';

import 'package:mt_data_helper/data_helper.dart';

class MTDataAdapter<T extends MTData> {
  late MTDataTable<T> _originalDatatable;
  late MTDataTable<T> _datatable;
  MTDataTable<T> get originalDatatable => _originalDatatable;
  MTDataTable<T> get datatable => _datatable;
  late final MTDataSource<T> dataSource;

  MTDataAdapter._(this.dataSource) {
    _originalDatatable = MTDataTable<T>().deepCopy();
    _datatable = MTDataTable<T>();
  }

  static Future<MTDataAdapter<T>> initialize<T extends MTData>(
      MTDataSource<T> datasource) async {
    final adapter = MTDataAdapter<T>._(datasource);
    await adapter._initialize();
    return adapter;
  }

  Future<void> _initialize() async {
    if (!dataSource.initCompleter.isCompleted) {
      await dataSource.initialized;
    }
  }

  Future<void> fill(MTDataTable<T>? datatable) async {
    _datatable = datatable ?? MTDataTable();
    final List<T> dataList = await dataSource.fetchData();

    _datatable.clear();
    _datatable.load(dataList.map((data) => MTDataRow(data: data)).toList());
    _originalDatatable = _datatable.deepCopy();
  }

  Future<void> update({bool acceptChanges = true}) async {
    RowChanges<T> rowChanges = datatable.getChanges();

    await dataSource.batchInsertData(rowChanges.inserted);
    await dataSource.batchUpdateData(rowChanges.updated);
    await dataSource.batchDeleteData(rowChanges.deleted);

    if (acceptChanges) {
      datatable.acceptChanges();
    }
  }
}
