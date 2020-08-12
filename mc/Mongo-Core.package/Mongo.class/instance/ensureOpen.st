operations
ensureOpen
	self isOpen ifTrue: [ ^ self ].
	^ self open