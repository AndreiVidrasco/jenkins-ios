//
//  AddAccountTableViewController.swift
//  JenkinsiOS
//
//  Created by Robert on 25.09.16.
//  Copyright © 2016 MobiLab Solutions. All rights reserved.
//

import SafariServices
import UIKit

protocol AddAccountTableViewControllerDelegate: class {
    func didEditAccount(account: Account, oldAccount: Account?, useAsCurrentAccount: Bool)
    func didDeleteAccount(account: Account)
}

protocol VerificationFailurePresenting: class {
    func showVerificationFailure(error: Error)
    func hideVerificationFailure()
}

protocol DoneButtonEventReceiving: class {
    func doneButtonPressed()
}

class AddAccountTableViewController: UITableViewController, VerificationFailureNotifying, AccountProvidable, DoneButtonEventReceiving {
    // MARK: - Instance variables

    var account: Account?
    var isCurrentAccount = false
    var isFirstAccount = false

    weak var delegate: AddAccountTableViewControllerDelegate?
    weak var verificationFailurePresenter: VerificationFailurePresenting?
    weak var doneButtonContainer: DoneButtonContaining?

    private var shouldShowNameField: Bool {
        return true
    }

    private var shouldShowSwitchAccountToggle: Bool {
        return true
    }

    // MARK: - Outlets

    @IBOutlet var nameTextField: UITextField?
    @IBOutlet var urlTextField: UITextField!
    @IBOutlet var usernameTextField: UITextField!
    @IBOutlet var apiKeyTextField: UITextField!
    @IBOutlet var trustAllCertificatesSwitch: UISwitch!
    @IBOutlet var bottomMostBackgroundView: UIView!
    @IBOutlet var deleteAccountCell: UITableViewCell!
    @IBOutlet var switchAccountLabel: UILabel!
    @IBOutlet var switchAccountSwitch: UISwitch!
    @IBOutlet var seeTutorialButton: UIButton!

    @IBOutlet var textFields: [UITextField]!

    private var actionButtonTitle: String {
        if account == nil {
            return "ADD ACCOUNT"
        }

        return (isCurrentAccount || !switchAccountSwitch.isOn) ? "SAVE" : "SAVE AND SWITCH"
    }

    // MARK: - Nested Types

    private enum Section: Int {
        case name = 0
        case url
        case username
        case apiKey
        case seeTutorial
        case trustCertificates
        case switchAccount
        case delete

        func heightForRowInSection(account: Account?, showName: Bool, shouldShowSwitchAccount: Bool) -> CGFloat {
            switch self {
            case .name where showName: return 50.0
            case .name: return 0.0
            case .url: return 50
            case .username: return 50
            case .seeTutorial: return 60
            case .apiKey: return 50
            case .trustCertificates: return 47
            case .switchAccount: return shouldShowSwitchAccount ? 47 : 0
            case .delete where account != nil: return 50
            case .delete: return 48
            }
        }
    }

    // MARK: - Actions

    @objc func verifyAndAddAccount() {
        guard let account = createAccount()
        else { return }

        verify(account: account, onSuccess: { [weak self] in
            let _ = self?.addAccountWith(account: account)
        })
    }

    private func addAccountWith(account: Account) -> Bool {
        do {
            try addOrUpdateAccount(account: account)
            return true
        } catch let error as AccountManagerError {
            displayError(title: "Error", message: error.localizedDescription, textFieldConfigurations: [], actions: [
                UIAlertAction(title: "Alright", style: .cancel, handler: nil),
            ])
        } catch { print("An error occurred: \(error)") }

        return false
    }

    private func createAccount() -> Account? {
        guard let url = createAccountURL(), var components = URLComponents(url: url, resolvingAgainstBaseURL: false)
        else { return nil }

        let username = usernameTextField.text != "" ? usernameTextField.text : nil
        let password = apiKeyTextField.text != "" ? apiKeyTextField.text : nil
        let trustAllCertificates = trustAllCertificatesSwitch.isOn

        let displayName = nameTextField?.text?.isEmpty == false ? nameTextField?.text : nil
        let port = components.port

        components.port = nil

        guard let baseUrl = components.url
        else { return nil }

        return Account(baseUrl: baseUrl, username: username, password: password, port: port, displayName: displayName,
                       trustAllCertificates: trustAllCertificates)
    }

    private func createAccountURL() -> URL? {
        guard let urlText = urlTextField.text
        else { return nil }
        return URL(string: urlText)
    }

