//
//  SwiftUIView.swift
//  MyAmazingReminderVersion
//
//  Created by Luigi Fiorentino on 15/11/23.
//

import SwiftUI
import UserNotifications

extension View {
    /// Sets the text color for a navigation bar title.
    /// - Parameter color: Color the title should be
    ///
    /// Supports both regular and large titles.
    @available(iOS 17, *)
    func navigationBarTitleTextColor(_ color: Color) -> some View {
        let uiColor = UIColor(color)
    
        // Set appearance for both normal and large sizes.
        UINavigationBar.appearance().titleTextAttributes = [.foregroundColor: uiColor ]
        UINavigationBar.appearance().largeTitleTextAttributes = [.foregroundColor: uiColor ]
        return self
    }
}

func scheduleNotification(title: String, body: String, WeekDay: Int, Hour: Int, Minute: Int, Repeat: Bool){
    
    let content = UNMutableNotificationContent()
    content.title = title
    content.body = body
    content.sound = .default
    content.badge = 1
    
    var dateComponents = DateComponents()
   // dateComponents.day
   // dateComponents.month
   // dateComponents.year
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


struct ReminderView: View {
    
    @State private var isTextFieldVisible = false
    @State private var isPresented = false
    @State private var enteredText = ""
    let calendar = Calendar.current
    @State var viewModel = NotificationDataModel()
    
    @State var Attempt : LocalNotification = LocalNotification(Identifier: "N4", Title: "", Body: "", WeekDay:0 , Hour: 8, Minute: 0, Repeat: false)
    
    var body: some View {
  
        NavigationStack {
            
            List{
                
                ForEach(viewModel.LocalNotifications) { LocalNotification in
                    
                    HStack{
                      
                        
                        VStack (alignment: .leading){
                            
                          Text(LocalNotification.Title)
                           
                        /*    TextField("Add a note", text: $LocalNotification.Notes, onCommit: {
                                            // Perform actions when the user presses return
                                            isTextFieldVisible = false
                                        })
                                        .padding()
                            
                            Text("\(enteredText)")
                                .font(.subheadline)
                                .foregroundStyle(.gray)
                            */
                            
                           Text("\(dayOfWeekString(for: LocalNotification.WeekDay))\(",")\(LocalNotification.Hour)\(":")\(LocalNotification.Minute)")
                                .foregroundStyle(.red)
                           

                        }
                        .onTapGesture {
                            isTextFieldVisible=true
                        }
                        
                        Spacer()
                        
                        Button(action: {
                         /*  scheduleNotification(title: LocalNotification.Title, body: LocalNotification.Body, WeekDay: LocalNotification.WeekDay, Hour: LocalNotification.Hour, Minute: LocalNotification.Minute, Repeat: LocalNotification.Repeat)*/
                            isPresented=true;
                                    }
                            ) {
                                        Image(systemName: "info.circle")
                                            .font(.title)
                                            .foregroundColor(.blue)
                                    }
                            .sheet(isPresented: $isPresented){
                                ReminderDetailView(notificationDetail: $Attempt)
                            }
                        
                                        }
                   
                }
            }
            .listStyle(.plain)
            .navigationBarTitle(Text("Reminders"), displayMode: .large)
            .navigationBarTitleTextColor(Color.blue)
         
        }
    }
}


#Preview {
    ReminderView()
}
