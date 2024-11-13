// ignore_for_file: avoid_print
import 'package:mt_data_helper/src/mt_data_adapter.dart';
import 'package:mt_data_helper/src/mt_data_source.dart';
import 'package:mt_data_helper/src/mt_data_row.dart';
import 'package:mt_data_helper/src/mt_datatable.dart';
import 'package:mt_data_helper/src/printing.dart';

// List<MTDataRow<Map<String, dynamic>>> mockData = [
//   MTDataRow(data: {"name": "a", "title": "1"}),
//   MTDataRow(data: {"name": "b", "title": "2"}),
//   MTDataRow(data: {"name": "c", "title": "3"}),
//   MTDataRow(data: {"name": "d", "title": "4"}),
// ];
void main() async {
  // MTDatatable<MTMap> datatable = MTDatatable();
  // datatable.load([
  //   MTDataRow(data: MTMap({"name": "1"}))
  // ]);

  // var ds = SqlDatasource<MTMap>(MTDatasourceConfig(
  //     tableName: '', primaryKeyName: '', fromMap: MTMap.fromMap));
  // MTDataAdapter<MTMap> adapter = await MTDataAdapter.initialize(ds);
  // List<MTMap> dataList = await ds.fetchData();
  // dataList[0]['name'] = "9943";
  // warningPrint(dataList.map((e) => e['name']).toString());

  MTDatatable<Test> datatable = MTDatatable();
  datatable.load([MTDataRow(data: Test(name: "123"))]);
  var ds = SqlDatasource<Test>(MTDatasourceConfig(
      tableName: '', primaryKeyName: '', fromMap: Test.fromMap));
  MTDataAdapter<Test> adapter = await MTDataAdapter.initialize(ds);
  await adapter.fill(datatable);
  var newDataRow = MTDataRow(data: Test(name: "123"));
  datatable.rows.insert(0, newDataRow);
  // datatable.rows.remove(newDataRow);
  // datatable.newRow = ;
  // datatable.rows.remove(datatable.rows.first);
  warningPrint(
      "Before Update -> ${datatable.fullRows.map((dr) => dr.rowState).toString()}");
  await adapter.update();

  // datatable.acceptChanges();

  warningPrint(datatable.fullRows.map((dr) => dr.rowState).toString());
}

class SqlDatasource<T extends MTData> extends MTDataSource<T> {
  SqlDatasource(super.config);

  @override
  Future<void> batchDeleteData(List<MTDataRow<T>> data) async {
    infoPrint("deleted");
    warningPrint(data.map((e) => e.data.toMap()['name']).toString());
  }

  @override
  Future<void> batchInsertData(List<MTDataRow<T>> list) async {
    infoPrint("inserted");
    warningPrint(list.map((e) => e.data.toMap()['name']).toString());
  }

  @override
  Future<void> batchUpdateData(List<MTDataRow<T>> data) async {
    infoPrint("updated");
    warningPrint(data.map((e) => e.data.toMap()['name']).toString());
  }

  @override
  Future<List<T>> fetchData() async {
    List<Map<String, dynamic>> dataList = [
      {"name": "a", "title": "1"}
    ];

    return dataList.map((data) => config.fromMap(data)).toList();
  }

  @override
  Future<void> initialize() async {}
}

class Test implements MTData {
  String name;
  Test({
    required this.name,
  });

  factory Test.fromMap(Map<String, dynamic> map) {
    return Test(name: map['name']);
  }

  @override
  Map<String, dynamic> toMap() {
    return {"name": name};
  }

  @override
  MTData fromMap(Map<String, dynamic> map) => fromMap(map);

  @override
  Test copyWith({
    String? name,
  }) {
    return Test(
      name: name ?? this.name,
    );
  }
}
