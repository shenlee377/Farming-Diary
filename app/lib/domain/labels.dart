/// 介面用的白話標籤。資料庫存英文代碼，畫面只顯示中文。
library;

const workTypes = <String, String>{
  'land_prep': '整地',
  'planting': '播種／定植',
  'fertilizing': '施肥',
  'weeding': '除草',
  'spraying': '施藥',
  'irrigation': '灌溉',
  'inspection': '巡田',
  'harvest': '採收',
  'other': '其他',
};

String workTypeLabel(String code) => workTypes[code] ?? code;

const landRelationKinds = <String, String>{
  'owner': '所有人',
  'co_owner': '共有人',
  'lessee': '承租',
  'operator': '代耕／經營',
  'user': '使用（借用等）',
};

String landRelationLabel(String code) => landRelationKinds[code] ?? code;

const verificationLabels = <String, String>{
  'self_reported': '本人填寫，未經查證',
  'document_seen': '已看過文件',
  'officially_verified': '已向官方查證',
};

const seasonStatusLabels = <String, String>{
  'planned': '計畫中',
  'active': '種植中',
  'fallow': '休耕',
  'closed': '已結束',
};

const contactChannels = <String, String>{
  'phone': '電話',
  'line': 'LINE',
  'in_person': '當面',
  'other': '其他',
};

const roleLabels = <String, String>{
  'owner': '擁有者',
  'manager': '共同管理者',
  'bookkeeper': '記帳',
  'worker': '現場工作者',
  'advisor': '顧問',
  'viewer': '唯讀',
};

const inspectionStatusLabels = <String, String>{
  'capturing': '拍攝中',
  'local_saved': '已存在手機，等待上傳與雲端檢查',
  'reshoot_required': '需要補拍',
};
