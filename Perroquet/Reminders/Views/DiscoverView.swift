//
//  DiscoverView.swift
//  Perroquet
//
//  Created by Yoan Dubuc on 2/17/24.
//

import SwiftUI

struct DiscoverView: View {
    @StateObject var vm: DiscoverViewModel
    
    init(vm: StateObject<DiscoverViewModel> = .init(wrappedValue: .init())) {
        _vm = vm
    }
    
    var body: some View {
        
        ScrollView(.vertical, showsIndicators: true) {
            
            LazyVStack(alignment: .leading, spacing: 0) {
                
                Text("Discover View")
                
                Button(action: {
                    AuthMan.shared.onSignout()
                }, label: {
                    Text("Sign out")
                })
                
            }

        }
        
    }
}

#Preview {
    DiscoverView()
}