    @objc func verifyAndSaveAccount() {
        guard let newAccount = createAccount()
        else { return }

        verify(account: newAccount, onSuccess: { [weak self] in
            do {
                try self?.addOrUpdateAccount(account: newAccount)
            } catch {
                print("Could not save account: \(error)")
                let alert = UIAlertController(title: "Error", message: "Could not save the account", preferredStyle: .alert)
                alert.addAction(UIAlertAction(title: "OK", style: .cancel, handler: nil))
                self?.present(alert, animated: true, completion: nil)
            }
        })
    }

    // MARK: - View Controller lifecycle

    override func viewDidLoad() {
        bottomMostBackgroundView.layer.cornerRadius = 5

        // Write all known data into the text fields
        if let account = account {
            prepareUI(for: account)
        } else {
            prepareUIWithoutAccount()
        }

        // The add button should not be enabled when there is no text in the mandatory textfields
        doneButtonContainer?.setDoneButton(enabled: addButtonShouldBeEnabled())
        doneButtonContainer?.setDoneButton(title: actionButtonTitle)
        // For every mandatory textfield, add an event handler
        urlTextField.addTarget(self, action: #selector(textFieldChanged), for: .allEditingEvents)
        usernameTextField.addTarget(self, action: #selector(textFieldChanged), for: .allEditingEvents)
        apiKeyTextField.addTarget(self, action: #selector(textFieldChanged), for: .allEditingEvents)

        toggleTrustAllCertificates(trustAllCertificatesSwitch)

        trustAllCertificatesSwitch.addTarget(self, action: #selector(didToggleTrustAllCertificates), for: .valueChanged)
        switchAccountSwitch.addTarget(self, action: #selector(didToggleSwitchAccount), for: .valueChanged)

        textFields.forEach { $0.delegate = self }

        addDoneButtonInputAccessory(to: apiKeyTextField)
        toggleTrustAllCertificatesCell()

        switchAccountSwitch.isOn = shouldShowSwitchAccountToggle

        tableView.allowsSelection = false
        tableView.keyboardDismissMode = .interactive

        let tap = UITapGestureRecognizer(target: self, action: #selector(endEditing))
        view.addGestureRecognizer(tap)

        let text = NSMutableAttributedString(string: "See tutorial", attributes: [
            .foregroundColor: Constants.UI.skyBlue,
            NSAttributedString.Key.underlineStyle: NSUnderlineStyle.single.rawValue,
        ])
        seeTutorialButton.setAttributedTitle(text, for: .normal)
        seeTutorialButton.addTarget(self, action: #selector(showTutorial), for: .touchUpInside)
    }

    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        let bottomOffset = doneButtonContainer?.tableViewOffsetForDoneButton()
        tableView.contentInset = UIEdgeInsets(top: 0, left: 0,
                                              bottom: -(bottomOffset ?? 0), right: 0)
    }

    private func verify(account: Account, onSuccess: @escaping () -> Void) {
        doneButtonContainer?.setDoneButton(alpha: 0.7)
        doneButtonContainer?.setDoneButton(title: "Verifying...")

        verificationFailurePresenter?.hideVerificationFailure()

        _ = NetworkManager.manager.verifyAccount(userRequest: UserRequest.userRequestForJobList(account: account)) { error in
            DispatchQueue.main.async { [weak self] in
                self?.doneButtonContainer?.setDoneButton(alpha: 1.0)
                self?.doneButtonContainer?.setDoneButton(title: self?.actionButtonTitle ?? "Done")

                guard let error = error
                else { onSuccess(); return }

                self?.doneButtonContainer?.setDoneButton(enabled: false)
                self?.verificationFailurePresenter?.showVerificationFailure(error: error)
            }
        }
    }

    @objc private func toggleTrustAllCertificatesCell() {
        guard let url = createAccountURL()
        else { return }

        if url.scheme == "http" {
            trustAllCertificatesSwitch.setOn(false, animated: true)
            trustAllCertificatesSwitch.isEnabled = false
        } else {
            trustAllCertificatesSwitch.isEnabled = true
        }
        toggleTrustAllCertificates(trustAllCertificatesSwitch)
    }

    @objc private func dismissKeyboard() {
        tableView.endEditing(true)
    }

    @IBAction func toggleTrustAllCertificates(_: UISwitch) {
        doneButtonContainer?.setDoneButton(enabled: addButtonShouldBeEnabled())
    }

    @IBAction func deleteAccount(_: Any) {
        guard let alertImage = UIImage(named: "delete-account-illustration")
        else { return }
        let alert = alertWithImage(image: alertImage, title: "Delete Account", message: "Are you sure you want to delete this account?", height: 48)
        alert.addAction(UIAlertAction(title: "Delete", style: .destructive, handler: { [weak self] _ in
            self?.deleteAccountConfirmed()
        }))
        alert.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
        present(alert, animated: true, completion: nil)
    }

    private func deleteAccountConfirmed() {
        guard let account = account
        else { return }
        do {
            _ = try AccountManager.manager.deleteAccount(account: account)
            delegate?.didDeleteAccount(account: account)
        } catch {
            print("An error occurred deleting the current account: \(error)")
        }
    }

    private func prepareUI(for account: Account) {
        let url: URL

        if let port = account.port, var components = URLComponents(url: account.baseUrl, resolvingAgainstBaseURL: false) {
            components.port = port
            guard let urlWithPort = components.url
            else { return }
            url = urlWithPort
        } else {
            url = account.baseUrl
        }

        usernameTextField.text = account.username ?? ""
        apiKeyTextField.text = account.password ?? ""
        urlTextField.text = url.absoluteString
        trustAllCertificatesSwitch.isOn = account.trustAllCertificates
        deleteAccountCell.isHidden = false
        nameTextField?.text = account.displayName
    }

    private func prepareUIWithoutAccount() {
        usernameTextField.text = ""
        apiKeyTextField.text = ""
        urlTextField.placeholder = "https://jenkins.example.com:8080"
        deleteAccountCell.isHidden = true
    }

    @objc private func didToggleTrustAllCertificates() {
        doneButtonContainer?.setDoneButton(enabled: addButtonShouldBeEnabled())
    }

    @objc private func didToggleSwitchAccount() {
        doneButtonContainer?.setDoneButton(title: actionButtonTitle)
    }

    override func tableView(_: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        guard let section = Section(rawValue: indexPath.section)
        else { return 0 }
        return section.heightForRowInSection(account: account, showName: shouldShowNameField,
                                             shouldShowSwitchAccount: !isCurrentAccount && !isFirstAccount && shouldShowSwitchAccountToggle)
    }

    @objc private func showTutorial() {
        presentSafariForApiFAQItem()
    }

    // MARK: - Textfield methods

    @objc private func textFieldChanged() {
        doneButtonContainer?.setDoneButton(enabled: addButtonShouldBeEnabled())
        toggleTrustAllCertificatesCell()
    }

    func doneButtonPressed() {
        if account != nil {
            verifyAndSaveAccount()
        } else {
            verifyAndAddAccount()
        }
    }

    private func addButtonShouldBeEnabled() -> Bool {
        // Attention: a textField's text property is *never* nil, unless set to nil by the programmer

        // The urlTextField's text should be a valid URL
        // The port text field's text should either be empty or a valid integer
        guard urlTextField.text != nil, let url = URL(string: urlTextField.text!), let scheme = url.scheme
        else { return false }

        return Constants.SupportedSchemes(rawValue: scheme) != nil
    }

    private func addDoneButtonInputAccessory(to textField: UITextField) {
        let toolbar = UIToolbar(frame: CGRect(origin: .zero, size: CGSize(width: tableView.frame.width, height: 50)))
        let doneItem = UIBarButtonItem(title: "Done", style: .plain, target: textField, action: #selector(resignFirstResponder))
        doneItem.tintColor = Constants.UI.greyBlue
        toolbar.setItems([
            UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: nil, action: nil), doneItem,
        ], animated: false)
        textField.inputAccessoryView = toolbar
    }

    override func prepare(for segue: UIStoryboardSegue, sender _: Any?) {
        if var dest = segue.destination as? AccountProvidable {
            dest.account = createAccount()
        }
    }

    @objc private func endEditing() {
        view.endEditing(true)
    }
}

extension AddAccountTableViewController: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        if let index = textFields.firstIndex(of: textField), index.advanced(by: 1) < textFields.endIndex {
            textField.resignFirstResponder()
            textFields[index.advanced(by: 1)].becomeFirstResponder()
            return false
        } else {
            textField.resignFirstResponder()
        }

        return true
    }
}

extension AddAccountTableViewController {
    private func addOrUpdateAccount(account: Account) throws {
        if let oldAccount = self.account {
            try AccountManager.manager.editAccount(newAccount: account, oldAccount: oldAccount)
            delegate?.didEditAccount(account: account, oldAccount: oldAccount, useAsCurrentAccount: switchAccountSwitch.isOn || isFirstAccount)
        } else {
            try AccountManager.manager.addAccount(account: account)
            ApplicationUserManager.manager.save()
            delegate?.didEditAccount(account: account, oldAccount: nil, useAsCurrentAccount: switchAccountSwitch.isOn || isFirstAccount)
        }
    }
}

extension AddAccountTableViewController {
    private func presentSafariForApiFAQItem() {}
}
