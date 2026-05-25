import SwiftUI

struct DiscoverScreen: View {
    @State private var index: Int = 0
    @State private var supporterMode: Bool = true
    @State private var supporterSkills: [String] = ["Design", "Funding"]
    @State private var presentedDream: Dream?
    @State private var helpForDream: Dream?

    private var dream: Dream { Dream.samples[index % Dream.samples.count] }

    var body: some View {
        ZStack {
            Color.black.ignoresSafeArea()

            ScenePoster(category: dream.category)
                .ignoresSafeArea()
                .id(dream.id)
                .transition(.opacity)

            topGradient
            bottomGradient

            VStack(alignment: .leading, spacing: 0) {
                topBar
                if supporterMode {
                    supporterBanner.padding(.top, 10)
                }
                if let matchedSkill = dream.matched(against: supporterSkills), supporterMode {
                    matchBadge(matchedSkill).padding(.top, 10)
                }
                Spacer()
            }
            .padding(.top, 8)
            .padding(.horizontal, 16)

            HStack(alignment: .bottom) {
                bottomInfo
                Spacer(minLength: 12)
                rightRail
            }
            .padding(.horizontal, 16)
            .padding(.bottom, 130)
        }
        .contentShape(Rectangle())
        .fullScreenCover(item: $presentedDream) { d in
            DreamDetailScreen(
                dream: d,
                onBack: { presentedDream = nil },
                onHelp: {
                    presentedDream = nil
                    helpForDream = d
                }
            )
        }
        .sheet(item: $helpForDream) { d in
            HelpSheet(dream: d, onClose: { helpForDream = nil })
        }
        .gesture(
            DragGesture(minimumDistance: 30)
                .onEnded { value in
                    if value.translation.height < -60 {
                        withAnimation(.easeInOut(duration: 0.35)) {
                            index = (index + 1) % Dream.samples.count
                        }
                    } else if value.translation.height > 60 {
                        withAnimation(.easeInOut(duration: 0.35)) {
                            index = (index - 1 + Dream.samples.count) % Dream.samples.count
                        }
                    }
                }
        )
    }

    // MARK: - Pieces

    private var topGradient: some View {
        LinearGradient(
            colors: [.black.opacity(0.55), .clear],
            startPoint: .top, endPoint: .bottom
        )
        .frame(height: 220)
        .frame(maxHeight: .infinity, alignment: .top)
        .ignoresSafeArea()
        .allowsHitTesting(false)
    }

    private var bottomGradient: some View {
        LinearGradient(
            colors: [.clear, .black.opacity(0.65)],
            startPoint: .top, endPoint: .bottom
        )
        .frame(height: 320)
        .frame(maxHeight: .infinity, alignment: .bottom)
        .ignoresSafeArea()
        .allowsHitTesting(false)
    }

    private var topBar: some View {
        HStack {
            Text("Dream")
                .font(DreamTheme.Font.display(28, weight: .light, italic: true))
                .foregroundStyle(DreamTheme.blue)
                .tracking(-0.8)
                .shadow(color: DreamTheme.blue.opacity(0.6), radius: 8)
                .shadow(color: .white.opacity(0.3), radius: 16)

            Spacer()

            Button(action: {}) {
                Image(systemName: "slider.horizontal.3")
                    .font(.system(size: 17, weight: .semibold))
                    .foregroundStyle(.white)
                    .frame(width: 40, height: 40)
                    .background(Color.white.opacity(0.16), in: Circle())
                    .background(.ultraThinMaterial, in: Circle())
                    .overlay(Circle().strokeBorder(Color.white.opacity(0.25), lineWidth: 0.5))
            }
            .buttonStyle(.plain)
        }
    }

    private var supporterBanner: some View {
        HStack(spacing: 8) {
            Circle()
                .fill(Color(hex: 0x8AD3A7))
                .frame(width: 8, height: 8)
                .shadow(color: Color(hex: 0x8AD3A7), radius: 4)
            Text("Supporter mode · matching")
                .font(DreamTheme.Font.text(12))
                .foregroundStyle(.white.opacity(0.9))
            Spacer(minLength: 8)
            HStack(spacing: 4) {
                ForEach(supporterSkills, id: \.self) { s in
                    Text(s)
                        .font(DreamTheme.Font.text(11, weight: .semibold))
                        .foregroundStyle(.white)
                        .padding(.horizontal, 8)
                        .padding(.vertical, 2)
                        .background(Color.white.opacity(0.2), in: Capsule())
                }
            }
        }
        .padding(.horizontal, 12)
        .padding(.vertical, 8)
        .background(Color.white.opacity(0.14), in: RoundedRectangle(cornerRadius: 12))
        .background(.ultraThinMaterial, in: RoundedRectangle(cornerRadius: 12))
        .overlay(
            RoundedRectangle(cornerRadius: 12)
                .strokeBorder(Color.white.opacity(0.25), lineWidth: 0.5)
        )
    }

