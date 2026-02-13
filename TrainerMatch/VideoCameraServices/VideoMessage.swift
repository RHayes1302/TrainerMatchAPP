//
//  VideoMessage.swift
//  TrainerMatch
//
//  Created by Ramone Hayes on 2/12/26.
//

//
//  VideoMessage.swift
//  TrainerMatch
//
//  Video messaging system for trainers to send feedback to clients
//

import Foundation

struct VideoMessage: Identifiable, Codable {
    let id: String
    var trainerId: String
    var clientId: String
    var title: String
    var message: String
    var videoFileName: String
    var duration: TimeInterval
    var dateCreated: Date
    var isViewed: Bool
    var viewedDate: Date?
    
    // Message type categorization
    var messageType: MessageType
    
    enum MessageType: String, Codable {
        case progressFeedback = "Progress Feedback"
        case workoutInstructions = "Workout Instructions"
        case motivational = "Motivational Message"
        case checkIn = "Check-In"
        case formCorrection = "Form Correction"
        case general = "General Message"
    }
    
    init(trainerId: String,
         clientId: String,
         title: String,
         message: String,
         videoFileName: String,
         duration: TimeInterval,
         messageType: MessageType = .general) {
        self.id = UUID().uuidString
        self.trainerId = trainerId
        self.clientId = clientId
        self.title = title
        self.message = message
        self.videoFileName = videoFileName
        self.duration = duration
        self.dateCreated = Date()
        self.isViewed = false
        self.messageType = messageType
    }
    
    var formattedDate: String {
        let formatter = DateFormatter()
        formatter.dateStyle = .medium
        formatter.timeStyle = .short
        return formatter.string(from: dateCreated)
    }
    
    var formattedDuration: String {
        let minutes = Int(duration) / 60
        let seconds = Int(duration) % 60
        return String(format: "%02d:%02d", minutes, seconds)
    }
    
    var videoURL: URL {
        let documents = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)[0]
        return documents.appendingPathComponent(videoFileName)
    }
    
    var isNew: Bool {
        !isViewed
    }
    
    // Helper for relative time display
    var timeAgo: String {
        let calendar = Calendar.current
        let now = Date()
        let components = calendar.dateComponents([.minute, .hour, .day, .weekOfYear], from: dateCreated, to: now)
        
        if let weeks = components.weekOfYear, weeks > 0 {
            return "\(weeks)w ago"
        } else if let days = components.day, days > 0 {
            return "\(days)d ago"
        } else if let hours = components.hour, hours > 0 {
            return "\(hours)h ago"
        } else if let minutes = components.minute, minutes > 0 {
            return "\(minutes)m ago"
        } else {
            return "Just now"
        }
    }
    
    // Sample data for previews
    static let sample = VideoMessage(
        trainerId: "trainer1",
        clientId: "client1",
        title: "Great Progress This Week!",
        message: "You've been crushing your workouts. Let's review your form on squats.",
        videoFileName: "sample_message.mov",
        duration: 45.0,
        messageType: .progressFeedback
    )
    
    static let sampleMessages: [VideoMessage] = [
        VideoMessage(
            trainerId: "trainer1",
            clientId: "client1",
            title: "Weekly Check-In",
            message: "Let's discuss your progress and upcoming goals.",
            videoFileName: "checkin_1.mov",
            duration: 120.0,
            messageType: .checkIn
        ),
        VideoMessage(
            trainerId: "trainer1",
            clientId: "client1",
            title: "Squat Form Tips",
            message: "I noticed a few things we can improve on your squat form.",
            videoFileName: "form_1.mov",
            duration: 90.0,
            messageType: .formCorrection
        ),
        VideoMessage(
            trainerId: "trainer1",
            clientId: "client1",
            title: "You're Doing Amazing!",
            message: "Just wanted to send some motivation your way. Keep it up!",
            videoFileName: "motivation_1.mov",
            duration: 30.0,
            messageType: .motivational
        )
    ]
}
