import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../settings/domain/config.dart';

final configProvider = StateNotifierProvider<ConfigController, AppConfig>((ref) {
  return ConfigController();
});

class ConfigController extends StateNotifier<AppConfig> {
  ConfigController() : super(AppConfig.defaults);

  void setKmThreshold(int v) => state = state.copyWith(kmThreshold: v);
  void setMonthsThreshold(int v) => state = state.copyWith(monthsThreshold: v);
}