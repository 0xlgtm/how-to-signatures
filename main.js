const { ethers } = require('ethers');
require('dotenv').config()

const main = async () => {
  const provider = new ethers.JsonRpcProvider(process.env.RPC);
  const wallet = new ethers.Wallet(process.env.PK, provider);
  const me = await wallet.getAddress();

  /* For personal message */
  // Generate signature
  let message = 'hello world!';
  let signature = await wallet.signMessage(message);

  // Verify signature
  let address = ethers.verifyMessage(message, signature);

  // Logging stuff
  console.log(`Message     : ${message}`);
  console.log(`Signature   : ${signature}`);
  console.log(`Verification: ${address == me ? 'Success ✅' : 'Failed ❌'}`);

  /* For typed data */
  // For domain separator
  const domain = {
    name: 'MyEtherMail',
    version: '1',
    chainId: 1,
    verifyingContract: '0xEeeeeEeeeEeEeeEeEeEeeEEEeeeeEeeeeeeeEEeE'
  };

  // For typeHash, to be used in hashStruct
  const types = {
      Person: [
          { name: 'name', type: 'string' },
          { name: 'wallet', type: 'address' }
      ],
      Mail: [
          { name: 'from', type: 'Person' },
          { name: 'to', type: 'Person' },
          { name: 'contents', type: 'string' }
      ]
  };

  // For encodeData, to be used in hashStruct
  const value = {
      from: {
          name: 'Me',
          wallet: me
      },
      to: {
          name: 'Bob',
          wallet: '0xbBbBBBBbbBBBbbbBbbBbbbbBBbBbbbbBbBbbBBbB'
      },
      contents: 'Hello, Bob!'
  };

  signature = await wallet.signTypedData(domain, types, value);
  address = ethers.verifyTypedData(domain, types, value, signature);
  console.log("TypedData   :");
  console.log(value);
  console.log(`Signature   : ${signature}`);
  console.log(`Verification: ${address == me ? 'Success ✅' : 'Failed ❌'}`);
}

main();