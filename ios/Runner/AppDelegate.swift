import Flutter
import UIKit
import GoogleMaps

@main
@objc class AppDelegate: FlutterAppDelegate {
  override func application(
    _ application: UIApplication,
    didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?
  ) -> Bool {
    var mapsApiKey = ""
    if let filepath = Bundle.main.path(forResource: "flutter_assets/.env", ofType: "") {
      do {
        let contents = try String(contentsOfFile: filepath)
        let lines = contents.split(whereSeparator: \.isNewline)
        for line in lines {
          let parts = line.split(separator: "=", maxSplits: 1)
          if parts.count == 2, parts[0] == "GOOGLE_MAPS_API_KEY" {
            mapsApiKey = String(parts[1])
            break
          }
        }
      } catch {
        print("Could not read .env file")
      }
    }
    
    if !mapsApiKey.isEmpty {
      GMSServices.provideAPIKey(mapsApiKey)
    }

    GeneratedPluginRegistrant.register(with: self)
    return super.application(application, didFinishLaunchingWithOptions: launchOptions)
  }
}
