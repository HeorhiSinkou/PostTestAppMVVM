//
//  UserDataView.swift
//  PostAppMVVM
//
//  Created by Heorhi Sinkou on 2.08.21.
//

import Combine
import SwiftUI
import MessageUI

struct UserData: View {
    enum AlertType {
        case noAlert
        case email
        case phone
        case map

        var message: String {
            switch self {
            case .email: return "Your device can't send email"
            case .map: return "Your device can't open Google map"
            case .noAlert: return ""
            case .phone: return "Your phone number is incorrect"
            }
        }
    }

    @Environment(\.openURL) var openURL
    @Binding var isShowingMailView: Bool
    @State private var showAlert: Bool = false
    let userInfo: UserInfo?
    @State private var alertType: AlertType = .noAlert {
        didSet {
            showAlert = alertType != .noAlert
        }
    }

    var body: some View {
        VStack(alignment: .leading,spacing: 10.0) {
            Text("\(userInfo?.username ?? "Unknown user name")")
            Button(action: {
                if MFMailComposeViewController.canSendMail() {
                    isShowingMailView = true
                } else {
                    alertType = .email
                }
            })
            {
                HStack {
                    Image(systemName: "envelope.circle")
                        .font(.system(size: 24, weight: .semibold, design: .rounded))
                    Text(userInfo?.email ?? "unknown email")
                }
            }// :Button
            .modifier(ContactButton())
            Button(action: {
                if let url = URL(string:"tel://\(userInfo?.phone ?? ""))") {
                    openURL(url)
                } else {
                    alertType = .phone
                }
            })
            {
                HStack {
                    Image(systemName: "phone")
                        .font(.system(size: 24, weight: .semibold, design: .rounded))
                    Text(userInfo?.phone ?? "unknown phone")
                }
            }// :Button
            .modifier(ContactButton())
            Text("""
                Adress:
                \(userInfo?.address?.street ?? "unknown street"),
                \(userInfo?.address?.suite ?? "unknown suite"),
                \(userInfo?.address?.city ?? "unknown city"),
                \(userInfo?.address?.zipcode ?? "unknown zipcode")
                """)
                .onTapGesture {
                    guard let url = URL(string:"comgooglemaps://"),
                          UIApplication.shared.canOpenURL(url)
                    else {
                        alertType = .map
                        return
                    }
                    self.openGoogleMap()
                }// :Text
            Text(userInfo?.company?.name ?? "Unknown company")// :Text
        }// :VStack
        .alert(isPresented: $showAlert, content: {
            Alert(title: Text("Warning"),
                  message: Text(self.alertType.message),
                  dismissButton: .default(Text("Ok")))
        })// :Alert
        .sheet(isPresented: $isShowingMailView) {
            MailComposeViewController(toRecipients: ["test@test.com"], mailBody: "Write something") {
            }
        }// :Sheet
    }

    private func openGoogleMap() {
        guard
            let geo = userInfo?.address?.geo,
            let lat = Double(geo.lat ?? ""),
            let lng = Double(geo.lng ?? ""),
            let url = URL(string: "comgooglemaps-x-callback://?saddr=&daddr=\(lat),\(lng)&directionsmode=driving")
        else {
            return
        }
        openURL(url)
    }
}

