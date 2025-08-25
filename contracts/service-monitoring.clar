;; Service Quality Monitoring Contract
;; Monitors service quality metrics and passenger feedback

;; Constants
(define-constant CONTRACT-OWNER tx-sender)
(define-constant ERR-NOT-AUTHORIZED (err u100))
(define-constant ERR-NOT-FOUND (err u101))
(define-constant ERR-INVALID-INPUT (err u102))
(define-constant ERR-ALREADY-EXISTS (err u103))
(define-constant ERR-INVALID-STATUS (err u104))

;; Data Variables
(define-data-var next-service-id uint u1)
(define-data-var next-feedback-id uint u1)

;; Data Maps
(define-map service-records
  { service-id: uint }
  {
    request-id: uint,
    vehicle-id: uint,
    driver-id: principal,
    passenger-id: principal,
    service-date: uint,
    pickup-time: uint,
    dropoff-time: uint,
    service-duration: uint,
    service-quality: uint,
    accessibility-rating: uint,
    on-time-performance: bool,
    equipment-functioning: bool,
    driver-assistance-rating: uint,
    created-at: uint
  }
)

(define-map passenger-feedback
  { feedback-id: uint }
  {
    service-id: uint,
    passenger-id: principal,
    overall-rating: uint,
    accessibility-rating: uint,
    driver-rating: uint,
    vehicle-rating: uint,
    feedback-text: (string-ascii 500),
    improvement-suggestions: (string-ascii 300),
    would-recommend: bool,
    submitted-at: uint
  }
)

(define-map quality-metrics
  { metric-date: uint }
  {
    total-services: uint,
    average-rating: uint,
    on-time-percentage: uint,
    equipment-success-rate: uint,
    passenger-satisfaction: uint,
    complaints-count: uint,
    compliments-count: uint
  }
)

(define-map authorized-operators principal bool)

;; Authorization Functions
(define-public (add-authorized-operator (operator principal))
  (begin
    (asserts! (is-eq tx-sender CONTRACT-OWNER) ERR-NOT-AUTHORIZED)
    (ok (map-set authorized-operators operator true))
  )
)

(define-read-only (is-authorized-operator (operator principal))
  (default-to false (map-get? authorized-operators operator))
)

;; Service Recording Functions
(define-public (record-service
  (request-id uint)
  (vehicle-id uint)
  (driver-id principal)
  (passenger-id principal)
  (service-date uint)
  (pickup-time uint)
  (dropoff-time uint)
  (accessibility-rating uint)
  (on-time-performance bool)
  (equipment-functioning bool)
  (driver-assistance-rating uint))
  (let
    (
      (service-id (var-get next-service-id))
      (current-time (unwrap-panic (get-block-info? time (- block-height u1))))
      (service-duration (- dropoff-time pickup-time))
      (service-quality (/ (+ accessibility-rating driver-assistance-rating) u2))
    )
    (asserts! (is-authorized-operator tx-sender) ERR-NOT-AUTHORIZED)
    (asserts! (> dropoff-time pickup-time) ERR-INVALID-INPUT)
    (asserts! (<= accessibility-rating u5) ERR-INVALID-INPUT)
    (asserts! (<= driver-assistance-rating u5) ERR-INVALID-INPUT)

    (map-set service-records
      { service-id: service-id }
      {
        request-id: request-id,
        vehicle-id: vehicle-id,
        driver-id: driver-id,
        passenger-id: passenger-id,
        service-date: service-date,
        pickup-time: pickup-time,
        dropoff-time: dropoff-time,
        service-duration: service-duration,
        service-quality: service-quality,
        accessibility-rating: accessibility-rating,
        on-time-performance: on-time-performance,
        equipment-functioning: equipment-functioning,
        driver-assistance-rating: driver-assistance-rating,
        created-at: current-time
      }
    )
    (var-set next-service-id (+ service-id u1))
    (ok service-id)
  )
)

;; Feedback Functions
(define-public (submit-passenger-feedback
  (service-id uint)
  (overall-rating uint)
  (accessibility-rating uint)
  (driver-rating uint)
  (vehicle-rating uint)
  (feedback-text (string-ascii 500))
  (improvement-suggestions (string-ascii 300))
  (would-recommend bool))
  (let
    (
      (feedback-id (var-get next-feedback-id))
      (service-data (unwrap! (map-get? service-records { service-id: service-id }) ERR-NOT-FOUND))
      (current-time (unwrap-panic (get-block-info? time (- block-height u1))))
    )
    (asserts! (is-eq tx-sender (get passenger-id service-data)) ERR-NOT-AUTHORIZED)
    (asserts! (<= overall-rating u5) ERR-INVALID-INPUT)
    (asserts! (<= accessibility-rating u5) ERR-INVALID-INPUT)
    (asserts! (<= driver-rating u5) ERR-INVALID-INPUT)
    (asserts! (<= vehicle-rating u5) ERR-INVALID-INPUT)

    (map-set passenger-feedback
      { feedback-id: feedback-id }
      {
        service-id: service-id,
        passenger-id: tx-sender,
        overall-rating: overall-rating,
        accessibility-rating: accessibility-rating,
        driver-rating: driver-rating,
        vehicle-rating: vehicle-rating,
        feedback-text: feedback-text,
        improvement-suggestions: improvement-suggestions,
        would-recommend: would-recommend,
        submitted-at: current-time
      }
    )
    (var-set next-feedback-id (+ feedback-id u1))
    (ok feedback-id)
  )
)

;; Quality Metrics Functions
(define-public (update-daily-metrics
  (metric-date uint)
  (total-services uint)
  (average-rating uint)
  (on-time-percentage uint)
  (equipment-success-rate uint)
  (passenger-satisfaction uint)
  (complaints-count uint)
  (compliments-count uint))
  (begin
    (asserts! (is-authorized-operator tx-sender) ERR-NOT-AUTHORIZED)
    (asserts! (<= average-rating u500) ERR-INVALID-INPUT) ;; 5.00 * 100
    (asserts! (<= on-time-percentage u100) ERR-INVALID-INPUT)
    (asserts! (<= equipment-success-rate u100) ERR-INVALID-INPUT)
    (asserts! (<= passenger-satisfaction u100) ERR-INVALID-INPUT)

    (map-set quality-metrics
      { metric-date: metric-date }
      {
        total-services: total-services,
        average-rating: average-rating,
        on-time-percentage: on-time-percentage,
        equipment-success-rate: equipment-success-rate,
        passenger-satisfaction: passenger-satisfaction,
        complaints-count: complaints-count,
        compliments-count: compliments-count
      }
    )
    (ok true)
  )
)

;; Read Functions
(define-read-only (get-service-record (service-id uint))
  (map-get? service-records { service-id: service-id })
)

(define-read-only (get-passenger-feedback (feedback-id uint))
  (map-get? passenger-feedback { feedback-id: feedback-id })
)

(define-read-only (get-quality-metrics (metric-date uint))
  (map-get? quality-metrics { metric-date: metric-date })
)

(define-read-only (get-next-service-id)
  (var-get next-service-id)
)

(define-read-only (get-next-feedback-id)
  (var-get next-feedback-id)
)
