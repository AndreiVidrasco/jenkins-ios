//
//  MainTabBarViewController.swift
//  JenkinsiOS
//
//  Created by Robert on 07.08.18.
//  Copyright © 2018 MobiLab Solutions. All rights reserved.
//

import UIKit

class MainTabBarViewController: UITabBarController, AccountProvidable, CurrentAccountProviding, CurrentAccountProvidingDelegate {
    weak var currentAccountDelegate: CurrentAccountProvidingDelegate?

    var account: Account? {
        didSet {
            if oldValue == nil && account != nil {
                updateSelectedAccountProvidable()
            }
        }
    }

    private let childItems: [ChildItem] = [.nodes, .buildQueue, .jobs, .actions, .settings]

    enum ChildItem: String {
        case nodes
        case buildQueue
        case jobs
        case actions
        case settings

        var imageName: String {
            return rawValue
        }

        var selectedImageName: String {
            return rawValue + "Selected"
        }
    }

    private let handler = OnBoardingHandler()

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        if handler.shouldStartOnBoarding() {
            handler.startOnBoarding(on: self, delegate: self)
        } else if handler.shouldShowAccountCreationViewController() {
            let navigationController = UINavigationController()
            present(navigationController, animated: false, completion: nil)
            handler.showAccountCreationViewController(on: navigationController, delegate: self)
        }
    }

    override func awakeFromNib() {
        super.awakeFromNib()
        sharedInit()
        tabBar.items?.enumerated().forEach({ index, item in
            item.image = UIImage(named: childItems[index].imageName)?.withRenderingMode(.alwaysOriginal)
            item.selectedImage = UIImage(named: childItems[index].selectedImageName)?.withRenderingMode(.alwaysOriginal)
        })
    }

    private func sharedInit() {
        guard let viewControllers = viewControllers
        else { return }
        selectedIndex = min(viewControllers.count - 1, 2)
    }

    override func setViewControllers(_ viewControllers: [UIViewController]?, animated: Bool) {
        updateAccountProvidableViewControllers(viewControllers: viewControllers)
        super.setViewControllers(viewControllers, animated: animated)
    }

    private func updateSelectedAccountProvidable() {
        if var accountProvidable = selectedViewController as? AccountProvidable {
            accountProvidable.account = account
        }

        if var currentAccountProviding = selectedViewController as? CurrentAccountProviding {
            currentAccountProviding.currentAccountDelegate = self
        }
    }

    private func updateAccountProvidableViewControllers(viewControllers: [UIViewController]?) {
        viewControllers?.forEach({ viewController in
            if var accountProvidable = viewController as? AccountProvidable {
                accountProvidable.account = account
            }

            if var currentAccountProviding = viewController as? CurrentAccountProviding {
                currentAccountProviding.currentAccountDelegate = self
            }
        })
    }

    override var selectedViewController: UIViewController? {
        didSet {
            updateSelectedAccountProvidable()
        }
    }

    override var selectedIndex: Int {
        didSet {
            updateSelectedAccountProvidable()
        }
    }

    func didChangeCurrentAccount(current: Account) {
        account = current
        updateAccountProvidableViewControllers(viewControllers: viewControllers)
        currentAccountDelegate?.didChangeCurrentAccount(current: current)
    }
}

extension MainTabBarViewController: OnBoardingDelegate {
    func didFinishOnboarding(didAddAccount _: Bool) {
        dismiss(animated: true, completion: nil)
    }
}

extension MainTabBarViewController: AccountDeletionNotified {
    func didDeleteAccount(account: Account) {
        viewControllers?.forEach {
            if let deletionDelegate = $0 as? AccountDeletionNotified {
                deletionDelegate.didDeleteAccount(account: account)
            }
        }
    }
}
