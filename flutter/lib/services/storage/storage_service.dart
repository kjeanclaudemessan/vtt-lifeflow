import 'dart:typed_data';

import 'package:dartz/dartz.dart';
import 'package:image_picker/image_picker.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import '../../core/errors/failures.dart';
import '../../core/utils/logger.dart';

/// Service for handling file storage operations with Supabase Storage.
///
/// Provides methods for uploading, downloading, and managing files
/// in Supabase Storage buckets.
class StorageService {
  late final SupabaseClient _client;
  final Logger _logger = const Logger('StorageService');

  /// Default bucket for user avatars.
  static const String avatarsBucket = 'avatars';

  /// Default bucket for general uploads.
  static const String uploadsBucket = 'uploads';

  /// Creates a [StorageService] using the default Supabase instance.
  StorageService() : _client = Supabase.instance.client;

  /// Creates a [StorageService] with a custom Supabase client (for testing).
  StorageService.withClient(this._client);

  // ═══════════════════════════════════════════════════════════════════════════
  // AVATAR OPERATIONS
  // ═══════════════════════════════════════════════════════════════════════════

  /// Uploads a user avatar image.
  ///
  /// Returns the public URL of the uploaded avatar on success.
  Future<Either<Failure, String>> uploadAvatar({
    required String userId,
    required XFile file,
  }) async {
    try {
      final bytes = await file.readAsBytes();
      final extension = file.name.split('.').last.toLowerCase();
      final path = '$userId/avatar.$extension';

      _logger.d('Uploading avatar for user: $userId');

      // Upload with upsert to replace existing avatar
      await _client.storage.from(avatarsBucket).uploadBinary(
            path,
            bytes,
            fileOptions: FileOptions(
              contentType: _getContentType(extension),
              upsert: true,
            ),
          );

      // Get public URL
      final url = _client.storage.from(avatarsBucket).getPublicUrl(path);

      _logger.i('Avatar uploaded successfully: $url');
      return Right(url);
    } on StorageException catch (e) {
      _logger.e('Storage error uploading avatar', error: e);
      return Left(StorageFailure(e.message));
    } catch (e) {
      _logger.e('Error uploading avatar', error: e);
      return Left(UnknownFailure(message: e.toString()));
    }
  }

  /// Uploads avatar from bytes directly.
  Future<Either<Failure, String>> uploadAvatarBytes({
    required String userId,
    required Uint8List bytes,
    String extension = 'jpg',
  }) async {
    try {
      final path = '$userId/avatar.$extension';

      _logger.d('Uploading avatar bytes for user: $userId');

      await _client.storage.from(avatarsBucket).uploadBinary(
            path,
            bytes,
            fileOptions: FileOptions(
              contentType: _getContentType(extension),
              upsert: true,
            ),
          );

      final url = _client.storage.from(avatarsBucket).getPublicUrl(path);

      _logger.i('Avatar bytes uploaded successfully');
      return Right(url);
    } on StorageException catch (e) {
      _logger.e('Storage error uploading avatar bytes', error: e);
      return Left(StorageFailure(e.message));
    } catch (e) {
      _logger.e('Error uploading avatar bytes', error: e);
      return Left(UnknownFailure(message: e.toString()));
    }
  }

  /// Gets the public URL for a user's avatar.
  String? getAvatarUrl(String userId, {String extension = 'jpg'}) {
    try {
      final path = '$userId/avatar.$extension';
      return _client.storage.from(avatarsBucket).getPublicUrl(path);
    } catch (e) {
      _logger.w('Error getting avatar URL', error: e);
      return null;
    }
  }

