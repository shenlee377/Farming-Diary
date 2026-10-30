/// 三組狀態機，對應 docs/DOMAIN_MODEL.md §3。
///
/// 規則集中在這裡，畫面與資料層只能透過 [TaskStatus.apply] 等方法轉移狀態；
/// 非法轉移丟出 [IllegalTransition]，不默默忽略。
library;

class IllegalTransition implements Exception {
  final String machine;
  final String from;
  final String action;

  const IllegalTransition(this.machine, this.from, this.action);

  @override
  String toString() => 'IllegalTransition($machine: $from --$action-->)';
}

// ───────────────────────── 工作（TASK）§3.1 ─────────────────────────

enum TaskStatus {
  draft('草稿'),
  scheduled('已排定'),
  staffing('找人中'),
  ready('人手已齊'),
  inProgress('進行中'),
  reported('已回報，待確認'),
  completed('已完成'),
  cancelled('已取消'),
  rescheduled('改期中');

  final String label;
  const TaskStatus(this.label);

  static TaskStatus parse(String name) => TaskStatus.values.byName(name);

  bool get isOpen => this != completed && this != cancelled;
}

enum TaskAction {
  schedule('排定時間與田區'),
  startStaffing('開始找人'),
  staffingFilled('人手已齊'),
  someoneCancelled('有人取消'),
  noExternalStaff('不需外部人力'),
  start('開工'),
  startShortHanded('人力不足仍開工'),
  report('收到完成回報'),
  confirm('確認紀錄'),
  sendBack('退回補做'),
  cancel('取消工作'),
  reschedule('改期'),
  rescheduleConfirmed('新時間確定');

  final String label;
  const TaskAction(this.label);
}

const Map<TaskStatus, Map<TaskAction, TaskStatus>> _taskTransitions = {
  TaskStatus.draft: {
    TaskAction.schedule: TaskStatus.scheduled,
    TaskAction.cancel: TaskStatus.cancelled,
  },
  TaskStatus.scheduled: {
    TaskAction.startStaffing: TaskStatus.staffing,
    TaskAction.noExternalStaff: TaskStatus.ready,
    TaskAction.cancel: TaskStatus.cancelled,
    TaskAction.reschedule: TaskStatus.rescheduled,
  },
  TaskStatus.staffing: {
    TaskAction.staffingFilled: TaskStatus.ready,
    TaskAction.startShortHanded: TaskStatus.inProgress,
    TaskAction.cancel: TaskStatus.cancelled,
    TaskAction.reschedule: TaskStatus.rescheduled,
  },
  TaskStatus.ready: {
    TaskAction.someoneCancelled: TaskStatus.staffing,
    TaskAction.start: TaskStatus.inProgress,
    TaskAction.cancel: TaskStatus.cancelled,
    TaskAction.reschedule: TaskStatus.rescheduled,
  },
  TaskStatus.inProgress: {TaskAction.report: TaskStatus.reported},
  TaskStatus.reported: {
    TaskAction.confirm: TaskStatus.completed,
    TaskAction.sendBack: TaskStatus.inProgress,
  },
  TaskStatus.rescheduled: {
    TaskAction.rescheduleConfirmed: TaskStatus.scheduled,
  },
};

extension TaskStatusMachine on TaskStatus {
  Set<TaskAction> get allowedActions =>
      (_taskTransitions[this] ?? const {}).keys.toSet();

  bool can(TaskAction action) =>
      _taskTransitions[this]?.containsKey(action) ?? false;

  TaskStatus apply(TaskAction action) {
    final next = _taskTransitions[this]?[action];
    if (next == null) throw IllegalTransition('task', name, action.name);
    return next;
  }
}

/// `staffing → ready` 只看「已答應」人數，不看「已聯繫」人數。
bool isStaffingFilled({
  required int acceptedCount,
  required int headcountNeeded,
}) => headcountNeeded > 0 && acceptedCount >= headcountNeeded;

// ───────────────────────── 人員安排（ASSIGNMENT）§3.2 ─────────────────────────

enum AssignmentStatus {
  notContacted('還沒聯絡'),
  awaitingReply('已聯絡，等回覆'),
  accepted('答應了'),
  declined('不能來'),
  cancelled('已取消安排'),
  needsReconfirm('改期，需再確認'),
  arrived('已到場'),
  finished('已完成'),
  leftEarly('提早離開');

  final String label;
  const AssignmentStatus(this.label);

  static AssignmentStatus parse(String name) =>
      AssignmentStatus.values.byName(name);

  /// 只有真正答應（含已到場、已完成）才計入人手。
  bool get countsAsAccepted =>
      this == accepted ||
      this == arrived ||
      this == finished ||
      this == leftEarly;
}

enum AssignmentAction {
  contact('記錄已聯絡'),
  accept('答應了'),
  decline('不能來'),
  cancel('取消安排'),
  taskRescheduled('工作改期'),
  arrive('到場'),
  finish('完成'),
  leaveEarly('提早離開');

  final String label;
  const AssignmentAction(this.label);
}

