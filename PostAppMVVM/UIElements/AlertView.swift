//
//  AlertView.swift
//  PostAppMVVM
//
//  Created by Heorhi Sinkou on 3.08.21.
//

import SwiftUI

public typealias VoidCompletion = (() -> Void)

struct AlertView: View {
    @Binding var isPresented: Bool
    let title: String
    let primaryTitle: String
    var message: String?
    var primaryAction: VoidCompletion?
    var secondaryAction: VoidCompletion?

    var body: some View {
        Text("")
            .alert(isPresented: $isPresented, content: {
                Alert(title: Text(title),
                      message: message != nil ? Text(message ?? "") : nil,
                      primaryButton: Alert.Button.default(Text(primaryTitle),
                                                          action: primaryAction),
                      secondaryButton: Alert.Button.cancel(secondaryAction))
            })
    }
}

struct AlertView_Previews: PreviewProvider {
    static var previews: some View {
        AlertView(isPresented: .constant(true), title: "Error", primaryTitle: "Ok")
    }
}
