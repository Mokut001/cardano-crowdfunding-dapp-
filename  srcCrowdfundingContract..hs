{-# LANGUAGE DataKinds, NoImplicitPrelude, TemplateHaskell, OverloadedStrings #-}
module Crowdfunding.Contract where
import Plutus.V2.Ledger.Api; import Plutus.V2.Ledger.Contexts; import PlutusTx.Prelude hiding (Applicative (..))
import Crowdfunding.Types

{-# INLINABLE mkValidator #-}
mkValidator :: CFParams -> CFDatum -> CFRedeemer -> ScriptContext -> Bool
mkValidator params datum redeemer ctx = case redeemer of
    Collect -> traceIfFalse "Goal not met" (totalScriptValue >= goal params) &&
               traceIfFalse "Not beneficiary" (txSignedBy info (beneficiary params))
    Refund  -> traceIfFalse "Not contributor" (txSignedBy info (contributor datum))
  where
    info = scriptContextTxInfo ctx
    totalScriptValue = valueOf (valueSpent info) adaSymbol adaToken

validator :: CFParams -> Validator
validator p = mkValidatorScript $ $$(PlutusTx.compile [|| mkValidator ||]) `PlutusTx.applyCode` PlutusTx.liftCode p