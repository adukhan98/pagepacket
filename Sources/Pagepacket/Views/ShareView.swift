import SwiftUI

struct ShareView: View {
    @EnvironmentObject private var workspace: WorkspaceStore
    @State private var email = ""
    @State private var role: InviteRole = .editor

    var body: some View {
        VStack(alignment: .leading, spacing: 14) {
            SectionHeader(title: "Email Invites", icon: "person.2")
            Text("V1 writes invite intent to `.pagepacket/shares/invites.json`. A cloud backend can later turn these same records into real memberships.")
                .font(.callout)
                .foregroundStyle(PagepacketTheme.muted)

            VStack(spacing: 10) {
                TextField("teammate@example.com", text: $email)
                    .textFieldStyle(.roundedBorder)
                Picker("Role", selection: $role) {
                    ForEach(InviteRole.allCases) { role in
                        Text(role.title).tag(role)
                    }
                }
                .pickerStyle(.segmented)
                Button {
                    workspace.addInvite(email: email, role: role)
                    email = ""
                } label: {
                    Label("Add Invite", systemImage: "paperplane")
                }
                .buttonStyle(.borderedProminent)
                .frame(maxWidth: .infinity, alignment: .trailing)
            }
            .pagepacketCard()

            ForEach(workspace.invites) { invite in
                HStack(spacing: 10) {
                    Circle()
                        .fill(roleColor(invite.role))
                        .frame(width: 28, height: 28)
                        .overlay {
                            Text(String(invite.email.prefix(1)).uppercased())
                                .font(.caption.weight(.bold))
                                .foregroundStyle(PagepacketTheme.ink)
                        }
                    VStack(alignment: .leading, spacing: 2) {
                        Text(invite.email)
                            .foregroundStyle(PagepacketTheme.ink)
                        Text(invite.role.title)
                            .font(.caption)
                            .foregroundStyle(PagepacketTheme.muted)
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
                .pagepacketCard()
            }
        }
    }

    private func roleColor(_ role: InviteRole) -> Color {
        switch role {
        case .viewer: PagepacketTheme.lavender
        case .commenter: PagepacketTheme.ochre
        case .editor: PagepacketTheme.mint
        }
    }
}
