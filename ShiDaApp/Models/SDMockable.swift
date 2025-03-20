//
//  SDMockable.swift
//  ShiDaApp
//
//  Created by 黄祯鑫 on 2025/3/6.
//

import Foundation

protocol SDMockable {
    static var jsonModel: String{get}
    static var jsonArray: String {get}
}
extension SDMockable {
    static var jsonModel: String { "" }
    static var jsonArray: String { "" }
}
extension SDMockable where Self: Codable{
    static var mock: Self {
        do {
            let string = Self.jsonModel
            return try JSONDecoder().decode(Self.self, from: string.data(using: .utf8)!)
        } catch {
            print("JSON 解码错误: \(error)")
            fatalError("JSON 解码失败")
        }
    }
//    static var mock: Self {
//        try! JSONDecoder().decode(Self.self, from: jsonModel.data(using: .utf8)!)
//    }
    
    static var mockArray: [Self] {
        try! JSONDecoder().decode([Self].self, from: jsonArray.data(using: .utf8)!)
    }
}
extension SDResponseLogin: SDMockable{
    static var jsonModel: String {  // 从 json 改为 jsonModel
        """
{
    "address": "浙江省杭州市西湖区浙江大学紫金港校区",
    "authStatus": 10,
    "city": 330100,
    "createDatetime": "2025-03-06T01:26:30.289Z",
    "deparment": "计算机科学与技术学院",
    "field": "计算机科学",
    "id": 10086,
    "inputMajor": "计算机科学与技术",
    "jobId": "ZJU10086",
    "jobTitle": "教授",
    "lastLoginDatetime": "2025-03-06T01:26:30.289Z",
    "level": "高级",
    "mail": "professor@zju.edu.cn",
    "major": "计算机科学与技术",
    "majorId": 0825,
    "name": "张教授",
    "phone": "13800138000",
    "photo": "https://example.com/photos/avatar.jpg",
    "position": "教师",
    "postalCode": "310058",
    "province": 330000,
    "schoolId": 10001,
    "status": 1,
    "token": "eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9...",
    "userType": 10
}
"""
    }
}

