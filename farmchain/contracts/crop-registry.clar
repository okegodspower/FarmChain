;; Crop Registry Contract
;; Registers and verifies crop batches from farmers

(define-data-var admin principal tx-sender)

(define-map crop-batches
  uint ;; batch-id
  {
    farmer: principal,
    crop-type: (string-ascii 50),
    location: (string-ascii 50),
    harvest-date: uint,
    cert-hash: (string-ascii 70),
    is-verified: bool
  }
)

(define-data-var next-id uint u1)

;; Error codes
(define-constant ERR-NOT-AUTHORIZED u100)
(define-constant ERR-NOT-FOUND u101)
(define-constant ERR-ALREADY-VERIFIED u102)

(define-private (is-admin)
  (is-eq tx-sender (var-get admin)))

(define-public (register-crop
    (crop-type (string-ascii 50))
    (location (string-ascii 50))
    (harvest-date uint)
    (cert-hash (string-ascii 70))
  )
  (begin
    (asserts! (is-std-string-ascii? crop-type) (err u200))
    (asserts! (is-std-string-ascii? location) (err u201))
    (asserts! (is-std-string-ascii? cert-hash) (err u202))
    (let ((id (var-get next-id)))
      (begin
        (map-set crop-batches id {
          farmer: tx-sender,
          crop-type: crop-type,
          location: location,
          harvest-date: harvest-date,
          cert-hash: cert-hash,
          is-verified: false
        })
        (var-set next-id (+ id u1))
        (ok id)
      )
    )
  )
)

(define-public (verify-crop (id uint))
  (begin
    (asserts! (is-admin) (err ERR-NOT-AUTHORIZED))
    (match (map-get? crop-batches id)
      crop-batch
        (begin
          (asserts! (not (get is-verified crop-batch)) (err ERR-ALREADY-VERIFIED))
          (map-set crop-batches id (merge crop-batch { is-verified: true }))
          (ok true)
        )
      (err ERR-NOT-FOUND)
    )
  )
)

(define-read-only (get-crop (id uint))
  (match (map-get? crop-batches id)
    crop-batch
      (ok crop-batch)
    (err ERR-NOT-FOUND)
  )
)
