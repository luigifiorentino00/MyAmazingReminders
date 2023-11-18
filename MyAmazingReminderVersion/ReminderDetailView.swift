//
//  ReminderDetailView.swift
//  MyAmazingReminderVersion
//
//  Created by Luigi Fiorentino on 15/11/23.
//

import SwiftUI
import UserNotifications

func scheduleNotification(title: String, body: String, Year : Int, Month : Int, Day : Int, WeekDay: Int, Hour: Int, Minute: Int, Repeat: Bool){
    
    let content = UNMutableNotificationContent()
    content.title = title
    content.body = body
    content.sound = .default
    content.badge = 1
    
    var dateComponents = DateComponents()
    dateComponents.day = Day
    dateComponents.month = Month
    dateComponents.year = Year
    dateComponents.weekday = WeekDay
    dateComponents.hour = Hour
    dateComponents.minute = Minute
    
    let trigger = UNCalendarNotificationTrigger(dateMatching: dateComponents, repeats: Repeat)
    
    let request = UNNotificationRequest(identifier: UUID().uuidString, content: content, trigger: trigger)
    
    UNUserNotificationCenter.current().add(request)
}

func dayOfWeekString(for dayOfWeek: Int) -> String {
        switch dayOfWeek {
        case 1: return "Sunday"
        case 2: return "Monday"
        case 3: return "Tuesday"
        case 4: return "Wednesday"
        case 5: return "Thursday"
        case 6: return "Friday"
        case 7: return "Saturday"
        default: return "Invalid Day"
        }
    }


struct ReminderDetailView: View {
    
    @EnvironmentObject var vm : NotificationDataModel
    @Environment(\.dismiss) private var dismiss
    @State private var toggleDateStatus : Bool = false
    @State private var toggleTimeStatus : Bool = false
    @State private var selectedDate : Date = Date()
    @State private var selectedTime : Date = Date()
    let reminderIdentifier : String
    @State var newTitle : String = ""
    @State var newBody : String = ""
    
    var body: some View {
        
        
        NavigationStack {
            Form {
                
            TextField("\(vm.getTitle(reminderIdentifier: reminderIdentifier))", text: $newTitle)
            TextField("\(vm.getNotes(reminderIdentifier: reminderIdentifier))", text: $newBody)
            
                
                Toggle(isOn: $toggleDateStatus) {
                    
                    HStack{
                        Image(systemName: "calendar")
                            .foregroundColor(.red)
                        Text("Date")
                    }
                }
                
                if(toggleDateStatus || toggleTimeStatus){
                    
                    DatePicker(
                        "",
                        selection: $selectedDate,
                        displayedComponents: [.date]
                    ).datePickerStyle(.graphical)
                }
                
                Toggle(isOn: $toggleTimeStatus) {
                    
                    HStack{
                        Image(systemName: "clock.fill")
                            .foregroundColor(.blue)
                        Text("Time")
                    }
                }
                
                if(toggleTimeStatus){
                    DatePicker(
                        "",
                        selection: $selectedTime,
                        displayedComponents: [.hourAndMinute]
                    ).datePickerStyle(.wheel)

                }
                
            }
            .navigationBarItems(leading: Button(action: {
                vm.changeTappedStatus(reminderIdentifier: reminderIdentifier) ; dismiss()}, label: {
                Text("Cancel")
            }),trailing: Button(action: {
                
              /*  if(toggleDateStatus || toggleTimeStatus){
                    vm.enableReminder(reminderIdentifier: reminderIdentifier)
                }*/
                vm.changeTappedStatus(reminderIdentifier: reminderIdentifier)
                
                vm.UpdateReminder(reminderIdentifier: reminderIdentifier,
                                  newTitle: newTitle,
                                  newBody: newBody,
                                  newYear: Calendar.current.component(.year, from: selectedDate),
                                  newMonth: Calendar.current.component(.month, from : selectedDate),
                                  newDay:  Calendar.current.component(.day, from : selectedDate),
                                  newWeekDay: Calendar.current.component(.weekday, from: selectedDate),
                                  newHour: Calendar.current.component(.hour, from: selectedTime) ,
                                  newMinute: Calendar.current.component(.minute, from :selectedTime),
                                  newRepeat: false)
                
                if(toggleDateStatus || toggleTimeStatus){
                    scheduleNotification(title: newTitle,
                                         body: newBody,
                                         Year: Calendar.current.component(.year, from: selectedDate),
                                         Month: Calendar.current.component(.month, from : selectedDate),
                                         Day: Calendar.current.component(.day, from : selectedDate),
                                         WeekDay: Calendar.current.component(.weekday, from: selectedDate),
                                         Hour: Calendar.current.component(.hour, from: selectedTime),
                                         Minute: Calendar.current.component(.minute, from :selectedTime),
                                         Repeat: false)
                }
                dismiss()
                
            }) {
                Text("Done")
            })
        }
    }
}

/*#Preview {
    ReminderDetailView(selectedTitle: "BadgeIn", selectedNotes: "Ricordati di badge")
}*/
