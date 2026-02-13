//
//  Models.swift
//  TrainerMatch
//
//  Created by Ramone Hayes on 2/10/26.
//

import Foundation
import SwiftUI

// MARK: - User Role
enum UserRole: String, Codable {
    case trainer
    case client
}

// MARK: - Trainer Specialties (from TrainerMatch)
enum TrainerSpecialty: String, Codable, CaseIterable {
    case personalTraining = "Personal Training"
    case yoga = "Yoga"
    case pilates = "Pilates"
    case crossfit = "CrossFit"
    case hiit = "HIIT"
    case strength = "Strength/Conditioning"
    case cardio = "Cardio Kickboxing"
    case boxing = "Boxing"
    case spinning = "Spin/Cycling"
    case zumba = "Zumba"
    case bootcamp = "Boot Camp"
    case martialArts = "Martial Arts/Self-Defense"
    case sportsPerformance = "Sports Performance"
    case seniorFitness = "Senior Fitness"
    case youthFitness = "Youth Fitness"
    case nutrition = "Certified Nutritionist"
    case wellness = "Wellness"
    case swimming = "Swimming"
    case running = "Running"
    case triathlon = "Triathlon"
    case bodybuilding = "Bodybuilding"
    case powerlifting = "Powerlifting"
    case groupFitness = "Group Fitness"
    case meditation = "Meditation"
    case other = "Other"
}

// MARK: - Trainer Certifications (NEW)
enum TrainerCertification: String, Codable, CaseIterable {
    // Major Organizations
    case nasmCpt = "NASM-CPT"
    case aceCpt = "ACE-CPT"
    case nscaCscs = "NSCA-CSCS"
    case nscaCpt = "NSCA-CPT"
    case ismaCft = "ISMA-CFT"
    case afaaCpt = "AFAA-CPT"
    case nfptCpt = "NFPT-CPT"
    case acsm = "ACSM-CPT"
    
    // Specialty Certifications
    case precisionNutrition = "Precision Nutrition"
    case nasmCes = "NASM-CES (Corrective Exercise)"
    case nasmPes = "NASM-PES (Performance)"
    case aceFitness = "ACE Fitness Nutrition"
    case crossfitL1 = "CrossFit Level 1"
    case crossfitL2 = "CrossFit Level 2"
    case usaWeightlifting = "USA Weightlifting"
    case usaPowerlifting = "USA Powerlifting"
    
    // Yoga & Pilates
    case ryt200 = "RYT-200 (Yoga)"
    case ryt500 = "RYT-500 (Yoga)"
    case pilatesInstructor = "Pilates Instructor"
    case stottPilates = "STOTT Pilates"
    
    // Special Populations
    case prenatalPostnatal = "Prenatal/Postnatal"
    case seniorFitness = "Senior Fitness Specialist"
    case youthFitness = "Youth Fitness Specialist"
    case cancerExercise = "Cancer Exercise Specialist"
    
    // Other
    case firstAidCpr = "First Aid/CPR"
    case nutritionist = "Certified Nutritionist"
    case dietitian = "Registered Dietitian"
    case other = "Other Certification"
    
    var category: String {
        switch self {
        case .nasmCpt, .aceCpt, .nscaCscs, .nscaCpt, .ismaCft, .afaaCpt, .nfptCpt, .acsm:
            return "General CPT"
        case .precisionNutrition, .nasmCes, .nasmPes, .aceFitness, .crossfitL1, .crossfitL2, .usaWeightlifting, .usaPowerlifting:
            return "Specialty"
        case .ryt200, .ryt500, .pilatesInstructor, .stottPilates:
            return "Yoga/Pilates"
        case .prenatalPostnatal, .seniorFitness, .youthFitness, .cancerExercise:
            return "Special Populations"
        case .firstAidCpr, .nutritionist, .dietitian, .other:
            return "Other"
        }
    }
}

// MARK: - Training Schools (NEW)
enum TrainingSchool: String, Codable, CaseIterable {
    // Major Certification Bodies
    case nasm = "National Academy of Sports Medicine (NASM)"
    case ace = "American Council on Exercise (ACE)"
    case nsca = "National Strength & Conditioning Association (NSCA)"
    case acsm = "American College of Sports Medicine (ACSM)"
    case isma = "International Sports Medicine Association (ISMA)"
    case afaa = "Athletics and Fitness Association of America (AFAA)"
    case nfpt = "National Federation of Professional Trainers (NFPT)"
    case issa = "International Sports Sciences Association (ISSA)"
    
