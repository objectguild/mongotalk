operations
authenticateUsername: username password: password forcedDatabase: database
	| clientNonce clientFirstWithoutHeader op response serverFirst parsedServerFirst iterationCount salt combinedNonce clientFinalWithoutProof saltedPassword clientKey storedKey authMsg clientSig clientProof clientFinal parsedServerFinal serverKey serverSig |
	clientNonce := (Random new next asString allButFirst: 2) asByteArray base64Encoded.
	clientFirstWithoutHeader := 'n=' , username , ',r=' , clientNonce.
	op := OrderedIdentityDictionary new
		add: #saslStart -> 1;
		add: #mechanism -> self mechanismName;
		add: #payload -> ('n,,' , clientFirstWithoutHeader) asByteArray;
		add: #autoAuthorize -> 1;
		yourself.
	[ response := self root command: op database: database ]
		on: MongoCommandError
		do: [ ^ false ].
	serverFirst := response at: #payload.
	parsedServerFirst := self parseScramResponse: serverFirst.
	iterationCount := parsedServerFirst at: #i.
	salt := parsedServerFirst at: #s.
	combinedNonce := parsedServerFirst at: #r.
	(combinedNonce beginsWith: clientNonce)
		ifFalse: [ ^ false "Server returned an invalid nonce." ].
	clientFinalWithoutProof := 'c=biws,r=' , combinedNonce.
	saltedPassword := PBKDF2 new
		hashFunction: self hashFunction;
		password: (self digestUsername: username password: password);
		salt: salt base64Decoded;
		iterations: iterationCount asInteger;
		length: self hashFunction hashSize;
		deriveKey.
	clientKey := (HMAC on: self hashFunction new)
		key: saltedPassword;
		digestMessage: 'Client Key'.
	storedKey := self hashFunction hashMessage: clientKey.
	authMsg := ',' join: { clientFirstWithoutHeader. serverFirst. clientFinalWithoutProof }.
	clientSig := (HMAC on: self hashFunction new)
		key: storedKey;
		digestMessage: authMsg.
	clientProof := 'p=' , (clientKey bitXor: clientSig) base64Encoded.
	clientFinal := ',' join: { clientFinalWithoutProof. clientProof }.
	op := OrderedIdentityDictionary new
		add: #saslContinue -> 1;
		add: #conversationId -> (response at: #conversationId);
		add: #payload -> clientFinal asByteArray;
		yourself.
	[ response := self root command: op database: database ]
		on: MongoCommandError
		do: [ ^ false ].
	parsedServerFinal := self parseScramResponse: (response at: #payload).
	serverKey := (HMAC on: self hashFunction new)
		key: saltedPassword;
		digestMessage: 'Server Key'.
	serverSig := ((HMAC on: self hashFunction new)
		key: serverKey;
		digestMessage: authMsg) base64Encoded.
	(parsedServerFirst at: #v) = serverSig
		ifFalse: [ ^ false "Server returned an invalid signature." ].
	(response at: #done)
		ifFalse: [ op := OrderedIdentityDictionary new
				add: #saslContinue -> 1;
				add: #conversationId -> (response at: #conversationId);
				add: #payload -> ByteArray new;
				yourself.
			response := self root command: op database: database.
			^ response at: #done ].	"ifFalse: SASL conversation failed to complete."
	^ true