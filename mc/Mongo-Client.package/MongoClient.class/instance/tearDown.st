running
tearDown
	self stop.
	monitors valuesDo: #tearDown.