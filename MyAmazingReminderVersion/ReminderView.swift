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


struct ReminderView: View {
    
    @State private var isTextFieldVisible = false
    @State private var isPresented = false
    @State var fill = "circle"
    @StateObject private var vm: NotificationDataModel
    init(vm: NotificationDataModel) {
        _vm = StateObject(wrappedValue: vm)
        UIView.appearance().tintColor = UIColor(named: "AccentColor")
    }
    
    
    var body: some View {
  
        NavigationStack {
            
            List{
                
                ForEach(vm.LocalNotifications) { LocalNotification in
                    
                    HStack{
                                                
                            
                        ZStack{
                            
                            Image(systemName: "circle")
                                .font(.title2)
                                .foregroundStyle(LocalNotification.Color)
                            
                            Image(systemName: LocalNotification.Done)
                                .font(LocalNotification.Format)
                                .foregroundStyle(LocalNotification.Color)
                                .onTapGesture {
                                    vm.setDone(reminderIdentifier: LocalNotification.Identifier)
                                    DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
                                        vm.removeReminder(reminderIdentifier: LocalNotification.Identifier)
                                    }
                                }
                        }
                        
                        VStack (alignment: .leading){
                            
                            Text(LocalNotification.Title)
                                
                            if(vm.isReminderTimeOn(reminderIdentifier: LocalNotification.Identifier))
                            {
                                Text("\(vm.getDate(reminderIdentifier: LocalNotification.Identifier)), \(vm.getTime(reminderIdentifier: LocalNotification.Identifier))")
                                    .foregroundStyle(.gray)
                            }
                            else if(vm.isReminderDateOn(reminderIdentifier: LocalNotification.Identifier)){
                                Text("\(vm.getDate(reminderIdentifier: LocalNotification.Identifier))")
                                    .foregroundStyle(.gray)
                            }
                               
                           }
                            .onTapGesture {
                                vm.changeTappedStatus(reminderIdentifier: LocalNotification.Identifier)
                            }
                            .padding(.leading,5)
                            
                      
                    
                        /*    TextField("Add a note", text: $LocalNotification.Notes, onCommit: {
                         // Perform actions when the user presses return
                         isTextFieldVisible = false
                         })
                         .padding()
                         
                         Text("\(enteredText)")
                         .font(.subheadline)
                         .foregroundStyle(.gray)
                         */
                        
                        /*              Text("\(dayOfWeekString(for: LocalNotification.WeekDay))\(",")\(LocalNotification.Hour)\(":")\(LocalNotification.Minute)")
                         .foregroundStyle(.red)*/
                        
                        Spacer()
                        
                        if(LocalNotification.Tapped){
                            Button(action: {
                                isPresented=true;
                            }
                            ) {
                                Image(systemName: "info.circle")
                                    .font(.title)
                                    .foregroundColor(.blue)
                            }
                            .sheet(isPresented: $isPresented){
                                ReminderDetailView(reminderIdentifier : LocalNotification.Identifier)
                                    .environmentObject(vm)
                            }
                        }
                    }
                }
            }
            .listStyle(.plain)
            .navigationBarTitle(Text("Reminders"), displayMode: .large)
            .navigationBarTitleTextColor(Color.blue)
         
        }
        
        Button (action :
                {
            vm.saveNewReminder(newIdentifier: vm.getNewIdentifier(), newTitle: "New", newBody: "")
            
                })
                {
                HStack{
                    
                    Image(systemName: "plus.circle.fill")
                        .font(.title)
                        .foregroundColor(.blue)
                        
                    
                    Text("New Reminder")
                        .bold()
                }.padding()
            
            Spacer()
        }
    }
}


#Preview {
    ReminderView(vm : NotificationDataModel())
}
