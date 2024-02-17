//
//  JwtDecoder.swift
//  Perroquet
//
//  Created by Yoan Dubuc on 2/16/24.
//

import Foundation

struct JwtDecoder {
    static func decode<T: Decodable>(jwt: String) -> Result<T, AppError> {
        let splitJwt = jwt.split(separator: ".")
        guard splitJwt.count == 3
        else {
            return .failure(AppError("Invalid JWT structure."))
        }

        let encodedPayload = String(splitJwt[1])
        let encodedPayloadPadded = encodedPayload.padding(
            toLength: ((encodedPayload.count + 3) / 4) * 4,
            withPad: "=",
            startingAt: 0
        )
        guard let decodedPayload = Data(base64Encoded: encodedPayloadPadded)
        else {
            return .failure(AppError("Unable to decode payload."))
        }

        do {
            let decoded = try JSONDecoder().decode(T.self, from: decodedPayload)
            return .success(decoded)
        } catch {
            return .failure(AppError("Failed to decode JWT."))
        }
    }
}