  /// Deletes a user's avatar.
  Future<Either<Failure, void>> deleteAvatar(String userId) async {
    try {
      _logger.d('Deleting avatar for user: $userId');

      // Try common extensions
      final extensions = ['jpg', 'jpeg', 'png', 'webp'];
      final paths = extensions.map((ext) => '$userId/avatar.$ext').toList();

      await _client.storage.from(avatarsBucket).remove(paths);

      _logger.i('Avatar deleted successfully');
      return const Right(null);
    } on StorageException catch (e) {
      _logger.e('Storage error deleting avatar', error: e);
      return Left(StorageFailure(e.message));
    } catch (e) {
      _logger.e('Error deleting avatar', error: e);
      return Left(UnknownFailure(message: e.toString()));
    }
  }

  // ═══════════════════════════════════════════════════════════════════════════
  // GENERIC FILE OPERATIONS
  // ═══════════════════════════════════════════════════════════════════════════

  /// Uploads a file to the specified bucket.
  ///
  /// Returns the public URL on success.
  Future<Either<Failure, String>> uploadFile({
    required String bucket,
    required String path,
    required XFile file,
    bool upsert = false,
  }) async {
    try {
      final bytes = await file.readAsBytes();
      final extension = file.name.split('.').last.toLowerCase();

      _logger.d('Uploading file to $bucket/$path');

      await _client.storage.from(bucket).uploadBinary(
            path,
            bytes,
            fileOptions: FileOptions(
              contentType: _getContentType(extension),
              upsert: upsert,
            ),
          );

      final url = _client.storage.from(bucket).getPublicUrl(path);

      _logger.i('File uploaded successfully: $url');
      return Right(url);
    } on StorageException catch (e) {
      _logger.e('Storage error uploading file', error: e);
      return Left(StorageFailure(e.message));
    } catch (e) {
      _logger.e('Error uploading file', error: e);
      return Left(UnknownFailure(message: e.toString()));
    }
  }

  /// Uploads bytes to the specified bucket.
  Future<Either<Failure, String>> uploadBytes({
    required String bucket,
    required String path,
    required Uint8List bytes,
    String? contentType,
    bool upsert = false,
  }) async {
    try {
      _logger.d('Uploading bytes to $bucket/$path');

      await _client.storage.from(bucket).uploadBinary(
            path,
            bytes,
            fileOptions: FileOptions(
              contentType: contentType,
              upsert: upsert,
            ),
          );

      final url = _client.storage.from(bucket).getPublicUrl(path);

      _logger.i('Bytes uploaded successfully');
      return Right(url);
    } on StorageException catch (e) {
      _logger.e('Storage error uploading bytes', error: e);
      return Left(StorageFailure(e.message));
    } catch (e) {
      _logger.e('Error uploading bytes', error: e);
      return Left(UnknownFailure(message: e.toString()));
    }
  }

  /// Downloads a file as bytes.
  Future<Either<Failure, Uint8List>> downloadFile({
    required String bucket,
    required String path,
  }) async {
    try {
      _logger.d('Downloading file from $bucket/$path');

      final bytes = await _client.storage.from(bucket).download(path);

      _logger.i('File downloaded successfully');
      return Right(bytes);
    } on StorageException catch (e) {
      _logger.e('Storage error downloading file', error: e);
      return Left(StorageFailure(e.message));
    } catch (e) {
      _logger.e('Error downloading file', error: e);
      return Left(UnknownFailure(message: e.toString()));
    }
  }

  /// Gets the public URL for a file.
  String getPublicUrl({
    required String bucket,
    required String path,
  }) {
    return _client.storage.from(bucket).getPublicUrl(path);
  }

  /// Gets a signed URL for private file access.
  Future<Either<Failure, String>> getSignedUrl({
    required String bucket,
    required String path,
    Duration expiresIn = const Duration(hours: 1),
  }) async {
    try {
      final url = await _client.storage.from(bucket).createSignedUrl(
            path,
            expiresIn.inSeconds,
          );

      return Right(url);
    } on StorageException catch (e) {
      _logger.e('Storage error getting signed URL', error: e);
      return Left(StorageFailure(e.message));
    } catch (e) {
      _logger.e('Error getting signed URL', error: e);
      return Left(UnknownFailure(message: e.toString()));
    }
  }

