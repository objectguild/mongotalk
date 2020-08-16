private
next
	"Answer an instance of Mongo that is open (and then ready to be used). The instance may be either one cached from from the pool or a new one if there isn't any cached.
	
	IMPORTANT: When caller is done with the Mongo instance, it must either release it to this pool (see #return:) or close it (since it references an open Socket... else the Pharo image can run out of external semaphores)."

	| mongo |
	mutex critical: [
		mongo := connections
			ifEmpty: [ 
				Mongo debugLog: 'Creating new Mongo connection'.
				Mongo url: url ]
			ifNotEmpty: [ 
				Mongo debugLog: 'Re-using existing Mongo connection'.
				connections removeFirst ] ].

	"Caller assumes it's open."
	self ensureOpenMongo: mongo.

	^ mongo