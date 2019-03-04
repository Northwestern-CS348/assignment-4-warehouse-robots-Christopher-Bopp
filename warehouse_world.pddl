(define (domain warehouse)
  (:requirements :typing)
  (:types robot pallette - bigobject
          location shipment order saleitem)

    (:predicates
      (ships ?s - shipment ?o - order)
      (orders ?o - order ?si - saleitem)
      (unstarted ?s - shipment)
      (started ?s - shipment)
      (complete ?s - shipment)
      (includes ?s - shipment ?si - saleitem)

      (free ?r - robot)
      (has ?r - robot ?p - pallette)

      (packing-location ?l - location)
      (packing-at ?s - shipment ?l - location)
      (available ?l - location)
      (connected ?l - location ?l - location)
      (at ?bo - bigobject ?l - location)
      (no-robot ?l - location)
      (no-pallette ?l - location)

      (contains ?p - pallette ?si - saleitem)
  )

   (:action startShipment
      :parameters (?sh - shipment ?o - order ?l - location)
      :precondition (and (unstarted ?sh) (not (complete ?sh)) (ships ?sh ?o) (available ?l) (packing-location ?l))
      :effect (and (started ?sh) (packing-at ?sh ?l) (not (unstarted ?sh)) (not (available ?l)))
   )

   (:action robotMove
      :parameters (?r - robot ?l1 - location ?l2 - location)
      :precondition (and (connected ?l1 ?l2) (at ?r ?l1) (no-robot ?l2))
      :effect (and (at ?r ?l2) (not (at ?r ?l1)) (no-robot ?l1) (not (no-robot ?l2)))
      )


    (:action robotMoveWithPallete
      :parameters (?l1 - location ?l2 - location ?r - robot ?p - pallette)
      :precondition (and (connected ?l1 ?l2) (at ?r ?l1) (at ?p ?l1) (no-robot ?l2) (no-pallette ?l2) (not (no-pallette ?l1)))
      :effect (and (at ?r ?l2) (not (at ?r ?l1)) (no-robot ?l1) (not (no-robot ?l2)) (at ?p ?l2) (not (at ?p ?l1)) (no-pallette ?l1) (not (no-pallette ?l2)))
    )

    (:action moveItemFromPalleteToShipment
      :parameters (?sh - shipment ?o - order ?l - location ?p - pallette ?si - saleitem)
      :precondition (and (packing-location ?l) (not (no-pallette ?l)) (at ?p ?l) (contains ?p ?si) (orders ?o ?si) (not (complete ?sh)) (ships ?sh ?o))
      :effect (and (includes ?sh ?si) (not (contains ?p ?si)))
    )

    (:action completeShipment
      :parameters (?sh - shipment ?o - order ?l - location)
      :precondition (and (started ?sh) (packing-at ?sh ?l) (not (unstarted ?sh)) (not (available ?l)) (ships ?sh ?o))
      :effect (and (complete ?sh) (available ?l) (not (packing-at ?sh ?l)))

    )

)