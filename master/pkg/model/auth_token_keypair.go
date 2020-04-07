package model

import "golang.org/x/crypto/ed25519"

// AuthTokenKeypair stores the public/private keypair used for asymmetric encryption
// of authentication tokens.
type AuthTokenKeypair struct {
	PublicKey  ed25519.PublicKey  `db:"public_key"`
	PrivateKey ed25519.PrivateKey `db:"private_key"`
}
