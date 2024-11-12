import 'dart:async';

import 'package:mt_data_helper/data_helper.dart';

class MTDataAdapter<T> {
  late MTDatatable<T> _originalDatatable;
  late MTDatatable<T> _datatable;
  MTDatatable<T> get originalDatatable => _originalDatatable;
  MTDatatable<T> get datatable => _datatable;
  late final MTDataSource<T> dataSource;

  MTDataAdapter._(this.dataSource) {
    _originalDatatable = MTDatatable<T>().deepCopy();
    _datatable = MTDatatable<T>();
  }

  static Future<MTDataAdapter<T>> initialize<T>(
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

  Future<void> fill(MTDatatable<T>? datatable) async {
    _datatable = datatable ?? MTDatatable();
    final List<T> dataList = await dataSource.fetchData();

    _datatable.clear();
    _datatable.rows.addAll(dataList.map((data) => MTDataRow(data: data)));
    _originalDatatable = _datatable.deepCopy();
  }

  void update() async {
    RowChanges<T> rowChanges = datatable.getChanges();

    for (MTDataRow<T> dr in rowChanges.inserted) {
      await dataSource.insertData(dr.data);
    }

    for (MTDataRow<T> dr in rowChanges.updated) {
      await dataSource.updateData(dr.data);
    }

    for (MTDataRow<T> dr in rowChanges.deleted) {
      await dataSource.deleteData(dr.data);
    }
  }
}
