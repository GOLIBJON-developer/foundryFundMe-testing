-include .env
export

build:; forge build

deploy-sepolia:
	forge script script/FundMe.s.sol:CounterScript \
	--rpc-url $(RPC_URL) \
	--private-key $(PRIVATE_KEY) \
	--broadcast \
	--verify \
	--etherscan-api-key $(ETHERSCAN_API_KEY) \
	-vvvv || true