    private func matchBadge(_ skill: String) -> some View {
        HStack(spacing: 6) {
            Image(systemName: "star.fill")
                .font(.system(size: 11, weight: .bold))
            Text("\(skill) match")
                .font(DreamTheme.Font.text(12, weight: .bold))
        }
        .foregroundStyle(Color(hex: 0x1F4731))
        .padding(.horizontal, 12)
        .padding(.vertical, 6)
        .background(Color(hex: 0x8AD3A7), in: Capsule())
        .shadow(color: .black.opacity(0.2), radius: 8, y: 4)
        .frame(maxWidth: .infinity, alignment: .leading)
    }

    private var bottomInfo: some View {
        VStack(alignment: .leading, spacing: 12) {
            HStack(spacing: 8) {
                CategoryBadge(category: dream.category, dark: true)
                HStack(spacing: 4) {
                    Text("◐")
                    Text(dream.stage.rawValue)
                }
                .font(DreamTheme.Font.text(12, weight: .semibold))
                .foregroundStyle(.white)
                .padding(.horizontal, 10)
                .padding(.vertical, 4)
                .background(Color.white.opacity(0.18), in: Capsule())
                .overlay(Capsule().strokeBorder(Color.white.opacity(0.3), lineWidth: 0.5))
            }

            HStack(spacing: 8) {
                Text("@\(dream.handle)")
                    .font(DreamTheme.Font.text(14, weight: .medium))
                    .foregroundStyle(.white.opacity(0.92))
                Circle().fill(.white.opacity(0.5)).frame(width: 3, height: 3)
                Text(dream.distance)
                    .font(DreamTheme.Font.text(14))
                    .foregroundStyle(.white.opacity(0.8))
            }

            Button { presentedDream = dream } label: {
                Text(dream.title)
                    .font(DreamTheme.Font.display(30, weight: .regular))
                    .tracking(-0.6)
                    .foregroundStyle(.white)
                    .shadow(color: .black.opacity(0.4), radius: 6, y: 1)
                    .lineLimit(3)
                    .multilineTextAlignment(.leading)
                    .fixedSize(horizontal: false, vertical: true)
            }
            .buttonStyle(.plain)

            Rectangle()
                .fill(dream.category.palette.fg)
                .frame(width: 36, height: 3)
                .clipShape(Capsule())
                .shadow(color: dream.category.palette.fg.opacity(0.7), radius: 6)

            Text(descriptionWithMore)
                .font(DreamTheme.Font.text(13))
                .foregroundStyle(.white.opacity(0.9))
                .lineSpacing(2)
                .lineLimit(2)
        }
        .frame(maxWidth: .infinity, alignment: .leading)
        .frame(maxWidth: 280, alignment: .leading)
    }

    private var descriptionWithMore: AttributedString {
        let snippet = String(dream.desc.prefix(90)) + "... "
        var s = AttributedString(snippet)
        s.foregroundColor = .white.opacity(0.9)
        var more = AttributedString("more")
        more.foregroundColor = .white.opacity(0.7)
        more.font = DreamTheme.Font.text(13, weight: .semibold)
        return s + more
    }

    private var rightRail: some View {
        VStack(spacing: 16) {
            let matched = dream.matched(against: supporterSkills) != nil && supporterMode
            ActionButton(
                systemImage: "heart.fill",
                label: matched ? "Offer \(dream.matched(against: supporterSkills) ?? "")" : "I can help",
                highlight: matched,
                action: { helpForDream = dream }
            )
            ActionButton(systemImage: "arrowshape.turn.up.right.fill", label: "124")
            ActionButton(systemImage: "bookmark.fill", label: "Save")

            Avatar(name: dream.name, seed: dream.avatarSeed, size: 40)
                .padding(2)
                .overlay(
                    Circle().strokeBorder(
                        matched ? Color(hex: 0x8AD3A7) : .white,
                        lineWidth: matched ? 2.5 : 2
                    )
                )
                .shadow(color: matched ? Color(hex: 0x8AD3A7).opacity(0.7) : .clear, radius: 8)
        }
    }
}

#Preview {
    DiscoverScreen()
}
