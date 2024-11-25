import 'package:mt_data_helper/data_helper.dart';

// extension DeepCopyList on List<Map<String, dynamic>> {
//   // `Map.from()` creates a new Map for each map, thus replicating all key-value pairs.
//   List<Map<String, dynamic>> deepCopy() {
//     return map((map) => Map<String, dynamic>.from(map)).toList();
//   }

//   // `List.from()` creates a new list but reuses the map references from the original list.
//   List<Map<String, dynamic>> shallowCopy() {
//     return List<Map<String, dynamic>>.from(this);
//   }
// }

// abstract class DeepCopyable<T> {
//   T copyWith();
// }

// extension CopyList<T extends DeepCopyable<T>> on List<T> {
//   // `Map.from()` creates a new Map for each map, thus replicating all key-value pairs.
//   List<T> deepCopy() {
//     return map((element) => element.copyWith()).toList();
//   }

//   // `List.from()` creates a new list but reuses the map references from the original list.
//   List<T> shallowCopy() {
//     return List<T>.from(this);
//   }
// }

extension MTDataRowCopyList<T extends MTData> on List<MTDataRow<T>> {
  MTDataTable<T> toDatatable() {
    return MTDataTable()..load(this);
  }

  List<MTDataRow<T>> deepCopy() {
    return map((datarow) {
      return MTDataRow<T>(data: datarow.data.copyWith() as T);
    }).toList();
  }

  List<MTDataRow<T>> shallowCopy() {
    return List<MTDataRow<T>>.from(this);
  }
}
