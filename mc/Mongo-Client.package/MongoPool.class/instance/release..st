as yet unclassified
release: mongo
	"Release to this pool an instance of Mongo previously obtained via #next. Ideally, such Mongo instance should be open and ready to be answered by #next on a new operation."
	| msg |
	mutex critical: [
		connections size >= settings maxConnections
			ifTrue: [ 
				msg := 'Closed connection, reached pool maximum: '.
				self ensureCloseMongo: mongo ]
			ifFalse: [ 
				msg := 'Stored connection in pool: '.
				connections add: mongo ].
		Mongo debugLog: msg , mongo identityHash asString , ' (size ' , connections size asString , ')' ].