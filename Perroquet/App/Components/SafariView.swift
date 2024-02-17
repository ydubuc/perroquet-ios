//
//  SafariView.swift
//  Perroquet
//
//  Created by Yoan Dubuc on 2/16/24.
//

import Foundation
import SwiftUI
import SafariServices

struct SafariView: UIViewControllerRepresentable {
    let url: URL
    let theme: Theme

    func makeUIViewController(context: Context) -> SFSafariViewController {
        let viewController = SFSafariViewController(url: url)
        viewController.preferredBarTintColor = UIColor(theme.primary)
        viewController.preferredControlTintColor = UIColor(theme.fontBright)
        return viewController
    }

    func updateUIViewController(_ uiViewController: SFSafariViewController, context: Context) {}
}
