//
//  SettingsScreen.swift
//  BookNook
//
//  Created by Riley Jenum on 13/05/24.
//

import SwiftUI

struct SettingsScreen: View {
    @State private var isProVersion = false
    @State private var showPaywall = false

    var body: some View {
        NavigationView {
            Form {
                Section(header: Text("Profile")) {
                    NavigationLink(destination: ProfileSettingsView()) {
                        Text("Profile Settings")
                    }
                }

                Section(header: Text("Reading Preferences")) {
                    NavigationLink(destination: ReadingGoalsView()) {
                        Text("Reading Goals")
                    }
                    NavigationLink(destination: PreferredGenresView()) {
                        Text("Preferred Genres")
                    }
                    NavigationLink(destination: NotificationSettingsView()) {
                        Text("Notifications")
                    }
                }

                Section(header: Text("App Appearance")) {
                    NavigationLink(destination: ThemeSettingsView()) {
                        Text("Theme")
                    }
                    NavigationLink(destination: FontSizeSettingsView()) {
                        Text("Font Size")
                    }
                    NavigationLink(destination: LayoutSettingsView()) {
                        Text("Layout")
                    }
                }

                Section(header: Text("Account Management")) {
                    if isProVersion {
                        Text("You are a Pro user!")
                    } else {
                        Button(action: {
                            showPaywall = true
                        }) {
                            Text("Upgrade to Pro")
                        }
                    }
                    Button(action: {
                        // Restore purchases action
                    }) {
                        Text("Restore Purchases")
                    }
                    NavigationLink(destination: BillingInformationView()) {
                        Text("Billing Information")
                    }
                }

                Section(header: Text("Data Management")) {
                    NavigationLink(destination: BackupRestoreView()) {
                        Text("Backup & Restore")
                    }
                    NavigationLink(destination: ExportDataView()) {
                        Text("Export Data")
                    }
                    NavigationLink(destination: ClearDataView()) {
                        Text("Clear Data")
                    }
                }

                Section(header: Text("Support and Feedback")) {
                    NavigationLink(destination: HelpCenterView()) {
                        Text("Help Center")
                    }
                    NavigationLink(destination: ContactSupportView()) {
                        Text("Contact Support")
                    }
                    NavigationLink(destination: FeedbackView()) {
                        Text("Feedback")
                    }
                }

                Section(header: Text("Legal and Privacy")) {
                    NavigationLink(destination: TermsOfServiceView()) {
                        Text("Terms of Service")
                    }
                    NavigationLink(destination: PrivacyPolicyView()) {
                        Text("Privacy Policy")
                    }
                    NavigationLink(destination: DataUsageView()) {
                        Text("Data Usage")
                    }
                }

                Section(header: Text("Other Settings")) {
                    NavigationLink(destination: LanguageSettingsView()) {
                        Text("Language")
                    }
                    NavigationLink(destination: SyncSettingsView()) {
                        Text("Sync Settings")
                    }
                }
            }
            .navigationTitle("Settings")
            .sheet(isPresented: $showPaywall) {
                PaywallView()
            }
        }
    }
}

// Placeholder Views for Navigation
struct ProfileSettingsView: View { var body: some View { Text("Profile Settings") } }
struct ReadingGoalsView: View { var body: some View { Text("Reading Goals") } }
struct PreferredGenresView: View { var body: some View { Text("Preferred Genres") } }
struct NotificationSettingsView: View { var body: some View { Text("Notifications") } }
struct ThemeSettingsView: View { var body: some View { Text("Theme Settings") } }
struct FontSizeSettingsView: View { var body: some View { Text("Font Size Settings") } }
struct LayoutSettingsView: View { var body: some View { Text("Layout Settings") } }
struct BillingInformationView: View { var body: some View { Text("Billing Information") } }
struct BackupRestoreView: View { var body: some View { Text("Backup & Restore") } }
struct ExportDataView: View { var body: some View { Text("Export Data") } }
struct ClearDataView: View { var body: some View { Text("Clear Data") } }
struct HelpCenterView: View { var body: some View { Text("Help Center") } }
struct ContactSupportView: View { var body: some View { Text("Contact Support") } }
struct FeedbackView: View { var body: some View { Text("Feedback") } }
struct TermsOfServiceView: View { var body: some View { Text("Terms of Service") } }
struct PrivacyPolicyView: View { var body: some View { Text("Privacy Policy") } }
struct DataUsageView: View { var body: some View { Text("Data Usage") } }
struct LanguageSettingsView: View { var body: some View { Text("Language Settings") } }
struct SyncSettingsView: View { var body: some View { Text("Sync Settings") } }
struct PaywallView: View { var body: some View { Text("Paywall") } }

struct SettingsScreen_Previews: PreviewProvider {
    static var previews: some View {
        SettingsScreen()
    }
}
