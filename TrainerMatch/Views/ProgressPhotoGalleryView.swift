//
//  ProgressPhotoGalleryView.swift
//  TrainerMatch
//
//  Created by Ramone Hayes on 2/10/26.
//

import SwiftUI

struct ProgressPhotoGalleryView: View {
    let client: Client
    let progressEntries: [ProgressEntry]
    @State private var selectedEntry: ProgressEntry?
    
    var entriesWithPhotos: [ProgressEntry] {
        progressEntries.filter { $0.photoURLs != nil && !$0.photoURLs!.isEmpty }
    }
    
    var body: some View {
        ScrollView {
            VStack(spacing: 24) {
                // Header
                VStack(spacing: 8) {
                    Text("\(client.name)'s Progress")
                        .font(.title2)
                        .fontWeight(.bold)
                    
                    if !entriesWithPhotos.isEmpty {
                        Text("\(entriesWithPhotos.count) photo entries")
                            .font(.subheadline)
                            .foregroundColor(.secondary)
                    }
                }
                .padding(.top)
                
                if entriesWithPhotos.isEmpty {
                    // Empty State
                    VStack(spacing: 16) {
                        Image(systemName: "photo.on.rectangle.angled")
                            .font(.system(size: 60))
                            .foregroundColor(.gray)
                        
                        Text("No Progress Photos Yet")
                            .font(.headline)
                            .foregroundColor(.secondary)
                        
                        Text("Add progress entries with photos to track \(client.name)'s transformation journey")
                            .font(.subheadline)
                            .foregroundColor(.gray)
                            .multilineTextAlignment(.center)
                            .padding(.horizontal, 40)
                    }
                    .padding(.vertical, 60)
                } else {
                    // Timeline View
                    LazyVStack(spacing: 20) {
                        ForEach(entriesWithPhotos.sorted(by: { $0.date > $1.date })) { entry in
                            ProgressPhotoCard(entry: entry, client: client)
                                .onTapGesture {
                                    selectedEntry = entry
                                }
                        }
                    }
                    .padding(.horizontal)
                }
            }
            .padding(.bottom, 20)
        }
        .navigationTitle("Progress Photos")
        .navigationBarTitleDisplayMode(.inline)
        .sheet(item: $selectedEntry) { entry in
            ProgressPhotoDetailView(entry: entry, client: client)
        }
    }
}

// MARK: - Progress Photo Card
struct ProgressPhotoCard: View {
    let entry: ProgressEntry
    let client: Client
    
    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            // Date Header
            HStack {
                VStack(alignment: .leading, spacing: 4) {
                    Text(entry.date.formatted(date: .long, time: .omitted))
                        .font(.headline)
                    
                    if let weight = entry.weight {
                        Text("\(String(format: "%.1f", weight)) kg")
                            .font(.subheadline)
                            .foregroundColor(.secondary)
                    }
                }
                
                Spacer()
                
                if let bodyFat = entry.bodyFat {
                    VStack(alignment: .trailing, spacing: 4) {
                        Text("Body Fat")
                            .font(.caption)
                            .foregroundColor(.gray)
                        Text("\(String(format: "%.1f", bodyFat))%")
                            .font(.headline)
                            .foregroundColor(.tmGold)
                    }
                }
            }
            
            // Photos Grid
            if let photoURLs = entry.photoURLs {
                ScrollView(.horizontal, showsIndicators: false) {
                    HStack(spacing: 12) {
                        ForEach(photoURLs.indices, id: \.self) { index in
                            PhotoThumbnail(photoURL: photoURLs[index])
                        }
                    }
                }
            }
            
            // Notes
            if let notes = entry.notes, !notes.isEmpty {
                Text(notes)
                    .font(.subheadline)
                    .foregroundColor(.secondary)
                    .lineLimit(2)
            }
        }
        .padding()
        .background(
            RoundedRectangle(cornerRadius: 15)
                .fill(Color(.systemBackground))
                .shadow(color: .black.opacity(0.1), radius: 5, x: 0, y: 2)
        )
    }
}

// MARK: - Photo Thumbnail
struct PhotoThumbnail: View {
    let photoURL: String
    
    var body: some View {
        ZStack {
            RoundedRectangle(cornerRadius: 10)
                .fill(
                    LinearGradient(
                        colors: [Color.blue.opacity(0.3), Color.purple.opacity(0.3)],
                        startPoint: .topLeading,
                        endPoint: .bottomTrailing
                    )
                )
                .frame(width: 120, height: 160)
            
            // Placeholder - in real app would load actual image
            Image(systemName: "photo.fill")
                .font(.title)
                .foregroundColor(.white)
        }
    }
}

