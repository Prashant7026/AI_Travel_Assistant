
import Foundation

class UserDetails {
    var location: String?
    var NumberofTravellers: Int?
    var Duration: Int?
    var Interest: String?
    
    init(location: String? = nil, NumberofTravellers: Int? = nil, Duration: Int? = nil, Interest: String? = nil) {
        self.location = location
        self.NumberofTravellers = NumberofTravellers
        self.Duration = Duration
        self.Interest = Interest
    }
}
