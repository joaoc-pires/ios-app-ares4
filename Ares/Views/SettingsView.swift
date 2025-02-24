//
//  SettingsView.swift
//  Ares
//
//  Created by Joao Pires on 26/01/2025.
//

import SwiftUI
import MessageUI
import OPML
import SafariServices
import QuickLook

struct SettingsView: View {
    @Environment(\.openURL)             private var openURL
    
    // AppSettings
    @AppStorage("openLinksInApp")       var openLinksInApp = true
    @AppStorage("openLinksInReader")    var openLinksInReader = true
    @AppStorage("hideUnreadMarker")     var hideUnreadMarker = false
    @AppStorage("themeColor")           var themeColor = "pink"
    
    @State private var mailResult: Result<MFMailComposeResult, Error>? = nil
    
    @State private var opmlFile: OPMLFile?
    @State private var loadingOPML = false
    @State private var loadingOPMLError = false
    @State private var showMailError = false
    @State private var showMailView = false
    @State private var showExporter = false
    
    @State private var logFileURL: URL?
        
    @State private var showDeleteCacheWarning = false
    
    var body: some View {
        List {
            Section {
                Button(action: didTapThemes) {
                    HStack {
                        Text("Themes".localized)
                        Spacer()
                        Image(systemName: "chevron.right")
                            .foregroundColor(Color(uiColor: .secondaryLabel))
                    }
                    .contentShape(Rectangle())
                }
                .buttonStyle(.plain)
                Button(action: didTapFilters) {
                    HStack {
                        Text("Filters".localized)
                        Spacer()
                        Image(systemName: "chevron.right")
                            .foregroundColor(Color(uiColor: .secondaryLabel))
                    }
                    .contentShape(Rectangle())
                }
                .buttonStyle(.plain)
                Toggle(isOn: $openLinksInApp) {
                    Text("Open links in app".localized)
                }
                .toggleStyle(SwitchToggleStyle(tint: ThemeType(rawValue: themeColor)!.color))
                Toggle(isOn: $openLinksInReader) {
                    Text("Open links in 'Reader Mode'".localized)
                }
                .toggleStyle(SwitchToggleStyle(tint: ThemeType(rawValue: themeColor)!.color))
                .disabled(!openLinksInApp)
                .opacity(!openLinksInApp ? 0.5 : 1)
            } header: {
                Text("General".localized)
            }
            Section {
                Toggle(isOn: $hideUnreadMarker) {
                    Text("Hide unread markers".localized)
                }
                .toggleStyle(SwitchToggleStyle(tint: ThemeType(rawValue: themeColor)!.color))
                Button(action: { /*navigationStack.append(.notifications)*/ }) {
                    HStack {
                        Text("Notifications".localized)
                        Spacer()
                        Image(systemName: "chevron.right")
                            .foregroundColor(Color(uiColor: .secondaryLabel))
                    }
                    .contentShape(Rectangle())
                }
                .buttonStyle(.plain)
                if opmlFile != nil {
                    Button(action: exportOPML) {
                        HStack {
                            Text("Export OPML".localized)
                            Spacer()
                            ProgressView()
                                .foregroundStyle(ThemeType(rawValue: themeColor)!.color)
                                .opacity(loadingOPML ? 1 : 0)
                            Image(systemName: "chevron.right")
                                .foregroundColor(Color(uiColor: .secondaryLabel))
                        }
                        .contentShape(Rectangle())
                    }
                    .buttonStyle(.plain)
                    .disabled(loadingOPML || loadingOPMLError)
                }
                Button(action: deleteCacheWarning) {
                    HStack {
                        Text("Delete Cache".localized)
                        Spacer()
                        Image(systemName: "chevron.right")
                            .foregroundColor(Color(uiColor: .secondaryLabel))
                    }
                    .contentShape(Rectangle())
                }
                .buttonStyle(.plain)
            } header: {
                Text("Feeds".localized)
            }
            Section {
                Button(action: didTapSendFeedback) {
                    HStack {
                        Text("Send feedback".localized)
                        Spacer()
                        Image(systemName: "chevron.right")
                            .foregroundColor(Color(uiColor: .secondaryLabel))
                    }
                    .contentShape(Rectangle())
                }
                .buttonStyle(.plain)
                Button(action: didTapPrivacy) {
                    HStack {
                        Text("Privacy Policy".localized)
                        Spacer()
                        Image(systemName: "chevron.right")
                            .foregroundColor(Color(uiColor: .secondaryLabel))
                    }
                    .contentShape(Rectangle())
                }
                .buttonStyle(.plain)
                Button(action: didTapTerms) {
                    HStack {
                        Text("Terms of Use".localized)
                        Spacer()
                        Image(systemName: "chevron.right")
                            .foregroundColor(Color(uiColor: .secondaryLabel))
                    }
                    .contentShape(Rectangle())
                }
                .buttonStyle(.plain)
                Button(action: didTapLibraries) {
                    HStack {
                        Text("Open Source Libraries".localized)
                        Spacer()
                        Image(systemName: "chevron.right")
                            .foregroundColor(Color(uiColor: .secondaryLabel))
                    }
                    .contentShape(Rectangle())
                }
                .buttonStyle(.plain)
                Button(action: { previewLogs() }) {
                    HStack {
                        Text("Logs".localized)
                        Spacer()
                        Image(systemName: "chevron.right")
                            .foregroundColor(Color(uiColor: .secondaryLabel))
                    }
                    .contentShape(Rectangle())
                }
                .buttonStyle(.plain)
                .quickLookPreview($logFileURL)
            } header: {
                Text("About".localized)
            } footer: {
                VStack(alignment: .center) {
                    HStack {
                        Spacer()
                        VStack(alignment: .center, spacing: 0) {
                            Text("Ares - RSS Reader")
                                .font(.caption)
                                .foregroundColor(Color(uiColor: .secondaryLabel))
                            Text("João Pires")
                                .font(.caption)
                                .foregroundColor(Color(uiColor: .secondaryLabel))
                            Text("\(Bundle.main.releaseVersion)-\(Bundle.main.buildVersion)")
                                .font(.caption2)
                                .foregroundColor(Color(uiColor: .tertiaryLabel))
                        }
                        Spacer()
                    }
                    .padding(.top)
                }
            }
        }
        .navigationTitle("Settings")
        .navigationBarTitleDisplayMode(.inline)
        .onAppear(perform: prepareOPML)
        .alert(isPresented: $showMailError) {
            Alert(title: Text("Error!"), message: Text("Couldn't send email"))
        }
        .alert("Delete Cache?", isPresented: $showDeleteCacheWarning, actions: {
            Button(role: .cancel, action: {}) {
                Text("Cancel")
            }
            Button(role: .destructive, action: confirmedDeleteCache) {
                Text("Delete")
            }
        }, message: {
            Text("Are you sure you want to continue?\nThis will delete all unsaved entries, but keep the feeds.")
        })
        //            .navigationDestination(for: SettingsNavigationType.self) { destination in
        //                switch destination {
        //                    case .themes: ThemesView()
        //                    case .libraryList: LibraryListView()
        //                    case .notifications: NotificationsView()
        //                    case .library(let library): LibraryView(library: library)
        //                    case .logs: LogView()
        //                    default: EmptyView()
        //                }
        //            }
        .sheet(isPresented: $showMailView) {
            MailView(result: self.$mailResult)
        }
        .fileExporter(isPresented: $showExporter, document: opmlFile, contentType: .plainText) { result in
            switch result {
                case .success(let url):
                    print("Saved to \(url)")
                case .failure(let error):
                    print(error.localizedDescription)
            }
        }
    }
    
