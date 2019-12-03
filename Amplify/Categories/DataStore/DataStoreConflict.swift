//
// Copyright 2018-2019 Amazon.com,
// Inc. or its affiliates. All Rights Reserved.
//
// SPDX-License-Identifier: Apache-2.0
//

/// Information about a conflict that occurred attempting to sync a local model with a cloud model
public struct DataStoreSyncConflict {
    public let localModel: Model
    public let remoteModel: Model
    public let errors: [GraphQLError]?
    public let mutationType: GraphQLMutationType
}