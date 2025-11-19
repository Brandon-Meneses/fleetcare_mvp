import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import 'CreateUserController.dart';

class CreateUserPage extends ConsumerStatefulWidget {
  const CreateUserPage({super.key});

  @override
  ConsumerState<CreateUserPage> createState() => _CreateUserPageState();
}

class _CreateUserPageState extends ConsumerState<CreateUserPage> {
  final _formKey = GlobalKey<FormState>();
  final emailCtrl = TextEditingController();

  String role = "USER";
  String? area;

  final areasList = ["MAINTENANCE", "OPERATIONS", "FINANCE", "COMMERCIAL"];
  final rolesList = ["USER", "ADMIN"];

  @override
  Widget build(BuildContext context) {
    final createState = ref.watch(createUserControllerProvider);

    return Scaffold(
      appBar: AppBar(title: const Text("Crear Usuario")),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              // Email
              TextFormField(
                controller: emailCtrl,
                decoration: const InputDecoration(labelText: "Correo"),
                validator: (v) =>
                v != null && v.contains("@") ? null : "Correo inválido",
              ),
              const SizedBox(height: 16),

              // ROL
              DropdownButtonFormField<String>(
                value: role,
                decoration: const InputDecoration(labelText: "Rol"),
                items: rolesList
                    .map((r) => DropdownMenuItem(value: r, child: Text(r)))
                    .toList(),
                onChanged: (v) {
                  setState(() {
                    role = v!;
                    if (role == "ADMIN") area = null;
                  });
                },
              ),
              const SizedBox(height: 16),

              // ÁREA (solo si USER)
              if (role == "USER")
                DropdownButtonFormField<String>(
                  value: area,
                  decoration: const InputDecoration(labelText: "Área"),
                  items: areasList
                      .map((a) => DropdownMenuItem(value: a, child: Text(a)))
                      .toList(),
                  onChanged: (v) {
                    setState(() {
                      area = v;
                    });
                  },
                  validator: (v) =>
                  (role == "USER" && v == null) ? "Área requerida" : null,
                ),

              const SizedBox(height: 20),

              // BOTÓN
              SizedBox(
                width: double.infinity,
                child: FilledButton(
                  onPressed: createState.isLoading
                      ? null
                      : () async {
                    if (!_formKey.currentState!.validate()) return;

                    final ok = await ref
                        .read(createUserControllerProvider.notifier)
                        .createUser(
                      email: emailCtrl.text.trim(),
                      role: role,
                      area: role == "USER" ? area : null,
                    );

                    if (ok && mounted) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                            content: Text("Usuario creado con éxito")),
                      );
                      Navigator.pop(context);
                    }
                  },
                  child: createState.isLoading
                      ? const CircularProgressIndicator()
                      : const Text("Crear usuario"),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}