import Foundation
import Utility
import os.log

extension FileManager {
  func temporaryFileURL(fileName: String = UUID().uuidString) -> URL? {
    return URL(fileURLWithPath: NSTemporaryDirectory(), isDirectory: true)
      .appendingPathComponent(fileName)
  }
}

enum CommandError: Error, LocalizedError {
  case runError(message: String)
  case commandError(command: String, errorMessage: String?, exitStatus: Int)

  var localizedDescription: String {
    switch self {
    case .runError(let error): return error
    case .commandError(let command, let errorMessage, let exitStatus):
      var description = "Error: \(command) failed with exit status \(exitStatus)."

      if let errorMessage = errorMessage { description += " Error message: \(errorMessage)" }

      return description
    }
  }
}

func run(command lauchPath: URL, with arguments: [String] = []) -> Result<String?, CommandError> {
  let process = Process()
  process.executableURL = lauchPath
  process.arguments = arguments

  let standardOutput = Pipe()
  let standardError = Pipe()
  process.standardOutput = standardOutput
  process.standardError = standardError

  do { try process.run() }
  catch { return .failure(.runError(message: error.localizedDescription)) }

  let standardOutputData = standardOutput.fileHandleForReading.readDataToEndOfFile()
  let output = String(data: standardOutputData, encoding: .utf8)
  let standardErrorData = standardError.fileHandleForReading.readDataToEndOfFile()
  let errorMessage = String(data: standardErrorData, encoding: .utf8)

  process.waitUntilExit()

  if process.terminationStatus != 0 {
    return .failure(
      .commandError(
        command: process.executableURL!.lastPathComponent,
        errorMessage: errorMessage,
        exitStatus: Int(process.terminationStatus)
      )
    )
  }

  return .success(output)
}

@objc class SwiftFormatterService: NSObject, SwiftFormatterServiceProtocol {
  enum SwiftFormatterServiceError: Error, LocalizedError {
    case tempFileNotFound(message: String)

    var localizedDescription: String {
      switch self {
      case .tempFileNotFound(let error): return error
      }
    }
  }

  private let swiftFormatBinaryPath = Bundle.main.url(
    forResource: "swift-format",
    withExtension: ""
  )!

  func format(source: String, reply: @escaping (String?, Error?) -> Void) {
    guard let tempFileURL = FileManager.default.temporaryFileURL() else {
      let error = SwiftFormatterServiceError.tempFileNotFound(
        message: "The temp file is not found!"
      )
      os_log("%{public}@", error.localizedDescription)
      return reply(nil, error)
    }

    defer { try? FileManager.default.removeItem(at: tempFileURL) }

    do { try source.write(to: tempFileURL, atomically: false, encoding: .utf8) }
    catch {
      os_log("%{public}@", error.localizedDescription)
      return reply(nil, error)
    }

    var arguments = [String]()
    arguments.append(contentsOf: ["-i", tempFileURL.path])

    if FileManager.default.fileExists(atPath: AppConstants.configFileURL.path) {
      arguments.append(contentsOf: ["--configuration", AppConstants.configFileURL.path])
    }

    let result = run(command: swiftFormatBinaryPath, with: arguments)

    switch result {
    case .success:
      do {
        let formattedSource = try String(contentsOf: tempFileURL)
        return reply(formattedSource, nil)
      }
      catch { return reply(nil, error) }
    case .failure(let error):
      os_log("%{public}@", error.localizedDescription)
      return reply(nil, error)
    }
  }
}