    // Universities & Colleges
    case exerciseScience = "Exercise Science Degree Program"
    case kinesiology = "Kinesiology Degree Program"
    case sportsScience = "Sports Science Degree Program"
    case physicalEducation = "Physical Education Degree"
    case lionelUniversity = "Lionel University"
    
    // Specialty Schools
    case crossfit = "CrossFit Certification"
    case yogaAlliance = "Yoga Alliance Certified School"
    case pilatesMethod = "Pilates Method Alliance School"
    case precisionNutrition = "Precision Nutrition Certification"
    
    // Online Platforms
    case nasmOnline = "NASM Online Learning"
    case aceOnline = "ACE Online Academy"
    case nscaOnline = "NSCA Online Education"
    case issaOnline = "ISSA Online Certification"
    
    // Other
    case apprenticeship = "Apprenticeship/Mentorship"
    case militaryFitness = "Military Fitness Training"
    case other = "Other Training Program"
    
    var icon: String {
        switch self {
        case .nasm, .ace, .nsca, .acsm, .isma, .afaa, .nfpt, .issa:
            return "building.columns.fill"
        case .exerciseScience, .kinesiology, .sportsScience, .physicalEducation, .lionelUniversity:
            return "graduationcap.fill"
        case .crossfit, .yogaAlliance, .pilatesMethod, .precisionNutrition:
            return "figure.strengthtraining.traditional"
        case .nasmOnline, .aceOnline, .nscaOnline, .issaOnline:
            return "laptopcomputer"
        case .apprenticeship, .militaryFitness, .other:
            return "person.fill"
        }
    }
}

// MARK: - Service Type
enum ServiceType: String, Codable, CaseIterable {
    case inPerson = "In-Person"
    case online = "Online"
    case both = "Both"
}

// MARK: - Trainer Profile (TrainerMatch Integration)
struct TrainerProfile: Identifiable, Codable {
    var id: String = UUID().uuidString
    var userId: String
    var businessName: String?
    var bio: String?
    var specialties: [TrainerSpecialty]
    var certifications: [String]
    var yearsOfExperience: Int
    var serviceTypes: [ServiceType]
    var location: TrainerLocation?
    var hourlyRate: Double?
    var profileImageURL: String?
    var websiteURL: String?
    var instagramHandle: String?
    var isVerified: Bool = false
    var rating: Double?
    var totalReviews: Int = 0
}

struct TrainerLocation: Codable {
    var city: String
    var state: String
    var country: String = "United States"
    var latitude: Double?
    var longitude: Double?
}

// MARK: - Client Model
struct Client: Identifiable, Codable {
    var id: String = UUID().uuidString
    var name: String
    var email: String
    var phoneNumber: String?
    var profileImageURL: String?
    var dateJoined: Date
    var trainerId: String
    
    // Health metrics
    var currentWeight: Double?
    var goalWeight: Double?
    var height: Double? // in cm
    
    // Activity data (synced from HealthKit)
    var dailySteps: Int = 0
    var dailyDistance: Double = 0.0
    var activityStatus: String = "Not Active"
    var lastSyncDate: Date?
    
    // TrainerMatch specific
    var fitnessGoals: [FitnessGoal] = []
    var preferredServiceType: ServiceType?
    var foundVia: String? // "TrainerMatch", "Referral", etc.
    
    // Notes from trainer
    var trainerNotes: String?
}

// MARK: - Fitness Goals (EXPANDED)
enum FitnessGoal: String, Codable, CaseIterable {
    // Weight Management
    case weightLoss = "Weight Loss"
    case toneUp = "Tone & Sculpt"
    case muscleGain = "Build Muscle"
    case bodyRecomposition = "Body Recomposition"
    
    // Health & Wellness
    case generalFitness = "General Fitness"
    case improveHealth = "Improve Overall Health"
    case heartHealth = "Cardiovascular Health"
    case betterSleep = "Better Sleep"
    case increaseEnergy = "Increase Energy"
    case stressRelief = "Reduce Stress"
    
    // Performance
    case athleticPerformance = "Athletic Performance"
    case increaseStrength = "Increase Strength"
    case buildEndurance = "Build Endurance"
    case improveSpeed = "Improve Speed & Agility"
    
    // Flexibility & Recovery
    case flexibility = "Flexibility & Mobility"
    case rehabilitation = "Injury Rehabilitation"
    case preventInjury = "Injury Prevention"
    case posture = "Improve Posture"
    
    // Lifestyle & Events
    case wedding = "Wedding Preparation"
    case postPregnancy = "Post-Pregnancy Recovery"
    case seniorFitness = "Active Aging/Senior Fitness"
    case sportSpecific = "Sport-Specific Training"
    
