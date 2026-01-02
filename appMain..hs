{-# LANGUAGE OverloadedStrings #-}
module Main where
import Cardano.Api; import Crowdfunding.Contract; import Crowdfunding.Types; import Plutus.V2.Ledger.Api (PubKeyHash(..), POSIXTime(..))
import Codec.Serialise (serialise); import qualified Data.ByteString.Lazy as LBS; import qualified Data.ByteString.Base16 as Base16; import qualified Data.ByteString.Char8 as BS

main :: IO ()
main = do
    let myPKH = PubKeyHash "b779fb5ad1dd0ed13aaf76138dbc60d73f5bcaabff122b3e961a8c5b"
    let params = CFParams myPKH 500000000 (POSIXTime 1735689600)
    let scriptRaw = LBS.toStrict $ serialise (validator params)
    BS.putStrLn $ Base16.encode scriptRaw