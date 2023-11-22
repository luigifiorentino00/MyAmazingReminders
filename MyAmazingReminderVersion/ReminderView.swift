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
                                
                                VStack(alignment: .leading){
                                    
                                    Text(LocalNotification.Title)
                                    if(vm.isReminderTimeOn(reminderIdentifier: LocalNotification.Identifier)){
                                        Text("\(vm.getDate(reminderIdentifier: LocalNotification.Identifier)) \(vm.getTime(reminderIdentifier: LocalNotification.Identifier))")
                                            .font(.subheadline)
                                            .foregroundStyle(vm.isElapsed(reminderIdentifier: LocalNotification.Identifier))
                                    }
                                    else if(vm.isReminderDateOn(reminderIdentifier: LocalNotification.Identifier)){
                                        Text("\(vm.getDate(reminderIdentifier: LocalNotification.Identifier))")
                                            .font(.subheadline)
                                            .foregroundStyle(vm.isElapsed(reminderIdentifier: LocalNotification.Identifier))
                                    }
                                }
                                
                            }
                            .onTapGesture {
                                vm.changeTappedStatus(reminderIdentifier: LocalNotification.Identifier)
                            }
                            .padding(.leading,5)
                        }
                        .accessibilityElement(children: .combine)
                        .accessibilityHint("Incomplete. Double tap to mark as completed. Double tap with two fingers to open details.")
                        .accessibilityAction(.magicTap, {
                            vm.changeTappedStatus(reminderIdentifier: LocalNotification.Identifier)
                            isPresented.toggle()
                        })
                        
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
                                ReminderDetailView(
                                    toggleDateStatus : vm.isReminderDateOn(reminderIdentifier: LocalNotification.Identifier),
                                    toggleTimeStatus : vm.isReminderTimeOn(reminderIdentifier: LocalNotification.Identifier),
                                    selectedDate : vm.returnDate(reminderIdentifier: LocalNotification.Identifier),
                                    selectedTime : vm.returnTime(reminderIdentifier: LocalNotification.Identifier),
                                    reminderIdentifier : LocalNotification.Identifier, newTitle : (vm.getTitle(reminderIdentifier: LocalNotification.Identifier)) , newBody : (vm.getNotes(reminderIdentifier: LocalNotification.Identifier)))
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
