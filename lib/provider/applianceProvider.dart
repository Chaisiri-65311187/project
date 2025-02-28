import 'package:flutter/material.dart';
import 'package:sembast/sembast.dart';
import 'package:sembast/sembast_io.dart';
import 'package:path_provider/path_provider.dart';
import 'package:path/path.dart';
import '../model/applianceItem.dart';

class ApplianceProvider with ChangeNotifier {
  final List<ApplianceItem> _appliances = [];
  Database? _db;
  final _store = intMapStoreFactory.store('appliances');
  String? _dbPath;

  List<ApplianceItem> get appliances => List.unmodifiable(_appliances);

  Future<void> initDatabase() async {
    if (_db != null) {
      print("Database already initialized.");
      return;
    }

    try {
      final dir = await getApplicationDocumentsDirectory();
      _dbPath = join(dir.path, 'appliances.db');
      print("Database Path: $_dbPath");

      _db = await databaseFactoryIo.openDatabase(_dbPath!);
      print("Database opened successfully.");

      await _loadAppliances();
      notifyListeners();
    } catch (e) {
      print("Error initializing database: $e");
    }
  }

  Future<void> _loadAppliances() async {
    if (_db == null) {
      print("Database is null in _loadAppliances()");
      return;
    }

    try {
      var records = await _store.find(_db!);
      print("Loaded ${records.length} appliances from database.");

      _appliances.clear();
      _appliances.addAll(
          records.map((snapshot) => ApplianceItem.fromMap(snapshot.value)));
      notifyListeners();
    } catch (e) {
      print("Error loading appliances: $e");
    }
  }

  Future<void> addAppliance(String name, String brandModel) async {
    await initDatabase();
    if (_db == null) return;
    final newItem = ApplianceItem(name: name, brandModel: brandModel);
    await _store.add(_db!, {
      'name': name,
      'brandModel': brandModel,
      'isOn': newItem.isOn,
    });
    _appliances.add(newItem);
    notifyListeners();
  }

  Future<void> updateAppliance(
      ApplianceItem oldItem, String newName, String newBrandModel) async {
    await initDatabase();
    if (_db == null) return;
    int index = _appliances.indexOf(oldItem);
    if (index != -1) {
      _appliances[index] = ApplianceItem(
        name: newName,
        brandModel: newBrandModel,
        isOn: oldItem.isOn,
      );
      await _store.update(
        _db!,
        {'name': newName, 'brandModel': newBrandModel, 'isOn': oldItem.isOn},
        finder: Finder(filter: Filter.equals('name', oldItem.name)),
      );
      notifyListeners();
    }
  }

  Future<void> togglePower(ApplianceItem item) async {
    await initDatabase();
    if (_db == null) return;
    int index = _appliances.indexOf(item);
    if (index != -1) {
      _appliances[index] = ApplianceItem(
        name: item.name,
        brandModel: item.brandModel,
        isOn: !item.isOn,
      );
      await _store.update(
        _db!,
        {'isOn': !item.isOn},
        finder: Finder(filter: Filter.equals('name', item.name)),
      );
      notifyListeners();
    }
  }

  Future<void> removeAppliance(ApplianceItem item) async {
    await initDatabase();
    if (_db == null) return;
    _appliances.remove(item);
    await _store.delete(
      _db!,
      finder: Finder(filter: Filter.equals('name', item.name)),
    );
    notifyListeners();
  }
}
