//
//  Constants.swift
//  JenkinsiOS
//
//  Created by Robert on 25.09.16.
//  Copyright © 2016 MobiLab Solutions. All rights reserved.
//

import Foundation
import UIKit

struct Constants {
    struct Defaults {
        /// The default port that should be used. 443 because the default protocol is https
        static let defaultPort = 443
        static let defaultReloadInterval: TimeInterval = 4

        static let apiTokenFAQItemId = "api_token"
        static let apiTokenFAQItem: FAQItem = {
            guard let url = URL(string: "https://mobilabsolutions.com/butler-tutorial/")
            else { fatalError("Could not initialize api token faq url!") }

            return FAQItem(key: Constants.Defaults.apiTokenFAQItemId, question: "How can I generate an API token?", url: url)
        }()
    }

    enum SupportedSchemes: String {
        case http
        case https
    }

    struct Paths {
        static let userPath = PersistenceUtils.getDocumentDirectory()!.appendingPathComponent("User")
        static let sharedUserPath = PersistenceUtils.getSharedDirectory()?.appendingPathComponent("Storage").appendingPathComponent("User")
        static let accountsPath = PersistenceUtils.getDocumentDirectory()!.appendingPathComponent("Account")
        static let sharedAccountsPath = PersistenceUtils.getSharedDirectory()?.appendingPathComponent("Storage").appendingPathComponent("Account")
    }

    struct Config {
        static var keychainAccessGroup: String? {
            return nil
        }
    }

    struct UI {
        static let defaultLabelFont = "Lato"
        static let paleGreyColor = UIColor(red: 229.0 / 255.0, green: 236.0 / 255.0, blue: 237.0 / 255.0, alpha: 1.0)
        static let darkGrey = UIColor(red: 140.0 / 255.0, green: 150.0 / 255.0, blue: 171.0 / 255.0, alpha: 1.0)
        static let silver = UIColor(red: 198.0 / 255.0, green: 203.0 / 255.0, blue: 213.0 / 255.0, alpha: 1.0)
        static let greyBlue = UIColor(red: 107.0 / 255.0, green: 120.0 / 255.0, blue: 151.0 / 255.0, alpha: 1.0)
        static let skyBlue = UIColor(red: 96.0 / 255.0, green: 205.0 / 255.0, blue: 1.0, alpha: 1.0)
        static let steel = UIColor(red: 108.0 / 255.0, green: 117.0 / 255.0, blue: 155.0 / 255.0, alpha: 1.0)
        static let backgroundColor = UIColor(red: 244.0 / 255.0, green: 245 / 255.0, blue: 248 / 255.0, alpha: 1.0)
        static let brightAqua = UIColor(red: 8.0 / 255.0, green: 232.0 / 255.0, blue: 222.0 / 255.0, alpha: 1.0)
        static let clearBlue = UIColor(red: 46.0 / 255.0, green: 126.0 / 255.0, blue: 242.0 / 255.0, alpha: 1.0)
        static let grapefruit = UIColor(red: 255.0 / 255.0, green: 98.0 / 255.0, blue: 96.0 / 255.0, alpha: 1.0)
        static let weirdGreen = UIColor(red: 59.0 / 255, green: 222.0 / 255, blue: 134.0 / 255, alpha: 1.0)
        static let veryLightBlue = UIColor(red: 225.0 / 255.0, green: 232.0 / 255.0, blue: 245.0 / 255.0, alpha: 1.0)
    }

    struct Identifiers {
        static let accountCell = "accountCell"
        static let jobCell = "jobCell"
        static let folderCell = "folderCell"
        static let buildCell = "buildCell"
        static let buildQueueCell = "buildQueueCell"
        static let favoritesCell = "favoritesCell"
        static let favoritesHeaderCell = "favoritesHeaderCell"
        static let jobsHeaderCell = "jobsHeaderCell"
        static let jenkinsCell = "jenkinsCell"
        static let staticBuildInfoCell = "staticBuildInfoCell"
        static let longBuildInfoCell = "longBuildInfoCell"
        static let moreInfoBuildCell = "moreInfoBuildCell"
        static let changeCell = "changeCell"
        static let testResultCell = "testResultCell"
        static let testResultErrorDetailsCell = "testResultErrorDetailsCell"
        static let computerCell = "computerCell"
        static let pluginCell = "pluginCell"
        static let userCell = "userCell"
        static let artifactsCell = "artifactsCell"
        static let parameterCell = "parameterCell"
        static let buildsFilteringCell = "buildsFilteringCell"
        static let titleCell = "titleCell"
        static let jobOverViewCell = "jobOverViewCell"
        static let specialBuildCell = "specialBuildCell"
        static let headerCell = "headerCell"
        static let settingsCell = "settingsCell"
        static let actionCell = "actionCell"
        static let buildCauseCell = "buildCauseCell"
        static let dependencyDataCell = "dependencyDataCell"
        static let creationCell = "creationCell"
        static let faqCell = "faqCell"
        static let detailContentCell = "detailContentCell"

