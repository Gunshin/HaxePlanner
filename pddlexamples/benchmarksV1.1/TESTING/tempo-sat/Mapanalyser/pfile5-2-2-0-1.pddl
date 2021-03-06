(define (problem citycar-5-5-2)
(:domain mapanalyzer)
(:objects  
junction0-0 junction0-1 junction0-2 junction0-3 junction0-4 
junction1-0 junction1-1 junction1-2 junction1-3 junction1-4 
junction2-0 junction2-1 junction2-2 junction2-3 junction2-4 
junction3-0 junction3-1 junction3-2 junction3-3 junction3-4 
junction4-0 junction4-1 junction4-2 junction4-3 junction4-4 - junction
car0 car1 - car
garage0 garage1 - garage
road0 road1 road2 road3 road4 road5 road6 - road
)
(:init
	(=(build-time) 5)
	(=(remove-time) 3)
	(=(arrived-time) 1)
	(=(start-time) 1)
	(=(speed car0) 2)
	(=(speed car1) 15)
(available road0)
(available road1)
(available road2)
(available road3)
(available road4)
(available road5)
(available road6)
(connected junction0-0 junction0-1)
(connected junction0-1 junction0-0)
(=(distance junction0-0 junction0-1) 15)
(=(distance junction0-1 junction0-0) 15)
(connected junction0-1 junction0-2)
(connected junction0-2 junction0-1)
(=(distance junction0-1 junction0-2) 28)
(=(distance junction0-2 junction0-1) 28)
(connected junction0-2 junction0-3)
(connected junction0-3 junction0-2)
(=(distance junction0-2 junction0-3) 53)
(=(distance junction0-3 junction0-2) 53)
(connected junction0-3 junction0-4)
(connected junction0-4 junction0-3)
(=(distance junction0-3 junction0-4) 89)
(=(distance junction0-4 junction0-3) 89)
(connected junction1-0 junction1-1)
(connected junction1-1 junction1-0)
(=(distance junction1-0 junction1-1) 90)
(=(distance junction1-1 junction1-0) 90)
(connected junction1-1 junction1-2)
(connected junction1-2 junction1-1)
(=(distance junction1-1 junction1-2) 94)
(=(distance junction1-2 junction1-1) 94)
(connected junction1-2 junction1-3)
(connected junction1-3 junction1-2)
(=(distance junction1-2 junction1-3) 56)
(=(distance junction1-3 junction1-2) 56)
(connected junction1-3 junction1-4)
(connected junction1-4 junction1-3)
(=(distance junction1-3 junction1-4) 51)
(=(distance junction1-4 junction1-3) 51)
(connected junction2-0 junction2-1)
(connected junction2-1 junction2-0)
(=(distance junction2-0 junction2-1) 51)
(=(distance junction2-1 junction2-0) 51)
(connected junction2-1 junction2-2)
(connected junction2-2 junction2-1)
(=(distance junction2-1 junction2-2) 28)
(=(distance junction2-2 junction2-1) 28)
(connected junction2-2 junction2-3)
(connected junction2-3 junction2-2)
(=(distance junction2-2 junction2-3) 24)
(=(distance junction2-3 junction2-2) 24)
(connected junction2-3 junction2-4)
(connected junction2-4 junction2-3)
(=(distance junction2-3 junction2-4) 22)
(=(distance junction2-4 junction2-3) 22)
(connected junction3-0 junction3-1)
(connected junction3-1 junction3-0)
(=(distance junction3-0 junction3-1) 60)
(=(distance junction3-1 junction3-0) 60)
(connected junction3-1 junction3-2)
(connected junction3-2 junction3-1)
(=(distance junction3-1 junction3-2) 37)
(=(distance junction3-2 junction3-1) 37)
(connected junction3-2 junction3-3)
(connected junction3-3 junction3-2)
(=(distance junction3-2 junction3-3) 24)
(=(distance junction3-3 junction3-2) 24)
(connected junction3-3 junction3-4)
(connected junction3-4 junction3-3)
(=(distance junction3-3 junction3-4) 53)
(=(distance junction3-4 junction3-3) 53)
(connected junction4-0 junction4-1)
(connected junction4-1 junction4-0)
(=(distance junction4-0 junction4-1) 7)
(=(distance junction4-1 junction4-0) 7)
(connected junction4-1 junction4-2)
(connected junction4-2 junction4-1)
(=(distance junction4-1 junction4-2) 43)
(=(distance junction4-2 junction4-1) 43)
(connected junction4-2 junction4-3)
(connected junction4-3 junction4-2)
(=(distance junction4-2 junction4-3) 11)
(=(distance junction4-3 junction4-2) 11)
(connected junction4-3 junction4-4)
(connected junction4-4 junction4-3)
(=(distance junction4-3 junction4-4) 67)
(=(distance junction4-4 junction4-3) 67)
(connected junction0-0 junction1-0)
(connected junction1-0 junction0-0)
(=(distance junction0-0 junction1-0) 33)
(=(distance junction1-0 junction0-0) 33)
(connected junction1-0 junction2-0)
(connected junction2-0 junction1-0)
(=(distance junction1-0 junction2-0) 84)
(=(distance junction2-0 junction1-0) 84)
(connected junction2-0 junction3-0)
(connected junction3-0 junction2-0)
(=(distance junction2-0 junction3-0) 67)
(=(distance junction3-0 junction2-0) 67)
(connected junction3-0 junction4-0)
(connected junction4-0 junction3-0)
(=(distance junction3-0 junction4-0) 14)
(=(distance junction4-0 junction3-0) 14)
(connected junction0-1 junction1-1)
(connected junction1-1 junction0-1)
(=(distance junction0-1 junction1-1) 95)
(=(distance junction1-1 junction0-1) 95)
(connected junction1-1 junction2-1)
(connected junction2-1 junction1-1)
(=(distance junction1-1 junction2-1) 67)
(=(distance junction2-1 junction1-1) 67)
(connected junction2-1 junction3-1)
(connected junction3-1 junction2-1)
(=(distance junction2-1 junction3-1) 77)
(=(distance junction3-1 junction2-1) 77)
(connected junction3-1 junction4-1)
(connected junction4-1 junction3-1)
(=(distance junction3-1 junction4-1) 97)
(=(distance junction4-1 junction3-1) 97)
(connected junction0-2 junction1-2)
(connected junction1-2 junction0-2)
(=(distance junction0-2 junction1-2) 13)
(=(distance junction1-2 junction0-2) 13)
(connected junction1-2 junction2-2)
(connected junction2-2 junction1-2)
(=(distance junction1-2 junction2-2) 16)
(=(distance junction2-2 junction1-2) 16)
(connected junction2-2 junction3-2)
(connected junction3-2 junction2-2)
(=(distance junction2-2 junction3-2) 35)
(=(distance junction3-2 junction2-2) 35)
(connected junction3-2 junction4-2)
(connected junction4-2 junction3-2)
(=(distance junction3-2 junction4-2) 24)
(=(distance junction4-2 junction3-2) 24)
(connected junction0-3 junction1-3)
(connected junction1-3 junction0-3)
(=(distance junction0-3 junction1-3) 90)
(=(distance junction1-3 junction0-3) 90)
(connected junction1-3 junction2-3)
(connected junction2-3 junction1-3)
(=(distance junction1-3 junction2-3) 66)
(=(distance junction2-3 junction1-3) 66)
(connected junction2-3 junction3-3)
(connected junction3-3 junction2-3)
(=(distance junction2-3 junction3-3) 99)
(=(distance junction3-3 junction2-3) 99)
(connected junction3-3 junction4-3)
(connected junction4-3 junction3-3)
(=(distance junction3-3 junction4-3) 100)
(=(distance junction4-3 junction3-3) 100)
(connected junction0-4 junction1-4)
(connected junction1-4 junction0-4)
(=(distance junction0-4 junction1-4) 70)
(=(distance junction1-4 junction0-4) 70)
(connected junction1-4 junction2-4)
(connected junction2-4 junction1-4)
(=(distance junction1-4 junction2-4) 77)
(=(distance junction2-4 junction1-4) 77)
(connected junction2-4 junction3-4)
(connected junction3-4 junction2-4)
(=(distance junction2-4 junction3-4) 21)
(=(distance junction3-4 junction2-4) 21)
(connected junction3-4 junction4-4)
(connected junction4-4 junction3-4)
(=(distance junction3-4 junction4-4) 13)
(=(distance junction4-4 junction3-4) 13)
(clear junction0-0)
(clear junction0-1)
(clear junction0-2)
(clear junction0-3)
(clear junction0-4)
(clear junction1-0)
(clear junction1-1)
(clear junction1-2)
(clear junction1-3)
(clear junction1-4)
(clear junction2-0)
(clear junction2-1)
(clear junction2-2)
(clear junction2-3)
(clear junction2-4)
(clear junction3-0)
(clear junction3-1)
(clear junction3-2)
(clear junction3-3)
(clear junction3-4)
(clear junction4-0)
(clear junction4-1)
(clear junction4-2)
(clear junction4-3)
(clear junction4-4)
(at_garage garage0 junction0-0)
(at_garage garage1 junction0-0)
(starting car0 garage0)
(starting car1 garage1)
)
(:goal
(and
(arrived car0 junction4-0)
(arrived car1 junction4-0)
)
)
(:metric minimize (total-time))
)
