// lib/features/profile/presentation/screens/profile_screen.dart

import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:image_picker/image_picker.dart';
import '../../../auth/presentation/providers/auth_provider.dart';
import '../providers/profile_provider.dart';

class ProfileScreen extends ConsumerWidget {
  const ProfileScreen({super.key});

  Future<void> _pickAndUploadImage(WidgetRef ref) async {
    final picker = ImagePicker();
    final pickedFile = await picker.pickImage(
      source: ImageSource.gallery,
      imageQuality: 70,
    );

    if (pickedFile != null) {
      ref.read(profileProvider.notifier).updateAvatar(File(pickedFile.path));
    }
  }

  void _showEditNameDialog(BuildContext context, WidgetRef ref, String currentName) {
    final controller = TextEditingController(text: currentName);

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Ubah Nama Lengkap'),
        content: TextField(
          controller: controller,
          decoration: const InputDecoration(
            labelText: 'Nama Lengkap',
            border: OutlineInputBorder(),
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Batal'),
          ),
          ElevatedButton(
            onPressed: () {
              final newName = controller.text.trim();
              if (newName.isNotEmpty) {
                ref.read(profileProvider.notifier).updateFullName(newName);
              }
              Navigator.pop(context);
            },
            child: const Text('Simpan'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final asyncProfile = ref.watch(profileProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Profil Saya'),
        centerTitle: true,
      ),
      body: asyncProfile.when(
        data: (profile) {
          return SingleChildScrollView(
            padding: const EdgeInsets.all(24.0),
            child: Column(
              children: [
                // Avatar Foto Profil dengan Tombol Kamera
                Stack(
                  children: [
                    CircleAvatar(
                      radius: 50,
                      backgroundColor: Colors.teal.shade100,
                      backgroundImage: profile.avatarUrl != null
                          ? NetworkImage(profile.avatarUrl!)
                          : null,
                      child: profile.avatarUrl == null
                          ? const Icon(Icons.person, size: 50, color: Colors.teal)
                          : null,
                    ),
                    Positioned(
                      bottom: 0,
                      right: 0,
                      child: CircleAvatar(
                        radius: 18,
                        backgroundColor: Colors.teal,
                        child: IconButton(
                          padding: EdgeInsets.zero,
                          icon: const Icon(Icons.camera_alt, size: 18, color: Colors.white),
                          onPressed: () => _pickAndUploadImage(ref),
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 24),

                // Informasi Email (Readonly)
                Card(
                  child: ListTile(
                    leading: const Icon(Icons.email_outlined, color: Colors.teal),
                    title: const Text('Email'),
                    subtitle: Text(profile.email),
                  ),
                ),
                const SizedBox(height: 8),

                // Informasi Nama Lengkap (Dapat Diubah)
                Card(
                  child: ListTile(
                    leading: const Icon(Icons.badge_outlined, color: Colors.teal),
                    title: const Text('Nama Lengkap'),
                    subtitle: Text(profile.fullName),
                    trailing: IconButton(
                      icon: const Icon(Icons.edit_outlined, color: Colors.grey),
                      onPressed: () => _showEditNameDialog(context, ref, profile.fullName),
                    ),
                  ),
                ),
                const SizedBox(height: 32),

                // Tombol Logout
                ElevatedButton.icon(
                  onPressed: () async {
                    await ref.read(authRepositoryProvider).signOut();
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.red.shade50,
                    foregroundColor: Colors.red,
                    minimumSize: const Size.fromHeight(48),
                    elevation: 0,
                  ),
                  icon: const Icon(Icons.logout),
                  label: const Text('Keluar dari Akun', style: TextStyle(fontSize: 16)),
                ),
              ],
            ),
          );
        },
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (err, _) => Center(child: Text('Gagal memuat profil: $err')),
      ),
    );
  }
}