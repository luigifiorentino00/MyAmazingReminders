//
//  LocalNotification.swift
//  MyAmazingReminderVersion
//
//  Created by Luigi Fiorentino on 15/11/23.
//

import Foundation
import SwiftUI

struct LocalNotification : Identifiable {
 
    var id: UUID = UUID()
    var Identifier: String
    var Title: String
    var Body: String
   // var DateComponents: DateComponents
    var Year : Int?
    var Month : Int?
    var Day : Int?
    var WeekDay : Int?
    var Hour : Int?
    var Minute : Int?
    var reminderDateOn : Bool = false
    var reminderTimeOn : Bool = false
    var Repeat: Bool?
    var Tapped : Bool = false
    var Done : String = "circle"
    var Color : AnyShapeStyle = AnyShapeStyle(.gray)
    var Format : Font = .title2
    
}


class NotificationDataModel: NSObject, ObservableObject {
    
     @Published var LocalNotifications: [LocalNotification] = [
       LocalNotification(Identifier: "N0", Title: "Morning learner", Body: "Time to badge in"),
       LocalNotification(Identifier: "N1", Title: "Goodbye learner", Body: "Time to badge out"),
       LocalNotification(Identifier: "N2", Title: "What's up?", Body: "You're doing good")
    ]
    
    
    func changeTappedStatus(reminderIdentifier: String) {
        
        for i in 0..<LocalNotifications.count {
            if(LocalNotifications[i].Identifier==reminderIdentifier){
                if(LocalNotifications[i].Tapped){
                    LocalNotifications[i].Tapped=false
                }
                else{
                    LocalNotifications[i].Tapped=true
                }
            }
            else{
                LocalNotifications[i].Tapped=false
            }
        }
    }
    
    func saveNewReminder (newIdentifier : String, newTitle : String, newBody : String){
        let newNotification: LocalNotification = LocalNotification(Identifier: newIdentifier, Title: newTitle, Body: newBody)
        LocalNotifications.append(newNotification)
    }
    
    func getTitle(reminderIdentifier : String) -> String {
        
        var temp = ""
        for i in 0..<LocalNotifications.count {
            if(LocalNotifications[i].Identifier==reminderIdentifier){
                temp=LocalNotifications[i].Title
            }
        }
        return temp
    }
    
    func getNotes(reminderIdentifier : String) -> String {
        
        var temp = ""
        for i in 0..<LocalNotifications.count {
            if(LocalNotifications[i].Identifier==reminderIdentifier){
                temp=LocalNotifications[i].Body
            }
        }
        return temp
    }
    
    func UpdateReminder(reminderIdentifier: String, newTitle : String?,newBody : String?, newYear : Int?, newMonth : Int?, newDay : Int?, newWeekDay: Int?, newHour: Int?, newMinute: Int?, newRepeat: Bool?){
        for i in 0..<LocalNotifications.count {
            if(LocalNotifications[i].Identifier==reminderIdentifier){
                           if let newTitle = newTitle {
                               LocalNotifications[i].Title = newTitle
                           }
                           if let newBody = newBody {
                               LocalNotifications[i].Body = newBody
                           }
                           if let newYear = newYear {
                               LocalNotifications[i].Year = newYear                           }
                           if let newMonth = newMonth {
                               LocalNotifications[i].Month = newMonth
                           }
                           if let newDay = newDay {
                               LocalNotifications[i].Day = newDay
                           }
                           if let newWeekDay = newWeekDay {
                               LocalNotifications[i].WeekDay = newWeekDay
                           }
                           if let newHour = newHour {
                               LocalNotifications[i].Hour = newHour
                           }
                           if let newMinute = newMinute {
                               LocalNotifications[i].Minute = newMinute
                           }
                           if let newRepeat = newRepeat {
                               LocalNotifications[i].Repeat = newRepeat
                           }
            }
        }
    }
    
    func removeReminder(reminderIdentifier : String){
        
        if let index = extractNumber(from: reminderIdentifier){
            LocalNotifications.remove(at: index)
            for i in index..<LocalNotifications.count {
                LocalNotifications[i].Identifier = "N\(i)"
            }
        }
        
    }
    
    private func extractNumber(from string: String) -> Int? {
            // Extracting the number from the string
            let components = string.components(separatedBy: CharacterSet.decimalDigits.inverted)
            if let number = components.compactMap({ Int($0) }).first {
                return number
            }
            return nil
        }
    
