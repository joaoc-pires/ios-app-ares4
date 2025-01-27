//
//  MailView.swift
//  Ares
//
//  Created by Joao Pires on 26/01/2025.
//

import SwiftUI
import MessageUI

struct MailView: UIViewControllerRepresentable {
    
    @Environment(\.presentationMode) var presentation
    @Binding var result: Result<MFMailComposeResult, Error>?
    
    class Coordinator: NSObject, MFMailComposeViewControllerDelegate {
        
        @Binding var presentation: PresentationMode
        @Binding var result: Result<MFMailComposeResult, Error>?
        
        init(presentation: Binding<PresentationMode>,
             result: Binding<Result<MFMailComposeResult, Error>?>) {
            _presentation = presentation
            _result = result
        }
        
        func mailComposeController(_ controller: MFMailComposeViewController, didFinishWith result: MFMailComposeResult, error: Error?) {
            defer {
                $presentation.wrappedValue.dismiss()
            }
            guard error == nil else {
                self.result = .failure(error!)
                return
            }
            self.result = .success(result)
        }
    }
    
    func makeCoordinator() -> Coordinator {
        return Coordinator(presentation: presentation,
                           result: $result)
    }
    
    func makeUIViewController(context: UIViewControllerRepresentableContext<MailView>) -> MFMailComposeViewController {
        let mail = MFMailComposeViewController()
        mail.mailComposeDelegate = context.coordinator
        mail.setToRecipients(["developer@joaopires.com"])
        mail.setSubject("Ares: Feedback")
        let documentPath = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first
        if let logsFolder = documentPath?.absoluteURL.appendingPathComponent("logs") {
            if let logData = try? Data(contentsOf: .logFile!) {
                mail.addAttachmentData(logData, mimeType: "text", fileName: "Ares.log")
            }
            else {
                log.error("Error while enumerating files \(logsFolder.path)")
            }
        }
        return mail
    }
    
    func updateUIViewController(_ uiViewController: MFMailComposeViewController,
                                context: UIViewControllerRepresentableContext<MailView>) {
        
    }
}
