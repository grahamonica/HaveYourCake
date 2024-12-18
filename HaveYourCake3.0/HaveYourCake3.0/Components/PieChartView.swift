//
//  PieChartView.swift
//  HaveYourCake3.0
//
//  Created by Monica Graham on 12/18/24.
//
//

import SwiftUI

struct PieChartView: View {
    var slices: [PieSliceData] // Data for each slice
    var onSliceTapped: (Int) -> Void // Closure to handle slice taps (index of the slice)

    var body: some View {
        GeometryReader { geometry in
            ZStack {
                // Draw all the slices
                ForEach(0..<slices.count, id: \.self) { index in
                    ZStack {
                        // The Pie Slice
                        Path { path in
                            let rect = geometry.frame(in: .local)
                            let center = CGPoint(x: rect.midX, y: rect.midY)
                            let radius = min(rect.width, rect.height) / 2

                            path.move(to: center)
                            path.addArc(center: center, radius: radius, startAngle: slices[index].startAngle, endAngle: slices[index].endAngle, clockwise: false)
                        }
                        .fill(slices[index].color)
                        .onTapGesture {
                            onSliceTapped(index) // Trigger the tap action
                        }

                        // Title Above Each Slice
                        if let position = sliceLabelPosition(for: index, in: geometry.size) {
                            Text(slices[index].label)
                                .font(.caption)
                                .foregroundColor(.primary)
                                .position(position)
                        }
                    }
                }
            }
        }
        .aspectRatio(1, contentMode: .fit) // Keep chart square
    }

    // MARK: - Helper Methods
    private func sliceLabelPosition(for index: Int, in size: CGSize) -> CGPoint? {
        let start = slices[index].startAngle.radians
        let end = slices[index].endAngle.radians
        let midAngle = (start + end) / 2
        let radius = min(size.width, size.height) * 0.6 / 2

        // Validate angles and radius to avoid NaN errors
        guard !midAngle.isNaN, !radius.isNaN else {
            print("Invalid angle or radius for slice \(index)")
            return nil
        }

        let x = size.width / 2 + CGFloat(cos(midAngle)) * radius
        let y = size.height / 2 + CGFloat(sin(midAngle)) * radius - 20
        return CGPoint(x: x, y: y)
    }
}

// MARK: - PieSliceData
struct PieSliceData {
    var startAngle: Angle
    var endAngle: Angle
    var color: Color
    var label: String
}

// MARK: - Preview
struct PieChartView_Previews: PreviewProvider {
    static var previews: some View {
        PieChartView(
            slices: [
                PieSliceData(startAngle: .degrees(0), endAngle: .degrees(90), color: .red, label: "List 1"),
                PieSliceData(startAngle: .degrees(90), endAngle: .degrees(180), color: .blue, label: "List 2"),
                PieSliceData(startAngle: .degrees(180), endAngle: .degrees(270), color: .green, label: "List 3"),
                PieSliceData(startAngle: .degrees(270), endAngle: .degrees(360), color: .yellow, label: "List 4")
            ],
            onSliceTapped: { index in
                print("Tapped on slice \(index)")
            }
        )
        .frame(width: 300, height: 300)
    }
}
