import 'dart:async';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../data/models/daily_container_model.dart';
import '../../data/repositories/daily_container_repository.dart';
import 'auth_provider.dart';

final dailyContainerRepositoryProvider = Provider<DailyContainerRepository>((ref) {
  return DailyContainerRepository(ref.read(dioClientProvider));
});

final dailyContainerProvider = AsyncNotifierProvider<DailyContainerNotifier, List<DailyContainerModel>>(
  DailyContainerNotifier.new,
);

class DailyContainerNotifier extends AsyncNotifier<List<DailyContainerModel>> {
  late final DailyContainerRepository _repository;

  @override
  FutureOr<List<DailyContainerModel>> build() async {
    _repository = ref.read(dailyContainerRepositoryProvider);
    return _load();
  }

  Future<List<DailyContainerModel>> _load() async {
    state = const AsyncLoading();
    try {
      final items = await _repository.fetchDailyContainers();
      state = AsyncData(items);
      return items;
    } catch (e) {
      state = AsyncError(e, StackTrace.current);
      rethrow;
    }
  }

  Future<void> refresh() async {
    await _load();
  }
}
