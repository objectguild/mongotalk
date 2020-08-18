accessing
tearDown
	self crTrace: self class name , '>>tearDown'.
	self ensureMongoIsClosed.
	pool resetAll.
