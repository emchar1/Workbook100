//
//  LineListViewController+MailCompose.swift
//  Workbook100
//
//  Created by Eddie Char on 1/28/22.
//

import MessageUI
import UIKit


// MARK: - MF Mail Compose View Controller Delegate

extension LineListViewController {
    func mailOrder(for data: Data) {
        guard MFMailComposeViewController.canSendMail() else {
            print("Unable to export from Simulator. Try it on a device.")
            return
        }
        
        let mail = MFMailComposeViewController()
        let date = Date()
        let formatter = DateFormatter()
        formatter.dateFormat = "MM/dd/yyyy h:mm a"
        
        mail.mailComposeDelegate = self
        mail.setCcRecipients(["eddie@100percent.com"])
        mail.setSubject("List Export \(formatter.string(from: date))")
        mail.setMessageBody("Here's your file", isHTML: true)
        mail.addAttachmentData(data, mimeType: "text/csv", fileName: "LineSheet.csv")
        
        present(mail, animated: true)
    }
    
    func mailComposeController(_ controller: MFMailComposeViewController, didFinishWith result: MFMailComposeResult, error: Error?) {
        controller.dismiss(animated: true)
    }
}
