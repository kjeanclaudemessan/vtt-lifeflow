import 'package:flutter_test/flutter_test.dart';

/// Integration tests for Supabase Storage.
///
/// Tests file upload, download, and management.
/// Note: Requires the 'avatars' bucket with proper RLS policies.
/// These tests are skipped by default until storage is configured.
///
/// To enable: Create bucket 'avatars' in Supabase Studio with policies:
/// - INSERT: auth.uid()::text = (storage.foldername(name))[1]
/// - SELECT: auth.uid()::text = (storage.foldername(name))[1]
/// - UPDATE: auth.uid()::text = (storage.foldername(name))[1]
/// - DELETE: auth.uid()::text = (storage.foldername(name))[1]
void main() {
  // Skip storage tests until bucket with RLS is configured
  // Remove this line to enable tests after configuring storage
  group('Storage Integration Tests', () {
    test('SKIPPED - Configure avatars bucket with RLS policies first', () {
      // Instructions:
      // 1. Go to Supabase Studio > Storage
      // 2. Create bucket 'avatars' (public: true)
      // 3. Add RLS policies for authenticated users to their folder
      // 4. Remove this skip and uncomment tests below
    }, skip: 'Storage bucket not configured - see instructions above');
  });

  // Uncomment below after configuring storage bucket
  /*
  setUpSupabaseTests();

  group('Storage Integration Tests', () {
    const testBucket = 'avatars';
    late String testEmail;
    const testPassword = 'Test123456!';
    late String userId;

    setUp(() async {
      testEmail = generateTestEmail();
      final user = await SupabaseTestHelper.createTestUser(
        email: testEmail,
        password: testPassword,
      );
      userId = user.id;
      await SupabaseTestHelper.client.auth.signInWithPassword(
        email: testEmail,
        password: testPassword,
      );
    });

    tearDown(() async {
      if (!bucketExists) return;
      // Cleanup uploaded files
      try {
        final files = await SupabaseTestHelper.client.storage
            .from(testBucket)
            .list(path: userId);
        if (files.isNotEmpty) {
          await SupabaseTestHelper.client.storage.from(testBucket).remove(
                files.map((f) => '$userId/${f.name}').toList(),
              );
        }
      } catch (_) {}

      await SupabaseTestHelper.signOut();
      await SupabaseTestHelper.deleteTestUser(testEmail);
    });

    // ═══════════════════════════════════════════════════════════════════════════
    // UPLOAD TESTS
    // ═══════════════════════════════════════════════════════════════════════════

    group('upload', () {
      test('should upload a file successfully', () async {
        // Arrange
        final fileData = Uint8List.fromList(
          List.generate(100, (i) => i % 256),
        );
        final filePath = '$userId/test_file.bin';

        // Act
        final result = await SupabaseTestHelper.client.storage
            .from(testBucket)
            .uploadBinary(filePath, fileData);

        // Assert
        expect(result, isNotEmpty);
        expect(result, contains(filePath));
      });

      test('should upload image data', () async {
        // Arrange - Create a simple PNG (1x1 red pixel)
        final pngData = Uint8List.fromList([
          0x89, 0x50, 0x4E, 0x47, 0x0D, 0x0A, 0x1A, 0x0A, // PNG signature
          0x00, 0x00, 0x00, 0x0D, 0x49, 0x48, 0x44, 0x52, // IHDR chunk
          0x00, 0x00, 0x00, 0x01, 0x00, 0x00, 0x00, 0x01,
          0x08, 0x02, 0x00, 0x00, 0x00, 0x90, 0x77, 0x53,
          0xDE, 0x00, 0x00, 0x00, 0x0C, 0x49, 0x44, 0x41, // IDAT chunk
          0x54, 0x08, 0xD7, 0x63, 0xF8, 0xCF, 0xC0, 0x00,
          0x00, 0x00, 0x03, 0x00, 0x01, 0x00, 0x18, 0xDD,
          0x8D, 0xB4, 0x00, 0x00, 0x00, 0x00, 0x49, 0x45, // IEND chunk
          0x4E, 0x44, 0xAE, 0x42, 0x60, 0x82,
        ]);
        final filePath = '$userId/avatar.png';

        // Act
        final result = await SupabaseTestHelper.client.storage
            .from(testBucket)
            .uploadBinary(
              filePath,
              pngData,
              fileOptions: const FileOptions(contentType: 'image/png'),
            );

        // Assert
        expect(result, isNotEmpty);
      });

      test('should overwrite existing file with upsert', () async {
        // Arrange
        final filePath = '$userId/upsert_test.txt';
        final originalData = Uint8List.fromList('original content'.codeUnits);
        final newData = Uint8List.fromList('new content'.codeUnits);

        // Upload original
        await SupabaseTestHelper.client.storage
            .from(testBucket)
            .uploadBinary(filePath, originalData);

        // Act - upsert with new content
        await SupabaseTestHelper.client.storage.from(testBucket).uploadBinary(
              filePath,
              newData,
              fileOptions: const FileOptions(upsert: true),
            );

        // Assert - download and verify new content
        final downloaded = await SupabaseTestHelper.client.storage
            .from(testBucket)
            .download(filePath);

        expect(String.fromCharCodes(downloaded), equals('new content'));
      });
    });

    // ═══════════════════════════════════════════════════════════════════════════
    // DOWNLOAD TESTS
    // ═══════════════════════════════════════════════════════════════════════════

    group('download', () {
      test('should download uploaded file', () async {
        // Arrange
        final content = 'Test content ${DateTime.now().toIso8601String()}';
        final fileData = Uint8List.fromList(content.codeUnits);
        final filePath = '$userId/download_test.txt';

        await SupabaseTestHelper.client.storage
            .from(testBucket)
            .uploadBinary(filePath, fileData);

        // Act
        final downloaded = await SupabaseTestHelper.client.storage
            .from(testBucket)
            .download(filePath);

        // Assert
        expect(String.fromCharCodes(downloaded), equals(content));
      });

      test('should get public URL', () async {
        // Arrange
        final filePath = '$userId/public_test.txt';
        await SupabaseTestHelper.client.storage.from(testBucket).uploadBinary(
              filePath,
              Uint8List.fromList('public'.codeUnits),
            );

        // Act
        final url = SupabaseTestHelper.client.storage
            .from(testBucket)
            .getPublicUrl(filePath);

        // Assert
        expect(url, isNotEmpty);
        expect(url, contains(testBucket));
        expect(url, contains(filePath));
      });

      test('should create signed URL', () async {
        // Arrange
        final filePath = '$userId/signed_test.txt';
        await SupabaseTestHelper.client.storage.from(testBucket).uploadBinary(
              filePath,
              Uint8List.fromList('signed'.codeUnits),
            );

        // Act
        final signedUrl = await SupabaseTestHelper.client.storage
            .from(testBucket)
            .createSignedUrl(filePath, 60); // 60 seconds

        // Assert
        expect(signedUrl, isNotEmpty);
        expect(signedUrl, contains('token='));
      });
    });

    // ═══════════════════════════════════════════════════════════════════════════
    // LIST FILES TESTS
    // ═══════════════════════════════════════════════════════════════════════════

    group('list files', () {
      test('should list files in user folder', () async {
        // Arrange - upload multiple files
        for (var i = 0; i < 3; i++) {
          await SupabaseTestHelper.client.storage.from(testBucket).uploadBinary(
                '$userId/file_$i.txt',
                Uint8List.fromList('content $i'.codeUnits),
              );
        }

        // Act
        final files = await SupabaseTestHelper.client.storage
            .from(testBucket)
            .list(path: userId);

        // Assert
        expect(files.length, equals(3));
        expect(files.map((f) => f.name), containsAll(['file_0.txt', 'file_1.txt', 'file_2.txt']));
      });

      test('should return empty list for non-existent folder', () async {
        // Act
        final files = await SupabaseTestHelper.client.storage
            .from(testBucket)
            .list(path: 'non_existent_folder_${DateTime.now().millisecondsSinceEpoch}');

        // Assert
        expect(files, isEmpty);
      });
    });

    // ═══════════════════════════════════════════════════════════════════════════
    // DELETE TESTS
    // ═══════════════════════════════════════════════════════════════════════════

    group('delete', () {
      test('should delete a single file', () async {
        // Arrange
        final filePath = '$userId/to_delete.txt';
        await SupabaseTestHelper.client.storage.from(testBucket).uploadBinary(
              filePath,
              Uint8List.fromList('delete me'.codeUnits),
            );

        // Act
        await SupabaseTestHelper.client.storage
            .from(testBucket)
            .remove([filePath]);

        // Assert - try to download should fail
        expect(
          () => SupabaseTestHelper.client.storage
              .from(testBucket)
              .download(filePath),
          throwsException,
        );
      });

      test('should delete multiple files', () async {
        // Arrange
        final files = <String>[];
        for (var i = 0; i < 3; i++) {
          final path = '$userId/batch_delete_$i.txt';
          files.add(path);
          await SupabaseTestHelper.client.storage.from(testBucket).uploadBinary(
                path,
                Uint8List.fromList('batch $i'.codeUnits),
              );
        }

        // Act
        await SupabaseTestHelper.client.storage.from(testBucket).remove(files);

        // Assert
        final remaining = await SupabaseTestHelper.client.storage
            .from(testBucket)
            .list(path: userId);

        expect(
          remaining.where((f) => f.name.startsWith('batch_delete_')),
          isEmpty,
        );
      });
    });

    // ═══════════════════════════════════════════════════════════════════════════
    // MOVE/COPY TESTS
    // ═══════════════════════════════════════════════════════════════════════════

    group('move and copy', () {
      test('should move a file', () async {
        // Arrange
        final fromPath = '$userId/original.txt';
        final toPath = '$userId/moved.txt';
        await SupabaseTestHelper.client.storage.from(testBucket).uploadBinary(
              fromPath,
              Uint8List.fromList('move me'.codeUnits),
            );

        // Act
        await SupabaseTestHelper.client.storage
            .from(testBucket)
            .move(fromPath, toPath);

        // Assert
        final files = await SupabaseTestHelper.client.storage
            .from(testBucket)
            .list(path: userId);

        expect(files.map((f) => f.name), contains('moved.txt'));
        expect(files.map((f) => f.name), isNot(contains('original.txt')));
      });

      test('should copy a file', () async {
        // Arrange
        final fromPath = '$userId/source.txt';
        final toPath = '$userId/copy.txt';
        await SupabaseTestHelper.client.storage.from(testBucket).uploadBinary(
              fromPath,
              Uint8List.fromList('copy me'.codeUnits),
            );

        // Act
        await SupabaseTestHelper.client.storage
            .from(testBucket)
            .copy(fromPath, toPath);

        // Assert
        final files = await SupabaseTestHelper.client.storage
            .from(testBucket)
            .list(path: userId);

        expect(files.map((f) => f.name), contains('source.txt'));
        expect(files.map((f) => f.name), contains('copy.txt'));
      });
    });
  });
  */
}