extension SDResponseHomeSection: SDMockable {
    static var jsonModel: String {  // 从 json 改为 jsonModel
        """
{
      "id": 24,
      "name": "十四五规划精品教材",
      "memo": ""fifteen"普通高等教育本科国家级规划教材建设实施方案 为深入贯彻zza精神,加快自主知识体系、学科专业体系、教材教学体系建设,全面加强教材建设",
      "seq": 2,
      "style": 5,
      "dataList": [
          {
            "appSectionId": 24,
            "dataType": 10,
            "dataId": 110,
            "dataCover": "http://gxsds.oss-cn-beijing.aliyuncs.com/dfile/png/202407/1722403658896.png",
            "dataName": "实用英语语音教程",
            "dataSummary": "本教材包括三个单元：英语语音知识概述、辅音音素和元音音素、实战操练。第一单元包含26个字母正确的读音和书写、音素和音标的基本概述、音节的定义和划分、单词的重读、非重语流和发音器官图。第二单元按英语48个音素发音方法分成五课，每课都包含音标学习、音标练习、巩固拓展三个环节，循序渐进，环环相扣。第三单元包含五套综合实践操练任务，每套包含音标朗读、单词朗读、句子朗读、对话或短文朗读、歌曲演唱等，综合考查学习者对音标的识读能力、单词拼读技巧、重读和非重读的识别能力、句子朗读的技巧、语感、英文歌曲演唱等。",
            "seq": 11
          },
          {
            "appSectionId": 24,
            "dataType": 10,
            "dataId": 109,
            "dataCover": "http://gxsds.oss-cn-beijing.aliyuncs.com/dfile/jpg/202407/1722403509664.jpg",
            "dataName": "高职院校思想政治理论课实践教程",
            "dataSummary": "本书稿为高职院校思想政治理论课实践教学的指导教材，内容主要包括高职院校思想政治理论课实践教学实施方案、高职院校思想政治理论课各门课程实践教学的设计与实施、高职院校思想政治理论课实践教学典型案例选编三大部分。本书稿以高校思想政治理论课全国统编教材确定的理论教学内容为依据设计实践教学方案，旨在构建理论教学与实践教学相互联系、相互支撑、相互促进的思想政治理论课立体化教学体系，使实践教学与理论教学共同服务于高校思想政治理论课教学目标和宗旨。",
            "seq": 11
          },
          {
            "appSectionId": 24,
            "dataType": 10,
            "dataId": 108,
            "dataCover": "http://gxsds.oss-cn-beijing.aliyuncs.com/dfile/jpg/202407/1722403340159.jpg",
            "dataName": "体育健康与职业促进教程（第四版）",
            "dataSummary": "本教材结合广西高职院校学生的学习能力和体育能力，以促进学生终身体育能力、提高其健康水平及职业能力为目的编写。教材分为理论和实践两个部分。理论篇包括体育卫生知识、自我健康和体质评价的方法、职业能力构建中所要求的人的身体素质的锻炼方法。实践篇将体育人文、体育实用知识融入其中，方便学生阅读并增强知识拓展性。教材中大部分技术图解使用真人照片，真实还原运动环节和动作细节，使教材内容一目了然，便于学生学习。",
            "seq": 11
          },
          {
            "appSectionId": 24,
            "dataType": 10,
            "dataId": 110,
            "dataCover": "http://gxsds.oss-cn-beijing.aliyuncs.com/dfile/png/202407/1722403658896.png",
            "dataName": "实用英语语音教程",
            "dataSummary": "本教材包括三个单元：英语语音知识概述、辅音音素和元音音素、实战操练。第一单元包含26个字母正确的读音和书写、音素和音标的基本概述、音节的定义和划分、单词的重读、非重语流和发音器官图。第二单元按英语48个音素发音方法分成五课，每课都包含音标学习、音标练习、巩固拓展三个环节，循序渐进，环环相扣。第三单元包含五套综合实践操练任务，每套包含音标朗读、单词朗读、句子朗读、对话或短文朗读、歌曲演唱等，综合考查学习者对音标的识读能力、单词拼读技巧、重读和非重读的识别能力、句子朗读的技巧、语感、英文歌曲演唱等。",
            "seq": 11
          },
          {
            "appSectionId": 24,
            "dataType": 10,
            "dataId": 109,
            "dataCover": "http://gxsds.oss-cn-beijing.aliyuncs.com/dfile/jpg/202407/1722403509664.jpg",
            "dataName": "高职院校思想政治理论课实践教程",
            "dataSummary": "本书稿为高职院校思想政治理论课实践教学的指导教材，内容主要包括高职院校思想政治理论课实践教学实施方案、高职院校思想政治理论课各门课程实践教学的设计与实施、高职院校思想政治理论课实践教学典型案例选编三大部分。本书稿以高校思想政治理论课全国统编教材确定的理论教学内容为依据设计实践教学方案，旨在构建理论教学与实践教学相互联系、相互支撑、相互促进的思想政治理论课立体化教学体系，使实践教学与理论教学共同服务于高校思想政治理论课教学目标和宗旨。",
            "seq": 11
          },
          {
            "appSectionId": 24,
            "dataType": 10,
            "dataId": 108,
            "dataCover": "http://gxsds.oss-cn-beijing.aliyuncs.com/dfile/jpg/202407/1722403340159.jpg",
            "dataName": "体育健康与职业促进教程（第四版）",
            "dataSummary": "本教材结合广西高职院校学生的学习能力和体育能力，以促进学生终身体育能力、提高其健康水平及职业能力为目的编写。教材分为理论和实践两个部分。理论篇包括体育卫生知识、自我健康和体质评价的方法、职业能力构建中所要求的人的身体素质的锻炼方法。实践篇将体育人文、体育实用知识融入其中，方便学生阅读并增强知识拓展性。教材中大部分技术图解使用真人照片，真实还原运动环节和动作细节，使教材内容一目了然，便于学生学习。",
            "seq": 11
          },
          {
            "appSectionId": 24,
            "dataType": 10,
            "dataId": 110,
            "dataCover": "http://gxsds.oss-cn-beijing.aliyuncs.com/dfile/png/202407/1722403658896.png",
            "dataName": "实用英语语音教程",
            "dataSummary": "本教材包括三个单元：英语语音知识概述、辅音音素和元音音素、实战操练。第一单元包含26个字母正确的读音和书写、音素和音标的基本概述、音节的定义和划分、单词的重读、非重语流和发音器官图。第二单元按英语48个音素发音方法分成五课，每课都包含音标学习、音标练习、巩固拓展三个环节，循序渐进，环环相扣。第三单元包含五套综合实践操练任务，每套包含音标朗读、单词朗读、句子朗读、对话或短文朗读、歌曲演唱等，综合考查学习者对音标的识读能力、单词拼读技巧、重读和非重读的识别能力、句子朗读的技巧、语感、英文歌曲演唱等。",
            "seq": 11
          },
          {
            "appSectionId": 24,
            "dataType": 10,
            "dataId": 109,
            "dataCover": "http://gxsds.oss-cn-beijing.aliyuncs.com/dfile/jpg/202407/1722403509664.jpg",
            "dataName": "高职院校思想政治理论课实践教程",
            "dataSummary": "本书稿为高职院校思想政治理论课实践教学的指导教材，内容主要包括高职院校思想政治理论课实践教学实施方案、高职院校思想政治理论课各门课程实践教学的设计与实施、高职院校思想政治理论课实践教学典型案例选编三大部分。本书稿以高校思想政治理论课全国统编教材确定的理论教学内容为依据设计实践教学方案，旨在构建理论教学与实践教学相互联系、相互支撑、相互促进的思想政治理论课立体化教学体系，使实践教学与理论教学共同服务于高校思想政治理论课教学目标和宗旨。",
            "seq": 11
          },
          {
            "appSectionId": 24,
            "dataType": 10,
            "dataId": 108,
            "dataCover": "http://gxsds.oss-cn-beijing.aliyuncs.com/dfile/jpg/202407/1722403340159.jpg",
            "dataName": "体育健康与职业促进教程（第四版）",
            "dataSummary": "本教材结合广西高职院校学生的学习能力和体育能力，以促进学生终身体育能力、提高其健康水平及职业能力为目的编写。教材分为理论和实践两个部分。理论篇包括体育卫生知识、自我健康和体质评价的方法、职业能力构建中所要求的人的身体素质的锻炼方法。实践篇将体育人文、体育实用知识融入其中，方便学生阅读并增强知识拓展性。教材中大部分技术图解使用真人照片，真实还原运动环节和动作细节，使教材内容一目了然，便于学生学习。",
            "seq": 11
          },
          {
            "appSectionId": 24,
            "dataType": 10,
            "dataId": 110,
            "dataCover": "http://gxsds.oss-cn-beijing.aliyuncs.com/dfile/png/202407/1722403658896.png",
            "dataName": "实用英语语音教程",
            "dataSummary": "本教材包括三个单元：英语语音知识概述、辅音音素和元音音素、实战操练。第一单元包含26个字母正确的读音和书写、音素和音标的基本概述、音节的定义和划分、单词的重读、非重语流和发音器官图。第二单元按英语48个音素发音方法分成五课，每课都包含音标学习、音标练习、巩固拓展三个环节，循序渐进，环环相扣。第三单元包含五套综合实践操练任务，每套包含音标朗读、单词朗读、句子朗读、对话或短文朗读、歌曲演唱等，综合考查学习者对音标的识读能力、单词拼读技巧、重读和非重读的识别能力、句子朗读的技巧、语感、英文歌曲演唱等。",
            "seq": 11
          },
          {
            "appSectionId": 24,
            "dataType": 10,
            "dataId": 109,
            "dataCover": "http://gxsds.oss-cn-beijing.aliyuncs.com/dfile/jpg/202407/1722403509664.jpg",
            "dataName": "高职院校思想政治理论课实践教程",
            "dataSummary": "本书稿为高职院校思想政治理论课实践教学的指导教材，内容主要包括高职院校思想政治理论课实践教学实施方案、高职院校思想政治理论课各门课程实践教学的设计与实施、高职院校思想政治理论课实践教学典型案例选编三大部分。本书稿以高校思想政治理论课全国统编教材确定的理论教学内容为依据设计实践教学方案，旨在构建理论教学与实践教学相互联系、相互支撑、相互促进的思想政治理论课立体化教学体系，使实践教学与理论教学共同服务于高校思想政治理论课教学目标和宗旨。",
            "seq": 11
          },
          {
            "appSectionId": 24,
            "dataType": 10,
            "dataId": 108,
            "dataCover": "http://gxsds.oss-cn-beijing.aliyuncs.com/dfile/jpg/202407/1722403340159.jpg",
            "dataName": "体育健康与职业促进教程（第四版）",
            "dataSummary": "本教材结合广西高职院校学生的学习能力和体育能力，以促进学生终身体育能力、提高其健康水平及职业能力为目的编写。教材分为理论和实践两个部分。理论篇包括体育卫生知识、自我健康和体质评价的方法、职业能力构建中所要求的人的身体素质的锻炼方法。实践篇将体育人文、体育实用知识融入其中，方便学生阅读并增强知识拓展性。教材中大部分技术图解使用真人照片，真实还原运动环节和动作细节，使教材内容一目了然，便于学生学习。",
            "seq": 11
          }
      ]
    }
"""
    }
    