    // Support & Guidance
    case nutrition = "Nutrition Guidance"
    case accountability = "Accountability & Motivation"
    case learnProperForm = "Learn Proper Form"
    case buildConfidence = "Build Confidence"
    
    var icon: String {
        switch self {
        case .weightLoss: return "scalemass"
        case .toneUp: return "figure.strengthtraining.traditional"
        case .muscleGain: return "dumbbell.fill"
        case .bodyRecomposition: return "chart.line.uptrend.xyaxis"
        case .generalFitness: return "heart.fill"
        case .improveHealth: return "cross.case.fill"
        case .heartHealth: return "heart.circle.fill"
        case .betterSleep: return "bed.double.fill"
        case .increaseEnergy: return "bolt.fill"
        case .stressRelief: return "brain.head.profile"
        case .athleticPerformance: return "sportscourt.fill"
        case .increaseStrength: return "figure.strengthtraining.traditional"
        case .buildEndurance: return "figure.run"
        case .improveSpeed: return "hare.fill"
        case .flexibility: return "figure.yoga"
        case .rehabilitation: return "bandage.fill"
        case .preventInjury: return "shield.fill"
        case .posture: return "figure.stand"
        case .wedding: return "heart.circle"
        case .postPregnancy: return "figure.and.child.holdinghands"
        case .seniorFitness: return "figure.walk"
        case .sportSpecific: return "tennis.racket"
        case .nutrition: return "carrot.fill"
        case .accountability: return "checkmark.circle.fill"
        case .learnProperForm: return "eye.fill"
        case .buildConfidence: return "star.fill"
        }
    }
}

// MARK: - Exercise Model
struct Exercise: Identifiable, Codable {
    var id: String = UUID().uuidString
    var name: String
    var category: ExerciseCategory
    var description: String?
    var sets: Int?
    var reps: Int?
    var duration: Int? // in seconds
    var restTime: Int? // in seconds
    var videoURL: String?
    var imageURL: String?
}

enum ExerciseCategory: String, Codable, CaseIterable {
    case strength = "Strength"
    case cardio = "Cardio"
    case flexibility = "Flexibility"
    case balance = "Balance"
    case other = "Other"
}

// MARK: - Workout Model
struct Workout: Identifiable, Codable {
    var id: String = UUID().uuidString
    var name: String
    var description: String?
    var exercises: [Exercise]
    var assignedDate: Date
    var dueDate: Date?
    var isCompleted: Bool = false
    var completedDate: Date?
    var clientId: String
    var trainerId: String
    var difficulty: WorkoutDifficulty
    var estimatedDuration: Int? // in minutes
}

enum WorkoutDifficulty: String, Codable, CaseIterable {
    case beginner = "Beginner"
    case intermediate = "Intermediate"
    case advanced = "Advanced"
}

// MARK: - Progress Entry Model
struct ProgressEntry: Identifiable, Codable {
    var id: String = UUID().uuidString
    var clientId: String
    var date: Date
    var weight: Double?
    var bodyFat: Double?
    var measurements: BodyMeasurements?
    var photoURLs: [String]?
    var notes: String?
}

struct BodyMeasurements: Codable {
    var chest: Double? // in cm
    var waist: Double?
    var hips: Double?
    var thighs: Double?
    var arms: Double?
}

// MARK: - Sample Data for Preview/Testing
extension Client {
    static let sampleClients: [Client] = [
        Client(
            name: "John Doe",
            email: "john.doe@email.com",
            phoneNumber: "+1234567890",
            dateJoined: Date().addingTimeInterval(-30*24*60*60),
            trainerId: "trainer1",
            currentWeight: 85.5,
            goalWeight: 75.0,
            height: 180,
            dailySteps: 8500,
            dailyDistance: 6.2,
            activityStatus: "Active",
            lastSyncDate: Date(),
            fitnessGoals: [.weightLoss, .generalFitness],
            preferredServiceType: .inPerson,
            foundVia: "TrainerMatch",
            trainerNotes: "Great progress this month! Keep up the consistency."
        ),
        Client(
            name: "Sarah Johnson",
            email: "sarah.j@email.com",
            phoneNumber: "+1987654321",
            dateJoined: Date().addingTimeInterval(-60*24*60*60),
            trainerId: "trainer1",
            currentWeight: 68.0,
            goalWeight: 65.0,
            height: 165,
            dailySteps: 12000,
            dailyDistance: 9.8,
            activityStatus: "Very Active",
            lastSyncDate: Date(),
            fitnessGoals: [.muscleGain, .athleticPerformance],
            preferredServiceType: .both,
            foundVia: "TrainerMatch",
            trainerNotes: "Excellent dedication! Ready for advanced workouts."
        ),
        Client(
            name: "Mike Williams",
            email: "mike.w@email.com",
            dateJoined: Date().addingTimeInterval(-15*24*60*60),
            trainerId: "trainer1",
            currentWeight: 92.0,
            goalWeight: 82.0,
            height: 175,
            dailySteps: 4500,
            dailyDistance: 3.2,
            activityStatus: "Lightly Active",
            lastSyncDate: Date(),
            fitnessGoals: [.weightLoss, .accountability],
            preferredServiceType: .online,
            foundVia: "Referral",
            trainerNotes: "New client - building foundation and consistency."
        )
    ]
}

