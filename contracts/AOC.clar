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

;; Public function to mint a new art token
(define-public (mint-art (name (string-ascii 50))
                         (description (string-ascii 200))
                         (artist (string-ascii 50)))
  (let 
    ((next-id (+ u1 (default-to u0 (get current-id (map-get? token-supply { id: u1 }))))))
    (begin
      ;; Input validation
      (asserts! (validate-string name) err-invalid-params)
      (asserts! (validate-description description) err-invalid-params)
      (asserts! (validate-string artist) err-invalid-params)
      
      ;; Ensure the token does not already exist
      (asserts! (is-none (map-get? art-ownership { token-id: next-id })) err-token-exists)

      ;; Save art details and owner
      (map-set art-ownership { token-id: next-id } { owner: tx-sender, is-active: true })
      (map-set art-details { token-id: next-id } { name: name, description: description, artist: artist, created-at: stacks-block-height, updated-at: stacks-block-height })
      (map-set token-supply { id: u1 } { current-id: next-id })

      ;; Return success
      (ok next-id))))

(define-public (transfer-art (token-id uint) (new-owner principal))
  (let ((token-supply-data (map-get? token-supply { id: u1 })))
    (begin
      ;; Validate token-id
      (asserts! (and 
          (is-some token-supply-data)
          (<= token-id (get current-id (unwrap-panic token-supply-data)))
      ) err-invalid-params)
      ;; Ensure the token exists and caller is the current owner
      (match (map-get? art-ownership { token-id: token-id })
      owner-data (begin
          (asserts! (get is-active owner-data) err-inactive-token)
          (asserts! (is-eq tx-sender (get owner owner-data)) err-unauthorized)
          ;; Transfer ownership
          (asserts! (is-some (some new-owner)) err-invalid-owner)
          (map-set art-ownership { token-id: token-id } { owner: new-owner, is-active: true })
          (match (map-get? art-details { token-id: token-id })
            art-data (begin
              (asserts! (and 
                (validate-string (get name art-data))
                (validate-description (get description art-data))
                (validate-string (get artist art-data))
                (> (get updated-at art-data) u0)) 
                err-invalid-params)
                (map-set art-details 
                { token-id: token-id } 
                { 
                  name: (get name art-data),
                  description: (get description art-data),
                  artist: (get artist art-data),
                  created-at: (get created-at art-data),
                  updated-at: stacks-block-height 
                })
              (ok true))
            err-token-not-found))
        err-token-not-found))))

;; Public function to get details of a specific art token
(define-read-only (get-art-details (token-id uint))
  (match (map-get? art-details { token-id: token-id })
    details (ok details)
    (err err-token-not-found)))

;; Public function to get the owner of a specific art token
(define-read-only (get-art-owner (token-id uint))
  (match (map-get? art-ownership { token-id: token-id })
    owner-data (if (get is-active owner-data)
                   (ok (get owner owner-data))
                   (err err-inactive-token))
    (err err-token-not-found)))
(define-public (deactivate-token (token-id uint))
    (let ((token-supply-data (map-get? token-supply { id: u1 })))
        (begin
            (asserts! (and 
                (is-some token-supply-data)
                (<= token-id (get current-id (unwrap-panic token-supply-data)))
            ) err-invalid-params)
            (match (map-get? art-ownership { token-id: token-id })
                owner-data (begin
                    (asserts! (is-contract-owner) err-unauthorized)
                    (map-set art-ownership
                        { token-id: token-id }
                        { owner: (get owner owner-data), is-active: false })
                    (ok true))
                err-token-not-found))))