    static var jsonArray: String {  // 从 jsonArray? 改为 jsonArray
        """
[
    {
        "dataList": [
            {
                "appSectionId": 1,
                "dataCover": "http://gxsds.oss-cn-beijing.aliyuncs.com/dfile/png/202406/1719287022000.png",
                "dataId": 1,
                "dataName": "春季新书推荐",
                "dataSummary": "2024春季新书推荐",
                "dataType": 20,
                "seq": 1
            },
            {
                "appSectionId": 1,
                "dataCover": "http://obs.huaweicloud.gxsds.qanzone.com/dfile/png/202502/1739243278476.png",
                "dataId": 2,
                "dataName": "经典教材展示",
                "dataSummary": "精选经典教材展示",
                "dataType": 20,
                "seq": 2
            },
            {
                "appSectionId": 1,
                "dataCover": "http://gxsds.oss-cn-beijing.aliyuncs.com/dfile/jpg/202407/1722403509664.jpg",
                "dataId": 3,
                "dataName": "热门推荐",
                "dataSummary": "本月热门推荐",
                "dataType": 20,
                "seq": 3
            },
            {
                "appSectionId": 1,
                "dataCover": "http://gxsds.oss-cn-beijing.aliyuncs.com/dfile/png/202407/1722403658896.png",
                "dataId": 4,
                "dataName": "新书速递",
                "dataSummary": "新书速递",
                "dataType": 20,
                "seq": 4
            },
            {
                "appSectionId": 1,
                "dataCover": "http://gxsds.oss-cn-beijing.aliyuncs.com/dfile/png/202407/1722402815827.png",
                "dataId": 5,
                "dataName": "精品推荐",
                "dataSummary": "精品推荐",
                "dataType": 20,
                "seq": 5
            },
            {
                "appSectionId": 1,
                "dataCover": "http://gxsds.oss-cn-beijing.aliyuncs.com/dfile/png/202407/1722402678318.png",
                "dataId": 6,
                "dataName": "特色书籍",
                "dataSummary": "特色书籍展示",
                "dataType": 20,
                "seq": 6
            }
        ],
        "id": 1,
        "memo": "头部轮播图展示",
        "name": "头部Banner",
        "seq": 1,
        "style": 1
    },
    {
        "id": 2,
        "memo": "腰部banner展示",
        "name": "腰部Banner",
        "seq": 2,
        "style": 2,
        "dataList": [
            {
                "appSectionId": 2,
                "dataCover": "http://gxsds.oss-cn-beijing.aliyuncs.com/dfile/png/202407/1722402815827.png",
                "dataId": 11,
                "dataName": "腰部Banner1",
                "dataSummary": "腰部Banner测试数据1",
                "dataType": 20,
                "seq": 1
            },
            {
                "appSectionId": 2,
                "dataCover": "http://gxsds.oss-cn-beijing.aliyuncs.com/dfile/png/202407/1722402815827.png",
                "dataId": 12,
                "dataName": "腰部Banner2",
                "dataSummary": "腰部Banner测试数据2",
                "dataType": 20,
                "seq": 2
            }
        ]
    },
    {
        "id": 3,
        "memo": "推荐位E型展示",
        "name": "推荐位E型",
        "seq": 3,
        "style": 3,
        "dataList": [
            {
                "appSectionId": 3,
                "dataCover": "http://gxsds.oss-cn-beijing.aliyuncs.com/dfile/jpg/202407/1722403509664.jpg",
                "dataId": 21,
                "dataName": "推荐位E型1",
                "dataSummary": "推荐位E型测试数据1",
                "dataType": 10,
                "seq": 1
            },
            {
                "appSectionId": 3,
                "dataCover": "http://gxsds.oss-cn-beijing.aliyuncs.com/dfile/jpg/202407/1722403509664.jpg",
                "dataId": 22,
                "dataName": "推荐位E型2",
                "dataSummary": "推荐位E型测试数据2",
                "dataType": 10,
                "seq": 2
            }
        ]
    }
]
"""
    }
}