        static let actionHeader = "actionHeader"

        static let showJobsSegue = "showJobsSegue"
        static let showJobSegue = "showJobSegue"
        static let showBuildsSegue = "showBuildsSegue"
        static let showBuildSegue = "showBuildSegue"
        static let showBuildQueueSegue = "showBuildQueueSegue"
        static let showJenkinsSegue = "showJenkinsSegue"
        static let showConsoleOutputSegue = "showConsoleOutputSegue"
        static let showChangesSegue = "showChangesSegue"
        static let showTestResultsSegue = "showTestResultsSegue"
        static let showTestResultSegue = "showTestResultSegue"
        static let showComputersSegue = "showComputersSegue"
        static let showComputerSegue = "showComputerSegue"
        static let showUsersSegue = "showUsersSegue"
        static let showPluginsSegue = "showPluginsSegue"
        static let editAccountSegue = "editAccountSegue"
        static let showArtifactsSegue = "showArtifactsSegue"
        static let showFolderSegue = "showFolderSegue"
        static let showParametersSegue = "showParametersSegue"
        static let didAddAccountSegue = "didAddAccountSegue"
        static let showInformationSegue = "showInformationSegue"
        static let showAccountsSegue = "showAccountsSegue"
        static let showUserSegue = "showUserSegue"
        static let showPluginSegue = "showPluginSegue"
        static let githubAccountSegue = "githubAccountSegue"
        static let aboutSegue = "aboutSegue"
        static let faqSegue = "FAQSegue"

        static let favoritesShortcutItemType = "com.mobilabsolutions.favorites.shortcutItem"

        static let currentAccountBaseUrlUserDefaultsKey = "currentAccountBaseUrlUserDefaultsKey"

        static let favoriteStatusToggledNotification: Notification.Name = .init(rawValue: "favoriteStatusToggledNotification")

        static let remoteConfigNewAccountDesignKey = "new_account_design_active"
        static let remoteConfigShowDisplayNameFieldKey = "display_name_field_active"
        static let remoteConfigFAQListKey = "faq_item_list"
    }

    struct JSON {
        static let allViews = "All"
        static let views = "views"
        static let name = "name"
        static let url = "url"
        static let jobs = "jobs"
        static let color = "color"
        static let builds = "builds"
        static let firstBuild = "firstBuild"
        static let absoluteUrl = "absoluteUrl"
        static let fullName = "fullName"
        static let blocked = "blocked"
        static let buildable = "buildable"
        static let id = "id"
        static let inQueueSince = "inQueueSince"
        static let params = "params"
        static let stuck = "stuck"
        static let why = "why"
        static let task = "task"
        static let buildableStartMilliseconds = "buildableStartMilliseconds"
        static let actions = "actions"
        static let items = "items"
        static let age = "age"
        static let className = "className"
        static let duration = "duration"
        static let errorDetails = "errorDetails"
        static let errorStackTrace = "errorStackTrace"
        static let failedSince = "failedSince"
        static let skipped = "skipped"
        static let skippedMessage = "skippedMessage"
        static let status = "status"
        static let stdout = "stdout"
        static let stderr = "stderr"
        static let reportUrl = "reportUrl"
        static let cases = "cases"
        static let timestamp = "timestamp"
        static let number = "number"
        static let empty = "empty"
        static let failCount = "failCount"
        static let passCount = "passCount"
        static let skipCount = "skipCount"
        static let suites = "suites"
        static let child = "child"
        static let result = "result"
        static let totalCount = "totalCount"
        static let childReports = "childReports"
        static let urlName = "urlName"
        static let active = "active"
        static let shortName = "shortName"
        static let bundled = "bundled"
        static let deleted = "deleted"
        static let downgradable = "downgradable"
        static let enabled = "enabled"
        static let hasUpdate = "hasUpdate"
        static let longName = "longName"
        static let pinned = "pinned"
        static let supportsDynamicLoad = "supportsDynamicLoad"
        static let version = "version"
        static let dependencies = "dependencies"
        static let optional = "optional"
        static let plugins = "plugins"
        static let description = "description"
        static let nodeDescription = "nodeDescription"
        static let mode = "mode"
        static let nodeName = "nodeName"
        static let lastChange = "lastChange"
        static let project = "project"
        static let user = "user"
        static let users = "users"
        static let availablePhysicalMemory = "availablePhysicalMemory"
        static let availableSwapSpace = "availableSwapSpace"
        static let totalPhysicalMemory = "totalPhysicalMemory"
        static let totalSwapSpace = "totalSwapSpace"
        static let artifacts = "artifacts"
        static let fileName = "fileName"
        static let relativePath = "relativePath"
        static let crumb = "crumb"
        static let crumbRequestField = "crumbRequestField"
        static let type = "type"
        static let defaultParameterValue = "defaultParameterValue"
        static let value = "value"
        static let parameterDefinitions = "parameterDefinitions"
        static let property = "property"
        static let choices = "choices"
        static let projectName = "projectName"
    }