// MARK: - Progress Photo Detail View
struct ProgressPhotoDetailView: View {
    let entry: ProgressEntry
    let client: Client
    @Environment(\.dismiss) var dismiss
    
    var body: some View {
        NavigationView {
            ScrollView {
                VStack(spacing: 24) {
                    // Date and Stats
                    VStack(spacing: 16) {
                        Text(entry.date.formatted(date: .long, time: .omitted))
                            .font(.title3)
                            .fontWeight(.semibold)
                        
                        // Stats Grid
                        LazyVGrid(columns: [GridItem(.flexible()), GridItem(.flexible())], spacing: 16) {
                            if let weight = entry.weight {
                                StatCard(title: "Weight", value: "\(String(format: "%.1f", weight)) kg", color: .tmGold)
                            }
                            
                            if let bodyFat = entry.bodyFat {
                                StatCard(title: "Body Fat", value: "\(String(format: "%.1f", bodyFat))%", color: .tmBlack)
                            }
                            
                            if let measurements = entry.measurements {
                                if let chest = measurements.chest {
                                    StatCard(title: "Chest", value: "\(String(format: "%.1f", chest)) cm", color: .tmGold)
                                }
                                if let waist = measurements.waist {
                                    StatCard(title: "Waist", value: "\(String(format: "%.1f", waist)) cm", color: .tmBlack)
                                }
                                if let hips = measurements.hips {
                                    StatCard(title: "Hips", value: "\(String(format: "%.1f", hips)) cm", color: .tmGold)
                                }
                                if let thighs = measurements.thighs {
                                    StatCard(title: "Thighs", value: "\(String(format: "%.1f", thighs)) cm", color: .tmBlack)
                                }
                            }
                        }
                    }
                    .padding()
                    
                    // Full Size Photos
                    if let photoURLs = entry.photoURLs {
                        VStack(alignment: .leading, spacing: 12) {
                            Text("Photos")
                                .font(.headline)
                                .padding(.horizontal)
                            
                            ForEach(photoURLs.indices, id: \.self) { index in
                                ZStack {
                                    RoundedRectangle(cornerRadius: 15)
                                        .fill(
                                            LinearGradient(
                                                colors: [Color.blue.opacity(0.3), Color.purple.opacity(0.3)],
                                                startPoint: .topLeading,
                                                endPoint: .bottomTrailing
                                            )
                                        )
                                        .frame(height: 400)
                                    
                                    // Placeholder - in real app would load actual image
                                    VStack(spacing: 12) {
                                        Image(systemName: "photo.fill")
                                            .font(.system(size: 60))
                                            .foregroundColor(.white)
                                        
                                        Text("Photo \(index + 1)")
                                            .font(.headline)
                                            .foregroundColor(.white)
                                    }
                                }
                                .padding(.horizontal)
                            }
                        }
                    }
                    
                    // Notes
                    if let notes = entry.notes, !notes.isEmpty {
                        VStack(alignment: .leading, spacing: 8) {
                            Text("Notes")
                                .font(.headline)
                            
                            Text(notes)
                                .font(.body)
                                .foregroundColor(.secondary)
                        }
                        .frame(maxWidth: .infinity, alignment: .leading)
                        .padding()
                        .background(
                            RoundedRectangle(cornerRadius: 15)
                                .fill(Color(.systemGray6))
                        )
                        .padding(.horizontal)
                    }
                }
                .padding(.vertical)
            }
            .navigationTitle("Progress Details")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button("Done") {
                        dismiss()
                    }
                }
            }
        }
    }
}

// MARK: - Stat Card
struct StatCard: View {
    let title: String
    let value: String
    let color: Color
    
    var body: some View {
        VStack(spacing: 8) {
            Text(title)
                .font(.caption)
                .foregroundColor(.gray)
            
            Text(value)
                .font(.title3)
                .fontWeight(.bold)
                .foregroundColor(color)
        }
        .frame(maxWidth: .infinity)
        .padding()
        .background(
            RoundedRectangle(cornerRadius: 12)
                .fill(Color(.systemGray6))
        )
    }
}

#Preview {
    NavigationView {
        ProgressPhotoGalleryView(
            client: Client.sampleClients[0],
            progressEntries: ProgressEntry.sampleEntries
        )
    }
}