// 添加SDResponseHomeSectionSchool的mock数据
extension SDResponseHomeSectionSchool: SDMockable {
    static var jsonArray: String {
        """
[
    {
        "dbookCount": 15,
        "iconUrl": "http://gxsds.oss-cn-beijing.aliyuncs.com/dfile/png/202406/school_logo_1.png",
        "id": 1,
        "name": "北京大学",
        "type": "本科"
    },
    {
        "dbookCount": 12,
        "iconUrl": "http://gxsds.oss-cn-beijing.aliyuncs.com/dfile/png/202406/school_logo_2.png",
        "id": 2,
        "name": "清华大学",
        "type": "本科"
    },
    {
        "dbookCount": 8,
        "iconUrl": "http://gxsds.oss-cn-beijing.aliyuncs.com/dfile/png/202406/school_logo_3.png",
        "id": 3,
        "name": "复旦大学",
        "type": "本科"
    },
    {
        "dbookCount": 10,
        "iconUrl": "http://gxsds.oss-cn-beijing.aliyuncs.com/dfile/png/202406/school_logo_4.png",
        "id": 4,
        "name": "上海交通大学",
        "type": "本科"
    },
    {
        "dbookCount": 6,
        "iconUrl": "http://gxsds.oss-cn-beijing.aliyuncs.com/dfile/png/202406/school_logo_5.png",
        "id": 5,
        "name": "北京职业技术学院",
        "type": "高职"
    },
    {
        "dbookCount": 4,
        "iconUrl": "http://gxsds.oss-cn-beijing.aliyuncs.com/dfile/png/202406/school_logo_6.png",
        "id": 6,
        "name": "上海中等专业学校",
        "type": "中职"
    }
]
"""
    }
}

