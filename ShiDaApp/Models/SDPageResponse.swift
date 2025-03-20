

/// 分页数据结构
public struct SDPageResponse<T: Codable & Equatable>: Codable, Equatable,SDMockable {
    /// 当前页码
    public var currentPage: Int?
    /// 偏移量，初始值为1
    public var offset: Int?
    /// 每页大小
    public var pageSize: Int?
    /// 实际大小
    public var realSize: Int?
    /// 数据行
    public var rows: [T]?
    /// 总数
    public var total: Int?
    /// 总页数
    public var totalPage: Int?
    
    /// 是否有更多数据
    public var hasMoreData: Bool {
        guard let currentPage = currentPage, let totalPage = totalPage else {
            return false
        }
        return currentPage < totalPage
    }
    
    /// 获取有效数据数量
    public var count: Int {
        return rows?.count ?? 0
    }
    
    /// 是否为空
    public var isEmpty: Bool {
        return count == 0
    }
    
    /// 下一页页码
    public var nextPage: Int {
        return (currentPage ?? 0) + 1
    }
    
    /// 默认初始化方法
    public init(currentPage: Int? = 1,
                offset: Int? = 1,
                pageSize: Int? = 20,
                realSize: Int? = 0,
                rows: [T]? = [],
                total: Int? = 0,
                totalPage: Int? = 0) {
        self.currentPage = currentPage
        self.offset = offset
        self.pageSize = pageSize
        self.realSize = realSize
        self.rows = rows
        self.total = total
        self.totalPage = totalPage
    }
    
    /// 合并两个分页响应
    public func merge(with other: SDPageResponse<T>) -> SDPageResponse<T> {
        var result = self
        
        // 合并数据行
        if let otherRows = other.rows, !otherRows.isEmpty {
            if result.rows == nil {
                result.rows = otherRows
            } else {
                result.rows?.append(contentsOf: otherRows)
            }
        }
        
        // 更新页码和总数信息
        result.currentPage = other.currentPage
        result.total = other.total
        result.totalPage = other.totalPage
        result.realSize = result.rows?.count
        
        return result
    }
    
    /// 重置为初始状态
    public mutating func reset() {
        currentPage = 1
        offset = 1
        rows = []
        realSize = 0
    }
    
    /// 获取指定索引的数据，如果索引无效则返回nil
    public func item(at index: Int) -> T? {
        guard let rows = rows, index >= 0, index < rows.count else {
            return nil
        }
        return rows[index]
    }
}
