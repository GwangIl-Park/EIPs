import React, { Component } from "react";
import EIP712 from "./contracts/EIP712.json";
import getWeb3 from "./getWeb3";

import "./App.css";

var ethUtil = require('ethereumjs-util');
var sigUtil = require('eth-sig-util');

class App extends Component {
  state = { storageValue: 0, web3: null, accounts: null, contract: null };

  componentDidMount = async () => {
    try {
      // Get network provider and web3 instance.
      const web3 = await getWeb3();

      // Use web3 to get the user's accounts.
      const accounts = await web3.eth.getAccounts();

      // Get the contract instance.
      const networkId = await web3.eth.net.getId();
      const deployedNetwork = EIP712.networks[networkId];
      const instance = new web3.eth.Contract(
        EIP712.abi,
        deployedNetwork && deployedNetwork.address,
      );

      // Set web3, accounts, and contract to the state, and then proceed with an
      // example of interacting with the contract's methods.
      this.setState({ web3, accounts, contract: instance }, this.runExample);
    } catch (error) {
      // Catch any errors for any of the above operations.
      alert(
        `Failed to load web3, accounts, or contract. Check console for details.`,
      );
      console.error(error);
    }
  };


  runExample = async () => {
    const typedData = {
      types: {
          EIP712Domain: [
              { name: 'name', type: 'string' },
              { name: 'version', type: 'string' },
              { name: 'chainId', type: 'uint256' },
              { name: 'verifyingContract', type: 'address' },
          ],
          Person: [
              { name: 'name', type: 'string' },
              { name: 'wallet', type: 'address' }
          ],
          Mail: [
              { name: 'from', type: 'Person' },
              { name: 'to', type: 'Person' },
              { name: 'contents', type: 'string' }
          ],
      },
      primaryType: 'Mail',
      domain: {
          name: 'Ether Mail',
          version: '1',
          chainId: 1337,
          verifyingContract: '0x9297CF267D624a6Dd535487784865BDcDd437915',
      },
      message: {
          from: {
              name: 'Alice',
              wallet: '0xBd38a82611b0B1C3f027a3dEeb4CBBcf29A248f0',
          },
          to: {
              name: 'Bob',
              wallet: '0x323aA5668A80Ee1ef4168694031A8b069192aAd1',
          },
          contents: 'Hello, Bob!',
      },
    };
    const { web3, accounts, contract } = this.state;
    const msgParams = JSON.stringify(typedData)
    let from = accounts[0];
    var params = [from, msgParams]
    var method = 'eth_signTypedData_v3'
    web3.currentProvider.send({
      method,
        params,
        from,
      }, async function (err, result) {
        const recovered = sigUtil.recoverTypedSignature({ data: JSON.parse(msgParams), sig: result.result })
    
        if (ethUtil.toChecksumAddress(recovered) === ethUtil.toChecksumAddress(from)) {
          alert('Successfully ecRecovered signer as ' + from)
        } else {
          alert('Failed to verify signer when comparing ' + result + ' to ' + from)
        }
        const signature = result.result.substring(2);
        const r = "0x" + signature.substring(0, 64);
        const s = "0x" + signature.substring(64, 128);
        const v = parseInt(signature.substring(128, 130), 16);
        console.log("r:", r);
        console.log("s:", s);
        console.log("v:", v);
    // Stores a given value, 5 by default.
        await contract.methods.verify(typedData.message,v,r,s).send({ from: accounts[0] });
      }
    );
    // Get the value from the contract to prove it worked.
    //const response = await contract.methods.get().call();

    // Update state with the result.
    //this.setState({ storageValue: response });
  };

  render() {
    if (!this.state.web3) {
      return <div>Loading Web3, accounts, and contract...</div>;
    }
    return (
      <div className="App">
        <h1>Good to Go!</h1>
        <p>Your Truffle Box is installed and ready.</p>
        <h2>Smart Contract Example</h2>
        <p>
          If your contracts compiled and migrated successfully, below will show
          a stored value of 5 (by default).
        </p>
        <p>
          Try changing the value stored on <strong>line 42</strong> of App.js.
        </p>
        <div>The stored value is: {this.state.storageValue}</div>
      </div>
    );
  }
}

export default App;
