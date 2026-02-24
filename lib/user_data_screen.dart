import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'bloc/user_data/user_data_bloc.dart';
import 'bloc/user_data/user_data_event.dart';
import 'bloc/user_data/user_data_state.dart';

class UserDataScreen extends StatefulWidget {
  const UserDataScreen({super.key});

  @override
  State<UserDataScreen> createState() => _UserDataScreenState();
}

class _UserDataScreenState extends State<UserDataScreen> {
  final _formKey = GlobalKey<FormState>();

  final nameController = TextEditingController();
  final ageController = TextEditingController();
  final weightController = TextEditingController();
  final heightController = TextEditingController();

  String? gender;

  @override
  void initState() {
    super.initState();
    // نطلب تحميل البيانات أول ما الصفحة تفتح
    context.read<UserDataBloc>().add(const LoadUserDataEvent());
  }

  @override
  void dispose() {
    nameController.dispose();
    ageController.dispose();
    weightController.dispose();
    heightController.dispose();
    super.dispose();
  }

  void _onSavePressed() {
    if (!_formKey.currentState!.validate()) return;

    final bloc = context.read<UserDataBloc>();

    bloc.add(
      SaveUserDataEvent(
        name: nameController.text.trim(),
        age: int.tryParse(ageController.text) ?? 0,
        weight: double.tryParse(weightController.text) ?? 0.0,
        height: double.tryParse(heightController.text) ?? 0.0,
        gender: gender,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<UserDataBloc, UserDataState>(
      listenWhen: (prev, curr) =>
      prev.error != curr.error || prev.saveSuccess != curr.saveSuccess,
      listener: (context, state) {
        if (state.error != null) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('Error: ${state.error}')),
          );
        }

        if (state.saveSuccess) {
          Navigator.pushReplacementNamed(context, '/gallery');
        }

        // أول ما البيانات تتحمل، املى الكنترولرز
        if (!state.loading && state.name != null) {
          nameController.text = state.name ?? '';
          ageController.text = state.age?.toString() ?? '';
          weightController.text = state.weight?.toString() ?? '';
          heightController.text = state.height?.toString() ?? '';
          gender = state.gender;
        }
      },
      child: Scaffold(
        appBar: AppBar(title: const Text('User Data')),
        body: BlocBuilder<UserDataBloc, UserDataState>(
          builder: (context, state) {
            if (state.loading && state.name == null && state.error == null) {
              // تحميل أولي
              return const Center(child: CircularProgressIndicator());
            }

            return Padding(
              padding: const EdgeInsets.all(16),
              child: Form(
                key: _formKey,
                child: ListView(
                  children: [
                    TextFormField(
                      controller: nameController,
                      decoration:
                      const InputDecoration(labelText: 'Name'),
                      validator: (v) =>
                      v == null || v.isEmpty ? 'Required' : null,
                    ),
                    TextFormField(
                      controller: ageController,
                      decoration:
                      const InputDecoration(labelText: 'Age'),
                      keyboardType: TextInputType.number,
                      validator: (v) =>
                      v == null || v.isEmpty ? 'Required' : null,
                    ),
                    TextFormField(
                      controller: weightController,
                      decoration:
                      const InputDecoration(labelText: 'Weight'),
                      keyboardType: TextInputType.number,
                      validator: (v) =>
                      v == null || v.isEmpty ? 'Required' : null,
                    ),
                    TextFormField(
                      controller: heightController,
                      decoration:
                      const InputDecoration(labelText: 'Height'),
                      keyboardType: TextInputType.number,
                      validator: (v) =>
                      v == null || v.isEmpty ? 'Required' : null,
                    ),

                    const SizedBox(height: 16),

                    RadioListTile<String>(
                      title: const Text('Male'),
                      value: 'Male',
                      groupValue: gender,
                      onChanged: (v) => setState(() => gender = v),
                    ),
                    RadioListTile<String>(
                      title: const Text('Female'),
                      value: 'Female',
                      groupValue: gender,
                      onChanged: (v) => setState(() => gender = v),
                    ),

                    const SizedBox(height: 20),

                    SizedBox(
                      width: double.infinity,
                      child: ElevatedButton(
                        onPressed: state.loading ? null : _onSavePressed,
                        child: state.loading
                            ? const SizedBox(
                          height: 20,
                          width: 20,
                          child: CircularProgressIndicator(
                            strokeWidth: 2,
                          ),
                        )
                            : const Text('Save'),
                      ),
                    ),
                  ],
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}