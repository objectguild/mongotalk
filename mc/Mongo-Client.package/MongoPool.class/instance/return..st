private
return: mongo
	"Release to this pool an instance of Mongo previously obtained via #next. Ideally, such Mongo instance should be open and ready to be answered by #next on a new operation."

	mutex critical: [
		connections size >= settings maxConnections
			ifTrue: [ 
				Mongo debugLog: 'Closing connection, reached pool maximum'.
				self ensureCloseMongo: mongo ]
			ifFalse: [ 
				connections add: mongo.
				Mongo debugLog: 'Stored connection in pool, current size: ' , connections size asString ] ]