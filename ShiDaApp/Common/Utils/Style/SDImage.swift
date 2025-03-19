import Foundation

/// 师大App图片资源管理
public enum SDImage {
    // MARK: - 首页功能模块
    public enum Home {
        /// 笔记图标
        public static let notes = "icon_notes_bookmark"
        /// 资料图标
        public static let documents = "icon_documents_folder"
        /// 试题图标
        public static let exam = "icon_exam_edit"
        /// 统计报告图标
        public static let statistics = "icon_statistics_chart"
        /// 班级管理图标
        public static let classManagement = "icon_class_management_flag"
        /// 班级讨论图标
        public static let classDiscussion = "icon_class_discussion_chat"
        /// 任务管理图标
        public static let taskManagement = "icon_task_checklist"
        /// 教学直播图标
        public static let liveTeaching = "icon_live_teaching_video"
    }
    
    // MARK: - 学习模块
    public enum Study {
        /// 笔记图标
        public static let notes = "icon_notes_bookmark"
        /// 资料图标
        public static let documents = "icon_documents_folder"
        /// 试题图标
        public static let exam = "icon_exam_edit"
        /// 统计报告图标
        public static let statistics = "icon_statistics_chart"
        /// 班级管理图标
        public static let classManagement = "icon_class_management_flag"
        /// 班级讨论图标
        public static let classDiscussion = "icon_class_discussion_chat"
        /// 任务管理图标
        public static let taskManagement = "icon_task_checklist"
        /// 教学直播图标
        public static let liveTeaching = "icon_live_teaching_video"
    }
    
    // MARK: - 通用图标
    public enum Common {
        /// 返回按钮
        public static let back = "icon_back"
        /// 关闭按钮
        public static let close = "icon_close"
        /// 更多按钮
        public static let more = "icon_more"
    }
    
    // MARK: - 个人中心模块
    public enum My {
        public static let myHeader = "bg_my_header"

        
        /// 我的收藏图标
        public static let favorites = "icon_favorites_star"
        /// 我的纠错图标
        public static let corrections = "icon_corrections_mark"
        /// 账号设置图标
        public static let accountSettings = "icon_account_settings"
        /// 教师认证图标
        public static let teacherCertification = "icon_teacher_certification"
        /// 帮助反馈图标
        public static let helpFeedback = "icon_help_feedback"
        /// 关于我们图标
        public static let aboutUs = "icon_about_us"
    }
    
    // MARK: - 占位图
    public enum Placeholder {
        /// 空状态占位图
        public static let empty = "img_empty_placeholder"
        /// 加载失败占位图
        public static let error = "img_error_placeholder"
        /// 网络错误占位图
        public static let network = "img_network_error"
    }
}
