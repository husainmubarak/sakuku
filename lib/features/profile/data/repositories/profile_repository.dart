// lib/features/profile/data/repositories/profile_repository.dart

import 'dart:io';
import 'package:supabase_flutter/supabase_flutter.dart';
import '../models/profile_model.dart';

class ProfileRepository {
  final SupabaseClient _client;

  ProfileRepository(this._client);

  // Ambil data profil user yang sedang login
  Future<ProfileModel> fetchProfile() async {
    final user = _client.auth.currentUser;
    if (user == null) throw Exception('User belum login!');

    final response = await _client
        .from('profiles')
        .select()
        .eq('id', user.id)
        .maybeSingle();

    if (response == null) {
      // Buat profil default jika belum ada
      await _client.from('profiles').insert({
        'id': user.id,
        'full_name': user.email?.split('@').first ?? 'Pengguna',
      });
      return ProfileModel(
        id: user.id,
        email: user.email ?? '',
        fullName: user.email?.split('@').first ?? 'Pengguna',
      );
    }

    return ProfileModel.fromJson(response, user.email ?? '');
  }

  // Update Nama
  Future<void> updateFullName(String fullName) async {
    final user = _client.auth.currentUser;
    if (user == null) return;

    await _client.from('profiles').upsert({
      'id': user.id,
      'full_name': fullName,
    });
  }

  // Upload Foto Profil ke Supabase Storage
  Future<String> uploadAvatar(File imageFile) async {
    final user = _client.auth.currentUser;
    if (user == null) throw Exception('User belum login!');

    final fileExt = imageFile.path.split('.').last;
    final filePath = '${user.id}/avatar.$fileExt';

    // Upload ke bucket 'avatars'
    await _client.storage.from('avatars').upload(
          filePath,
          imageFile,
          fileOptions: const FileOptions(upsert: true),
        );

    // Ambil URL publik gambar
    final imageUrl = _client.storage.from('avatars').getPublicUrl(filePath);

    // Simpan URL ke tabel profiles
    await _client.from('profiles').upsert({
      'id': user.id,
      'avatar_url': imageUrl,
    });

    return imageUrl;
  }
}