testing
isAvailable
	"Return true when it is possible to connect to the mongo DB instance, false otherwise.
	 When it is available it is also opened."
	
	"This method opens a new connection, regardless if one is already open. 
	In the process, it has the side-effect to lose connection authentication, which breaks 
	functionality in a scenario where authentication is enabled on MongoDB.
	
	To enable the Mongo tools to work with an authenticated database, follow these steps.
	
	1. Create a MongoDB user with read/write access (using mongo shell):

use admin
db.createUser({ user: 'pharo', pwd: 'pharo', roles: [ 'readAnyDatabase' ] })


	2. Configure the Mongo default to use it:

MongoAuthMechanism authAgainstAdmin: true.
Mongo default in: [ :mongo | mongo username: 'pharo' password: 'pharo' database: mongo admin ].
"
	self 
		deprecated: 'Method has side-effects, please use #isOpen instead' 
		transformWith: '`@receiver isAvailable' -> '`@receiver isOpen'.

	^[self open isOpen ]
		on: ConnectionTimedOut
		do: [ ^false ]