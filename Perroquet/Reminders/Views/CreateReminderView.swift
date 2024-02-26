//
//  CreateReminderView.swift
//  Perroquet
//
//  Created by Yoan Dubuc on 2/19/24.
//

import SwiftUI

struct CreateReminderView: View {
    @Environment(\.presentationMode) var presentationMode
    @StateObject var vm: CreateReminderViewModel
    
    @FocusState var isFocusingTextfield: Bool
    @State private var bottomPadding: CGFloat = 0
    
    init(vm: StateObject<CreateReminderViewModel> = .init(wrappedValue: .init())) {
        _vm = vm
    }
    
    var body: some View {
        
        VStack(alignment: .leading, spacing: 0) {
            
            Rectangle()
                .foregroundColor(.clear)
                .frame(maxHeight: .infinity)
//                .layoutPriority(1)
                .contentShape(Rectangle())
                .onTapGesture {
                    presentationMode.wrappedValue.dismiss()
                }
            
            VStack(alignment: .leading, spacing: Dims.spacingRegular) {
                
                FormTextfieldMultilineComponent(
                    text: $vm.body,
                    title: .constant("Reminder me to..."),
                    placeholder: .constant("cut the grass in 1 hour"),
                    theme: vm.appVm.theme
                )
                .focused($isFocusingTextfield)
                .onAppear {
                    isFocusingTextfield = true
                }
                
                HStack(alignment: .center, spacing: Dims.spacingRegular) {
                    
                    DatePicker("at", selection: $vm.triggerAtDate, displayedComponents: [.date, .hourAndMinute])
                        .labelsHidden()
                        .colorScheme(vm.appVm.theme.colorScheme)
                    
                    Spacer()
                    
                    Button(action: {
                        vm.createReminder()
                        presentationMode.wrappedValue.dismiss()
                    }, label: {
                        Text("Save")
                            .foregroundColor(vm.appVm.theme.fontBright)
                            .font(.body.weight(.regular))
                            .padding(Dims.spacingSmall)
                            .background(vm.appVm.theme.primaryDark)
                            .cornerRadius(Dims.cornerRadius)
                    })
                    
                }
                
            } // VStack
            .padding(Dims.spacingRegular)
            .background(vm.appVm.theme.primary.ignoresSafeArea(.all))
            
        } // VStack
        
    }
    
}

#Preview {
    CreateReminderView()
}
