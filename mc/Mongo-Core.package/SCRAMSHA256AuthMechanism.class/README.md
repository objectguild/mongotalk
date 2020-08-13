I provide the SCRAM-SHA-256 authentication mechanism for MongoDB.

My implementation is based on RFC 7677 (https://tools.ietf.org/html/rfc7677).

The SCRAM-SHA-256 SASL mechanism is defined in the same way that 
SCRAM-SHA-1 is defined in RFC 5802, except that the hash function 
for HMAC() and H() uses SHA-256 instead of SHA-1.
