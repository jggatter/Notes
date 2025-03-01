# TileDB Encryption
#tiledb #encryption

TileDB allows encrypting arrays at rest.
Currently supports only AES-256 encryption in the GCM mode.

## AES-256 and GCM

Advanced Encryption Standard (AES) algorithm requires key to unscramble it.
The key is a secret password that locks or unlocks the data.
AES-256 indicates 256-bit key (more bits = more secure).
It's secure, fast, and trusted.

Galois/Counter Mode (GCM) is a mode of operation for symmetric-key
cryptographic block ciphers.
It's like an add-on for AES-256 that improves tasks such as,
encrypting securely and quickly while also checking for tampering.
GCM creates an authentication tag (MAC) that acts as a tamper seal.
GCM guarantees confidentiality (key needed) and integrity (tampering revealed)
It makes AES-256 practical for real-world use.

## TileDB use of AES-256 and GCM

In TileDB, the AES-256 key is needed when creating/reading/writing arrays.
Authenticated nature of encryption scheme means a MAC,
or message authenticated code, is stored with the encrypted data
to enable verification that the persisted ciphertext was not modified.

Encryption is optionally specified on array-level at creation.
If specified, it applies to each physical data tile across attrs, coords, offsets.
TileDB further partitions each physical data tile into chunks,
typically of size that is equal to the L1 cache.
The chunks are streamed into the encryption process.

## Encryption key lifetime

TileDB doesn't persist the encryption key, but it does 
keep a copy of the key in main memory while an encrypted array is open.
When the array is closed, the memory used is zeroed out and freed.

## Performance

Extra processing is required to encrypt and decrypt array metadata/attr data.
Lower performane is to be expected for opening/reading/writing encrypted arrays.

Some newer CPUs offer instructions for hardware acceleration of 
encryption/decryption. TileDB is configured to use these if available.
