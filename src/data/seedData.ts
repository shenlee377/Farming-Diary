import { Workspace, Field, CropSeason, WorkContact, FarmTask, FarmWorkLog } from '../types/index.ts';

export const SEED_WORKSPACE: Workspace = {
  id: 'ws-tw-xiluo-001',
  name: '西螺大橋下青農合作社',
  ownerUserId: 'user-lin-01',
  createdAt: '2026-03-01T08:00:00Z',
  userRole: 'OWNER',
};

export const SEED_FIELDS: Field[] = [
  {
    id: 'field-north-01',
    workspaceId: 'ws-tw-xiluo-001',
    name: '大同路後底大坵 (北田)',
    areaHectares: 0.85,
    areaSource: 'GPS_TRACK_ESTIMATE',
    landRelationship: {
      ownerName: '陳黃阿雀 (祭祀公業管理人)',
      isSharedOwnership: true,
      tenantName: '林慶忠 (阿忠伯)',
      actualOperator: '林家豪 (青農返鄉返家管理)',
      leasePeriodStart: '2024-01-01',
      leasePeriodEnd: '2028-12-31',
      annualRentTWD: 32000,
      specialAgreements: '三期水稻後需種植田菁綠肥以滋養地力，水圳清理費用雙方各半。',
      verificationStatus: 'CONFIRMED_WITH_LANDOWNER',
      confirmedDate: '2024-02-15',
    },
    cadastralParcels: [
      { cadastralNumber: '雲林縣西螺鎮公館段 0451-0000 號', areaSqMeters: 5200 },
      { cadastralNumber: '雲林縣西螺鎮公館段 0452-0000 號', areaSqMeters: 3300 },
    ],
    waterSourceDescription: '濁水溪引水道第五支線 + 備用深井馬達 (深45米)',
    assemblyPointDescription: '北側農路三叉路口鐵皮工寮前榕樹下',
    boundaryVersion: 3,
    boundaryCoordinates: [
      [120.4632, 23.7845],
      [120.4645, 23.7848],
      [120.4648, 23.7832],
      [120.4630, 23.7830],
    ],
    isArchived: false,
  },
  {
    id: 'field-south-02',
    workspaceId: 'ws-tw-xiluo-001',
    name: '溪州堤防邊二分半地',
    areaHectares: 0.25,
    areaSource: 'MANUAL_INPUT',
    landRelationship: {
      ownerName: '林慶忠 (自有土地)',
      isSharedOwnership: false,
      tenantName: '林慶忠',
      actualOperator: '林家豪',
      verificationStatus: 'SELF_REPORTED_UNVERIFIED', // 系統明示：自填未查證
    },
    cadastralParcels: [
      { cadastralNumber: '彰化縣溪州鄉成功段 0889-0000 號', areaSqMeters: 2500 },
    ],
    waterSourceDescription: '農田水利署溪州工作站配水圳',
    assemblyPointDescription: '堤防6號水門旁空地',
    boundaryVersion: 1,
    boundaryCoordinates: [
      [120.4710, 23.7910],
      [120.4725, 23.7912],
      [120.4722, 23.7898],
      [120.4708, 23.7895],
    ],
    isArchived: false,
  },
];

export const SEED_CROP_SEASONS: CropSeason[] = [
  {
    id: 'crop-season-2026-01',
    fieldId: 'field-north-01',
    workspaceId: 'ws-tw-xiluo-001',
    seasonCode: '115年春季一期作',
    cropName: '青江白菜與包心白菜 (分區輪作)',
    variety: '三津一號',
    seedlingSource: '西螺惠農種苗行',
    seedlingBatchNumber: 'HN-2026-03-A',
    plannedPlantingDate: '2026-03-10',
    actualPlantingDate: '2026-03-12',
    plannedHarvestDate: '2026-04-28',
    status: 'ACTIVE',
    notes: '前作為 114 年二期水稻，土壤基肥施用充足，目前第3畦生長良好。',
  },
  {
    id: 'crop-season-2026-02',
    fieldId: 'field-south-02',
    workspaceId: 'ws-tw-xiluo-001',
    seasonCode: '115年休耕綠肥',
    cropName: '田菁綠肥 (休耕期)',
    variety: '在地採種',
    seedlingSource: '農會補助種子',
    plannedPlantingDate: '2026-03-01',
    plannedHarvestDate: '2026-05-30',
    status: 'FALLOW',
    notes: '依農業部轉作休耕申報規定辦理，預計5月下旬翻埋整地。',
  },
];

