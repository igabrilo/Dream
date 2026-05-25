import Foundation

struct JourneyStep: Identifiable, Hashable {
    let id = UUID()
    let stage: String
    let date: String
    let done: Bool
    let note: String
}

enum DreamStage: String {
    case idea = "Just an Idea"
    case early = "Early Progress"
    case needs = "Needs Help"
    case almost = "Almost There"
}

struct Dream: Identifiable, Hashable {
    let id: Int
    let name: String
    let handle: String
    let title: String
    let category: DreamCategory
    let stage: DreamStage
    let help: [String]
    let avatarSeed: Int
    let location: String
    let distance: String
    let desc: String
    let journey: [JourneyStep]
    let supporters: Int
    let offers: Int
    let viewsLabel: String

    static let samples: [Dream] = [
        .init(
            id: 1, name: "Maya Chen", handle: "maya.chen",
            title: "A quiet café for writers",
            category: .food, stage: .needs,
            help: ["Funding", "Design"], avatarSeed: 1,
            location: "Brooklyn, NY", distance: "2.4 km",
            desc: "I've been saving for five years. A tiny café where writers can work in peace — good coffee, long hours, no music. I know the space. I need help making it real.",
            journey: [
                .init(stage: "Sparked", date: "Jan 2024", done: true, note: "First sketches"),
                .init(stage: "Saved $30k", date: "Mar 2025", done: true, note: "Five years saving"),
                .init(stage: "Found space", date: "Feb 2026", done: true, note: "600 sqft on Bond St"),
                .init(stage: "First supporter", date: "Apr 2026", done: true, note: "Carpenter Sam offered to build the bar"),
                .init(stage: "Permits & build", date: "Q3 2026", done: false, note: "Need legal + design help"),
                .init(stage: "Open", date: "Spring 2027", done: false, note: "The dream"),
            ],
            supporters: 124, offers: 18, viewsLabel: "2.4k"
        ),
        .init(
            id: 2, name: "Dev Patel", handle: "dev.patel",
            title: "An app for lost pets",
            category: .tech, stage: .early,
            help: ["Coding", "Marketing"], avatarSeed: 2,
            location: "Austin, TX", distance: "8.1 km",
            desc: "Every year millions of pets go missing. I'm building a neighborhood-first app — photo in, AI matches, alerts nearby. MVP is live. Need an iOS dev who cares.",
            journey: [], supporters: 56, offers: 7, viewsLabel: "980"
        ),
        .init(
            id: 3, name: "Ana Ribeiro", handle: "ana.ribeiro",
            title: "Teaching kids to garden",
            category: .education, stage: .idea,
            help: ["Mentorship", "Funding"], avatarSeed: 3,
            location: "Oakland, CA", distance: "15 km",
            desc: "A weekend program for kids in my neighborhood. A small plot, a few tools, and the patience to teach them what my grandmother taught me.",
            journey: [], supporters: 12, offers: 3, viewsLabel: "412"
        ),
        .init(
            id: 4, name: "Jordan Wells", handle: "jordan.wells",
            title: "Bike shop for the unhoused",
            category: .impact, stage: .almost,
            help: ["Legal", "Funding"], avatarSeed: 4,
            location: "Portland, OR", distance: "22 km",
            desc: "Refurbish donated bikes. Give them free to people who need mobility to get to work. I have the space and 40 bikes waiting. I need help with the nonprofit paperwork.",
            journey: [], supporters: 240, offers: 31, viewsLabel: "5.1k"
        ),
    ]
}

extension Dream {
    func matched(against skills: [String]) -> String? {
        help.first(where: { skills.contains($0) })
    }
}
