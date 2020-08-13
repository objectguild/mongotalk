tests
testSCRAMSHA256AuthMechanism
	"ToDo: this test requires manual configuration. 
	=> Run in command-line:
	mongo test --eval 'db.createUser({ user: ""pharounittest"", pwd: ""test"", roles: [], mechanisms: [ ""SCRAM-SHA-256"" ] });'
	"
	root authMechanism: (SCRAMSHA256AuthMechanism root: root).

	self assert: (root authenticateUsername: 'pharounittest' password: 'test' database: database).
	self assert: (root authenticateUsername: 'pharounittest' password: 'invalid' database: database) not