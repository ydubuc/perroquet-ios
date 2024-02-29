//
//  ReminderView.swift
//  Perroquet
//
//  Created by Yoan Dubuc on 2/29/24.
//

import SwiftUI

struct ReminderView: View {
    @Environment(\.presentationMode) var presentationMode
    @StateObject var vm: ReminderViewModel
    
    @FocusState var isFocusingTextfield: Bool
    
    init(vm: StateObject<ReminderViewModel>) {
        _vm = vm
    }
    
    var body: some View {
        
        GeometryReader { geometry in
            
            VStack(alignment: .center, spacing: 0) {
                
                VStack(alignment: .leading, spacing: Dims.spacingRegular) {
                    
                    FormTextfieldMultilineComponent(
                        text: $vm.body,
                        title: .constant("Remind me to..."),
                        placeholder: $vm.placeholder,
                        theme: vm.appVm.theme
                    )
                    .focused($isFocusingTextfield)
                    .frame(maxWidth: Dims.formMaxWidth)
                    .onChange(of: vm.body, perform: { value in
                        DispatchQueue.main.async {
                            let dates = vm.body.findDates()
                            if let date = dates.last {
                                vm.triggerAtDate = date
                            }
                        }
                    })
                    
                    HStack(alignment: .center, spacing: Dims.spacingRegular) {
                        
                        Button(action: {
                            vm.isPresentingDatePickerView = true
                        }, label: {
                            Text("on \(vm.triggerAtDate.formatted(date: .abbreviated, time: .shortened))")
                                .foregroundColor(vm.appVm.theme.fontBright)
                                .font(.body.weight(.medium))
                                .padding(Dims.spacingSmall)
                                .background(vm.appVm.theme.primaryDark)
                                .cornerRadius(Dims.cornerRadius)
                        })
                        .sheet(isPresented: $vm.isPresentingDatePickerView) {
                            DatePickerView(date: $vm.triggerAtDate, theme: vm.appVm.theme)
                                .background(ClearBackgroundView())
                        }
                        
                        Spacer()
                        
                        Button(action: {
                            vm.editReminder()
                            presentationMode.wrappedValue.dismiss()
                        }, label: {
                            Text("Save")
                                .foregroundColor(vm.appVm.theme.fontBright)
                                .font(.body.weight(.medium))
                                .padding(Dims.spacingSmall)
                                .background(vm.appVm.theme.primaryDark)
                                .cornerRadius(Dims.cornerRadius)
                        })
                        
                    }
                    .frame(maxWidth: Dims.formMaxWidth)
                    
                    Spacer()
                    
                } // VStack
                .padding(Dims.spacingRegular)
                .frame(width: geometry.size.width)
                .background(vm.appVm.theme.primary.ignoresSafeArea(.all))
                
            } // VStack
            
        } // GeometryReader
        
    }
}

#Preview {
    ReminderView(vm: .init(wrappedValue: .init(reminder: .init(
        id: "123",
        userId: "321",
        title: nil,
        body: "Hello, World!",
        frequency: nil,
        visibility: 0,
        triggerAt: 1709222686678,
        updatedAt: 1709222686678,
        createdAt: 1709222686678
    ))))
}
