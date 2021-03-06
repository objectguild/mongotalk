tests
testMaxStaleness

	| readPreferenceWithMaxStaleness |
	self timeLimit: self defaultTimeLimit + self maxStaleness.

	readPreferenceWithMaxStaleness :=
		MongoReadPreference newPrimaryPreferred
			maxStaleness: self maxStaleness;
			yourself.
	client settings readPreference: readPreferenceWithMaxStaleness.

	self prepareScenarioWhereAllExceptCStopped.

	client mongoDo: [ :mongo |
		self
			assert: mongo urlString asMongoUrl
			equals: MongoReplicationTestResources mongoUrlC.
		self doReadOnMongo: mongo ].

	"Wait until staleness of C is too high."
	self maxStaleness wait.

	[ client mongoDo: [ :mongo |
		self fail: 'should not find a server because staleness is too high' ] ]
			on: MongoServerSelectionTimeout
			do: [:e | Transcript << 'expected timeout'; cr ].

	MongoReplicationTestResources continueAllServers.
	self waitMonitorsHeartbeatAndTimeout.
	
	"Ensure it reads again"
	self doRead.
