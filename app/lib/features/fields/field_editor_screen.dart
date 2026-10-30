import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../app/providers.dart';
import '../../app/widgets.dart';
import '../../core/db/database.dart';
import '../../domain/geo.dart';

/// 新增或修改田區。只有名稱必填；其他放在「更多資料」（漸進揭露）。
class FieldEditorScreen extends ConsumerStatefulWidget {
  final Field? existing;

  const FieldEditorScreen({super.key, this.existing});

  @override
  ConsumerState<FieldEditorScreen> createState() => _FieldEditorScreenState();
}

enum _AreaUnit { fen, m2, ha }

class _FieldEditorScreenState extends ConsumerState<FieldEditorScreen> {
  final _formKey = GlobalKey<FormState>();
  late final _name = TextEditingController(text: widget.existing?.name);
  late final _aliases = TextEditingController(text: widget.existing?.aliases);
  late final _notes = TextEditingController(text: widget.existing?.notes);
  final _area = TextEditingController();
  _AreaUnit _unit = _AreaUnit.fen;
  bool _saving = false;

  @override
  void dispose() {
    for (final c in [_name, _aliases, _notes, _area]) {
      c.dispose();
    }
    super.dispose();
  }

  double? _areaM2() {
    final v = double.tryParse(_area.text.trim());
    if (v == null || v <= 0) return null;
    return switch (_unit) {
      _AreaUnit.fen => v * squareMetersPerFen,
      _AreaUnit.m2 => v,
      _AreaUnit.ha => v * 10000,
    };
  }

  Future<void> _save() async {
    if (!_formKey.currentState!.validate()) return;
    setState(() => _saving = true);
    final repo = ref.read(repositoryProvider);
    final ok = await runAction(context, () async {
      if (widget.existing == null) {
        await repo.createField(
          name: _name.text,
          aliases: _aliases.text,
          notes: _notes.text,
          areaM2: _areaM2(),
        );
      } else {
        await repo.updateField(
          widget.existing!,
          name: _name.text,
          aliases: _aliases.text,
          notes: _notes.text,
          manualAreaM2: _areaM2(),
        );
      }
    });
    if (!mounted) return;
    setState(() => _saving = false);
    if (ok) Navigator.of(context).pop();
  }

  @override
  Widget build(BuildContext context) {
    final editing = widget.existing != null;
    return Scaffold(
      appBar: AppBar(title: Text(editing ? '修改田區' : '新增田區')),
      body: Form(
        key: _formKey,
        child: PageBody(
          children: [
            TextFormField(
              controller: _name,
              autofocus: !editing,
              decoration: const InputDecoration(
                labelText: '田區名稱（必填）',
                hintText: '例：北田、大坵',
              ),
              validator: (v) =>
                  (v == null || v.trim().isEmpty) ? '請填田區名稱' : null,
            ),
            const SizedBox(height: 8),
            ExpansionTile(
              tilePadding: EdgeInsets.zero,
              title: const Text('更多資料（可之後再補）'),
              initiallyExpanded: editing,
              children: [
                TextFormField(
                  controller: _aliases,
                  decoration: const InputDecoration(
                    labelText: '別名',
                    hintText: '家裡平常怎麼叫這塊田',
                  ),
                ),
                const SizedBox(height: 16),
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Expanded(
                      child: TextFormField(
                        controller: _area,
                        keyboardType: const TextInputType.numberWithOptions(
                          decimal: true,
                        ),
                        decoration: InputDecoration(
                          labelText: '面積（自己填）',
                          helperText: editing && widget.existing!.areaM2 != null
                              ? '目前：${formatArea(widget.existing!.areaM2!)}'
                              : '也可以之後沿田邊走一圈自動估算',
                          helperMaxLines: 3,
                        ),
                        validator: (v) {
                          if (v == null || v.trim().isEmpty) return null;
                          final n = double.tryParse(v.trim());
                          return (n == null || n <= 0) ? '請填大於 0 的數字' : null;
                        },
                      ),
                    ),
                    const SizedBox(width: 8),
                    DropdownButton<_AreaUnit>(
                      value: _unit,
                      onChanged: (u) => setState(() => _unit = u!),
                      items: const [
                        DropdownMenuItem(
                          value: _AreaUnit.fen,
                          child: Text('分'),
                        ),
                        DropdownMenuItem(
                          value: _AreaUnit.m2,
                          child: Text('平方公尺'),
                        ),
                        DropdownMenuItem(
                          value: _AreaUnit.ha,
                          child: Text('公頃'),
                        ),
                      ],
                    ),
                  ],
                ),
                const SizedBox(height: 16),
                TextFormField(
                  controller: _notes,
                  minLines: 2,
                  maxLines: 5,
                  decoration: const InputDecoration(
                    labelText: '備註',
                    hintText: '例：水源、進出路線',
                  ),
                ),
                const SizedBox(height: 8),
              ],
            ),
            const SizedBox(height: 16),
            FilledButton(
              onPressed: _saving ? null : _save,
              child: Text(editing ? '儲存修改' : '建立田區'),
            ),
          ],
        ),
      ),
    );
  }
}
