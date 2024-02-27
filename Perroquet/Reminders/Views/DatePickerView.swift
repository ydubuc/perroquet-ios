//
//  DatePickerView.swift
//  Perroquet
//
//  Created by Yoan Dubuc on 2/27/24.
//

import SwiftUI

struct DatePickerView: View {
    @Binding var date: Date
    let theme: Theme
    
    var body: some View {
        
        GeometryReader { geometry in
            
            VStack(alignment: .leading, spacing: 0) {
                
                Rectangle()
                    .foregroundColor(.clear)
                    .frame(maxHeight: .infinity)
                    .contentShape(Rectangle())
                
                VStack(alignment: .leading, spacing: Dims.spacingRegular) {
                    
                    DatePicker("at", selection: $date, displayedComponents: [.date])
                        .datePickerStyle(.graphical)
                        .colorScheme(theme.colorScheme)
                        .frame(maxWidth: Dims.formMaxWidth)
                    
                    HStack(alignment: .center, spacing: Dims.spacingRegular) {
                        
                        Button(action: {
                            date = Date().addingTimeInterval(TimeInterval(900))
                        }, label: {
                            Text("15m")
                                .foregroundColor(theme.fontBright)
                                .font(.body.weight(.regular))
                                .padding(Dims.spacingSmall)
                                .background(theme.primaryDark)
                                .cornerRadius(Dims.cornerRadius)
                        })
                        
                        Button(action: {
                            date = Date().addingTimeInterval(TimeInterval(1800))
                        }, label: {
                            Text("30m")
                                .foregroundColor(theme.fontBright)
                                .font(.body.weight(.regular))
                                .padding(Dims.spacingSmall)
                                .background(theme.primaryDark)
                                .cornerRadius(Dims.cornerRadius)
                        })
                        
                        Button(action: {
                            date = Date().addingTimeInterval(TimeInterval(3600))
                        }, label: {
                            Text("1h")
                                .foregroundColor(theme.fontBright)
                                .font(.body.weight(.regular))
                                .padding(Dims.spacingSmall)
                                .background(theme.primaryDark)
                                .cornerRadius(Dims.cornerRadius)
                        })
                        
                        Button(action: {
                            date = Date().addingTimeInterval(TimeInterval(7200))
                        }, label: {
                            Text("2h")
                                .foregroundColor(theme.fontBright)
                                .font(.body.weight(.regular))
                                .padding(Dims.spacingSmall)
                                .background(theme.primaryDark)
                                .cornerRadius(Dims.cornerRadius)
                        })
                        
                        Spacer()
                        
                        DatePicker("at", selection: $date, displayedComponents: .hourAndMinute)
                            .labelsHidden()
                            .colorScheme(theme.colorScheme)
                        
                    } // HStack
                    .frame(maxWidth: Dims.formMaxWidth)
                    
                } // VStack
                .padding(Dims.spacingRegular)
                .frame(width: geometry.size.width)
                .background(theme.primary.ignoresSafeArea(.all))
                
            } // VStack
            
        }
        
    }
}

#Preview {
    DatePickerView(
        date: .constant(Date()),
        theme: DarkTheme()
    )
}
