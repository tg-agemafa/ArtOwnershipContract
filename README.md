# Art Ownership Smart Contract

This smart contract, written in Clarity, represents certificates of ownership for physical artwork. It manages ownership records, artwork details, and token supply for each piece of art.

## Contract Details

- **File Path:** `contracts/AOC.clar`
- **Language:** Clarity

## Features

- **Minting Art Tokens:** 
  - Allows the creation of new art tokens with specified name, description, and artist.
  - Ensures unique token IDs and validates input parameters.

- **Ownership Transfer:**
  - Enables the transfer of art token ownership to a new owner.
  - Validates the current owner and ensures the token is active before transfer.

- **Querying Functions:**
  - Provides read-only functions to retrieve art details and current owner information.
  - Includes error handling for non-existent or inactive tokens.

- **Token Deactivation:**
  - Allows deactivation of tokens by the contract owner, marking them as inactive.

## Error Handling

The contract defines several constants for error handling to improve debugging and validation:

- `err-unauthorized`: Error code `u100` for unauthorized actions.
- `err-token-exists`: Error code `u101` for attempts to create a token that already exists.
- `err-token-not-found`: Error code `u102` for non-existent tokens.
- `err-invalid-params`: Error code `u103` for invalid parameters.
- `err-inactive-token`: Error code `u104` for inactive tokens.
- `err-invalid-owner`: Error code `u105` for invalid ownership claims.

## Internal Functions

- **is-contract-owner:** Checks if the transaction sender is the contract caller.
- **validate-string:** Validates the length of a string (up to 50 characters).
- **validate-description:** Validates the length of a description (up to 200 characters).
- **get-token-owner:** Retrieves the owner of a token by its ID, returning an error if not found.

## Usage

This contract is designed to be deployed on the Stacks blockchain, where it can be used to manage and verify ownership of physical artworks. It is intended for use by galleries, artists, and collectors who need a secure and transparent way to manage art ownership records.

## Contributing

Contributions are welcome! Please open an issue or submit a pull request for any improvements or bug fixes.

## Contact

For questions or support, please contact the repository maintainer.
