Access to Mongo

To enable tools to work with an authenticated MongoDB database, follow these steps.
	
1. Create a MongoDB user with read/write access (using mongo shell):
use admin
db.createUser({ user: "pharo", pwd: "pharo", roles: [ "readAnyDatabase" ] })

2. Configure Mongo default to use it:
MongoAuthMechanism authAgainstAdmin: true.
Mongo default in: [ :mongo | mongo username: 'pharo' password: 'pharo' database: mongo admin ].


Instance Variables
	authCache:		<Object>
	host:		<Object>
	port:		<Object>
	requestID:		<Object>
	stream:		<Object>

authCache
	- xxxxx

host
	- xxxxx

port
	- xxxxx

requestID
	- xxxxx

stream
	- xxxxx
