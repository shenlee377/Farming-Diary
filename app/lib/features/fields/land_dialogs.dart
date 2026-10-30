import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../app/providers.dart';
import '../../app/widgets.dart';
import '../../domain/labels.dart';

Future<void> showLinkParcelDialog(
  BuildContext context,
  WidgetRef ref,
  String fieldId,
) async {
  final code = TextEditingController();
  final notes = TextEditingController();
  final saved = await showDialog<bool>(
    context: context,
    builder: (context) => AlertDialog(
      title: const Text('連結地號'),
      content: SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(
              controller: code,
              autofocus: true,
              decoration: const InputDecoration(
                labelText: '地號（必填）',
                hintText: '例：西螺鎮新安段 0124-0000',
              ),
            ),
            const SizedBox(height: 12),
            TextField(
              controller: notes,
              decoration: const InputDecoration(labelText: '備註'),
            ),
          ],
        ),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(context, false),
          child: const Text('取消'),
        ),
        FilledButton(
          onPressed: () {
            if (code.text.trim().isNotEmpty) Navigator.pop(context, true);
          },
          child: const Text('連結'),
        ),
      ],
    ),
  );
  if (saved == true && context.mounted) {
    await runAction(
      context,
      () => ref
          .read(repositoryProvider)
          .linkParcel(fieldId, code.text, notes: notes.text),
      success: '已連結地號',
    );
  }
}

Future<void> showLandRelationDialog(
  BuildContext context,
  WidgetRef ref,
  String parcelId,
) async {
  await showModalBottomSheet<void>(
    context: context,
    isScrollControlled: true,
    showDragHandle: true,
    builder: (context) => _LandRelationSheet(parcelId: parcelId),
  );
}

class _LandRelationSheet extends ConsumerStatefulWidget {
  final String parcelId;

  const _LandRelationSheet({required this.parcelId});

  @override
  ConsumerState<_LandRelationSheet> createState() => _LandRelationSheetState();
}

class _LandRelationSheetState extends ConsumerState<_LandRelationSheet> {
  final _party = TextEditingController();
  final _share = TextEditingController();
  final _rent = TextEditingController();
  String _kind = 'owner';
  DateTimeRange? _period;

  @override
  void dispose() {
    _party.dispose();
    _share.dispose();
    _rent.dispose();
    super.dispose();
  }

  Future<void> _save() async {
    if (_party.text.trim().isEmpty) {
      showMessage(context, '請填關係人名稱');
      return;
    }
    if (_rent.text.trim().isNotEmpty &&
        num.tryParse(_rent.text.trim()) == null) {
      showMessage(context, '租金請填數字');
      return;
    }
    final ok = await runAction(
      context,
      () => ref
          .read(repositoryProvider)
          .addLandRelation(
            parcelId: widget.parcelId,
            partyName: _party.text,
            kind: _kind,
            share: _share.text,
            periodStart: _period?.start,
            periodEnd: _period?.end,
            rentAmount: _rent.text,
          ),
      success: '已新增（標示為本人填寫，未經查證）',
    );
    if (ok && mounted) Navigator.of(context).pop();
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(bottom: MediaQuery.viewInsetsOf(context).bottom),
      child: SingleChildScrollView(
        padding: const EdgeInsets.fromLTRB(16, 0, 16, 24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Text('新增土地關係', style: Theme.of(context).textTheme.titleLarge),
            const SizedBox(height: 16),
            TextField(
              controller: _party,
              decoration: const InputDecoration(
                labelText: '關係人（必填）',
                hintText: '例：林阿公、王先生',
              ),
            ),
            const SizedBox(height: 16),
            DropdownButtonFormField<String>(
              initialValue: _kind,
              decoration: const InputDecoration(labelText: '關係'),
              items: [
                for (final e in landRelationKinds.entries)
                  DropdownMenuItem(value: e.key, child: Text(e.value)),
              ],
              onChanged: (v) => setState(() => _kind = v!),
            ),
            const SizedBox(height: 16),
            TextField(
              controller: _share,
              decoration: const InputDecoration(
                labelText: '持分（可不填）',
                hintText: '例：1/3',
              ),
            ),
            const SizedBox(height: 16),
            OutlinedButton.icon(
              onPressed: () async {
                final now = DateTime.now();
                final picked = await showDateRangePicker(
                  context: context,
                  firstDate: DateTime(now.year - 30),
                  lastDate: DateTime(now.year + 30),
                  initialDateRange: _period,
                );
                if (picked != null) setState(() => _period = picked);
              },
              icon: const Icon(Icons.date_range),
              label: Text(
                _period == null
                    ? '期間（可不填）'
                    : '${formatDate(_period!.start)}～${formatDate(_period!.end)}',
              ),
            ),
            if (_kind == 'lessee') ...[
              const SizedBox(height: 16),
              TextField(
                controller: _rent,
                keyboardType: const TextInputType.numberWithOptions(
                  decimal: true,
                ),
                decoration: const InputDecoration(
                  labelText: '租金（元，可不填）',
                  helperText: '租金屬敏感資料，之後只有有權限的成員看得到',
                ),
              ),
            ],
            const SizedBox(height: 12),
            const Text('這筆資料會標示「本人填寫，未經查證」。'),
            const SizedBox(height: 16),
            FilledButton(onPressed: _save, child: const Text('新增')),
          ],
        ),
      ),
    );
  }
}

