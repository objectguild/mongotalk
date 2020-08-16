private
debugLog: anObject
	"Debugging log"

	self ifDebugEnabled: [ 
		(DateAndTime now asString , ': ' , anObject asString) crTrace ]