const Map<AssignmentStatus, Map<AssignmentAction, AssignmentStatus>>
_assignmentTransitions = {
  AssignmentStatus.notContacted: {
    AssignmentAction.contact: AssignmentStatus.awaitingReply,
    AssignmentAction.accept: AssignmentStatus.accepted,
    AssignmentAction.cancel: AssignmentStatus.cancelled,
  },
  AssignmentStatus.awaitingReply: {
    AssignmentAction.accept: AssignmentStatus.accepted,
    AssignmentAction.decline: AssignmentStatus.declined,
    AssignmentAction.cancel: AssignmentStatus.cancelled,
  },
  AssignmentStatus.accepted: {
    AssignmentAction.decline: AssignmentStatus.declined,
    AssignmentAction.cancel: AssignmentStatus.cancelled,
    AssignmentAction.taskRescheduled: AssignmentStatus.needsReconfirm,
    AssignmentAction.arrive: AssignmentStatus.arrived,
  },
  AssignmentStatus.needsReconfirm: {
    AssignmentAction.contact: AssignmentStatus.awaitingReply,
  },
  AssignmentStatus.arrived: {
    AssignmentAction.finish: AssignmentStatus.finished,
    AssignmentAction.leaveEarly: AssignmentStatus.leftEarly,
  },
};

extension AssignmentStatusMachine on AssignmentStatus {
  Set<AssignmentAction> get allowedActions =>
      (_assignmentTransitions[this] ?? const {}).keys.toSet();

  bool can(AssignmentAction action) =>
      _assignmentTransitions[this]?.containsKey(action) ?? false;

  AssignmentStatus apply(AssignmentAction action) {
    final next = _assignmentTransitions[this]?[action];
    if (next == null) throw IllegalTransition('assignment', name, action.name);
    return next;
  }
}

// ───────────────────────── 回報與確認（WORK_REPORT）§3.3 ─────────────────────────

enum ReportStatus {
  draft('草稿，存在手機'),
  submitted('已送出，等確認'),
  underReview('確認中'),
  needsInfo('需要補資料'),
  confirmed('已確認成正式紀錄'),
  rejected('已退回'),
  amended('修正中'),
  voided('已作廢');

  final String label;
  const ReportStatus(this.label);

  static ReportStatus parse(String name) => ReportStatus.values.byName(name);
}

enum ReportAction {
  submit('送出回報'),
  openReview('開始確認'),
  requestInfo('要求補資料'),
  resubmit('補件送出'),
  confirm('確認成正式紀錄'),
  reject('退回'),
  amend('修正'),
  confirmAmendment('修正後確認'),
  voidRecord('作廢');

  final String label;
  const ReportAction(this.label);
}

const Map<ReportStatus, Map<ReportAction, ReportStatus>> _reportTransitions = {
  ReportStatus.draft: {ReportAction.submit: ReportStatus.submitted},
  ReportStatus.submitted: {ReportAction.openReview: ReportStatus.underReview},
  ReportStatus.underReview: {
    ReportAction.requestInfo: ReportStatus.needsInfo,
    ReportAction.confirm: ReportStatus.confirmed,
    ReportAction.reject: ReportStatus.rejected,
  },
  ReportStatus.needsInfo: {ReportAction.resubmit: ReportStatus.submitted},
  ReportStatus.confirmed: {
    ReportAction.amend: ReportStatus.amended,
    ReportAction.voidRecord: ReportStatus.voided,
  },
  ReportStatus.amended: {ReportAction.confirmAmendment: ReportStatus.confirmed},
};

extension ReportStatusMachine on ReportStatus {
  bool can(ReportAction action) =>
      _reportTransitions[this]?.containsKey(action) ?? false;

  ReportStatus apply(ReportAction action) {
    final next = _reportTransitions[this]?[action];
    if (next == null) throw IllegalTransition('report', name, action.name);
    return next;
  }
}

// ───────────────────────── 施藥狀態 ─────────────────────────

enum PesticideStatus {
  applied('已施用'),
  confirmedNone('已確認未施用'),
  unknown('尚未確認'),
  incomplete('紀錄不完整');

  final String label;
  const PesticideStatus(this.label);

  static PesticideStatus parse(String name) =>
      PesticideStatus.values.byName(name);
}

/// 期間彙總：任何一筆已施用 → 已施用；沒有紀錄 → 尚未確認（絕不推論為未施用）。
PesticideStatus aggregatePesticideStatus(Iterable<PesticideStatus> records) {
  final list = records.toList();
  if (list.isEmpty) return PesticideStatus.unknown;
  if (list.contains(PesticideStatus.applied)) return PesticideStatus.applied;
  if (list.contains(PesticideStatus.incomplete)) {
    return PesticideStatus.incomplete;
  }
  if (list.every((s) => s == PesticideStatus.confirmedNone)) {
    return PesticideStatus.confirmedNone;
  }
  return PesticideStatus.unknown;
}

// ───────────────────────── 上傳 §3.4 ─────────────────────────

enum UploadStatus {
  localSaved('已存在手機'),
  uploading('上傳中'),
  serverReceived('已上傳'),
  processed('已處理'),
  failed('上傳失敗'),
  processingFailed('處理失敗（原檔仍可用）');

  final String label;
  const UploadStatus(this.label);

  static UploadStatus parse(String name) => UploadStatus.values.byName(name);
}
