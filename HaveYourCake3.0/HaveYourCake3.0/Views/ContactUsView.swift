import SwiftUI
import MessageUI

struct ContactUsView: View {
    @State private var showMailView = false
    @State private var mailResult: Result<MFMailComposeResult, NSError> = .failure(NSError(domain: "", code: 0, userInfo: nil))
    
    @State private var firstName = ""
    @State private var lastName = ""
    @State private var email = ""
    @State private var message = ""
    
    var body: some View {
        VStack {
            TextField("First Name", text: $firstName)
                .padding()
                .textFieldStyle(RoundedBorderTextFieldStyle())
            
            TextField("Last Name", text: $lastName)
                .padding()
                .textFieldStyle(RoundedBorderTextFieldStyle())
            
            TextField("Email", text: $email)
                .padding()
                .textFieldStyle(RoundedBorderTextFieldStyle())
                .keyboardType(.emailAddress)
            
            TextField("Message", text: $message)
                .padding()
                .textFieldStyle(RoundedBorderTextFieldStyle())
            
            Button("Submit") {
                if MFMailComposeViewController.canSendMail() {
                    showMailView = true
                } else {
                    print("Mail services are not available.")
                }
            }
            .padding()
            .disabled(firstName.isEmpty || lastName.isEmpty || email.isEmpty || message.isEmpty)
        }
        .padding()
        .sheet(isPresented: $showMailView) {
            MailView(
                result: $mailResult,
                firstName: firstName,
                lastName: lastName,
                email: email,
                message: message
            )
        }
    }
}

struct MailView: UIViewControllerRepresentable {
    class Coordinator: NSObject, MFMailComposeViewControllerDelegate {
        var parent: MailView
        
        init(parent: MailView) {
            self.parent = parent
        }
        
        func mailComposeController(_ controller: MFMailComposeViewController, didFinishWith result: MFMailComposeResult, error: Error?) {
            if let error = error {
                print("Error sending mail: \(error.localizedDescription)")
            }
            parent.result = .success(result)
            controller.dismiss(animated: true)
        }
    }
    
    @Binding var result: Result<MFMailComposeResult, NSError>
    var firstName: String
    var lastName: String
    var email: String
    var message: String
    
    func makeCoordinator() -> Coordinator {
        return Coordinator(parent: self)
    }
    
    func makeUIViewController(context: Context) -> MFMailComposeViewController {
        let composeVC = MFMailComposeViewController()
        composeVC.setSubject("Contact Us: \(firstName) \(lastName)")
        composeVC.setToRecipients(["monicagraham40@gmail.com"])
        composeVC.setMessageBody(
            """
            Name: \(firstName) \(lastName)
            Email: \(email)
            
            Message:
            \(message)
            """,
            isHTML: false
        )
        composeVC.mailComposeDelegate = context.coordinator
        return composeVC
    }
    
    func updateUIViewController(_ uiViewController: MFMailComposeViewController, context: Context) {}
}
