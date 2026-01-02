// 1. Configuration
const BLOCKFROST_KEY = "61c2c5d8c94c7d5a8f8f5a1d4e3c2b1a0f9e8d7c6";
const SCRIPT_HEX = "5909245909210100003232323232323232222533300300114a0244646174756d004c636f6e7472696275746f72000000024b000000024d00000002494801b779fb5ad1dd0ed13aaf76138dbc60d73f5bcaabff122b3e961a8c5b0001";

async function contribute() {
    const status = document.getElementById("status");
    try {
        status.innerText = "Connecting...";

        // 2. Initialize Lucid with your Blockfrost Key
        const lucid = await Lucid.new(
            new Blockfrost("https://cardano-mainnet.blockfrost.io/api/v0", BLOCKFROST_KEY),
            "Mainnet"
        );

        // 3. Enable Wallet (Optimized for Android DApp Browsers like VESPR/Eternl)
        const wallet = window.cardano.vespr || window.cardano.eternl || window.cardano.nami;
        if (!wallet) throw new Error("No Cardano wallet found. Please use a DApp browser.");
        
        const api = await wallet.enable();
        lucid.selectWallet(api);
        
        const addr = await lucid.wallet.address();
        status.innerText = "Connected: " + addr.substring(0, 10) + "...";

        // 4. Set up the Smart Contract
        const script = { type: "PlutusV2", script: SCRIPT_HEX };
        const scriptAddr = lucid.utils.validatorToAddress(script);

        // 5. Build and Submit Transaction
        const adaAmount = document.getElementById("amt").value;
        if (!adaAmount || adaAmount <= 0) throw new Error("Enter a valid amount");

        const tx = await lucid.newTx()
            .payToContract(scriptAddr, { inline: "d87980" }, { lovelace: BigInt(adaAmount * 1000000) })
            .complete();

        const signed = await tx.sign().complete();
        const hash = await signed.submit();
        
        status.innerText = "Success! Hash: " + hash.substring(0, 15) + "...";
        alert("Success! Your contribution has been sent.");
    } catch (e) {
        status.innerText = "Error: " + e.message;
        console.error(e);
    }
}