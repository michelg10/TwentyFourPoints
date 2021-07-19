import SwiftUI
struct SizePreferenceKey: PreferenceKey {
    static var defaultValue: CGSize = .zero
    static func reduce(value: inout CGSize, nextValue: () -> CGSize) {}
}

extension View {
    func readSize(onChange: @escaping (CGSize) -> Void) -> some View {
        background(
            GeometryReader { geometryProxy in
                Color.clear
                    .preference(key: SizePreferenceKey.self, value: geometryProxy.size)
            }
        )
        .onPreferenceChange(SizePreferenceKey.self, perform: onChange)
    }
}

struct TruncableText: View {
    let text: Text
    let lineLimit: Int?
    @State private var intrinsicSize: CGSize = .zero
    @State private var truncatedSize: CGSize = .zero
    let isTruncatedUpdate: (_ isTruncated: Bool) -> Void
    
    var body: some View {
        text
            .lineLimit(lineLimit)
            .readSize { size in
                truncatedSize = size
                isTruncatedUpdate(truncatedSize != intrinsicSize)
            }
            .background(
                text
                    .fixedSize(horizontal: false, vertical: true)
                    .hidden()
                    .readSize { size in
                        intrinsicSize = size
                        isTruncatedUpdate(truncatedSize != intrinsicSize)
                    }
            )
    }
}

struct dynamicAdjustText: View {
    @State var isTruncated: Bool=false
    var beginTxt: String
    var flexTxt: String
    var endTxt: String
    var font: Font
    var txtColor: Color
    var body: some View {
        HStack(spacing:0) {
            Text(beginTxt)
                .foregroundColor(txtColor)
                .font(font)
                .lineLimit(1)
                .fixedSize(horizontal: true, vertical: true)
            if !isTruncated {
                TruncableText(text: Text(flexTxt)
                                .font(font)
                                .foregroundColor(txtColor),
                              lineLimit: 1
                ) {
                    isTruncated = $0
                }
            }
            Text(endTxt)
                .foregroundColor(txtColor)
                .font(font)
                .lineLimit(1)
                .fixedSize(horizontal: true, vertical: true)
        }
    }
}
