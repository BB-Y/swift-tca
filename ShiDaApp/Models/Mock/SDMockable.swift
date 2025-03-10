//
//  SDMockable.swift
//  ShiDaApp
//
//  Created by 黄祯鑫 on 2025/3/6.
//

import Foundation
protocol SDMockable {
    static var json: String{get}
}
extension SDMockable where Self: Codable{
    static var mock: Self {
        try! JSONDecoder().decode(Self.self, from: json.data(using: .utf8)!)
    }
}
extension SDResponseLogin: SDMockable{
    static var json: String {
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
    static var json: String {
        """
{
      "id": 24,
      "name": "十四五规划精品教材",
            "memo": "“十四五”普通高等教育本科国家级规划教材建设实施方案 为深入贯彻党的二十大精神,加快推进自主知识体系、学科专业体系、教材教学体系建设,全面加强教材建设",
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
          }
      ]
    }
"""
    }
}
/*
 /*
 
  */
 */
