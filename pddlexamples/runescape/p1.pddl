(define (problem runescape_test)
    (:domain runescape)
    (:objects
        logs - wood
        oak - wood
        willow - wood
		log_plank - plank
		oak_plank - plank
		willow_plank - plank
        
        logs_area - area
        oak_area - area
        willow_area - area
        bank_area - bank
		sawmill_area - sawmill
    )
    (:init
        (= (inventory_max) 28)
        (= (inventory_left) 28)
		
        (at bank_area)
        
        (contains logs_area logs)
        (contains oak_area oak)
        (contains willow_area willow)
		
		(conversion logs log_plank)
		(conversion oak oak_plank)
		(conversion willow willow_plank)
		
		(= (one) 1)
		(= (five) 5)
		(= (ten) 10)
		(= (twenty) 20)
    )
    (:goal
        (and
            (== (banked logs) 20)
			(== (inventory_has_item log_plank) 15)
        )
    )
)