//
//  ReminderComponent.swift
//  Perroquet
//
//  Created by Yoan Dubuc on 2/19/24.
//

import SwiftUI

struct ReminderComponent: View {
    let reminder: Reminder
    let theme: Theme
    
    var body: some View {
        
        VStack(alignment: .leading, spacing: Dims.spacingSmallest) {
            
            HStack(alignment: .center, spacing: Dims.spacingRegular) {
                    
                Text(reminder.title ?? reminder.body)
                    .foregroundColor(theme.fontNormal)
                    .font(.body.weight(.regular))
                
                Spacer()
                
            }
            
            Text("\(Date(timeIntervalSince1970: TimeInterval(reminder.triggerAt) / 1000).formatted())")
                .foregroundColor(theme.fontBright)
                .font(.caption.weight(.regular))
                .lineLimit(1)
            
        }
        
    }
}

#Preview {
    ReminderComponent(
        reminder: Reminder(
            id: "123",
            userId: "321",
            title: nil,
            body: "do the laundry",
            frequency: nil,
            visibility: 0,
            triggerAt: 1708358620664,
            updatedAt: 1708358620664,
            createdAt: 1708358620664
        ),
        theme: DarkTheme()
    )
}
