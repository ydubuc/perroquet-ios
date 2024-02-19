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
        
        VStack(alignment: .leading, spacing: 0) {
            
            Text(reminder.title ?? reminder.content)
                .foregroundColor(theme.fontNormal)
                .font(.body.weight(.regular))
                .lineLimit(1)
            
        }
        .padding(Dims.spacingRegular)
        .background(theme.primaryLight)
        .cornerRadius(Dims.cornerRadius)
        
    }
}

#Preview {
    ReminderComponent(
        reminder: Reminder(
            id: "123",
            userId: "321",
            title: nil,
            content: "do the laundry",
            frequency: nil,
            triggerAt: 1708358620664,
            updatedAt: 1708358620664,
            createdAt: 1708358620664
        ),
        theme: DarkTheme()
    )
}