  /// Deletes files from a bucket.
  Future<Either<Failure, void>> deleteFiles({
    required String bucket,
    required List<String> paths,
  }) async {
    try {
      _logger.d('Deleting ${paths.length} files from $bucket');

      await _client.storage.from(bucket).remove(paths);

      _logger.i('Files deleted successfully');
      return const Right(null);
    } on StorageException catch (e) {
      _logger.e('Storage error deleting files', error: e);
      return Left(StorageFailure(e.message));
    } catch (e) {
      _logger.e('Error deleting files', error: e);
      return Left(UnknownFailure(message: e.toString()));
    }
  }

  /// Lists files in a bucket path.
  Future<Either<Failure, List<FileObject>>> listFiles({
    required String bucket,
    String path = '',
  }) async {
    try {
      _logger.d('Listing files in $bucket/$path');

      final files = await _client.storage.from(bucket).list(path: path);

      _logger.i('Listed ${files.length} files');
      return Right(files);
    } on StorageException catch (e) {
      _logger.e('Storage error listing files', error: e);
      return Left(StorageFailure(e.message));
    } catch (e) {
      _logger.e('Error listing files', error: e);
      return Left(UnknownFailure(message: e.toString()));
    }
  }

  // ═══════════════════════════════════════════════════════════════════════════
  // IMAGE PICKER HELPERS
  // ═══════════════════════════════════════════════════════════════════════════

  /// Picks an image from gallery.
  Future<XFile?> pickImageFromGallery({
    int? maxWidth,
    int? maxHeight,
    int? imageQuality,
  }) async {
    try {
      final picker = ImagePicker();
      return await picker.pickImage(
        source: ImageSource.gallery,
        maxWidth: maxWidth?.toDouble(),
        maxHeight: maxHeight?.toDouble(),
        imageQuality: imageQuality,
      );
    } catch (e) {
      _logger.e('Error picking image from gallery', error: e);
      return null;
    }
  }

  /// Picks an image from camera.
  Future<XFile?> pickImageFromCamera({
    int? maxWidth,
    int? maxHeight,
    int? imageQuality,
  }) async {
    try {
      final picker = ImagePicker();
      return await picker.pickImage(
        source: ImageSource.camera,
        maxWidth: maxWidth?.toDouble(),
        maxHeight: maxHeight?.toDouble(),
        imageQuality: imageQuality,
      );
    } catch (e) {
      _logger.e('Error picking image from camera', error: e);
      return null;
    }
  }

  /// Picks multiple images from gallery.
  Future<List<XFile>> pickMultipleImages({
    int? maxWidth,
    int? maxHeight,
    int? imageQuality,
  }) async {
    try {
      final picker = ImagePicker();
      return await picker.pickMultiImage(
        maxWidth: maxWidth?.toDouble(),
        maxHeight: maxHeight?.toDouble(),
        imageQuality: imageQuality,
      );
    } catch (e) {
      _logger.e('Error picking multiple images', error: e);
      return [];
    }
  }

  // ═══════════════════════════════════════════════════════════════════════════
  // PRIVATE HELPERS
  // ═══════════════════════════════════════════════════════════════════════════

  /// Gets content type from file extension.
  String _getContentType(String extension) {
    switch (extension.toLowerCase()) {
      case 'jpg':
      case 'jpeg':
        return 'image/jpeg';
      case 'png':
        return 'image/png';
      case 'gif':
        return 'image/gif';
      case 'webp':
        return 'image/webp';
      case 'svg':
        return 'image/svg+xml';
      case 'pdf':
        return 'application/pdf';
      case 'json':
        return 'application/json';
      case 'txt':
        return 'text/plain';
      case 'mp4':
        return 'video/mp4';
      case 'mp3':
        return 'audio/mpeg';
      default:
        return 'application/octet-stream';
    }
  }
}

/// Storage-specific failure.
class StorageFailure extends Failure {
  const StorageFailure(String message) : super(message: message);
}
