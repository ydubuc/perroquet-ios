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
        
        GeometryReader { geometry in
            
            VStack(alignment: .center, spacing: 0) {
                
                Rectangle()
                    .foregroundColor(.clear)
                    .frame(maxHeight: .infinity)
                    .contentShape(Rectangle())
                
                VStack(alignment: .leading, spacing: Dims.spacingRegular) {
                    
                    FormTextfieldMultilineComponent(
                        text: $vm.body,
                        title: .constant("Remind me to..."),
                        placeholder: .constant("cut the grass in 1 hour"),
                        theme: vm.appVm.theme
                    )
                    .focused($isFocusingTextfield)
                    .frame(maxWidth: Dims.formMaxWidth)
                    .onAppear {
                        isFocusingTextfield = true
                    }
                    .onChange(of: vm.body, perform: { value in
                        DispatchQueue.global(qos: .background).async {
                            let dates = findDates(in: vm.body)
                            DispatchQueue.main.async {
                                if let date = dates.last {
                                    vm.triggerAtDate = date
                                }
                            }
                        }
                    })
                    
                    HStack(alignment: .center, spacing: Dims.spacingRegular) {
                        
                        Button(action: {
                            vm.isPresentingDatePickerView = true
                        }, label: {
                            Text("on \(vm.triggerAtDate.formatted(date: .abbreviated, time: .shortened))")
                                .foregroundColor(vm.appVm.theme.fontBright)
                                .font(.body.weight(.regular))
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
                    .frame(maxWidth: Dims.formMaxWidth)
                    
                } // VStack
                .padding(Dims.spacingRegular)
                .frame(width: geometry.size.width)
                .background(vm.appVm.theme.primary.ignoresSafeArea(.all))
                
            } // VStack
            
        } // GeometryReader
        
    }
    
    func findDates(in text: String) -> [Date] {
        var dates: [Date] = []
        
        // Create NSDataDetector instance for date detection
        let detector = try! NSDataDetector(types: NSTextCheckingResult.CheckingType.date.rawValue)
        
        // Enumerate matches in the text
        detector.enumerateMatches(in: text, options: [], range: NSRange(location: 0, length: text.utf16.count)) { match, _, _ in
            if let date = match?.date {
                dates.append(date)
            }
        }
        
        // Detect relative timeframes like "in 15 minutes"
        let relativeDates = detectRelativeDates(in: text)
        dates.append(contentsOf: relativeDates)
        
        return dates
    }
    
    func detectRelativeDates(in text: String) -> [Date] {
        var dates: [Date] = []
        
        // Regular expression pattern to match relative timeframes like "in 15 minutes"
        let pattern = "\\bin\\s+(\\d+)\\s+(m|mins|minutes?|h|hours?|d|days?|w|weeks?|mo|months?|y|years?)\\b"
        
        do {
            let regex = try NSRegularExpression(pattern: pattern, options: [])
            let matches = regex.matches(in: text, options: [], range: NSRange(location: 0, length: text.utf16.count))
            
            for match in matches {
                // Extract the quantity and unit of time from the match
                if let range = Range(match.range, in: text) {
                    let matchString = String(text[range])
                    let components = matchString.components(separatedBy: .whitespaces)
                    if components.count == 3, let quantity = Int(components[1]) {
                        let unit = components[2].singularized()
                        guard let dateComponent = unit.dateComponent else {
                            throw AppError("no date component")
                        }
                        if let date = Calendar.current.date(byAdding: dateComponent, value: quantity, to: Date()) {
                            dates.append(date)
                        }
                    }
                }
            }
        } catch {
            print("Error creating regular expression: \(error)")
        }
        
        return dates
    }
    
}

// Extension to convert time unit strings to DateComponents
extension String {
    var dateComponent: Calendar.Component? {
        switch self {
        case "m", "min", "mins", "minute", "minutes":
            return .minute
        case "h", "hour", "hours":
            return .hour
        case "d", "day", "days":
            return .day
        case "w", "week", "weeks":
            return .weekOfYear
        case "mo", "month", "months":
            return .month
        case "y", "year", "years":
            return .year
        default:
            return nil
        }
    }
    
    func singularized() -> String {
        if self.hasSuffix("s") {
            return String(self.dropLast())
        }
        return self
    }
}

#Preview {
    CreateReminderView()
}
