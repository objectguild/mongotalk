private
parseScramResponse: payload
	"Parse response from ByteArray to Dictionary.
	Example:
	(SCRAMAuthMechanism new parseScramResponse: 'r=NDQwNDY0NjUxNDE3MjAzNTM=D06U34OmY+NSiHeqb5LlQQ==,s=xyBf9wy9k94L7Zn+6A6UXg==,i=10000') >>> { 'r' -> 'NDQwNDY0NjUxNDE3MjAzNTM=D06U34OmY+NSiHeqb5LlQQ=='. 's' -> 'xyBf9wy9k94L7Zn+6A6UXg=='. 'i' -> '10000' } asDictionary"
	^ ((payload asString substrings: ',')
		collect: [ :each | each first asString -> (each copyFrom: 3 to: each size) ])
		asDictionary