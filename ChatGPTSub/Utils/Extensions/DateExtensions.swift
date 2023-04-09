//
//  DateExtensions.swift
//  ChatGPTSub
//
//  Created by 안수빈 on 2023/04/09.
//

import Foundation

extension Date {
//     let myDateFormatter = DateFormatter()
//    myDateFormatter.dateFormat = "yyyy년 MM월 dd일 a hh시 mm분" // 2020년 08월 13일 오후 04시 30분
//    myDateFormatter.locale = Locale(identifier:"ko_KR") // PM, AM을 언어에 맞게 setting (ex: PM -> 오후)
//    let convertStr = myDateFormatter.string(from: convertDate!)
    
    var timeStr: String {
        let formatter = DateFormatter()
        formatter.dateFormat = "a hh:mm"
        formatter.locale = Locale(identifier: "ko_KR")
        return formatter.string(from: self)
    }
}
