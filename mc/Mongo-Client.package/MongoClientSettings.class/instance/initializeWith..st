initialization
initializeWith: aMongoClient
	self initialize.
	aMongoClient addDependent: self.