    private func didTapThemes() {
        //navigationStack.append(.themes)
    }
    
    private func didTapFilters() {
        //navigationStack.append(.filters)
    }
    
    private func prepareOPML() {
        //        loadingOPML = true
        //        loadingOPMLError = false
        //        Task {
        //            do {
        //                let xmlString = try await dataManager.createOPML()
        //                await MainActor.run {
        //                    opmlFile = OPMLFile(initialText: xmlString)
        //                    loadingOPML = false
        //                    loadingOPMLError = false
        //                }
        //            }
        //            catch let error as NSError {
        //                await MainActor.run {
        //                    loadingOPML = false
        //                    loadingOPMLError = true
        //                    log.error("Failed to export feed with error: '\(error.localizedDescription)'")
        //                    log.error("Error details: '\(error.userInfo)'")
        //                }
        //            }
        //        }
    }
    
    private func exportOPML() {
        showExporter = true
    }
    
    private func didTapSendFeedback() {
        if MFMailComposeViewController.canSendMail() {
            showMailView = true
        }
        else {
            showMailError = true
        }
    }
    
    private func didTapPrivacy() {
        //        openURL(url: WebRounterType.privacy.url)
    }
    
    private func didTapTerms() {
        //        openURL(url: WebRounterType.terms.url)
    }
    
    private func deleteCacheWarning() {
        showDeleteCacheWarning = true
    }
    
    private func confirmedDeleteCache() {
        //        dataManager.deleteCache()
        //        NotificationCenter.default.post(name: .globalDismissViews, object: nil)
    }
    
    private func didTapLibraries() {
        //        navigationStack.append(.libraryList)
    }
    
    private func openURL(url: URL) {
        //        if settingsManager.openLinksInApp {
        //            let config = SFSafariViewController.Configuration()
        //            config.entersReaderIfAvailable = settingsManager.openLinksInReader
        //            let safariViewController = SFSafariViewController(url: url, configuration: config)
        //            safariViewController.preferredControlTintColor = settingsManager.theme.uiColor
        //            UIApplication.topController?.show(safariViewController, sender: self)
        //        }
        //        else {
        //            openURL(url)
        //        }
    }
    
    private func previewLogs() {
        logFileURL = URL.logFile
    }
    
}
