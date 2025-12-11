//
//  LocalizationHelper.swift
//  DemoLocalization
//
//  Created by Bahadir Sonmez on 23.12.2025.
//

import Foundation

public enum LocalizationHelper {
    public static func string(for key: String, _ arguments: CVarArg..., comment: String = "") -> String {
        let format = NSLocalizedString(key, tableName: "Localizable", bundle: Bundle.module, comment: comment)
        if arguments.isEmpty {
            return format
        }
        return String(format: format, arguments: arguments)
    }
}
