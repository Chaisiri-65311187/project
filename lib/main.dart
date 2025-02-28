import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'formScreen.dart';
import 'provider/applianceProvider.dart';
import 'model/applianceItem.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (context) => ApplianceProvider()),
      ],
      child: MaterialApp(
        title: 'Smart Appliance Manager',
        theme: ThemeData(
          primarySwatch: Colors.blue,
        ),
        home: const HomePage(),
      ),
    );
  }
}

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  int _selectedIndex = 0;

  static const List<Widget> _pages = <Widget>[
    ApplianceListScreen(),
    FormScreen()
  ];

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Smart Appliance Manager')),
      body: _pages[_selectedIndex],
      bottomNavigationBar: BottomNavigationBar(
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: 'Home',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.add),
            label: 'Add Appliance',
          ),
        ],
        currentIndex: _selectedIndex,
        onTap: _onItemTapped,
      ),
    );
  }
}

class ApplianceListScreen extends StatelessWidget {
  const ApplianceListScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<ApplianceProvider>(
      builder: (context, provider, child) {
        if (provider.appliances.isEmpty) {
          return const Center(child: Text('No appliances added yet.'));
        }
        return GridView.builder(
          padding: const EdgeInsets.all(10),
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 2, // ✅ ปรับเป็น 2 คอลัมน์
            childAspectRatio: 1.2,
          ),
          itemCount: provider.appliances.length,
          itemBuilder: (context, index) {
            ApplianceItem item = provider.appliances[index];
            return Card(
              elevation: 5,
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(15)),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(item.name,
                      style: const TextStyle(
                          fontSize: 18, fontWeight: FontWeight.bold)),
                  Text('Model: ${item.brandModel}',
                      style: const TextStyle(fontSize: 14)),
                  Switch(
                    // ✅ เพิ่มสวิตช์เปิด/ปิด
                    value: item.isOn,
                    onChanged: (value) => provider.togglePower(item),
                  ),
                  IconButton(
                    icon: const Icon(Icons.delete, color: Colors.red),
                    onPressed: () => provider.removeAppliance(item),
                  ),
                ],
              ),
            );
          },
        );
      },
    );
  }
}
