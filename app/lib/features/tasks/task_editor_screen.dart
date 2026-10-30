import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../app/providers.dart';
import '../../app/widgets.dart';
import '../../domain/labels.dart';
import '../fields/field_editor_screen.dart';

Future<DateTime?> pickDateTime(
  BuildContext context, {
  DateTime? initial,
}) async {
  final now = DateTime.now();
  final date = await showDatePicker(
    context: context,
    firstDate: DateTime(now.year - 1),
    lastDate: DateTime(now.year + 2),
    initialDate: initial ?? now,
  );
  if (date == null || !context.mounted) return null;
  final time = await showTimePicker(
    context: context,
    initialTime: initial == null
        ? const TimeOfDay(hour: 7, minute: 0)
        : TimeOfDay.fromDateTime(initial),
  );
  if (time == null) return null;
  return DateTime(date.year, date.month, date.day, time.hour, time.minute);
}

/// 新增工作：田區、工作內容、時間、需要幾個人；其他放「更多資料」。
class TaskEditorScreen extends ConsumerStatefulWidget {
  final String? initialFieldId;

  const TaskEditorScreen({super.key, this.initialFieldId});

  @override
  ConsumerState<TaskEditorScreen> createState() => _TaskEditorScreenState();
}

class _TaskEditorScreenState extends ConsumerState<TaskEditorScreen> {
  final _formKey = GlobalKey<FormState>();
  final _title = TextEditingController();
  final _meetPlace = TextEditingController();
  final _notes = TextEditingController();
  late String? _fieldId = widget.initialFieldId;
  String? _seasonId;
  String _workType = 'weeding';
  DateTime? _plannedStart;
  DateTime? _meetAt;
  int _headcount = 0;
  bool _saving = false;

  @override
  void dispose() {
    _title.dispose();
    _meetPlace.dispose();
    _notes.dispose();
    super.dispose();
  }

  Future<void> _save() async {
    if (!_formKey.currentState!.validate()) return;
    if (_fieldId == null) {
      showMessage(context, '請選擇田區');
      return;
    }
    setState(() => _saving = true);
    final ok = await runAction(
      context,
      () => ref
          .read(repositoryProvider)
          .createTask(
            fieldId: _fieldId!,
            seasonId: _seasonId,
            title: _title.text.trim().isEmpty
                ? workTypeLabel(_workType)
                : _title.text,
            workType: _workType,
            plannedStart: _plannedStart,
            meetAt: _meetAt,
            meetPlace: _meetPlace.text,
            headcountNeeded: _headcount,
            notes: _notes.text,
          ),
      success: '已新增工作',
    );
    if (!mounted) return;
    setState(() => _saving = false);
    if (ok) Navigator.of(context).pop();
  }

