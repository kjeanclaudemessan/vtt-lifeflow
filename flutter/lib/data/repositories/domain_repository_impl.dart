import 'package:dartz/dartz.dart';

import '../../app/app.locator.dart';
import '../../core/errors/error_handler.dart';
import '../../core/typedefs/typedefs.dart';
import '../../data/models/domain_model.dart';
import '../../domain/entities/domain_entity.dart';
import '../../domain/repositories/i_domain_repository.dart';
import '../../services/supabase/supabase_service.dart';

/// Implementation of [IDomainRepository] using Supabase.
class DomainRepositoryImpl implements IDomainRepository {
  final SupabaseService _supabaseService;

  DomainRepositoryImpl({SupabaseService? supabaseService})
      : _supabaseService = supabaseService ?? locator<SupabaseService>();

  // ─────────────────────────────────────────────────────────────────
  // Private Helpers
  // ─────────────────────────────────────────────────────────────────

  /// Current authenticated user ID.
  String get _userId => _supabaseService.client.auth.currentUser!.id;

  @override
  FutureResult<List<DomainEntity>> getDomains() async {
    try {
      final response = await _supabaseService.client
          .from('domains')
          .select()
          .eq('user_id', _userId)
          .order('sort_order');

      final domains = (response as List)
          .map((json) => DomainModel.fromJson(json as Map<String, dynamic>))
          .map((model) => model.toEntity())
          .toList();

      return Right(domains);
    } catch (e, s) {
      return Left(ErrorHandler.handle(e, s));
    }
  }

  @override
  FutureResult<DomainEntity> getDomainById(String id) async {
    try {
      final response = await _supabaseService.client
          .from('domains')
          .select()
          .eq('id', id)
          .eq('user_id', _userId)
          .single();

      return Right(
        DomainModel.fromJson(response).toEntity(),
      );
    } catch (e, s) {
      return Left(ErrorHandler.handle(e, s));
    }
  }

  @override
  FutureResult<DomainEntity> createDomain(DomainEntity entity) async {
    try {
      final data = DomainModel.toInsertJson(
        entity.copyWith(userId: _userId),
      );

      final response = await _supabaseService.client
          .from('domains')
          .insert(data)
          .select()
          .single();

      return Right(
        DomainModel.fromJson(response).toEntity(),
      );
    } catch (e, s) {
      return Left(ErrorHandler.handle(e, s));
    }
  }

  @override
  FutureResult<DomainEntity> updateDomain(DomainEntity entity) async {
    try {
      final data = DomainModel.toUpdateJson(entity);

      final response = await _supabaseService.client
          .from('domains')
          .update(data)
          .eq('id', entity.id)
          .eq('user_id', _userId)
          .select()
          .single();

      return Right(
        DomainModel.fromJson(response).toEntity(),
      );
    } catch (e, s) {
      return Left(ErrorHandler.handle(e, s));
    }
  }

  @override
  FutureResult<void> reorderDomains(List<String> orderedIds) async {
    try {
      // Update sort_order for each domain in parallel
      final futures = orderedIds.asMap().entries.map((entry) {
        return _supabaseService.client
            .from('domains')
            .update({'sort_order': entry.key})
            .eq('id', entry.value)
            .eq('user_id', _userId);
      });

      await Future.wait(futures);
      return const Right(null);
    } catch (e, s) {
      return Left(ErrorHandler.handle(e, s));
    }
  }

  @override
  FutureResult<void> archiveDomain(String id) async {
    try {
      await _supabaseService.client
          .from('domains')
          .update({'is_archived': true})
          .eq('id', id)
          .eq('user_id', _userId);

      return const Right(null);
    } catch (e, s) {
      return Left(ErrorHandler.handle(e, s));
    }
  }

  @override
  FutureResult<void> unarchiveDomain(String id) async {
    try {
      await _supabaseService.client
          .from('domains')
          .update({'is_archived': false})
          .eq('id', id)
          .eq('user_id', _userId);

      return const Right(null);
    } catch (e, s) {
      return Left(ErrorHandler.handle(e, s));
    }
  }
}
