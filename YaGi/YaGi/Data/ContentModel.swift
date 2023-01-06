//
//  ContentModel.swift
//  YaGi
//
//  Created by 임윤휘 on 2022/10/06.
//

import Foundation

struct ContentModel {
    let contentTitle: String
    let ContentDate: String
    let contentText: String
}

extension ContentModel {
    static let contents:[ContentModel] = [
        content1,
        content2,
        content3,
        content4,
        content5,
        content6,
        content7,
        content8
    ]
    
    static let content1 = ContentModel(contentTitle: "1. 주문하신 용은 매진입니다", ContentDate: "2022.10.06 목", contentText: "")
    static let content2 = ContentModel(contentTitle: "2. 한밤의 마법약 제조", ContentDate: "2022.10.07 금", contentText: "")
    static let content3 = ContentModel(contentTitle: "3. 현재를 보여 드립니다. ", ContentDate: "2022.10.08 토", contentText: "")
    static let content4 = ContentModel(contentTitle: "4. 마법약 요청 대소동", ContentDate: "2022.10.09 일", contentText: "")
    static let content5 = ContentModel(contentTitle: "5. 그냥 사양합니다. ", ContentDate: "2022.10.10 월", contentText: "")
    static let content6 = ContentModel(contentTitle: "6. 이 달의 베스트 마법 주문", ContentDate: "2022.10.11 화", contentText: "")
    static let content7 = ContentModel(contentTitle: "7. 예약하신 용이 도착하였습니다", ContentDate: "2022.10.12 수", contentText: "")
    static let content8 = ContentModel(contentTitle: "8. 대신 꿈 꾸어 드립니다. 비용은 수면 시간으로 받습니다.", ContentDate: "2022.10.13 목", contentText: "")
}
