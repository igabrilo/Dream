import SwiftUI

/// Procedurally generated circular avatar using a seed-derived gradient + initials.
struct Avatar: View {
    let name: String
    let seed: Int
    var size: CGFloat = 40

    private var initials: String {
        let parts = name.split(separator: " ").prefix(2)
        return parts.compactMap { $0.first.map(String.init) }.joined().uppercased()
    }

    private var colors: [Color] {
        let palette: [(UInt32, UInt32)] = [
            (0xF4B074, 0xC8632B),
            (0x8EC5DD, 0x3A7FA8),
            (0xC9A8E0, 0x7448A8),
            (0x9FD9B4, 0x2F7A52),
            (0xF1D27A, 0xB07908),
        ]
        let pair = palette[abs(seed) % palette.count]
        return [Color(hex: pair.0), Color(hex: pair.1)]
    }

    var body: some View {
        ZStack {
            LinearGradient(colors: colors, startPoint: .topLeading, endPoint: .bottomTrailing)
            Text(initials)
                .font(.system(size: size * 0.4, weight: .semibold, design: .rounded))
                .foregroundStyle(.white)
        }
        .frame(width: size, height: size)
        .clipShape(Circle())
    }
}
