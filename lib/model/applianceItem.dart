class ApplianceItem {
  final String name;
  final String brandModel;
  final bool isOn;

  ApplianceItem(
      {required this.name, required this.brandModel, this.isOn = false});

  // เพิ่มเมธอด fromMap()
  factory ApplianceItem.fromMap(Map<String, dynamic> map) {
    return ApplianceItem(
      name: map['name'] ?? '',
      brandModel: map['brandModel'] ?? '',
      isOn: map['isOn'] ?? false,
    );
  }

  // เพิ่มเมธอด toMap() เผื่อใช้บันทึกลงฐานข้อมูล
  Map<String, dynamic> toMap() {
    return {
      'name': name,
      'brandModel': brandModel,
      'isOn': isOn,
    };
  }
}
