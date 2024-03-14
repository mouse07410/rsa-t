{-# LANGUAGE OverloadedStrings #-}
{-# OPTIONS_GHC -Wno-name-shadowing #-}

module Main (main) where

import Botan.Low.PubKey
import Botan.Low.PubKey.KeyEncapsulation
import Botan.Low.Hash
import Botan.Low.KDF
import Botan.Low.RNG

-- to convert between ByteString and [Char], and to
-- print out the generated shared secrets
import Data.ByteArray.Encoding ( Base(Base16), convertToBase)
import Data.ByteString (ByteString)

-- we do not have anything in the src/Lib.hs, so skip this import
-- import Lib

main :: IO ()
main = do
    putStrLn "RSA KEM demo:"
    -- Initialize RNG
    rng <- rngInit UserRNG
    -- Alice generates her private and public keys
    alicePrivKey <- privKeyCreate RSA "2048" rng
    alicePubKey <- privKeyExportPubKey alicePrivKey
    -- Set KDF for KEM and set generated shared key size in bits
    let kdfAlg = hkdf SHA384
    salt <- rngGet rng 4
    let sharedKeyLength = 256

    -- Bob (presumably) receives Alice's public key and generates shared secret
    encryptCtx <- kemEncryptCreate alicePubKey kdfAlg
    (bobSharedKey, encapsulatedKey) <- kemEncryptCreateSharedKey encryptCtx rng salt sharedKeyLength
    -- sendToAlice encapsulatedKey (outside of this demo)
    -- Print Bob's generated shared secret
    putStrLn "Bob's encapsulated key:   "
    let s = convertToBase Base16 (bobSharedKey :: ByteString) :: ByteString
    print s
    putStrLn ""

    -- Alice receives encapsulated shared secret and decrypts it
    decryptCtx <- kemDecryptCreate alicePrivKey kdfAlg
    aliceSharedKey <- kemDecryptSharedKey decryptCtx salt encapsulatedKey sharedKeyLength
    -- Print Alice's decrypted shared secret
    putStrLn "Alice's encapsulated key: "
    let s = convertToBase Base16 (aliceSharedKey :: ByteString) :: ByteString
    print s
    putStrLn ""

    -- assert that (bobSharedKey == aliceSharedKey), and output the result
    if not (bobSharedKey == aliceSharedKey)
        then putStrLn "Shared keys do not match!\n"
        else putStrLn "Shared keys match.\n\nCompleted demo.\n"
