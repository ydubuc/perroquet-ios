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
    
    init(vm: StateObject<CreateReminderViewModel> = .init(wrappedValue: .init())) {
        _vm = vm
    }
    
    var body: some View {
        
        VStack(alignment: .leading, spacing: Dims.spacingRegular) {
            
            FormTextfieldComponent(text: $vm.body, placeholder: .constant("Remind me to..."), theme: vm.appVm.theme)
            
            HStack(alignment: .center, spacing: Dims.spacingRegular) {
                
                // TODO trigger at
                
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
            
            Spacer()
            
        } // VStack
        .padding(Dims.spacingRegular)
        .background(vm.appVm.theme.primary)
        
    }
    
}

#Preview {
    CreateReminderView()
}
