//
//  ReminderDetailView.swift
//  MyAmazingReminderVersion
//
//  Created by Luigi Fiorentino on 15/11/23.
//

import SwiftUI


struct ReminderDetailView: View {
    
    @Environment(\.dismiss) private var dismiss
    @State private var toggleDateStatus = false
    @State private var toggleTimeStatus = false
    @State private var selectedDate : Date = Date()
    @State private var selectedTime : Date = Date()
    @State var selectedHour : Int = 12
    @Binding var notificationDetail : LocalNotification
   
    
    var body: some View {
        
        NavigationStack {
            Form {
                
                TextField("\(notificationDetail.Title)", text: $notificationDetail.Title)
                TextField("\(notificationDetail.Body)", text: $notificationDetail.Body)
                
                Toggle(isOn: $toggleDateStatus) {
                    
                    HStack{
                        Image(systemName: "calendar")
                            .foregroundColor(.red)
                        Text("Date")
                    }
                }
                
                if(toggleDateStatus){
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
                        Text("Date")
                    }
                }
                
                if(toggleTimeStatus){
                    
                    Text("Done")
                    
                    DatePicker(
                        "",
                        selection: $selectedTime,
                        displayedComponents: [.hourAndMinute]
                    ).datePickerStyle(.wheel)
                    
                }
                
                //notificationDetail.Hour = Calendar.current.component(.hour, from: selectedTime)
                
            }
            .navigationBarItems(leading: Button(action: {dismiss()}, label: {
                Text("Cancel")
            }),trailing: Button(action: {
               /* notificationDetail.day = Calendar.current.component(.day, from : selectedDate)
                notificationDetail.month = Calendar.current.component(.month, from : selectedDate)
                notificationDetail.year = Calendar.current.component(.year, from: selectedDate)*/
                notificationDetail.WeekDay = Calendar.current.component(.weekday, from: selectedDate)
                notificationDetail.Hour = Calendar.current.component(.hour, from: selectedTime)
                notificationDetail.Minute = Calendar.current.component(.minute, from :selectedTime)
                
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
