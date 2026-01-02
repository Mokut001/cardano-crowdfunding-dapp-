{-# LANGUAGE DeriveAnyClass, DeriveGeneric, NoImplicitPrelude, TemplateHaskell #-}
module Crowdfunding.Types where
import GHC.Generics (Generic); import Plutus.V2.Ledger.Api; import qualified PlutusTx; import PlutusTx.Prelude

data CFParams = CFParams { beneficiary :: PubKeyHash, goal :: Integer, deadline :: POSIXTime } deriving (Generic, Show)
PlutusTx.makeLift ''CFParams

newtype CFDatum = CFDatum { contributor :: PubKeyHash } deriving (Generic, Show)
PlutusTx.unstableMakeIsData ''CFDatum

data CFRedeemer = Collect | Refund deriving (Generic, Show)
PlutusTx.unstableMakeIsData ''CFRedeemer