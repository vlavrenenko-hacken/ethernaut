# foundry_hardhat_template

This project demonstrates a basic Hardhat+Foundry template. It comes with a sample contract along with the Foundry&Hardat tests written for that contract.
To test the project, you can either use the following scripts or use the bare commands:
#### Scripts
- npm run test - executes "hh test ; forge test" to start the hardhat and the foundry tests
- npm run remap - executes "forge remappings > remappings.txt" to update the remappings.txt
- npm run clean - executes "forge clean ; hh clean" to clear the cache/artifacts of both testing tools
#### Bare commands
- hh test - executes hardhat tests
- forge test - executes foundry tests
- forge clean - deletes the out/ and cache/
- hh clean - deletes the artifacts/
