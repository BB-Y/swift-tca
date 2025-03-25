
enum SDStudyType : CaseIterable , Identifiable{
    var id: Self {self}
    var icon: String {
        switch self {
        case .notes:
            SDImage.Study.TopIcon.notes.rawValue
        case .documents:
            SDImage.Study.TopIcon.documents.rawValue
        case .exam:
            SDImage.Study.TopIcon.exam.rawValue
        case .statistics:
            SDImage.Study.TopIcon.statistics.rawValue
        case .classManagement:
            SDImage.Study.TopIcon.classManagement.rawValue
        case .classDiscussion:
            SDImage.Study.TopIcon.classDiscussion.rawValue
        case .taskManagement:
            SDImage.Study.TopIcon.taskManagement.rawValue
        case .liveTeaching:
            SDImage.Study.TopIcon.liveTeaching.rawValue
        }
    }
    func title(_ type: SDUserType) -> String {
        switch type {
        case .student:
            switch self {
            case .notes:
                return "笔记"
            case.documents:
                return "资料"
            case.exam:
                return "试题"
            case.statistics:
                return "学习报告"
            case.classManagement:
                return "班级管理"
            case.classDiscussion:
                return "班级讨论"
            case.taskManagement:
                return "学习任务"
            case.liveTeaching:
                return "直播教学"
            }
            
        case .teacher:
            switch self {
            case .notes:
                return "笔记"
            case.documents:
                return "资料"
            case.exam:
                return "试题"
            case.statistics:
                return "统计报告"
            case.classManagement:
                return "班级管理"
            case.classDiscussion:
                return "班级讨论"
            case.taskManagement:
                return "任务管理"
            case.liveTeaching:
                return "教学直播"
            }
        }
    }
    case notes
    case documents
    case exam
    case statistics
    case classManagement
    case classDiscussion
    case taskManagement
    case liveTeaching
}

// MARK: - 班级信息
/// 班级信息
public struct SDClassInfoDto: Codable, Equatable {
    /// 班级ID
    public let classId: Int?
    /// 班级名称
    public let className: String?
    /// 教师名称
    public let teacher: String?
    /// 教师用户ID
    public let teacherUserId: Int?
   
}

// MARK: - 教师用书信息
/// 教师用书信息
public struct SDStudyMyDbookDto: Codable, Equatable {
    /// 作者信息
    public let authors: String?
    /// 分类名称
    public let categoryName: String?
    /// 所在班级信息
    public let classInfo: SDClassInfoDto?
    /// 封面
    public let dbookCover: String?
    /// 图书ID
    public let dbookId: Int?
    /// 图书名
    public let dbookName: String?
    /// ID
    public let id: Int?
    /// 出版社
    public let publisher: String?
    /// 状态
    public let status: Int?
   
}

/// 教师用书列表结果
public typealias SDTeacherBookPageResult = SDPageResponse<SDStudyMyDbookDto>


