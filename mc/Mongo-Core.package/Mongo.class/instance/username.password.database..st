operations
username: aUserString password: aPasswordString database: aDatabase
	"Ensure user is authenticated for database. MongoDB requires authentication only once 
	every connection/session per database/user combination. So in order not to slow
	down things we cache the authentication setting.
	Note: A second authentication for a database with a different user invalidates the 
	first auth. That's why the authCache	stores only one username per database."
	| cachedUser authResult |
	mutex critical: [ "Using critical section to make sure we don't authenticate multiple times concurrently"
		cachedUser := self authCache at: aDatabase name ifAbsent: nil.
		aUserString = cachedUser ifFalse: [ 
			authResult := self authenticateUsername: aUserString password: aPasswordString database: aDatabase.
			authResult ifTrue: [ self authCache at: aDatabase name put: aUserString ] ] ].