updating
update: anAspect

	anAspect == #poolSettings
		ifTrue: [ ^ self updatedPoolSettings ].

	super update: anAspect.