// 添加SDResponseBookInfo的mock数据
extension SDResponseBookInfo: SDMockable {
    static var jsonArray: String {
        """
[
    {
        "authorList": [
            {
                "dbookId": 1,
                "id": 1,
                "memo": "主编",
                "name": "张三",
                "typeName": "主编"
            },
            {
                "dbookId": 1,
                "id": 2,
                "memo": "副主编",
                "name": "李四",
                "typeName": "副主编"
            }
        ],
        "cover": "http://gxsds.oss-cn-beijing.aliyuncs.com/dfile/png/202406/1719287022000.png",
        "id": 1,
        "introduction": "这是一本关于Swift编程的教材，详细介绍了Swift语言的基础知识和高级特性。",
        "name": "Swift编程实战",
        "sellPrice": 59.9
    },
    {
        "authorList": [
            {
                "dbookId": 2,
                "id": 3,
                "memo": "主编",
                "name": "王五",
                "typeName": "主编"
            }
        ],
        "cover": "http://gxsds.oss-cn-beijing.aliyuncs.com/dfile/jpg/202407/1722403509664.jpg",
        "id": 2,
        "introduction": "这是一本关于iOS开发的教材，涵盖了从基础到高级的iOS开发知识。",
        "name": "iOS开发指南",
        "sellPrice": 69.9
    },
    {
        "authorList": [
            {
                "dbookId": 3,
                "id": 4,
                "memo": "主编",
                "name": "赵六",
                "typeName": "主编"
            },
            {
                "dbookId": 3,
                "id": 5,
                "memo": "编委",
                "name": "钱七",
                "typeName": "编委"
            }
        ],
        "cover": "http://gxsds.oss-cn-beijing.aliyuncs.com/dfile/png/202407/1722402815827.png",
        "id": 3,
        "introduction": "这是一本关于SwiftUI的教材，详细讲解了SwiftUI的各种组件和布局方式。",
        "name": "SwiftUI实战指南",
        "sellPrice": 79.9
    },
    {
        "authorList": [
            {
                "dbookId": 4,
                "id": 6,
                "memo": "主编",
                "name": "孙八",
                "typeName": "主编"
            }
        ],
        "cover": "http://obs.huaweicloud.gxsds.qanzone.com/dfile/png/202502/1739243278476.png",
        "id": 4,
        "introduction": "这是一本关于Combine框架的教材，详细介绍了响应式编程的概念和实践。",
        "name": "Combine响应式编程",
        "sellPrice": 89.9
    },
    {
        "authorList": [
            {
                "dbookId": 5,
                "id": 7,
                "memo": "主编",
                "name": "周九",
                "typeName": "主编"
            },
            {
                "dbookId": 5,
                "id": 8,
                "memo": "副主编",
                "name": "吴十",
                "typeName": "副主编"
            }
        ],
        "cover": "http://gxsds.oss-cn-beijing.aliyuncs.com/dfile/png/202407/1722403658896.png",
        "id": 5,
        "introduction": "这是一本关于Core Data的教材，详细讲解了数据持久化的各种方法和技巧。",
        "name": "Core Data数据持久化",
        "sellPrice": 65.9
    }
]
"""
    }
}
/*
 /*
 
  */
 */
