//
//  AddProgressEntryWithPhotos.swift
//  TrainerMatch
//
//  Created by Ramone Hayes on 2/10/26.
//

import SwiftUI
import PhotosUI

// Extension to AddProgressEntryView with photo upload
struct AddProgressEntryWithPhotosView: View {
    let client: Client
    @ObservedObject var trainerVM: TrainerViewModel
    @Environment(\.dismiss) var dismiss
    
    @State private var entryDate = Date()
    @State private var weight = ""
    @State private var bodyFat = ""
    @State private var chest = ""
    @State private var waist = ""
    @State private var hips = ""
    @State private var thighs = ""
    @State private var arms = ""
    @State private var notes = ""
    
    // Progress Photos
    @State private var selectedPhotos: [PhotosPickerItem] = []
    @State private var progressImages: [UIImage] = []
    
    var body: some View {
        NavigationView {
            Form {
                Section(header: Text("Entry Details")) {
                    DatePicker("Date", selection: $entryDate, displayedComponents: .date)
                }
                
                Section(header: Text("Body Metrics")) {
                    HStack {
                        TextField("Weight", text: $weight)
                            .keyboardType(.decimalPad)
                        Text("kg")
                            .foregroundColor(.gray)
                    }
                    
                    HStack {
                        TextField("Body Fat %", text: $bodyFat)
                            .keyboardType(.decimalPad)
                        Text("%")
                            .foregroundColor(.gray)
                    }
                }
                
                Section(header: Text("Measurements (Optional)")) {
                    HStack {
                        TextField("Chest", text: $chest)
                            .keyboardType(.decimalPad)
                        Text("cm")
                            .foregroundColor(.gray)
                    }
                    
                    HStack {
                        TextField("Waist", text: $waist)
                            .keyboardType(.decimalPad)
                        Text("cm")
                            .foregroundColor(.gray)
                    }
                    
                    HStack {
                        TextField("Hips", text: $hips)
                            .keyboardType(.decimalPad)
                        Text("cm")
                            .foregroundColor(.gray)
                    }
                    
                    HStack {
                        TextField("Thighs", text: $thighs)
                            .keyboardType(.decimalPad)
                        Text("cm")
                            .foregroundColor(.gray)
                    }
                    
                    HStack {
                        TextField("Arms", text: $arms)
                            .keyboardType(.decimalPad)
                        Text("cm")
                            .foregroundColor(.gray)
                    }
                }
                
                // Progress Photos Section
                Section(header: Text("Progress Photos")) {
                    PhotosPicker(
                        selection: $selectedPhotos,
                        maxSelectionCount: 4,
                        matching: .images
                    ) {
                        HStack {
                            Image(systemName: "photo.on.rectangle.angled")
                                .font(.title2)
                                .foregroundColor(.tmGold)
                            
                            VStack(alignment: .leading, spacing: 4) {
                                Text("Add Progress Photos")
                                    .font(.headline)
                                    .foregroundColor(.tmGold)
                                
                                Text("Select up to 4 photos")
                                    .font(.caption)
                                    .foregroundColor(.gray)
                            }
                            
                            Spacer()
                            
                            if !progressImages.isEmpty {
                                Text("\(progressImages.count)")
                                    .font(.caption)
                                    .foregroundColor(.white)
                                    .padding(6)
                                    .background(Circle().fill(Color.tmGold))
                            }
                        }
                        .padding(.vertical, 8)
                    }
                    
                    // Display selected photos
                    if !progressImages.isEmpty {
                        ScrollView(.horizontal, showsIndicators: false) {
                            HStack(spacing: 12) {
                                ForEach(progressImages.indices, id: \.self) { index in
                                    ZStack(alignment: .topTrailing) {
                                        Image(uiImage: progressImages[index])
                                            .resizable()
                                            .scaledToFill()
                                            .frame(width: 120, height: 120)
                                            .clipShape(RoundedRectangle(cornerRadius: 10))
                                        
                                        // Remove button
                                        Button(action: {
                                            progressImages.remove(at: index)
                                            selectedPhotos.remove(at: index)
                                        }) {
                                            Image(systemName: "xmark.circle.fill")
                                                .font(.title3)
                                                .foregroundColor(.white)
                                                .background(Circle().fill(Color.black.opacity(0.6)))
                                        }
                                        .padding(8)
                                    }
                                }
                            }
                            .padding(.vertical, 8)
                        }
                    }
                    
                    Text("Tip: Take photos in good lighting, same pose and location for best comparison")
                        .font(.caption)
                        .foregroundColor(.gray)
                        .padding(.top, 4)
                }
                
                Section(header: Text("Notes")) {
                    TextEditor(text: $notes)
                        .frame(height: 100)
                }
            }
            .navigationTitle("Add Progress Entry")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    Button("Cancel") {
                        dismiss()
                    }
                }
                
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button("Save") {
                        saveProgressEntry()
                    }
                }
            }
            .onChange(of: selectedPhotos) { newPhotos in
                Task {
                    progressImages = []
                    for photo in newPhotos {
                        if let data = try? await photo.loadTransferable(type: Data.self),
                           let uiImage = UIImage(data: data) {
                            progressImages.append(uiImage)
                        }
                    }
                }
            }
        }
    }
    
    private func saveProgressEntry() {
        let measurements = BodyMeasurements(
            chest: Double(chest),
            waist: Double(waist),
            hips: Double(hips),
            thighs: Double(thighs),
            arms: Double(arms)
        )
        
        let hasAnyMeasurement = measurements.chest != nil || measurements.waist != nil ||
                                measurements.hips != nil || measurements.thighs != nil ||
                                measurements.arms != nil
        
        // In a real app, you'd upload images to server and get URLs
        let photoURLs = progressImages.isEmpty ? nil : progressImages.indices.map { "photo_\($0).jpg" }
        
        let entry = ProgressEntry(
            clientId: client.id,
            date: entryDate,
            weight: Double(weight),
            bodyFat: Double(bodyFat),
            measurements: hasAnyMeasurement ? measurements : nil,
            photoURLs: photoURLs,
            notes: notes.isEmpty ? nil : notes
        )
        
        trainerVM.addProgressEntry(entry)
        dismiss()
    }
}

#Preview {
    AddProgressEntryWithPhotosView(
        client: Client.sampleClients[0],
        trainerVM: TrainerViewModel()
    )
}
