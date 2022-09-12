//
// Copyright Amazon.com Inc. or its affiliates.
// All Rights Reserved.
//
// SPDX-License-Identifier: Apache-2.0
//

import Foundation

import XCTest
import Amplify
@testable import AWSCognitoAuthPlugin
import AWSCognitoIdentityProvider

// swiftlint:disable type_body_length
// swiftlint:disable file_length
class AWSAuthSignOutTaskTests: BasePluginTest {

    override var initialState: AuthState {
        AuthState.configured(
            AuthenticationState.signedIn(.testData),
            AuthorizationState.sessionEstablished(.testData))
    }

    func testSuccessfullSignOut() async {
        self.mockIdentityProvider = MockIdentityProvider(
            mockRevokeTokenResponse: { _ in
                return .testData
            }, mockGlobalSignOutResponse: { _ in
                return .testData
            })
        guard let result = await plugin.signOut() as? AWSCognitoSignOutResult,
              case .complete = result else {
            XCTFail("Did not return complete signOut")
            return
        }
    }

    func testGlobalSignOutFailed() async {
        self.mockIdentityProvider = MockIdentityProvider(
            mockRevokeTokenResponse: { _ in
                return .testData
            }, mockGlobalSignOutResponse: { _ in
                throw GlobalSignOutOutputError.internalErrorException(.init())
            })
        guard let result = await plugin.signOut(options: .init(globalSignOut: true)) as? AWSCognitoSignOutResult,
              case .partial(revokeTokenError: let revokeTokenError,
                            globalSignOutError: let globalSignOutError,
                            hostedUIError: let hostedUIError) = result else {
            XCTFail("Did not return partial signOut")
            return
        }
        XCTAssertNotNil(revokeTokenError)
        XCTAssertNotNil(globalSignOutError)
        XCTAssertNil(hostedUIError)
    }

    func testRevokeSignOutFailed() async {
        self.mockIdentityProvider = MockIdentityProvider(
            mockRevokeTokenResponse: { _ in
                throw RevokeTokenOutputError.internalErrorException(.init())
            }, mockGlobalSignOutResponse: { _ in
                return .testData
            })
        guard let result = await plugin.signOut(options: .init(globalSignOut: true)) as? AWSCognitoSignOutResult,
              case .partial(revokeTokenError: let revokeTokenError,
                            globalSignOutError: let globalSignOutError,
                            hostedUIError: let hostedUIError) = result else {
            XCTFail("Did not return partial signOut")
            return
        }
        XCTAssertNotNil(revokeTokenError)
        XCTAssertNil(globalSignOutError)
        XCTAssertNil(hostedUIError)
    }
}