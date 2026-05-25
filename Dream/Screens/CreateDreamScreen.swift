import SwiftUI

private enum CreateStep { case source, details }

struct CreateDreamScreen: View {
    var onClose: () -> Void = {}
    var onPublish: () -> Void = {}

    @State private var step: CreateStep = .source
    @State private var title: String = ""
    @State private var category: DreamCategory?
    @State private var stage: DreamStage?
    @State private var helpNeeded: Set<String> = []
    @State private var desc: String = ""
    @State private var hasMedia: Bool = false

    private let helps = ["Coding", "Design", "Funding", "Mentorship", "Marketing", "Legal"]

    var body: some View {
        NavigationStack {
            VStack(spacing: 0) {
                switch step {
                case .source: sourceStep
                case .details: detailsStep
                }
            }
            .background(Color.white.ignoresSafeArea())
            .navigationTitle(step == .source ? "Share your dream" : "Dream details")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .topBarLeading) {
                    if step == .details {
                        Button { step = .source } label: {
                            Image(systemName: "chevron.left")
                                .font(.system(size: 16, weight: .semibold))
                                .foregroundStyle(DreamTheme.ink)
                        }
                    }
                }
                ToolbarItem(placement: .topBarTrailing) {
                    Button(action: onClose) {
                        Image(systemName: "xmark")
                            .font(.system(size: 14, weight: .semibold))
                            .foregroundStyle(DreamTheme.ink2)
                        }
                }
            }
        }
    }

    // MARK: - Source step

    private var sourceStep: some View {
        VStack(alignment: .leading, spacing: 0) {
            Text("What's your dream?")
                .font(DreamTheme.Font.display(32, weight: .regular))
                .tracking(-0.7)
                .foregroundStyle(DreamTheme.ink)
                .padding(.top, 16)
                .padding(.bottom, 8)

            Text("A short video is the best way to share it. Speak from the heart — supporters listen.")
                .font(DreamTheme.Font.text(15))
                .foregroundStyle(DreamTheme.ink2)
                .lineSpacing(3)
                .padding(.bottom, 28)

            sourceCard(
                icon: "video.fill",
                title: "Record video",
                sub: "Up to 60 seconds · Vertical",
                tinted: true
            ) {
                hasMedia = true
                step = .details
            }
            .padding(.bottom, 12)

            sourceCard(
                icon: "photo.on.rectangle",
                title: "Choose from library",
                sub: "Pick an existing video",
                tinted: false
            ) {
                hasMedia = true
                step = .details
            }

            Spacer()

            HStack(alignment: .top, spacing: 10) {
                Text("💡")
                VStack(alignment: .leading, spacing: 4) {
                    Text("Simon's advice")
                        .font(DreamTheme.Font.text(13, weight: .bold))
                        .foregroundStyle(Color(hex: 0x7A5F3E))
                    Text("Start with why. What would this dream mean to you if it came true?")
                        .font(DreamTheme.Font.text(13))
                        .foregroundStyle(Color(hex: 0x7A5F3E))
                        .lineSpacing(2)
                }
            }
            .padding(16)
            .frame(maxWidth: .infinity, alignment: .leading)
            .background(RoundedRectangle(cornerRadius: 14).fill(DreamTheme.warm))
            .padding(.top, 16)
        }
        .padding(.horizontal, 20)
        .padding(.bottom, 24)
    }

    private func sourceCard(icon: String, title: String, sub: String, tinted: Bool, action: @escaping () -> Void) -> some View {
        Button(action: action) {
            HStack(spacing: 16) {
                ZStack {
                    RoundedRectangle(cornerRadius: 16)
                        .fill(tinted ? Color.white : DreamTheme.bg)
                        .shadow(color: tinted ? DreamTheme.blue.opacity(0.15) : .clear, radius: 12, y: 4)
                    Image(systemName: icon)
                        .font(.system(size: 24, weight: .semibold))
                        .foregroundStyle(DreamTheme.blue)
                }
                .frame(width: 56, height: 56)

                VStack(alignment: .leading, spacing: 3) {
                    Text(title)
                        .font(DreamTheme.Font.text(17, weight: .semibold))
                        .foregroundStyle(DreamTheme.ink)
                    Text(sub)
                        .font(DreamTheme.Font.text(13))
                        .foregroundStyle(DreamTheme.ink2)
                }
                Spacer()
            }
            .padding(20)
            .background(
                RoundedRectangle(cornerRadius: 20)
                    .fill(tinted
                          ? LinearGradient(colors: [DreamTheme.blueSoft, .white], startPoint: .topLeading, endPoint: .bottomTrailing)
                          : LinearGradient(colors: [.white, .white], startPoint: .top, endPoint: .bottom))
            )
            .overlay(
                RoundedRectangle(cornerRadius: 20)
                    .strokeBorder(tinted ? DreamTheme.blue : DreamTheme.line, lineWidth: 1.5)
            )
        }
        .buttonStyle(.plain)
    }

    // MARK: - Details step

    private var detailsStep: some View {
        VStack(spacing: 0) {
            ScrollView {
                VStack(alignment: .leading, spacing: 20) {
                    videoPreview

                    field("Title") {
                        TextField("e.g. A quiet café for writers", text: $title)
                            .font(DreamTheme.Font.text(15))
                            .padding(14)
                            .background(RoundedRectangle(cornerRadius: 14).fill(DreamTheme.bg))
                            .overlay(RoundedRectangle(cornerRadius: 14).strokeBorder(DreamTheme.line, lineWidth: 1))
                    }

                    field("Category") {
                        FlowLayout(spacing: 8, lineSpacing: 8) {
                            ForEach(DreamCategory.allCases, id: \.self) { c in
                                chip(label: c.rawValue, selected: category == c) {
                                    category = (category == c) ? nil : c
                                }
                            }
                        }
                    }

                    field("Stage") {
                        FlowLayout(spacing: 8, lineSpacing: 8) {
                            ForEach([DreamStage.idea, .early, .needs, .almost], id: \.rawValue) { s in
                                chip(label: s.rawValue, selected: stage == s) {
                                    stage = (stage == s) ? nil : s
                                }
                            }
                        }
                    }

                    field("Help needed") {
                        FlowLayout(spacing: 8, lineSpacing: 8) {
                            ForEach(helps, id: \.self) { h in
                                chip(label: h, selected: helpNeeded.contains(h)) {
                                    if helpNeeded.contains(h) { helpNeeded.remove(h) } else { helpNeeded.insert(h) }
                                }
                            }
                        }
                    }

                    field("Description (optional)") {
                        TextField("Share more about your dream...", text: $desc, axis: .vertical)
                            .font(DreamTheme.Font.text(15))
                            .lineLimit(4...10)
                            .padding(14)
                            .frame(minHeight: 100, alignment: .topLeading)
                            .background(RoundedRectangle(cornerRadius: 14).fill(DreamTheme.bg))
                            .overlay(RoundedRectangle(cornerRadius: 14).strokeBorder(DreamTheme.line, lineWidth: 1))
                    }
                }
                .padding(20)
                .padding(.bottom, 20)
            }

            Divider().background(DreamTheme.line)
            PrimaryButton(
                title: "Publish dream",
                background: canPublish ? (category?.palette.fg ?? DreamTheme.blue) : DreamTheme.ink3,
                action: { if canPublish { onPublish() } }
            )
            .disabled(!canPublish)
            .padding(.horizontal, 20)
            .padding(.top, 14)
            .padding(.bottom, 24)
            .background(Color.white)
        }
    }

    private var canPublish: Bool {
        !title.isEmpty && category != nil && stage != nil && !helpNeeded.isEmpty
    }

    private var videoPreview: some View {
        ZStack {
            ScenePoster(category: category ?? .tech)
                .aspectRatio(16.0/9.0, contentMode: .fill)
                .clipShape(RoundedRectangle(cornerRadius: 16))

            Circle()
                .fill(Color.black.opacity(0.4))
                .background(.ultraThinMaterial, in: Circle())
                .frame(width: 52, height: 52)
                .overlay(
                    Image(systemName: "play.fill")
                        .font(.system(size: 20, weight: .semibold))
                        .foregroundStyle(.white)
                        .offset(x: 2)
                )

            VStack {
                HStack {
                    Spacer()
                    Button("Re-record") { step = .source }
                        .font(DreamTheme.Font.text(12, weight: .semibold))
                        .foregroundStyle(.white)
                        .padding(.horizontal, 12)
                        .padding(.vertical, 6)
                        .background(Color.black.opacity(0.5), in: Capsule())
                }
                Spacer()
            }
            .padding(10)
        }
        .frame(maxWidth: .infinity)
        .aspectRatio(16.0/9.0, contentMode: .fit)
    }

    @ViewBuilder
    private func field<Content: View>(_ label: String, @ViewBuilder content: () -> Content) -> some View {
        VStack(alignment: .leading, spacing: 10) {
            Text(label.uppercased())
                .font(DreamTheme.Font.text(11, weight: .bold))
                .tracking(1.2)
                .foregroundStyle(DreamTheme.ink2)
            content()
        }
    }

    private func chip(label: String, selected: Bool, action: @escaping () -> Void) -> some View {
        Button(action: action) {
            Text(label)
                .font(DreamTheme.Font.text(13, weight: .semibold))
                .foregroundStyle(selected ? .white : DreamTheme.ink)
                .padding(.horizontal, 14)
                .padding(.vertical, 9)
                .background(Capsule().fill(selected ? DreamTheme.blue : Color.white))
                .overlay(Capsule().strokeBorder(selected ? DreamTheme.blue : DreamTheme.line, lineWidth: 1.5))
        }
        .buttonStyle(.plain)
    }
}

#Preview {
    CreateDreamScreen()
}
