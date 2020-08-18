accessing
tearDown
	Mongo debugLog: self class name , '>>tearDown'.
	self ensureMongoIsClosed.
	pool resetAll.
