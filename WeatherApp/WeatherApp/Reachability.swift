import Foundation
import SystemConfiguration

class Reachability {
    
    static let shared = Reachability()
    
    private init() {}
    
    // Function to check if the internet is reachable
    func isConnectedToNetwork() -> Bool {
        var zeroAddress = sockaddr_in()
        zeroAddress.sin_len = UInt8(MemoryLayout<sockaddr_in>.size)
        zeroAddress.sin_family = sa_family_t(AF_INET)
        
        // Create the reachability reference
        let reachability = withUnsafePointer(to: &zeroAddress) { pointer -> SCNetworkReachability? in
            pointer.withMemoryRebound(to: sockaddr.self, capacity: 1) { zeroSockAddress in
                SCNetworkReachabilityCreateWithAddress(nil, zeroSockAddress)
            }
        }
        
        var flags = SCNetworkReachabilityFlags()
        
        // Get the reachability flags
        guard let reachabilityRef = reachability, SCNetworkReachabilityGetFlags(reachabilityRef, &flags) else {
            return false
        }
        
        // Check if it's reachable and not restricted
        return flags.contains(.reachable) && !flags.contains(.connectionRequired)
    }
}

