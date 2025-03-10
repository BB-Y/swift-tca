import Foundation
import ComposableArchitecture
import Moya

/// 扩展依赖值以包含首页客户端
extension DependencyValues {
    var homeClient: SDHomeClient {
        get { self[SDHomeClient.self] }
        set { self[SDHomeClient.self] = newValue }
    }
}

/// 首页相关的客户端接口
struct SDHomeClient {
    /// 获取首页栏目列表
    var getSectionList: @Sendable () async throws -> [SDResponseHomeSection]
}

extension SDHomeClient: DependencyKey {
    /// 提供实际的首页客户端实现
    static var liveValue: Self {
        let apiService = APIService()
        
        return Self(
            getSectionList: {
                try await apiService.requestResult(SDHomeEndpoint.sectionList)
            }
        )
    }
    
    /// 提供测试用的模拟实现
    static var testValue: Self {
        Self(
            getSectionList: {
                return [
                    // headerBanner - style 1
                    SDResponseHomeSection(
                        dataList: [
                            SDResponseHomeListItem(
                                appSectionId: 1,
                                dataCover: "http://gxsds.oss-cn-beijing.aliyuncs.com/dfile/png/202406/1719287022000.png",
                                dataId: 1,
                                dataName: "春季新书推荐",
                                dataSummary: "2024春季新书推荐",
                                dataType: .carousel,
                                seq: 1
                            ),
                            SDResponseHomeListItem(
                                appSectionId: 1,
                                dataCover: "http://obs.huaweicloud.gxsds.qanzone.com/dfile/png/202502/1739243278476.png",
                                dataId: 2,
                                dataName: "经典教材展示",
                                dataSummary: "精选经典教材展示",
                                dataType: .carousel,
                                seq: 2
                            ),
                            SDResponseHomeListItem(
                                appSectionId: 1,
                                dataCover: "http://gxsds.oss-cn-beijing.aliyuncs.com/dfile/jpg/202407/1722403509664.jpg",
                                dataId: 3,
                                dataName: "热门推荐",
                                dataSummary: "本月热门推荐",
                                dataType: .carousel,
                                seq: 3
                            ),
                            SDResponseHomeListItem(
                                appSectionId: 1,
                                dataCover: "http://gxsds.oss-cn-beijing.aliyuncs.com/dfile/png/202407/1722403658896.png",
                                dataId: 4,
                                dataName: "新书速递",
                                dataSummary: "新书速递",
                                dataType: .carousel,
                                seq: 4
                            ),
                            SDResponseHomeListItem(
                                appSectionId: 1,
                                dataCover: "http://gxsds.oss-cn-beijing.aliyuncs.com/dfile/png/202407/1722402815827.png",
                                dataId: 5,
                                dataName: "精品推荐",
                                dataSummary: "精品推荐",
                                dataType: .carousel,
                                seq: 5
                            ),
                            SDResponseHomeListItem(
                                appSectionId: 1,
                                dataCover: "http://gxsds.oss-cn-beijing.aliyuncs.com/dfile/png/202407/1722402678318.png",
                                dataId: 6,
                                dataName: "特色书籍",
                                dataSummary: "特色书籍展示",
                                dataType: .carousel,
                                seq: 6
                            )
                        ],
                        id: 1,
                        memo: "头部轮播图展示",
                        name: "头部Banner",
                        seq: 1,
                        style: .headerBanner
                    ),
                    
                    // middleBanner - style 2
                    SDResponseHomeSection(
                        dataList: Array(1...6).map { index in
                            SDResponseHomeListItem(
                                appSectionId: 2,
                                dataCover: "http://gxsds.oss-cn-beijing.aliyuncs.com/dfile/png/202407/1722402815827.png",
                                dataId: 10 + index,
                                dataName: "腰部Banner\(index)",
                                dataSummary: "腰部Banner测试数据\(index)",
                                dataType: .carousel,
                                seq: index
                            )
                        },
                        id: 2,
                        memo: "腰部banner展示",
                        name: "腰部Banner",
                        seq: 2,
                        style: .middleBanner
                    ),
                    
                    // recommendTypeE - style 3
                    SDResponseHomeSection(
                        dataList: Array(1...8).map { index in
                            SDResponseHomeListItem(
                                appSectionId: 3,
                                dataCover: "http://gxsds.oss-cn-beijing.aliyuncs.com/dfile/jpg/202407/1722403509664.jpg",
                                dataId: 20 + index,
                                dataName: "推荐位E型\(index)",
                                dataSummary: "推荐位E型测试数据\(index)",
                                dataType: .textbook,
                                seq: index
                            )
                        },
                        id: 3,
                        memo: "推荐位E型展示",
                        name: "推荐位E型",
                        seq: 3,
                        style: .recommendTypeE
                    ),
                    
                    // recommendTypeB - style 4
                    SDResponseHomeSection(
                        dataList: Array(1...7).map { index in
                            SDResponseHomeListItem(
                                appSectionId: 4,
                                dataCover: "http://gxsds.oss-cn-beijing.aliyuncs.com/dfile/png/202407/1722403658896.png",
                                dataId: 30 + index,
                                dataName: "推荐位B型\(index)",
                                dataSummary: "推荐位B型测试数据\(index)",
                                dataType: .textbook,
                                seq: index
                            )
                        },
                        id: 4,
                        memo: "推荐位B型展示",
                        name: "推荐位B型",
                        seq: 4,
                        style: .recommendTypeB
                    ),
                    
                    // recommendTypeA - style 5
                    SDResponseHomeSection(
                        dataList: Array(1...9).map { index in
                            SDResponseHomeListItem(
                                appSectionId: 5,
                                dataCover: "http://gxsds.oss-cn-beijing.aliyuncs.com/dfile/png/202407/1722402815827.png",
                                dataId: 40 + index,
                                dataName: "推荐位A型\(index)",
                                dataSummary: "推荐位A型测试数据\(index)",
                                dataType: .textbook,
                                seq: index
                            )
                        },
                        id: 5,
                        memo: "推荐位A型展示",
                        name: "推荐位A型",
                        seq: 5,
                        style: .recommendTypeA
                    ),
                    
                    // recommendTypeC - style 6
                    SDResponseHomeSection(
                        dataList: Array(1...8).map { index in
                            SDResponseHomeListItem(
                                appSectionId: 6,
                                dataCover: "http://gxsds.oss-cn-beijing.aliyuncs.com/dfile/png/202406/1719287022000.png",
                                dataId: 50 + index,
                                dataName: "推荐位C型\(index)",
                                dataSummary: "推荐位C型测试数据\(index)",
                                dataType: .textbook,
                                seq: index
                            )
                        },
                        id: 6,
                        memo: "推荐位C型展示",
                        name: "推荐位C型",
                        seq: 6,
                        style: .recommendTypeC
                    ),
                    
                    // recommendTypeD - style 7
                    SDResponseHomeSection(
                        dataList: Array(1...10).map { index in
                            SDResponseHomeListItem(
                                appSectionId: 7,
                                dataCover: "http://obs.huaweicloud.gxsds.qanzone.com/dfile/png/202502/1739243278476.png",
                                dataId: 60 + index,
                                dataName: "推荐位D型\(index)",
                                dataSummary: "推荐位D型测试数据\(index)",
                                dataType: .textbook,
                                seq: index
                            )
                        },
                        id: 7,
                        memo: "推荐位D型展示",
                        name: "推荐位D型",
                        seq: 7,
                        style: .recommendTypeD
                    ),
                    
                    // recommendTypeG - style 8
                    SDResponseHomeSection(
                        dataList: Array(1...6).map { index in
                            SDResponseHomeListItem(
                                appSectionId: 8,
                                dataCover: "http://gxsds.oss-cn-beijing.aliyuncs.com/dfile/jpg/202407/1722403509664.jpg",
                                dataId: 70 + index,
                                dataName: "推荐位G型\(index)",
                                dataSummary: "推荐位G型测试数据\(index)",
                                dataType: .textbook,
                                seq: index
                            )
                        },
                        id: 8,
                        memo: "推荐位G型展示",
                        name: "推荐位G型",
                        seq: 8,
                        style: .recommendTypeG
                    ),
                    
                    // bookSectionSliding - style 9
                    SDResponseHomeSection(
                        dataList: Array(1...8).map { index in
                            SDResponseHomeListItem(
                                appSectionId: 9,
                                dataCover: "http://gxsds.oss-cn-beijing.aliyuncs.com/dfile/png/202407/1722403658896.png",
                                dataId: 80 + index,
                                dataName: "图书滑动\(index)",
                                dataSummary: "图书滑动测试数据\(index)",
                                dataType: .textbook,
                                seq: index
                            )
                        },
                        id: 9,
                        memo: "图书滑动展示",
                        name: "图书滑动板块",
                        seq: 9,
                        style: .bookSectionSliding
                    ),
                    
                    // bookSectionFixed - style 10
                    SDResponseHomeSection(
                        dataList: Array(1...7).map { index in
                            SDResponseHomeListItem(
                                appSectionId: 10,
                                dataCover: "http://gxsds.oss-cn-beijing.aliyuncs.com/dfile/png/202407/1722402815827.png",
                                dataId: 90 + index,
                                dataName: "图书固定\(index)",
                                dataSummary: "图书固定测试数据\(index)",
                                dataType: .cooperativeSchool,
                                seq: index
                            )
                        },
                        id: 10,
                        memo: "图书固定展示",
                        name: "图书固定板块",
                        seq: 9,
                        style: .bookSectionSliding
                    )
                ]
            }
        )
    }
    
    static var previewValue: SDHomeClient {
        testValue
    }
}
