import Foundation

struct UserDefaultsService {
    private let defaults = UserDefaults.standard
    
    enum Keys: String {
        case isFirstLaunch = "isFirstLaunch"
    }
    
    init() {
        if !containsValue(forKey: .isFirstLaunch) {
            isFirstLaunch = true
        }
    }
    
    var isFirstLaunch: Bool {
        get {
            getBool(forKey: .isFirstLaunch)
        }
        set {
            setBool(value: newValue, forKey: .isFirstLaunch)
        }
    }

    func setValue<T>(_ value: T?, forKey key: Keys) {
        defaults.setValue(value, forKey: key.rawValue)
    }

    func getValue<T>(forKey key: Keys) -> T? {
        return defaults.value(forKey: key.rawValue) as? T
    }

    func removeValue(forKey key: Keys) {
        defaults.removeObject(forKey: key.rawValue)
    }

    func containsValue(forKey key: Keys) -> Bool {
        return defaults.object(forKey: key.rawValue) != nil
    }
    
    private func setBool(value: Bool, forKey key: Keys) {
        setValue(value, forKey: key)
    }

    private func getBool(forKey key: Keys) -> Bool {
        return getValue(forKey: key) ?? false
    }
}
