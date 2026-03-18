import 'package:flutter/material.dart';
import 'package:stacked/stacked.dart';

import '../../../core/extensions/context_extensions.dart';
import '../../../design_system/design_system.dart';
import '../../../domain/entities/domain_entity.dart';
import '../viewmodels/domains_viewmodel.dart';
import '../widgets/domain_tile.dart';

/// View for managing life domains — reorderable list, archived section, add.
class DomainsView extends StackedView<DomainsViewModel> {
  const DomainsView({Key? key}) : super(key: key);

  @override
  Widget builder(
    BuildContext context,
    DomainsViewModel viewModel,
    Widget? child,
  ) {
    final brightness = Theme.of(context).brightness;
    final l10n = context.l10n;

    return Scaffold(
      appBar: AppBar(
        title: Text(l10n.domainsTitle),
        actions: [
          IconButton(
            icon: const Icon(Icons.add),
            onPressed: () => _showCreateDomainDialog(context, viewModel),
          ),
        ],
      ),
      body: viewModel.isBusy
          ? const AppLoadingState()
          : viewModel.hasError
          ? AppErrorState.generic(
              title: context.l10n.errorOccurred,
              description: context.l10n.errorUnknown,
              onRetry: viewModel.init,
            )
          : _buildContent(context, viewModel, brightness),
    );
  }

  Widget _buildContent(
    BuildContext context,
    DomainsViewModel viewModel,
    Brightness brightness,
  ) {
    final l10n = context.l10n;

    return Column(
      children: [
        Expanded(
          child: viewModel.activeDomains.isEmpty
              ? AppEmptyState(
                  icon: Icons.category_outlined,
                  title: l10n.domainsEmptyTitle,
                  description: l10n.domainsEmptyDescription,
                  actionLabel: l10n.domainAdd,
                  onAction: () => _showCreateDomainDialog(context, viewModel),
                )
              : ReorderableListView.builder(
                  padding: EdgeInsets.symmetric(vertical: AppSpacing.sm),
                  itemCount: viewModel.activeDomains.length,
                  onReorder: viewModel.reorderDomains,
                  itemBuilder: (context, index) {
                    final domain = viewModel.activeDomains[index];
                    return DomainTile(
                      key: ValueKey(domain.id),
                      domain: domain,
                      habitCount: viewModel.getHabitCount(domain.id),
                      onTap: () =>
                          _showEditDomainDialog(context, viewModel, domain),
                      onArchive: () =>
                          _confirmArchive(context, viewModel, domain),
                    );
                  },
                ),
        ),
        // Archived section
        if (viewModel.archivedDomains.isNotEmpty) ...[
          const AppDivider(),
          _buildArchivedSection(context, viewModel, brightness),
        ],
        // Helper text
        Padding(
          padding: EdgeInsets.all(AppSpacing.md),
          child: Text(
            context.l10n.domainsReorderHint,
            style: AppTypography.caption.copyWith(
              color: AppColors.textSecondary(brightness),
            ),
            textAlign: TextAlign.center,
          ),
        ),
      ],
    );
  }

  Widget _buildArchivedSection(
    BuildContext context,
    DomainsViewModel viewModel,
    Brightness brightness,
  ) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        AppListTile(
          leading: Icon(
            viewModel.showArchived ? Icons.expand_less : Icons.expand_more,
            color: AppColors.textSecondary(brightness),
          ),
          title: Text(
            '${context.l10n.archivedCount(viewModel.archivedDomains.length)}',
            style: AppTypography.titleSmall.copyWith(
              color: AppColors.textSecondary(brightness),
            ),
          ),
          onTap: viewModel.toggleShowArchived,
        ),
        if (viewModel.showArchived)
          ...viewModel.archivedDomains.map(
            (domain) => DomainTile(
              domain: domain,
              isArchived: true,
              onRestore: () => viewModel.unarchiveDomain(domain.id),
            ),
          ),
      ],
    );
  }

  Future<void> _showCreateDomainDialog(
    BuildContext context,
    DomainsViewModel viewModel,
  ) async {
    final result = await _showDomainFormDialog(context);
    if (result != null) {
      await viewModel.createDomain(result);
    }
  }

  Future<void> _showEditDomainDialog(
    BuildContext context,
    DomainsViewModel viewModel,
    DomainEntity domain,
  ) async {
    final result = await _showDomainFormDialog(context, domain: domain);
    if (result != null) {
      await viewModel.updateDomain(result);
    }
  }

  Future<DomainEntity?> _showDomainFormDialog(
    BuildContext context, {
    DomainEntity? domain,
  }) async {
    final isEdit = domain != null;
    final nameController = TextEditingController(text: domain?.name ?? '');
    final iconController = TextEditingController(text: domain?.icon ?? '🎯');

    return AppDialog.show<DomainEntity>(
      context: context,
      title: isEdit ? context.l10n.domainEdit : context.l10n.domainAdd,
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Row(
            children: [
              SizedBox(
                width: 56,
                child: AppTextField(
                  label: context.l10n.domainFormIcon,
                  controller: iconController,
                  maxLength: 2,
                ),
              ),
              SizedBox(width: AppSpacing.sm),
              Expanded(
                child: AppTextField(
                  label: context.l10n.domainFormName,
                  hint: context.l10n.domainFormNameHint,
                  controller: nameController,
                  autofocus: true,
                ),
              ),
            ],
          ),
        ],
      ),
      primaryAction: AppDialogAction(
        label: isEdit ? context.l10n.edit : context.l10n.create,
        onPressed: () {
          final name = nameController.text.trim();
          if (name.isEmpty) return;
          final entity = (domain ?? DomainEntity.empty()).copyWith(
            name: name,
            icon: iconController.text.trim().isEmpty
                ? '🎯'
                : iconController.text.trim(),
          );
          Navigator.of(context).pop(entity);
        },
      ),
      secondaryAction: AppDialogAction(
        label: context.l10n.cancel,
        isSecondary: true,
        onPressed: () => Navigator.of(context).pop(),
      ),
    );
  }

  Future<void> _confirmArchive(
    BuildContext context,
    DomainsViewModel viewModel,
    DomainEntity domain,
  ) async {
    final confirmed = await AppDialog.confirm(
      context: context,
      title: context.l10n.domainArchiveConfirmTitle(domain.name),
      message: context.l10n.domainArchiveConfirmMessage,
      confirmLabel: context.l10n.domainArchive,
      cancelLabel: context.l10n.cancel,
    );
    if (confirmed == true) {
      await viewModel.archiveDomain(
        domain.id,
        minActiveErrorMessage: context.l10n.domainCannotArchiveLast,
      );
    }
  }

  @override
  DomainsViewModel viewModelBuilder(BuildContext context) => DomainsViewModel();

  @override
  void onViewModelReady(DomainsViewModel viewModel) => viewModel.init();
}
