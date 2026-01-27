class HistoryModel {
  final Map<String, Map<String, HistoryItem>> history;

  HistoryModel({required this.history});

  factory HistoryModel.fromJson(Map<String, dynamic> json) {
    final Map<String, Map<String, HistoryItem>> tempHistory = {};

    final historyJson = json['history'] as Map<String, dynamic>;

    historyJson.forEach((date, items) {
      tempHistory[date] = {};

      final objects = items as Map<String, dynamic>;
      objects.forEach((objId, value) {
        tempHistory[date]![objId] = HistoryItem.fromJson(
          int.parse(objId), // ← objId из ключа
          value as Map<String, dynamic>,
        );
      });
    });

    return HistoryModel(history: tempHistory);
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> result = {};

    history.forEach((date, items) {
      result[date] = {};
      items.forEach((objId, item) {
        result[date][objId] = item.toJson();
      });
    });

    return {'history': result};
  }
}

class HistoryItem {
  final int objId;
  final String objectName;
  final double sum;
  //final List<CategoryWork> categoryWorkList;

  HistoryItem({
    required this.objId,
    required this.objectName,
    required this.sum,
    //required this.categoryWorkList,
  });

  factory HistoryItem.fromJson(int objId, Map<String, dynamic> json) {
    return HistoryItem(
      objId: objId,
      objectName: json['objectName'] as String,
      sum: (json['sum'] ?? 0).toDouble(),
      //  categoryWorkList: (json['categoryWorkList'] as List)
      //   .map((e) => CategoryWork.fromJson(e as Map<String, dynamic>))
      //   .toList(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'objectName': objectName,
      'sum': sum,
      //  'categoryWorkList': categoryWorkList.map((e) => e.toJson()).toList(),
    };
  }
}

class CategoryWork {
  final int id;
  final String name;
  final String defObj;
  final int defCat;

  CategoryWork({
    required this.id,
    required this.name,
    required this.defObj,
    required this.defCat,
  });

  factory CategoryWork.fromJson(Map<String, dynamic> json) {
    return CategoryWork(
      id: json['id'] as int,
      name: json['name'] as String,
      defObj: json['defObj'] as String,
      defCat: json['defCat'] as int,
    );
  }

  Map<String, dynamic> toJson() {
    return {'id': id, 'name': name, 'defObj': defObj, 'defCat': defCat};
  }
}
