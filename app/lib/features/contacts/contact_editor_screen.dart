import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../app/providers.dart';
import '../../app/widgets.dart';
import '../../core/db/database.dart';
import '../../domain/labels.dart';

/// 新增／修改聯絡人（臨時工、帶班者等，不需要 App 帳號）。存檔後回傳 [Contact]。
class ContactEditorScreen extends ConsumerStatefulWidget {
  final Contact? existing;

  const ContactEditorScreen({super.key, this.existing});

  @override
  ConsumerState<ContactEditorScreen> createState() =>
      _ContactEditorScreenState();
}

class _ContactEditorScreenState extends ConsumerState<ContactEditorScreen> {
  final _formKey = GlobalKey<FormState>();
  late final _name = TextEditingController(text: widget.existing?.name);
  late final _nickname = TextEditingController(text: widget.existing?.nickname);
  late final _phone = TextEditingController(text: widget.existing?.phone);
  late final _constraints = TextEditingController(
    text: widget.existing?.workConstraints,
  );
  late final _notes = TextEditingController(text: widget.existing?.notes);
  late String _channel = widget.existing?.preferredChannel ?? 'phone';

  @override
  void dispose() {
    for (final c in [_name, _nickname, _phone, _constraints, _notes]) {
      c.dispose();
    }
    super.dispose();
  }

  Future<void> _save() async {
    if (!_formKey.currentState!.validate()) return;
    Contact? saved;
    final ok = await runAction(context, () async {
      saved = await ref
          .read(repositoryProvider)
          .saveContact(
            existing: widget.existing,
            name: _name.text,
            nickname: _nickname.text,
            phone: _phone.text,
            preferredChannel: _channel,
            workConstraints: _constraints.text,
            notes: _notes.text,
          );
    });
    if (ok && mounted) Navigator.of(context).pop(saved);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(widget.existing == null ? '新增聯絡人' : '修改聯絡人')),
      body: Form(
        key: _formKey,
        child: PageBody(
          children: [
            TextFormField(
              controller: _name,
              autofocus: widget.existing == null,
              decoration: const InputDecoration(labelText: '姓名（必填）'),
              validator: (v) => (v == null || v.trim().isEmpty) ? '請填姓名' : null,
            ),
            const SizedBox(height: 16),
            TextFormField(
              controller: _nickname,
              decoration: const InputDecoration(
                labelText: '平常怎麼叫',
                hintText: '例：阿吉叔',
              ),
            ),
            const SizedBox(height: 16),
            TextFormField(
              controller: _phone,
              keyboardType: TextInputType.phone,
              decoration: const InputDecoration(
                labelText: '電話',
                helperText: '電話屬敏感資料，之後只有有權限的成員看得到',
              ),
            ),
            const SizedBox(height: 16),
            DropdownButtonFormField<String>(
              initialValue: _channel,
              decoration: const InputDecoration(labelText: '習慣的聯絡方式'),
              items: [
                for (final e in contactChannels.entries)
                  DropdownMenuItem(value: e.key, child: Text(e.value)),
              ],
              onChanged: (v) => setState(() => _channel = v!),
            ),
            const SizedBox(height: 16),
            TextFormField(
              controller: _constraints,
              decoration: const InputDecoration(
                labelText: '工作限制（本人說的）',
                hintText: '例：只能做上午、不噴藥',
              ),
            ),
            const SizedBox(height: 16),
            TextFormField(
              controller: _notes,
              minLines: 2,
              maxLines: 4,
              decoration: const InputDecoration(labelText: '備註'),
            ),
            const SizedBox(height: 24),
            FilledButton(onPressed: _save, child: const Text('儲存')),
          ],
        ),
      ),
    );
  }
}
