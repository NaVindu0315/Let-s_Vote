import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:quickalert/quickalert.dart';

import 'package:web3dart/web3dart.dart';

import 'test_constants.dart';

import 'package:firebase_storage/firebase_storage.dart';

Future<List<dynamic>> ask(
    String funcName, List<dynamic> args, Web3Client ethClient) async {
  final contract = await loadContract();
  final ethFunction = contract.function(funcName);
  final result =
      ethClient.call(contract: contract, function: ethFunction, params: args);
  return result;
}

Future<String> letsvotejson() async {
  final ref = FirebaseStorage.instance.ref('jsons/lvote2.json');
  final bytes = await ref.getData();
  final jsonString = utf8.decode(bytes!);
  return (jsonString);
}

Future<DeployedContract> loadContract() async {
  /* String abi = await rootBundle.loadString('assets/abi.json');
  String contractAddress = contractAddress1;
  final contract = DeployedContract(ContractAbi.fromJson(abi, 'Election'),
      EthereumAddress.fromHex(contractAddress));

  ///should return contract
  return contract;*/

  final abiFile = await letsvotejson();
  final contract = DeployedContract(ContractAbi.fromJson(abiFile, 'lvote2'),
      EthereumAddress.fromHex(contractadrs2));
  //print("payyya");
  return contract;
}

Future<String> callFunction(String funcname, List<dynamic> args,
    Web3Client ethClient, String privateKey) async {
  EthPrivateKey credentials = EthPrivateKey.fromHex(privateKey);
  DeployedContract contract = await loadContract();
  final ethFunction = contract.function(funcname);
  final result = await ethClient.sendTransaction(
      credentials,
      Transaction.callContract(
        contract: contract,
        function: ethFunction,
        parameters: args,
      ),
      chainId: null,
      fetchChainIdFromNetworkId: true);
  return result;
}

///to get candidate 1 votes
///
Future<List> getvotes_1(Web3Client ethClient) async {
  List<dynamic> result = await ask('get_1', [], ethClient);
  return result;
}

///candidate 1 vote count end
///
///
///to get candidate 1 votes
///
Future<List> getvotes_2(Web3Client ethClient) async {
  List<dynamic> result = await ask('get_2', [], ethClient);
  return result;
}

///candidate 1 vote count end

Future<String> vote_1(BuildContext context, Web3Client ethClient) async {
  var response = await callFunction("vote_1", [], ethClient, voter_private_key);
  print("Vote counted successfully for candidate 1");
  print(response);
  QuickAlert.show(
    context: context,
    type: QuickAlertType.success,
    title: 'Voted for candidate 1',
    text: '$response',
    backgroundColor: Colors.black,
    titleColor: Colors.white,
    textColor: Colors.white,
  );
  return response;
}

Future<String> vote_2(BuildContext context, Web3Client ethClient) async {
  var response = await callFunction("vote_2", [], ethClient, voter_private_key);
  print("Vote counted successfully for candidate 2");

  print(response);
  QuickAlert.show(
    context: context,
    type: QuickAlertType.success,
    title: 'Voted for Candidate 2',
    text: '$response',
    backgroundColor: Colors.black,
    titleColor: Colors.white,
    textColor: Colors.white,
  );
  return response;
}

Future<String> clearall(BuildContext context, Web3Client ethClient) async {
  var response =
      await callFunction("clearall", [], ethClient, voter_private_key);
  print("all cleared");
  print(response);

  QuickAlert.show(
    context: context,
    type: QuickAlertType.info,
    title: 'Votes Cleared',
    text: '$response',
    backgroundColor: Colors.black,
    titleColor: Colors.white,
    textColor: Colors.white,
  );
  return response;
}

Future<String> voteclearblockchain(Web3Client ethClient) async {
  var response =
      await callFunction("clearall", [], ethClient, voter_private_key);
  print("all cleared");
  print(response);

  return response;
}
