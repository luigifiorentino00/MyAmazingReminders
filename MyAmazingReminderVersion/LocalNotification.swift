//
//  LocalNotification.swift
//  MyAmazingReminderVersion
//
//  Created by Luigi Fiorentino on 15/11/23.
//

import Foundation


struct LocalNotification : Identifiable {
 
    var id: UUID = UUID()
    var Identifier: String
    var Title: String
    var Notes : String?
    var Body: String
   // var DateComponents: DateComponents
    var WeekDay : Int
    var Hour : Int
    var Minute : Int
    var Repeat: Bool
    
}


class NotificationDataModel {
    
      var LocalNotifications: [LocalNotification] = [
       LocalNotification(Identifier: "N1", Title: "Hey learner", Body: "Ricordati di fare badge in", WeekDay: 5, Hour: 8, Minute: 55, Repeat: true),
       LocalNotification(Identifier: "N2", Title: "Hey learner", Body: "Ricordati di fare badge out" , WeekDay: 5, Hour: 12, Minute: 55, Repeat: true),
       LocalNotification(Identifier: "N3", Title: "Test", Body: "Sto testando l'app", WeekDay: 4, Hour: 18, Minute: 0, Repeat: false)
    ]
    
}