extension TrainerProfile {
    static let sampleProfile = TrainerProfile(
        userId: "trainer1",
        businessName: "Elite Fitness Studio",
        bio: "Certified personal trainer with 10+ years of experience helping clients achieve their fitness goals. Specializing in strength training, HIIT, and weight loss programs.",
        specialties: [.personalTraining, .hiit, .strength, .nutrition],
        certifications: ["NASM-CPT", "ISSA-CFT", "Precision Nutrition Level 1"],
        yearsOfExperience: 10,
        serviceTypes: [.inPerson, .online],
        location: TrainerLocation(city: "Las Vegas", state: "Nevada", latitude: 36.1699, longitude: -115.1398),
        hourlyRate: 75.0,
        isVerified: true,
        rating: 4.8,
        totalReviews: 127
    )
}

extension Exercise {
    static let sampleExercises: [Exercise] = [
        Exercise(
            name: "Push-ups",
            category: .strength,
            description: "Standard push-ups for chest and triceps",
            sets: 3,
            reps: 15,
            restTime: 60
        ),
        Exercise(
            name: "Running",
            category: .cardio,
            description: "Moderate pace running",
            duration: 1800, // 30 minutes
            restTime: 120
        ),
        Exercise(
            name: "Squats",
            category: .strength,
            description: "Bodyweight squats for legs",
            sets: 4,
            reps: 20,
            restTime: 90
        ),
        Exercise(
            name: "Plank",
            category: .strength,
            description: "Core stability exercise",
            sets: 3,
            duration: 60,
            restTime: 60
        )
    ]
}

extension Workout {
    static let sampleWorkouts: [Workout] = [
        Workout(
            name: "Upper Body Strength",
            description: "Focus on chest, back, and arms",
            exercises: [
                Exercise(name: "Push-ups", category: .strength, sets: 3, reps: 15, restTime: 60),
                Exercise(name: "Pull-ups", category: .strength, sets: 3, reps: 10, restTime: 90),
                Exercise(name: "Dumbbell Curls", category: .strength, sets: 3, reps: 12, restTime: 60)
            ],
            assignedDate: Date(),
            dueDate: Date().addingTimeInterval(7*24*60*60),
            clientId: "client1",
            trainerId: "trainer1",
            difficulty: .intermediate,
            estimatedDuration: 45
        ),
        Workout(
            name: "Cardio Blast",
            description: "High intensity interval training",
            exercises: [
                Exercise(name: "Running", category: .cardio, duration: 300, restTime: 60),
                Exercise(name: "Burpees", category: .cardio, sets: 5, reps: 10, restTime: 45),
                Exercise(name: "Jump Rope", category: .cardio, duration: 180, restTime: 60)
            ],
            assignedDate: Date().addingTimeInterval(-2*24*60*60),
            dueDate: Date().addingTimeInterval(5*24*60*60),
            clientId: "client1",
            trainerId: "trainer1",
            difficulty: .advanced,
            estimatedDuration: 30
        )
    ]
}

extension ProgressEntry {
    static let sampleEntries: [ProgressEntry] = [
        ProgressEntry(
            clientId: "client1",
            date: Date(),
            weight: 85.5,
            bodyFat: 18.5,
            measurements: BodyMeasurements(chest: 100, waist: 85, hips: 95, thighs: 58, arms: 35),
            notes: "Feeling strong this week!"
        ),
        ProgressEntry(
            clientId: "client1",
            date: Date().addingTimeInterval(-7*24*60*60),
            weight: 86.2,
            bodyFat: 19.0,
            measurements: BodyMeasurements(chest: 101, waist: 87, hips: 96, thighs: 59, arms: 35),
            notes: "Starting to see changes"
        )
    ]
}
