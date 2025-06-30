;; GreenGrid - Renewable energy production tracking and incentive platform
(define-data-var grid-administrator principal tx-sender)
(define-data-var total-energy-produced uint u0)
(define-data-var green-incentive-rate uint u15) ;; incentive tokens per kWh
(define-data-var last-incentive-period uint u0)

(define-map producer-generation principal uint)
(define-map energy-source-types principal (string-utf8 64))
(define-map approved-energy-sources (string-utf8 64) bool)

;; Error codes
(define-constant err-unauthorized-administrator (err u1300))
(define-constant err-administrator-already-set (err u1301))
(define-constant err-invalid-energy-amount (err u1302))
(define-constant err-no-incentives-available (err u1303))
(define-constant err-no-energy-production (err u1304))
(define-constant err-invalid-energy-source (err u1305))
(define-constant err-energy-source-not-approved (err u1306))

;; Verify administrator authorization
(define-private (is-grid-administrator (caller principal))
  (begin
    (asserts! (is-eq caller (var-get grid-administrator)) err-unauthorized-administrator)
    (ok true)))

;; Initialize renewable energy tracking system
(define-public (initialize-green-grid (administrator principal))
  (begin
    (asserts! (is-none (map-get? producer-generation administrator)) err-administrator-already-set)
    (var-set grid-administrator administrator)
    (ok "GreenGrid renewable energy tracking initialized")))

;; Approve renewable energy source type
(define-public (approve-energy-source (source-type (string-utf8 64)))
  (begin
    (try! (is-grid-administrator tx-sender))
    (asserts! (> (len source-type) u0) err-invalid-energy-source)
    (map-set approved-energy-sources source-type true)
    (ok "Renewable energy source approved")))

;; Record renewable energy production
(define-public (record-energy-production (kwh-produced uint) (source-type (string-utf8 64)))
  (begin
    (asserts! (> kwh-produced u0) err-invalid-energy-amount)
    (asserts! (default-to false (map-get? approved-energy-sources source-type)) err-energy-source-not-approved)
    
    (let ((current-production (default-to u0 (map-get? producer-generation tx-sender))))
      (map-set producer-generation tx-sender (+ current-production kwh-produced))
      (map-set energy-source-types tx-sender source-type)
      (var-set total-energy-produced (+ (var-get total-energy-produced) kwh-produced))
      (ok (+ current-production kwh-produced)))))

;; Process green energy incentives
(define-public (process-green-incentives)
  (begin
    (try! (is-grid-administrator tx-sender))
    (let ((current-period (+ (var-get last-incentive-period) u1))
          (total-production (var-get total-energy-produced)))
      (asserts! (> total-production (var-get last-incentive-period)) err-no-incentives-available)
      
      (let ((incentive-pool (* (var-get green-incentive-rate) total-production)))
        (var-set last-incentive-period current-period)
        (ok incentive-pool)))))

;; Claim renewable energy incentives
(define-public (claim-energy-incentives)
  (begin
    (let ((producer-kwh (default-to u0 (map-get? producer-generation tx-sender))))
      (asserts! (> producer-kwh u0) err-no-energy-production)
      
      (let ((total-production (var-get total-energy-produced))
            (base-incentives (* (var-get green-incentive-rate) producer-kwh))
            (production-share (/ (* producer-kwh u100000) total-production)))
        
        (let ((final-incentives (/ (* production-share base-incentives) u100000)))
          (map-delete producer-generation tx-sender)
          (map-delete energy-source-types tx-sender)
          (var-set total-energy-produced (- (var-get total-energy-produced) producer-kwh))
          (ok (+ producer-kwh final-incentives)))))))

;; Read-only functions
(define-read-only (get-producer-generation (producer principal))
  (default-to u0 (map-get? producer-generation producer)))

(define-read-only (get-energy-source-type (producer principal))
  (map-get? energy-source-types producer))

(define-read-only (get-total-energy-produced)
  (var-get total-energy-produced))

(define-read-only (is-energy-source-approved (source-type (string-utf8 64)))
  (default-to false (map-get? approved-energy-sources source-type)))