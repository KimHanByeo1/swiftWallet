//
//  DateViewModel.swift
//  Wallet
//
//  Created by Jeong Yun Hyeon on 2023/03/20.
//

import Foundation

class DateViewModel {
    func DateCount(_ date: String) -> String {
        let formatter = DateFormatter()
        let currentDate = Date()
        formatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
        let date1 = formatter.date(from: formatter.string(from: currentDate))! // 입력 문자열을 Date 객체로 변환
        let date2 = formatter.date(from: date)! // 입력 문자열을 Date 객체로 변환
        let calendar = Calendar.current // 현재 달력 객체 생성
        let components = calendar.dateComponents([.year, .month, .day, .hour, .minute, .second], from: date2, to: date1) // 두 날짜 사이의 차이 계산
        let second = components.second ?? 0
        let minute = components.minute ?? 0 // 분 차이
        let hour = components.hour ?? 0
        let day = components.day ?? 0
        let month = components.month ?? 0
        let year = components.year ?? 0
        
        if year > 0 {
            return String(year) + "년전"
        } else if month > 0 {
            return String(month) + "달전"
        } else if day > 0 {
            return String(day) + "일전"
        } else if hour > 0 {
            return String(hour) + "시간전"
        } else if minute > 0 {
            return String(minute) + "분전"
        } else {
            return String(second) + "초전"
        }
    }
}