    struct Networking {
        static let successCodes = [200, 201, 202, 203, 204, 205, 206, 207, 208, 226]
    }

    struct API {
        static let consoleOutput = "/consoleText"
        static let jobListAdditionalQueryItems = [
            URLQueryItem(name: "tree", value: "views[name,url,jobs[name,url,color,healthReport[description,score,iconClassName],lastBuild[timestamp,number,url]]],nodeDescription,nodeName,mode,description"),
        ]
        static let jobListQuietingDownAdditionalQueryItems = [
            URLQueryItem(name: "tree", value: "quietingDown"),
        ]
        static let jobAdditionalQueryItems: [URLQueryItem] = {
            let changeSetFields = "kind,items[commitId,timestamp,comment,date,msg,affectedPaths,author[absoluteUrl,fullName]]"
            let buildFields = "duration,timestamp,fullDisplayName,result,id,url,artifacts,actions,number,artifacts[fileName,relativePath],changeSet[\(changeSetFields)],changeSets[\(changeSetFields)]"
            return [
                URLQueryItem(name: "tree", value: "color,url,name,healthReport[description,score,iconClassName],lastBuild[\(buildFields)],lastStableBuild[\(buildFields)],lastSuccessfulBuild[\(buildFields)],lastCompletedBuilds[\(buildFields)],builds[\(buildFields)],property[parameterDefinitions[*]],actions[*[*]]"),
        ] }()

        static let jobBuildIdsAdditionalQueryItems: [URLQueryItem] = [URLQueryItem(name: "tree", value: "builds[id]")]

        static let testReport = "/testReport"
        static let testReportAdditionalQueryItems = [
            URLQueryItem(name: "tree", value: "suites[name,cases[className,name,status]],childReports[child[url],result[suites[name,cases[className,name,status]],failCount,passCount,skipCount]],failCount,skipCount,passCount,totalCount"),
        ]
        static let buildQueue = "/queue"
        static let buildQueueAdditionalQueryItems = [URLQueryItem(name: "tree", value: "items[url,why,blocked,buildable,id,inQueueSince,params,stuck,task[name,url,color,healthReport[description,score,iconClassName]],actions[causes[shortDescription,userId,username],failCount,skipCount,totalCount,urlName],buildableStartMilliseconds]")]
        static let computer = "/computer"
        static let plugins = "/pluginManager"
        static let pluginsAdditionalQueryItems = [
            URLQueryItem(name: "depth", value: "2"),
        ]
        static let users = "/asynchPeople"
        static let usersAdditionalQueryItems = [
            URLQueryItem(name: "tree", value: "users[*,user[id,fullName,description,absoluteUrl]]"),
        ]
        static let artifact = "/artifact"
        static let crumbIssuer = "/crumbIssuer"

        static let quietDown = "/quietDown"
        static let cancelQuietDown = "/cancelQuietDown"
        static let restart = "/restart"
        static let safeRestart = "/safeRestart"
        static let exit = "/exit"
        static let safeExit = "/safeExit"
        static let gitPlugin = "/descriptorByName/net.uaznia.lukanus.hudson.plugins.gitparameter.GitParameterDefinition/fillValueItems"
        static func gitPluginAdditionalQueryItems(parameter: Parameter) -> [URLQueryItem]  {
            return [URLQueryItem(name: "param", value: parameter.name)]
        }
    }
}
