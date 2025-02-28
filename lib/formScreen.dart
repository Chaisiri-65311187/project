import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../model/applianceItem.dart';
import '../provider/applianceProvider.dart';

class FormScreen extends StatefulWidget {
  final ApplianceItem? appliance; // ✅ รับค่าถ้ามีการแก้ไข
  const FormScreen({Key? key, this.appliance}) : super(key: key);

  @override
  _FormScreenState createState() => _FormScreenState();
}

class _FormScreenState extends State<FormScreen> {
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _brandController = TextEditingController();
  bool _isOn = false; // ✅ เพิ่มตัวแปรสถานะเปิด/ปิด

  @override
  void initState() {
    super.initState();
    if (widget.appliance != null) {
      // ✅ ถ้ามีข้อมูล ให้เติมลงในฟอร์ม
      _nameController.text = widget.appliance!.name;
      _brandController.text = widget.appliance!.brandModel;
      _isOn = widget.appliance!.isOn;
    }
  }

  void _saveAppliance() {
    String name = _nameController.text.trim();
    String brand = _brandController.text.trim();

    if (name.isNotEmpty && brand.isNotEmpty) {
      var provider = Provider.of<ApplianceProvider>(context, listen: false);

      if (widget.appliance == null) {
        provider.addAppliance(name, brand); // ✅ เพิ่มเครื่องใช้ไฟฟ้าใหม่
      } else {
        provider.updateAppliance(
            widget.appliance!, name, brand); // ✅ อัปเดตเครื่องใช้ไฟฟ้า
      }

      Navigator.pop(context);
    }
  }

  @override
  Widget build(BuildContext context) {
    bool isEditing =
        widget.appliance != null; // ✅ ตรวจสอบว่าเป็นโหมดแก้ไขหรือไม่

    return Scaffold(
      appBar:
          AppBar(title: Text(isEditing ? 'Edit Appliance' : 'Add Appliance')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            TextField(
                controller: _nameController,
                decoration: InputDecoration(labelText: 'Appliance Name')),
            TextField(
                controller: _brandController,
                decoration: InputDecoration(labelText: 'Brand/Model')),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text('Power Status:', style: TextStyle(fontSize: 16)),
                Switch(
                  value: _isOn,
                  onChanged: (value) {
                    setState(() {
                      _isOn = value;
                    });
                  },
                ),
              ],
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: _saveAppliance,
              child: Text(isEditing ? 'Update' : 'Save'),
            ),
          ],
        ),
      ),
    );
  }
}
