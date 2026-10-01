// lib/features/profile/presentation/providers/profile_provider.dart

import 'dart:async';
import 'dart:io';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import '../../data/models/profile_model.dart';
import '../../data/repositories/profile_repository.dart';

final profileRepositoryProvider = Provider<ProfileRepository>((ref) {
  return ProfileRepository(Supabase.instance.client);
});

class ProfileNotifier extends AsyncNotifier<ProfileModel> {
  @override
  FutureOr<ProfileModel> build() async {
    return ref.read(profileRepositoryProvider).fetchProfile();
  }

  Future<void> updateFullName(String newName) async {
    state = const AsyncValue.loading();
    state = await AsyncValue.guard(() async {
      final repo = ref.read(profileRepositoryProvider);
      await repo.updateFullName(newName);
      return repo.fetchProfile();
    });
  }

  Future<void> updateAvatar(File imageFile) async {
    state = const AsyncValue.loading();
    state = await AsyncValue.guard(() async {
      final repo = ref.read(profileRepositoryProvider);
      await repo.uploadAvatar(imageFile);
      return repo.fetchProfile();
    });
  }
}

final profileProvider = AsyncNotifierProvider<ProfileNotifier, ProfileModel>(() {
  return ProfileNotifier();
});