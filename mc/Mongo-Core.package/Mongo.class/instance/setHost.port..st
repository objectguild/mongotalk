private
setHost: aString port: anInteger
	requestID := 0.
	host := aString.
	port := anInteger.
	mutex := Mutex new.
	"validate?"