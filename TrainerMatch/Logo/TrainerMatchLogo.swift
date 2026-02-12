//
//  TrainerMatchLogo.swift
//  TrainerMatch
//
//  Created by Ramone Hayes on 2/10/26.
//

import SwiftUI

// MARK: - Consistent TrainerMatch Logo Component
struct TrainerMatchLogo: View {
    var size: LogoSize = .medium
    
    enum LogoSize {
        case small, medium, large
        
        var dimension: CGFloat {
            switch self {
            case .small: return 60
            case .medium: return 100
            case .large: return 120
            }
        }
        
        var dumbbellSize: CGFloat {
            switch self {
            case .small: return 20
            case .medium: return 32
            case .large: return 38
            }
        }
        
        var dumbbellOffset: CGFloat {
            switch self {
            case .small: return -5
            case .medium: return -8
            case .large: return -10
            }
        }
    }
    
    var body: some View {
        ZStack {
            // Black circle background (invisible but creates the solid look)
            Circle()
                .fill(Color.black)
                .frame(width: size.dimension, height: size.dimension)
            
            // Map pin (black) - layered on top
            Image(systemName: "mappin.circle.fill")
                .font(.system(size: size.dimension))
                .foregroundColor(.black)
            
            // White dumbbell inside
            Image(systemName: "dumbbell")
                .font(.system(size: size.dumbbellSize))
                .foregroundColor(.white)
                .offset(y: size.dumbbellOffset)
        }
    }
}

#Preview {
    VStack(spacing: 40) {
        TrainerMatchLogo(size: .small)
        TrainerMatchLogo(size: .medium)
        TrainerMatchLogo(size: .large)
    }
    .padding()
    .background(Color.gray)
}
