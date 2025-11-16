import 'package:fleetcare_mvp/src/features/auth/data/auth_state.dart';
import 'package:fleetcare_mvp/src/features/auth/data/auth_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'app.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await AuthState.loadInitial();

  runApp(const ProviderScope(child: App()));
}