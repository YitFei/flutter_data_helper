// ignore_for_file: avoid_print
import 'package:data_helper/data_helper.dart';
import 'package:data_helper/src/data_source.dart';
import 'package:data_helper/src/list_extension.dart';
import 'package:data_helper/src/mt_data_row.dart';
import 'package:data_helper/src/mt_datatable.dart';
import 'package:data_helper/src/printing.dart';

List<MTDataRow<Map<String, dynamic>>> mockData = [
  MTDataRow(data: {"name": "a", "title": "1"}),
  MTDataRow(data: {"name": "b", "title": "2"}),
  MTDataRow(data: {"name": "c", "title": "3"}),
  MTDataRow(data: {"name": "d", "title": "4"}),
];
void main() async {
  MTDatatable<Map<String, dynamic>> datatable = MTDatatable();
  datatable.load(mockData);

  var ds = SqlDatasource<Map<String, dynamic>>(
      DatasourceConfig(tableName: '', primaryKeyName: ''));
  DataAdapter<Map<String, dynamic>> adapter = await DataAdapter.initialize(ds);

  await adapter.fill(datatable);
}

class SqlDatasource<T> extends IDataSource<T> {
  SqlDatasource(super.config);

  @override
  Future<void> initialize() async {}

  @override
  Future<List<T>> fetchData() async {
    return [];
  }

  @override
  Future<void> insertData(T data) async {}

  @override
  Future<void> updateData(T data) async {}

  @override
  Future<void> deleteData(T data) async {}
}

class Test implements DeepCopyable<Test> {
  String name;
  Test({
    required this.name,
  });

  @override
  Test copyWith({
    String? name,
  }) {
    return Test(
      name: name ?? this.name,
    );
  }
}
