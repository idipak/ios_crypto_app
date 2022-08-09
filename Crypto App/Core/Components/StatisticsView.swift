//
//  StatisticsView.swift
//  Crypto App
//
//  Created by Xcode on 09/08/22.
//

import SwiftUI

struct StatisticsView: View {
    let stats: StatisticModel
    
    var body: some View {
        VStack(alignment: .leading, spacing: 4){
            Text(stats.title)
                .font(.caption)
                .foregroundColor(Color.theme.secondaryText)
            Text(stats.value)
                .font(.headline)
                .foregroundColor(Color.theme.accent)
            HStack {
                Image(systemName: "triangle.fill")
                    .font(.caption2)
                    .rotationEffect(Angle(degrees:
                                            (stats.percentChange ?? 0) >= 0 ? 0 : 180))
                Text(stats.percentChange?.asPercentString() ?? "")
                    .font(.caption)
                .bold()
            }
            .foregroundColor((stats.percentChange ?? 0) >= 0 ? Color.theme.green : Color.theme.red)
            .opacity(stats.percentChange == nil ? 0.0 : 1.0)
        }
    }
}

struct StatisticsView_Previews: PreviewProvider {
    static var previews: some View {
        Group{
            StatisticsView(stats: dev.stats1)
                .previewLayout(.sizeThatFits)
                .preferredColorScheme(.dark)
            StatisticsView(stats: dev.stats2)
                .previewLayout(.sizeThatFits)
            StatisticsView(stats: dev.stats3)
                .previewLayout(.sizeThatFits)
        }
    }
}
