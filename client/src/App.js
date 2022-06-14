import React, { Component } from "react";
import EIP712 from "./contracts/EIP712.json";
import getWeb3 from "./getWeb3";

import "./App.css";

var ethUtil = require('ethereumjs-util');
var sigUtil = require('eth-sig-util');
let deployedNetwork;
class App extends Component {
  state = { web3: null, accounts: null, contract: null };
  componentDidMount = async () => {
    try {
      // Get network provider and web3 instance.
      const web3 = await getWeb3();

      // Use web3 to get the user's accounts.
      const accounts = await web3.eth.getAccounts();
      // Get the contract instance.
      const networkId = await web3.eth.net.getId();
      deployedNetwork = EIP712.networks[networkId];
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
    const { web3, accounts, contract } = this.state;
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
          verifyingContract: deployedNetwork.address,
      },
      message: {
          from: {
              name: 'Alice',
              wallet: '0x9cEBAaB21C47b8F1FDB29AF9ddF963d88CBc1E0B',
          },
          to: {
              name: 'Bob',
              wallet: '0xB499965155Ad04c0b3ee93bF13d6Fd8f5D911104',
          },
          contents: 'Hello, Bob!',
      },
    };
    const msgParams = JSON.stringify(typedData)
    let from = accounts[0];
    var params = [from, msgParams]
    var method = 'eth_signTypedData_v3'
    web3.currentProvider.send({
      method,
        params,
        from,
      }, async function (err, result) {

        /*const recovered = sigUtil.recoverTypedSignature({ data: JSON.parse(msgParams), sig: result.result })
    
        if (ethUtil.toChecksumAddress(recovered) === ethUtil.toChecksumAddress(from)) {
          alert('Successfully ecRecovered signer as ' + from)
        } else {
          alert('Failed to verify signer when comparing ' + result + ' to ' + from)
        }*/
        const signature = result.result.substr(2); //remove 0x
        const r = '0x' + signature.slice(0, 64)
        const s = '0x' + signature.slice(64, 128)
        const v = '0x' + signature.slice(128, 130)
        let recoveredAddress;
        let resultVerify;

        await contract.methods.recoverAddress(typedData.message, v, r, s).call({from:accounts[0]})
        .then(function(result){
          recoveredAddress = result;
        });

        await contract.methods.verify(typedData.message, v, r, s).call({from:accounts[0]})
        .then(function(result){
          resultVerify = result;
        });
        alert("account : "+accounts[0]+"\nrecoveredAccount : "+recoveredAddress+"\nresult : "+resultVerify)
      }
    );
  };

  render() {
    if (!this.state.web3) {
      return <div>Loading Web3, accounts, and contract...</div>;
    }
    return (
      <div className="App">
        <div>account            : {this.state.accounts[0]}</div>
      </div>
    );
  }
}

export default App;