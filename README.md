# Art Ownership Smart Contract

This smart contract, written in Clarity, represents certificates of ownership for physical artwork. It manages ownership records, artwork details, and token supply for each piece of art.

## Contract Details

- **File Path:** `contracts/art-ownership.clar`
- **Language:** Clarity

## Features

- **Ownership Management:** 
  - Maintains a record of ownership for each artwork using a unique token ID.
  - Allows querying of the current owner and the active status of the ownership.

- **Artwork Details:**
  - Stores detailed information about each artwork, including name, description, artist, and timestamps for creation and updates.

- **Token Supply Management:**
  - Keeps track of the current token ID supply.

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