    func setDone (reminderIdentifier : String){
        for i in 0..<LocalNotifications.count {
            if(LocalNotifications[i].Identifier==reminderIdentifier){
                LocalNotifications[i].Done="circle.fill"
                LocalNotifications[i].Color = AnyShapeStyle(.blue)
                LocalNotifications[i].Format = .subheadline
            }
        }
    }
    
    func getTime(reminderIdentifier : String) -> String {
        var temp = ""
        for i in 0..<LocalNotifications.count {
            if(LocalNotifications[i].Identifier==reminderIdentifier){
                if let actualHour = LocalNotifications[i].Hour {
                    if let actualMinute = LocalNotifications[i].Minute {
                        if(actualMinute<10){
                            temp="\(actualHour):0\(actualMinute)"
                                            }
                        else{
                            temp="\(actualHour):\(actualMinute)"
                            }
                                                                    }
                                                            }
                                                                    }
                                        }
        return temp;
    }
    
    func getDate(reminderIdentifier : String) -> String {
        
        var temp = ""
        
        for i in 0..<LocalNotifications.count {
            if(LocalNotifications[i].Identifier==reminderIdentifier){
                if let reminderYear = LocalNotifications[i].Year{
                    if let reminderMonth = LocalNotifications[i].Month {
                        if let reminderDay = LocalNotifications[i].Day  {
                            if(reminderYear == Calendar.current.component(.year, from: Date())
                               && reminderMonth == Calendar.current.component(.month, from: Date())
                               && reminderDay == Calendar.current.component(.day, from: Date())) {
                                temp = "Today"
                            }
                            else if(reminderYear == Calendar.current.component(.year, from: Date())
                                    && reminderMonth == Calendar.current.component(.month, from: Date())
                                    && reminderDay == Calendar.current.component(.day, from: Date())+1){
                                temp = "Tomorrow"
                            }
                            else if(reminderYear == Calendar.current.component(.year, from: Date())
                                    && reminderMonth == Calendar.current.component(.month, from: Date())
                                    && reminderDay == Calendar.current.component(.day, from: Date())-1){
                                temp = "Yesterday"
                            }
                            else{
                                temp = "\(reminderDay)/\(reminderMonth)/\(reminderYear)"
                            }
                        }
                    }
                }
            }
        }
        return temp;
    }
    
    func enableDateReminder(reminderIdentifier : String) {
        
        for i in 0..<LocalNotifications.count {
            if(LocalNotifications[i].Identifier==reminderIdentifier) {
                LocalNotifications[i].reminderDateOn = true
            }
        }
    }
    
    func disableDateReminder(reminderIdentifier : String) {
        
        for i in 0..<LocalNotifications.count {
            if(LocalNotifications[i].Identifier==reminderIdentifier){
                LocalNotifications[i].reminderDateOn = false
            }
        }
    }
    
    
    func enableTimeReminder(reminderIdentifier : String) {
        
        for i in 0..<LocalNotifications.count {
            if(LocalNotifications[i].Identifier==reminderIdentifier) {
                LocalNotifications[i].reminderTimeOn = true
            }
        }
    }
    
    func disableTimeReminder(reminderIdentifier : String) {
        
        for i in 0..<LocalNotifications.count {
            if(LocalNotifications[i].Identifier==reminderIdentifier){
                LocalNotifications[i].reminderTimeOn = false
            }
        }
    }
    
    func isReminderDateOn(reminderIdentifier : String) -> Bool {
        
        var temp = false
        
        for i in 0..<LocalNotifications.count {
            if(LocalNotifications[i].Identifier==reminderIdentifier){
                temp = LocalNotifications[i].reminderDateOn
            }
        }
        return temp
    }
    
    func isReminderTimeOn(reminderIdentifier : String) -> Bool {
        
        var temp = false
        
        for i in 0..<LocalNotifications.count {
            if(LocalNotifications[i].Identifier==reminderIdentifier){
                temp = LocalNotifications[i].reminderTimeOn
            }
        }
        return temp
    }
    
    func getNewIdentifier() -> String {
        var temp = ""
        if(LocalNotifications.count>0){
            if let number = extractNumber(from: LocalNotifications[LocalNotifications.count-1].Identifier){
                let increasedNumber = number + 1
                temp = "N\(increasedNumber)"
            }
        }
        else{
            temp="N0"
        }
        
        return temp;
    }
}
