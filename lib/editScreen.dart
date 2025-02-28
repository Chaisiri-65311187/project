import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'provider/applianceProvider.dart';
import 'model/applianceItem.dart';

class EditScreen extends StatefulWidget {
  final ApplianceItem item;
  const EditScreen({super.key, required this.item});

  @override
  _EditScreenState createState() => _EditScreenState();
}

class _EditScreenState extends State<EditScreen> {
  final _formKey = GlobalKey<FormState>();
  late String _name;
  late String _brandModel;

  @override
  void initState() {
    super.initState();
    _name = widget.item.name;
    _brandModel = widget.item.brandModel;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Edit Appliance')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              TextFormField(
                initialValue: _name,
                decoration: const InputDecoration(labelText: 'Appliance Name'),
                onSaved: (value) => _name = value!,
                validator: (value) => value!.isEmpty ? 'Enter a name' : null,
              ),
              TextFormField(
                initialValue: _brandModel,
                decoration: const InputDecoration(labelText: 'Brand/Model'),
                onSaved: (value) => _brandModel = value!,
                validator: (value) =>
                    value!.isEmpty ? 'Enter brand/model' : null,
              ),
              const SizedBox(height: 20),
              ElevatedButton(
                onPressed: () {
                  if (_formKey.currentState!.validate()) {
                    _formKey.currentState!.save();
                    Provider.of<ApplianceProvider>(context, listen: false)
                        .updateAppliance(widget.item, _name, _brandModel);
                    Navigator.pop(context);
                  }
                },
                child: const Text('Save Changes'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
