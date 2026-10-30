import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../app/providers.dart';
import '../../app/theme.dart';
import '../../app/widgets.dart';

/// 第一次開啟：建立本機身分與農場（工作空間）。
///
/// 正式登入（咖啡廳帳號 OAuth）尚未串接，所以先用本機身分；資料只存在這支手機。
class OnboardingScreen extends ConsumerStatefulWidget {
  const OnboardingScreen({super.key});

  @override
  ConsumerState<OnboardingScreen> createState() => _OnboardingScreenState();
}

class _OnboardingScreenState extends ConsumerState<OnboardingScreen> {
  final _formKey = GlobalKey<FormState>();
  final _name = TextEditingController();
  final _farm = TextEditingController();
  bool _saving = false;

  @override
  void dispose() {
    _name.dispose();
    _farm.dispose();
    super.dispose();
  }

  Future<void> _submit() async {
    if (!_formKey.currentState!.validate()) return;
    setState(() => _saving = true);
    await ref
        .read(sessionProvider.notifier)
        .setUp(displayName: _name.text, workspaceName: _farm.text);
    if (mounted) setState(() => _saving = false);
  }

  @override
  Widget build(BuildContext context) {
    final text = Theme.of(context).textTheme;
    return Scaffold(
      body: SafeArea(
        child: Form(
          key: _formKey,
          child: PageBody(
            children: [
              const SizedBox(height: 24),
              Icon(
                Icons.eco,
                size: 56,
                color: Theme.of(context).colorScheme.primary,
              ),
              const SizedBox(height: 12),
              Text('農田日記', style: text.displaySmall),
              const SizedBox(height: 8),
              Text('把田、人、工作和紀錄記在一起。先填兩項就能開始。', style: text.bodyLarge),
              const SizedBox(height: 24),
              TextFormField(
                controller: _name,
                textInputAction: TextInputAction.next,
                decoration: const InputDecoration(
                  labelText: '你的稱呼（必填）',
                  hintText: '例：阿明',
                ),
                validator: (v) =>
                    (v == null || v.trim().isEmpty) ? '請填你的稱呼' : null,
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: _farm,
                textInputAction: TextInputAction.done,
                onFieldSubmitted: (_) => _submit(),
                decoration: const InputDecoration(
                  labelText: '農場名稱（必填）',
                  hintText: '例：林家田',
                ),
                validator: (v) =>
                    (v == null || v.trim().isEmpty) ? '請填農場名稱' : null,
              ),
              const SizedBox(height: 24),
              FilledButton(
                onPressed: _saving ? null : _submit,
                child: Text(_saving ? '建立中…' : '開始使用'),
              ),
              const SizedBox(height: 24),
              Card(
                child: Padding(
                  padding: const EdgeInsets.all(16),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Icon(Icons.phone_android, color: context.colors.info),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Text(
                          '目前資料只存在這支手機。正式帳號登入與雲端同步完成後，會再請你登入並上傳。'
                          '在那之前，可以從「更多 › 匯出備份」自己保存一份。',
                          style: text.bodyMedium,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