export const SEED_CONTACTS: WorkContact[] = [
  {
    id: 'contact-01',
    workspaceId: 'ws-tw-xiluo-001',
    fullName: '張金吉',
    nickname: '阿吉叔 (整地大師)',
    phone: '0912-345-678',
    preferredContactMethod: 'PHONE_CALL',
    groupLeaderName: '西螺工班第一組',
    workRestrictions: '能開迴轉犁中耕機；不能久跪，不接挑重逾30公斤作業',
    confirmedAvailableDays: ['週一', '週二', '週四', '週六'],
    defaultDailyWageTWD: 2500,
    defaultHourlyWageTWD: 320,
    hasAppAccount: false, // 外部聯絡人：無 App 帳號
    notes: '早上7點前打電話最容易聯絡到，慣用台語溝通。',
  },
  {
    id: 'contact-02',
    workspaceId: 'ws-tw-xiluo-001',
    fullName: '陳美蓮',
    nickname: '蓮姊 (採收帶班)',
    phone: '0928-888-999',
    preferredContactMethod: 'LINE_PROXY',
    groupLeaderName: '刺桐臨時採收班',
    workRestrictions: '限上午班 (06:00~11:30)，避開正午酷暑',
    confirmedAvailableDays: ['每日上午'],
    defaultDailyWageTWD: 1600,
    hasAppAccount: false,
    notes: '帶班4~6人，調工需提前兩天告知。',
  },
];

export const SEED_TASKS: FarmTask[] = [
  {
    id: 'task-101',
    workspaceId: 'ws-tw-xiluo-001',
    fieldId: 'field-north-01',
    fieldName: '大同路後底大坵 (北田)',
    cropSeasonId: 'crop-season-2026-01',
    cropName: '青江白菜與包心白菜',
    title: '第1~8畦追施有機質肥並巡檢葉背跳甲',
    taskType: 'FERTILIZING',
    plannedDate: '2026-10-20',
    assemblyTime: '06:30',
    assemblyLocation: '北側農路三叉路口榕樹下工寮',
    requiredWorkersCount: 2,
    assignments: [
      {
        contactId: 'contact-01',
        contactName: '張金吉 (阿吉叔)',
        status: 'CONFIRMED', // 本人電話已確認出席
        contactTime: '2026-10-18T19:20:00Z',
        confirmedTime: '2026-10-18T19:22:00Z',
        wageType: 'DAILY',
        rateSnapshotTWD: 2500,
        paidStatus: 'UNPAID',
      },
      {
        contactId: 'contact-02',
        contactName: '陳美蓮 (蓮姊)',
        status: 'CONTACTED_PENDING', // 已打電話，待確認工班人數
        contactTime: '2026-10-19T08:15:00Z',
        wageType: 'DAILY',
        rateSnapshotTWD: 1600,
        paidStatus: 'UNPAID',
      },
    ],
    preparedToolsNotes: '背負式施肥機1台、台肥特43號3包、遮陽斗笠與手套',
    weatherAdjustmentNotes: '若中央氣象署預報降雨機率逾70%，順延至次日清晨辦理。',
    status: 'SCHEDULED',
  },
];

export const SEED_LOGS: FarmWorkLog[] = [
  {
    id: 'log-501',
    workspaceId: 'ws-tw-xiluo-001',
    taskId: 'task-100-past',
    fieldId: 'field-north-01',
    fieldName: '大同路後底大坵 (北田)',
    cropSeasonId: 'crop-season-2026-01',
    cropName: '青江白菜與包心白菜',
    activityType: '中耕培土與基肥施用',
    actualStartTime: '2026-10-15T06:30:00Z',
    actualEndTime: '2026-10-15T11:00:00Z',
    operatorNames: ['林家豪', '張金吉 (阿吉叔)'],
    workAreaDescription: '全區南側第1~6畦，培土厚度約8公分',
    materialsUsed: [
      {
        materialName: '台肥黑王一號有機質特43號複合肥料',
        specification: '40公斤/包',
        rawInputQuantityText: '一包半 (現場拆封一整包加半包剩料)',
        isSpecificationConfirmed: true,
        standardAmountKg: 60,
        batchNumber: 'TF-202602-098',
      },
    ],
    sprayingStatus: 'CONFIRMED_NOT_APPLIED', // 管理者明確確認未施用任何化學藥劑
    photoUrls: [
      'https://images.unsplash.com/photo-1592982537447-7440770cbfc9?auto=format&fit=crop&w=800&q=80',
    ],
    originalRawInput: '阿吉叔今天早上6點半到，幫忙把南邊六畦培好土，用了特43一包半，沒有噴藥。',
    reportedByUserId: 'user-lin-01',
    confirmedByManagerId: 'user-lin-01',
    confirmedAt: '2026-10-15T12:30:00Z',
    status: 'CONFIRMED',
  },
];
