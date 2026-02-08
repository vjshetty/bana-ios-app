//
//  ConventionModels.swift
//  bana
//
//  BANA 2026 Seattle Convention — data models.
//

import Foundation

// MARK: - Convention Phase

enum AppPhase {
    case preEvent
    case liveEvent
}

// MARK: - Convention Info (BANA 2026 Seattle)

struct ConventionInfo {
    let name: String
    let tagline: String
    let conventionStartDate: Date
    let conventionEndDate: Date
    let venueName: String
    let venueCity: String
    let earlyBirdPriceAdult: Int
    let registrationURL: String
    let hotelRoomBlockURL: String
    let banaInceptionYear: Int
    let expectedAttendees: Int
    let milestoneEdition: Int

    /// Whether we are in the "live event" window (convention dates).
    var isLiveEvent: Bool {
        let now = Date()
        return now >= conventionStartDate && now <= conventionEndDate
    }

    /// Current app phase based on convention dates.
    var appPhase: AppPhase {
        isLiveEvent ? .liveEvent : .preEvent
    }

    /// Days until convention start (0 or negative if started).
    var daysUntilStart: Int {
        Calendar.current.dateComponents([.day], from: Date(), to: conventionStartDate).day ?? 0
    }

    static let seattle2026 = ConventionInfo(
        name: "BANA 2026 Seattle",
        tagline: "25th Milestone Convention",
        conventionStartDate: Self.date(2026, 7, 30),
        conventionEndDate: Self.dateEndOfDay(2026, 8, 2),
        venueName: "Hyatt Regency Bellevue",
        venueCity: "Seattle",
        earlyBirdPriceAdult: 395,
        registrationURL: "https://www.bana.org",
        hotelRoomBlockURL: "https://www.bana.org",
        banaInceptionYear: 1979,
        expectedAttendees: 600,
        milestoneEdition: 25
    )

    private static func date(_ year: Int, _ month: Int, _ day: Int) -> Date {
        var components = DateComponents()
        components.year = year
        components.month = month
        components.day = day
        components.hour = 0
        components.minute = 0
        components.second = 0
        return Calendar.current.date(from: components) ?? Date()
    }
}

// MARK: - Schedule (offline-cacheable)

struct ScheduleDay: Identifiable {
    let id: String
    let label: String      // e.g. "Thursday", "Friday"
    let shortLabel: String // e.g. "Thu", "Fri"
    let date: Date
    var items: [ScheduleItem]
}

struct ScheduleItem: Identifiable {
    let id: String
    let title: String
    let subtitle: String?
    let startTime: Date
    let endTime: Date?
    let location: String?
    let track: ScheduleTrack?
}

enum ScheduleTrack: String, CaseIterable {
    case youngVoicesUnite = "Young Voices Unite"
    case businessForum = "Business Forum"
    case culturalShowcase = "Cultural Showcase"
    case kidsWorld = "Kids World"
    case youthPanel = "Youth Panel"
    case general = "General"
}

// MARK: - Attendee Directory (secure "Who's Coming")

struct Attendee: Identifiable {
    let id: String
    var displayName: String
    var region: String?
    var isVisibleInDirectory: Bool
}

// MARK: - Cultural Showcase Voting

struct CulturalPerformance: Identifiable {
    let id: String
    let title: String
    let description: String?
    var voteCount: Int
}