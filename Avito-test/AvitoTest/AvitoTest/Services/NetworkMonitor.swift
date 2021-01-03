import Foundation
import Network

protocol NetworkMonitorDelegate {
    func connectionHandler()
}

final class NetworkMonitor {
    static let shared = NetworkMonitor()
    
    private let queue = DispatchQueue.global()
    private let monitor: NWPathMonitor
    var delegate: NetworkMonitorDelegate?
    
    public private(set) var isConntected = false
    
    private init() {
        self.monitor = NWPathMonitor()
    }
    
    public func startMonitoring() {
        self.monitor.start(queue: queue)
        self.monitor.pathUpdateHandler = { [weak self] path in
            self?.isConntected = path.status == .satisfied
            self?.delegate?.connectionHandler()
        }
    }
    public func stopMonitoring() {
        self.monitor.cancel()
    }
}