  @override
  Widget build(BuildContext context) {
    final fields = ref.watch(fieldsProvider);
    final seasons = _fieldId == null
        ? null
        : ref.watch(seasonsProvider(_fieldId));
    return Scaffold(
      appBar: AppBar(title: const Text('新增工作')),
      body: Form(
        key: _formKey,
        child: AsyncView(
          fields,
          builder: (list) {
            if (list.isEmpty) {
              return PageBody(
                children: [
                  const EmptyHint('要先有田區才能排工作。', icon: Icons.grass),
                  const SizedBox(height: 12),
                  FilledButton(
                    onPressed: () => Navigator.of(context).push(
                      MaterialPageRoute(
                        builder: (_) => const FieldEditorScreen(),
                      ),
                    ),
                    child: const Text('新增田區'),
                  ),
                ],
              );
            }
            return PageBody(
              children: [
                DropdownButtonFormField<String>(
                  initialValue: _fieldId,
                  decoration: const InputDecoration(labelText: '田區（必填）'),
                  items: [
                    for (final f in list)
                      DropdownMenuItem(value: f.id, child: Text(f.name)),
                  ],
                  onChanged: (v) => setState(() {
                    _fieldId = v;
                    _seasonId = null;
                  }),
                  validator: (v) => v == null ? '請選擇田區' : null,
                ),
                const SizedBox(height: 16),
                DropdownButtonFormField<String>(
                  initialValue: _workType,
                  decoration: const InputDecoration(labelText: '要做什麼'),
                  items: [
                    for (final e in workTypes.entries)
                      DropdownMenuItem(value: e.key, child: Text(e.value)),
                  ],
                  onChanged: (v) => setState(() => _workType = v!),
                ),
                const SizedBox(height: 16),
                TextFormField(
                  controller: _title,
                  decoration: InputDecoration(
                    labelText: '工作名稱',
                    hintText: '不填就用「${workTypeLabel(_workType)}」',
                  ),
                ),
                const SizedBox(height: 16),
                OutlinedButton.icon(
                  onPressed: () async {
                    final picked = await pickDateTime(
                      context,
                      initial: _plannedStart,
                    );
                    if (picked != null) setState(() => _plannedStart = picked);
                  },
                  icon: const Icon(Icons.event),
                  label: Text(
                    _plannedStart == null
                        ? '選擇日期時間（不選則存為草稿）'
                        : '時間：${formatDateTime(_plannedStart)}',
                  ),
                ),
                const SizedBox(height: 16),
                Text(
                  '需要幾個人幫忙（不含自己）',
                  style: Theme.of(context).textTheme.titleSmall,
                ),
                Row(
                  children: [
                    IconButton.outlined(
                      tooltip: '減少',
                      onPressed: _headcount > 0
                          ? () => setState(() => _headcount--)
                          : null,
                      icon: const Icon(Icons.remove),
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 16),
                      child: Text(
                        '$_headcount 人',
                        style: Theme.of(context).textTheme.titleLarge,
                      ),
                    ),
                    IconButton.outlined(
                      tooltip: '增加',
                      onPressed: () => setState(() => _headcount++),
                      icon: const Icon(Icons.add),
                    ),
                  ],
                ),
                ExpansionTile(
                  tilePadding: EdgeInsets.zero,
                  title: const Text('更多資料（可不填）'),
                  children: [
                    if (seasons != null)
                      AsyncView(
                        seasons,
                        builder: (ss) {
                          if (ss.isEmpty) return const SizedBox.shrink();
                          return Padding(
                            padding: const EdgeInsets.only(bottom: 16),
                            child: DropdownButtonFormField<String?>(
                              initialValue: _seasonId,
                              decoration: const InputDecoration(
                                labelText: '屬於哪個期作',
                              ),
                              items: [
                                const DropdownMenuItem<String?>(
                                  value: null,
                                  child: Text('不指定'),
                                ),
                                for (final s in ss)
                                  DropdownMenuItem<String?>(
                                    value: s.id,
                                    child: Text('${s.name}・${s.cropName}'),
                                  ),
                              ],
                              onChanged: (v) => setState(() => _seasonId = v),
                            ),
                          );
                        },
                      ),
                    OutlinedButton.icon(
                      onPressed: () async {
                        final picked = await pickDateTime(
                          context,
                          initial: _meetAt ?? _plannedStart,
                        );
                        if (picked != null) setState(() => _meetAt = picked);
                      },
                      icon: const Icon(Icons.schedule),
                      label: Text(
                        _meetAt == null
                            ? '集合時間'
                            : '集合：${formatDateTime(_meetAt)}',
                      ),
                    ),
                    const SizedBox(height: 16),
                    TextFormField(
                      controller: _meetPlace,
                      decoration: const InputDecoration(
                        labelText: '集合地點',
                        hintText: '例：工寮',
                      ),
                    ),
                    const SizedBox(height: 16),
                    TextFormField(
                      controller: _notes,
                      minLines: 2,
                      maxLines: 5,
                      decoration: const InputDecoration(
                        labelText: '備註',
                        hintText: '例：要帶的工具',
                      ),
                    ),
                    const SizedBox(height: 8),
                  ],
                ),
                const SizedBox(height: 16),
                FilledButton(
                  onPressed: _saving ? null : _save,
                  child: const Text('建立工作'),
                ),
              ],
            );
          },
        ),
      ),
    );
  }
}