Future<void> showSeasonDialog(
  BuildContext context,
  WidgetRef ref,
  String fieldId,
) async {
  await showModalBottomSheet<void>(
    context: context,
    isScrollControlled: true,
    showDragHandle: true,
    builder: (context) => _SeasonSheet(fieldId: fieldId),
  );
}

class _SeasonSheet extends ConsumerStatefulWidget {
  final String fieldId;

  const _SeasonSheet({required this.fieldId});

  @override
  ConsumerState<_SeasonSheet> createState() => _SeasonSheetState();
}

class _SeasonSheetState extends ConsumerState<_SeasonSheet> {
  late final _name = TextEditingController(
    text: '${DateTime.now().year} ${DateTime.now().month >= 7 ? '秋作' : '春作'}',
  );
  final _crop = TextEditingController();
  final _variety = TextEditingController();
  DateTime? _plannedStart;

  @override
  void dispose() {
    _name.dispose();
    _crop.dispose();
    _variety.dispose();
    super.dispose();
  }

  Future<void> _save() async {
    if (_name.text.trim().isEmpty || _crop.text.trim().isEmpty) {
      showMessage(context, '請填期作名稱與作物');
      return;
    }
    final ok = await runAction(
      context,
      () => ref
          .read(repositoryProvider)
          .createSeason(
            fieldId: widget.fieldId,
            name: _name.text,
            cropName: _crop.text,
            variety: _variety.text,
            plannedStart: _plannedStart,
          ),
      success: '已新增期作',
    );
    if (ok && mounted) Navigator.of(context).pop();
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(bottom: MediaQuery.viewInsetsOf(context).bottom),
      child: SingleChildScrollView(
        padding: const EdgeInsets.fromLTRB(16, 0, 16, 24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Text('新增期作', style: Theme.of(context).textTheme.titleLarge),
            const SizedBox(height: 16),
            TextField(
              controller: _name,
              decoration: const InputDecoration(labelText: '期作名稱（必填）'),
            ),
            const SizedBox(height: 16),
            TextField(
              controller: _crop,
              decoration: const InputDecoration(
                labelText: '作物（必填）',
                hintText: '例：水稻、高麗菜',
              ),
            ),
            const SizedBox(height: 16),
            TextField(
              controller: _variety,
              decoration: const InputDecoration(labelText: '品種（可不填）'),
            ),
            const SizedBox(height: 16),
            OutlinedButton.icon(
              onPressed: () async {
                final now = DateTime.now();
                final picked = await showDatePicker(
                  context: context,
                  firstDate: DateTime(now.year - 2),
                  lastDate: DateTime(now.year + 3),
                  initialDate: _plannedStart ?? now,
                );
                if (picked != null) setState(() => _plannedStart = picked);
              },
              icon: const Icon(Icons.event),
              label: Text(
                _plannedStart == null
                    ? '預計開始日（可不填）'
                    : '預計 ${formatDate(_plannedStart)}開始',
              ),
            ),
            const SizedBox(height: 16),
            FilledButton(onPressed: _save, child: const Text('新增期作')),
          ],
        ),
      ),
    );
  }
}