extension SDPageResponse<SDResponseCorrectionInfo>
 {
    static var mock: Self {
        return try! JSONDecoder().decode(Self.self, from: jsonModel.data(using: .utf8)!)
    }
    static var jsonModel: String {
        """
{
    "currentPage": 1,
    "offset": 1,
    "pageSize": 10,
    "realSize": 10,
    "total": 3,
    "totalPage": 1,
    "rows": [
        {
            "articleId": 101,
            "articleNumber": 1,
            "chapterId": 201,
            "chapterName": "第一章 基础概念",
            "content": "页面中的闭包应该是闭包Closure，建议添加英文术语",
            "dbookId": 301,
            "dbookName": "Swift编程实战",
            "id": 1001,
            "position": "P15",
            "replyContent": "感谢反馈，已修改",
            "replyStatus": 20,
            "text": "闭包是引用类型",
            "createDatetime": "2015-12-13",
            "type": 20
        },
        {
            "articleId": 102,
            "articleNumber": 2,
            "chapterId": 202,
            "chapterName": "第二章 高级特性",
            "content": "这里的属性观察器的示例代码有误",
            "dbookId": 301,
            "dbookName": "Swift编程实战",
            "id": 1002,
            "position": "P45",
            "replyContent": null,
            "replyStatus": 10,
            "text": "willSet print(newValue)",
            "createDatetime": "2015-12-13",

            "type": 20
        },
        {
            "articleId": 103,
            "articleNumber": 3,
            "chapterId": 203,
            "chapterName": "第三章 函数式编程",
            "content": "map的示意图显示不清晰",
            "dbookId": 301,
            "dbookName": "Swift编程实战",
            "id": 1003,
            "position": "P78",
            "replyContent": "已更新为高清图片",
            "replyStatus": 20,
            "text": "图3-5 map函数示意图",
            "createDatetime": "2015-12-13",

            "type": 30
        }
    ]
}
"""
    }
    
    static var jsonArray: String {
        """
[
    {
        "currentPage": 1,
        "offset": 1,
        "pageSize": 10,
        "realSize": 3,
        "total": 3,
        "totalPage": 1,
        "rows": [
            {
                "articleId": 101,
                "articleNumber": 1,
                "chapterId": 201,
                "chapterName": "第一章 基础概念",
                "content": "页面中的闭包应该是闭包Closure，建议添加英文术语",
                "dbookId": 301,
                "dbookName": "Swift编程实战",
                "id": 1001,
                "position": "P15",
                "replyContent": "感谢反馈，已修改",
                "replyStatus": 20,
                "text": "闭包是引用类型",
                "type": 20
            }
        ]
    }
]
"""
    }
}

/*
 /*
 
  */
 */

