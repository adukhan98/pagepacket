import SwiftUI

struct ShareView: View {
    @EnvironmentObject private var workspace: WorkspaceStore
    @State private var email = ""
    @State private var role: InviteRole = .editor
    @State private var feedback: String?

    var body: some View {
        VStack(alignment: .leading, spacing: 14) {
            SectionHeader(title: "Review Packet", icon: "shippingbox")
            Text("Create a local checkpoint and manage invite intents for this Pagepacket workspace. Invite records stay in `.pagepacket/shares/invites.json`; no email is sent by Pagepacket.")
                .font(.callout)
                .foregroundStyle(GraftTheme.body)

            VStack(alignment: .leading, spacing: 10) {
                Text(workspace.selectedFile?.relativePath ?? "No file selected")
                    .font(.callout.weight(.semibold))
                    .foregroundStyle(GraftTheme.ink)
                    .lineLimit(2)

                Text("\(workspace.pendingChangeSets.count) pending agent edits in this workspace")
                    .font(.caption)
                    .foregroundStyle(GraftTheme.muted)

                Button {
                    workspace.createReviewPacket()
                } label: {
                    Label("Create Packet Checkpoint", systemImage: "archivebox")
                }
                .buttonStyle(.borderedProminent)
            }
            .graftCard()

            VStack(spacing: 10) {
                TextField("teammate@example.com", text: $email)
                    .textFieldStyle(.roundedBorder)
                GraftSegmentedControl(
                    items: InviteRole.allCases.map { ($0, $0.title) },
                    selection: $role
                )
                Button {
                    switch workspace.addInvite(email: email, role: role) {
                    case .added:
                        email = ""
                        feedback = nil
                    case .invalidEmail:
                        feedback = "Enter a valid email address."
                    case .duplicate:
                        feedback = "That invite is already listed."
                    }
                } label: {
                    Label("Add Invite", systemImage: "paperplane")
                }
                .buttonStyle(.borderedProminent)
                .frame(maxWidth: .infinity, alignment: .trailing)
                if let feedback {
                    Text(feedback)
                        .font(.caption)
                        .foregroundStyle(GraftTheme.pink)
                        .frame(maxWidth: .infinity, alignment: .leading)
                }
            }
            .graftCard()

            if workspace.pendingChangeSets.isEmpty {
                Text("No pending edits to include yet.")
                    .font(.callout)
                    .foregroundStyle(GraftTheme.muted)
                    .graftCard()
            } else {
                ForEach(workspace.pendingChangeSets) { changeSet in
                    HStack(spacing: 10) {
                        Image(systemName: changeSet.status == .conflict ? "exclamationmark.triangle" : "doc.text.magnifyingglass")
                            .foregroundStyle(changeSet.status == .conflict ? GraftTheme.pink : GraftTheme.teal)
                            .frame(width: 28, height: 28)
                        VStack(alignment: .leading, spacing: 2) {
                            Text(changeSet.summary)
                                .foregroundStyle(GraftTheme.ink)
                            Text("\(changeSet.authorName) - \(changeSet.filePath)")
                                .font(.caption)
                                .foregroundStyle(GraftTheme.muted)
                        }
                        Spacer()
                        Button {
                            workspace.focus(changeSet)
                        } label: {
                            Label("Show review", systemImage: "arrow.right")
                                .labelStyle(.iconOnly)
                        }
                        .buttonStyle(.plain)
                        .help("Show review")
                        .accessibilityLabel("Show review for \(changeSet.summary)")
                    }
                    .graftCard()
                }
            }

            if workspace.invites.isEmpty {
                Text("No invite intents saved yet.")
                    .font(.callout)
                    .foregroundStyle(GraftTheme.muted)
                    .graftCard()
            } else {
                ForEach(workspace.invites) { invite in
                    HStack(spacing: 10) {
                        Circle()
                            .fill(roleColor(invite.role))
                            .frame(width: 28, height: 28)
                            .overlay {
                                Text(String(invite.email.prefix(1)).uppercased())
                                    .font(.caption.weight(.bold))
                            }
                        VStack(alignment: .leading, spacing: 2) {
                            Text(invite.email)
                                .foregroundStyle(GraftTheme.ink)
                            Text(invite.role.title)
                                .font(.caption)
                                .foregroundStyle(GraftTheme.muted)
                        }
                        Spacer()
                        Button {
                            workspace.composeEmail(for: invite)
                        } label: {
                            Image(systemName: "envelope")
                        }
                        .buttonStyle(.plain)
                        .help("Compose email invite")
                        Button {
                            workspace.removeInvite(invite)
                        } label: {
                            Image(systemName: "xmark")
                        }
                        .buttonStyle(.plain)
                    }
                    .graftCard()
                }
            }
        }
    }

    private func roleColor(_ role: InviteRole) -> Color {
        switch role {
        case .viewer: GraftTheme.lavender
        case .commenter: GraftTheme.ochre
        case .editor: GraftTheme.mint
        }
    }
}
