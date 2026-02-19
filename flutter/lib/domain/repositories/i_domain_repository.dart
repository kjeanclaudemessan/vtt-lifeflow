import '../../core/typedefs/typedefs.dart';
import '../entities/domain_entity.dart';

/// Contract for domain operations.
///
/// Implementations: [DomainRepositoryImpl]
abstract class IDomainRepository {
  /// Gets all domains for the current user (active + archived).
  FutureResult<List<DomainEntity>> getDomains();

  /// Gets a single domain by ID.
  FutureResult<DomainEntity> getDomainById(String id);

  /// Creates a new domain.
  FutureResult<DomainEntity> createDomain(DomainEntity entity);

  /// Updates an existing domain.
  FutureResult<DomainEntity> updateDomain(DomainEntity entity);

  /// Reorders domains by setting sort_order based on the given ID list.
  FutureResult<void> reorderDomains(List<String> orderedIds);

  /// Archives a domain (soft delete).
  FutureResult<void> archiveDomain(String id);

  /// Unarchives a domain.
  FutureResult<void> unarchiveDomain(String id);
}
