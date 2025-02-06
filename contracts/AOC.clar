;; File: contracts/art-ownership.clar

;; This smart contract represents certificates of ownership for physical artwork.

(define-map art-ownership
  { token-id: uint }
  { owner: principal, is-active: bool })

(define-map art-details
  { token-id: uint }
  { name: (string-ascii 50), description: (string-ascii 200), artist: (string-ascii 50), created-at: uint, updated-at: uint })

(define-map token-supply
  { id: uint }
  { current-id: uint })

;; Define errors for better debugging and validation
(define-constant err-unauthorized (err u100))
(define-constant err-token-exists (err u101))
(define-constant err-token-not-found (err u102))
(define-constant err-invalid-params (err u103))
(define-constant err-inactive-token (err u104))
(define-constant err-invalid-owner (err u105))

;; Internal Functions
(define-private (is-contract-owner)
    (is-eq tx-sender contract-caller))

(define-private (validate-string (str (string-ascii 50)))
    (and (> (len str) u0) (<= (len str) u50)))

(define-private (validate-description (desc (string-ascii 200)))
    (and (> (len desc) u0) (<= (len desc) u200)))

(define-private (get-token-owner (token-id uint))
    (match (map-get? art-ownership { token-id: token-id })
        owner-data (ok (get owner owner-data))
        (err err-token-not-found)))

