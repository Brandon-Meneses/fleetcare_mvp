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

  // Valores REALES → backend
  final rolesList = ["USER", "ADMIN"];
  final areasList = ["MAINTENANCE", "OPERATIONS", "FINANCE", "COMMERCIAL"];

  // Etiquetas en español → UI
  final roleLabels = {
    "USER": "Usuario",
    "ADMIN": "Administrador",
  };

  final areaLabels = {
    "MAINTENANCE": "Mantenimiento",
    "OPERATIONS": "Operaciones",
    "FINANCE": "Finanzas",
    "COMMERCIAL": "Comercial",
  };

  @override
  Widget build(BuildContext context) {
    final createState = ref.watch(createUserControllerProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text("Crear Usuario"),
        centerTitle: true,
      ),

      body: Center(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(24),
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 420),
            child: Card(
              elevation: 4,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(16),
              ),
              child: Padding(
                padding: const EdgeInsets.all(24),
                child: Form(
                  key: _formKey,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [

                      // TITULO
                      Row(
                        children: [
                          Icon(Icons.person_add_alt_1,
                              size: 28,
                              color: Theme.of(context).colorScheme.primary),
                          const SizedBox(width: 12),
                          Text(
                            "Nuevo usuario",
                            style: Theme.of(context).textTheme.titleLarge,
                          ),
                        ],
                      ),

                      const SizedBox(height: 24),

                      // EMAIL
                      TextFormField(
                        controller: emailCtrl,
                        decoration: InputDecoration(
                          labelText: "Correo electrónico",
                          prefixIcon: const Icon(Icons.email_outlined),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                        ),
                        validator: (v) =>
                        v != null && v.contains("@")
                            ? null
                            : "Ingresa un correo válido",
                      ),

                      const SizedBox(height: 20),

                      // ROL
                      DropdownButtonFormField<String>(
                        value: role,
                        decoration: InputDecoration(
                          labelText: "Rol",
                          prefixIcon: const Icon(Icons.security),
                          border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(12)),
                        ),
                        items: rolesList
                            .map((r) => DropdownMenuItem(
                          value: r,
                          child: Text(
                              roleLabels[r] ?? r
                          ),
                        ))
                            .toList(),
                        onChanged: (v) {
                          setState(() {
                            role = v!;
                            if (role == "ADMIN") area = null;
                          });
                        },
                      ),

                      const SizedBox(height: 20),

                      // ÁREA
                      if (role == "USER")
                        DropdownButtonFormField<String>(
                          value: area,
                          decoration: InputDecoration(
                            labelText: "Área",
                            prefixIcon: const Icon(Icons.work_outline),
                            border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(12)),
                          ),
                          items: areasList
                              .map((a) => DropdownMenuItem(
                            value: a,
                            child: Text(areaLabels[a] ?? a),
                          ))
                              .toList(),
                          onChanged: (v) => setState(() => area = v),
                          validator: (v) =>
                          role == "USER" && v == null
                              ? "Selecciona un área"
                              : null,
                        ),

                      const SizedBox(height: 32),

                      // BOTÓN
                      SizedBox(
                        width: double.infinity,
                        child: FilledButton.icon(
                          icon: createState.isLoading
                              ? const SizedBox(
                              width: 16,
                              height: 16,
                              child: CircularProgressIndicator(
                                strokeWidth: 2,
                                color: Colors.white,
                              ))
                              : const Icon(Icons.check_circle_outline),
                          label: const Text("Crear usuario"),
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
                        ),
                      ),

                    ],
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}