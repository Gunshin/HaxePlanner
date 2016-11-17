(define

;;@problem_name@v1_87291_nb_50_001
(problem v1_87291_nb_50_001)

(:domain motion_planning_v3)

(:objects b_0 b_1 b_2 b_3 b_4 b_5 b_6 b_7 b_8 b_9 b_10 b_11 b_12 b_13 b_14 b_15 b_16 b_17 b_18 b_19 b_20 b_21 b_22
          b_23 b_24 b_25 b_26 b_27 b_28 b_29 b_30 b_31 b_32 b_33 b_34 b_35 b_36 b_37 b_38 b_39 b_40 b_41 b_42 b_43 b_44 b_45 b_46 b_47 b_48 b_49 - obstacle
          w_0 w_1 - waypoint
          r - rover )

(:init

    ;; @energy@["r", 20]
    (= (energy r) 20)
    ;; @max_energy@["r", 100]
    (= (max_energy r) 100)

    ;;@location@["r", [9, -10]]
    (= (x r) 9) (= (y r) -10)

    ;;@location@["w_0", [-25,0]]
    (= (x w_0) -25) (= (y w_0) 0)
    ;;@location@["w_1", [25,40]]
    (= (x w_1) 25) (= (y w_1) 40)


    ;;@bounding_box@ {"coordinates": [[53.64261344365215, -49.448785459265075], [-52.41616327363562, -49.448785459265075], [-52.41616327363562, 49.76192381544372], [53.64261344365215, 49.76192381544372]]}
    (= (max_x) 53) (= (max_y) 49) (= (min_x) -52) (= (min_y) -49)

    ;;@obstacle@ {"coordinates": [[-12.91127753869291, -21.462825784632454], [-22.256712524247153, -21.462825784632454], [-22.256712524247153, -19.756900582315122], [-12.91127753869291, -19.756900582315122]]}
    (= (a1 b_0) 0) (= (b1 b_0) -9) (= (c1 b_0) 200)
    (= (a2 b_0) -1) (= (b2 b_0) 0) (= (c2 b_0) 37)
    (= (a3 b_0) 0) (= (b3 b_0) 9) (= (c3 b_0) -184)
    (= (a4 b_0) 1) (= (b4 b_0) 0) (= (c4 b_0) -22)


    ;;@obstacle@ {"coordinates": [[-33.14014869076226, 40.29890355662933], [-38.45937196192061, 40.29890355662933], [-38.45937196192061, 49.76192381544372], [-33.14014869076226, 49.76192381544372]]}
    (= (a1 b_3) 0) (= (b1 b_3) -5) (= (c1 b_3) -214)
    (= (a2 b_3) -9) (= (b2 b_3) 0) (= (c2 b_3) 363)
    (= (a3 b_3) 0) (= (b3 b_3) 5) (= (c3 b_3) 264)
    (= (a4 b_3) 9) (= (b4 b_3) 0) (= (c4 b_3) -313)

  ;;@obstacle@ {"coordinates": [[-29.85858058545824, -24.552721641080208], [-33.75142864431641, -24.552721641080208], [-33.75142864431641, -21.965221953463146], [-29.85858058545824, -21.965221953463146]]}
  (= (a1 b_6) 0) (= (b1 b_6) -3) (= (c1 b_6) 95)
  (= (a2 b_6) -2) (= (b2 b_6) 0) (= (c2 b_6) 87)
  (= (a3 b_6) 0) (= (b3 b_6) 3) (= (c3 b_6) -85)
  (= (a4 b_6) 2) (= (b4 b_6) 0) (= (c4 b_6) -77)


  ;;@obstacle@ {"coordinates": [[-39.1482907513893, -43.13700726023718], [-40.3662336060777, -43.13700726023718], [-40.3662336060777, -33.912662310354264], [-39.1482907513893, -33.912662310354264]]}
  (= (a1 b_9) 0) (= (b1 b_9) -1) (= (c1 b_9) 52)
  (= (a2 b_9) -9) (= (b2 b_9) 0) (= (c2 b_9) 372)
  (= (a3 b_9) 0) (= (b3 b_9) 1) (= (c3 b_9) -41)
  (= (a4 b_9) 9) (= (b4 b_9) 0) (= (c4 b_9) -361)


  ;;@obstacle@ {"coordinates": [[31.329283387565507, -38.673222077448834], [28.3728332066996, -38.673222077448834], [28.3728332066996, -32.44055959769687], [31.329283387565507, -32.44055959769687]]}
  (= (a1 b_12) 0) (= (b1 b_12) -2) (= (c1 b_12) 114)
  (= (a2 b_12) -6) (= (b2 b_12) 0) (= (c2 b_12) -176)
  (= (a3 b_12) 0) (= (b3 b_12) 2) (= (c3 b_12) -95)
  (= (a4 b_12) 6) (= (b4 b_12) 0) (= (c4 b_12) 195)

  ;;@obstacle@ {"coordinates": [[-2.529745820524788, 1.7054118151964008], [-7.035053399582615, 1.7054118151964008], [-7.035053399582615, 8.561765695985242], [-2.529745820524788, 8.561765695985242]]}
  (= (a1 b_13) 0) (= (b1 b_13) -4) (= (c1 b_13) -7)
  (= (a2 b_13) -6) (= (b2 b_13) 0) (= (c2 b_13) 48)
  (= (a3 b_13) 0) (= (b3 b_13) 4) (= (c3 b_13) 38)
  (= (a4 b_13) 6) (= (b4 b_13) 0) (= (c4 b_13) -17)

  ;;@obstacle@ {"coordinates": [[10.750563684783856, 42.174328601509316], [4.741443610285245, 42.174328601509316], [4.741443610285245, 47.4103096671911], [10.750563684783856, 47.4103096671911]]}
  (= (a1 b_16) 0) (= (b1 b_16) -6) (= (c1 b_16) -253)
  (= (a2 b_16) -5) (= (b2 b_16) 0) (= (c2 b_16) -24)
  (= (a3 b_16) 0) (= (b3 b_16) 6) (= (c3 b_16) 284)
  (= (a4 b_16) 5) (= (b4 b_16) 0) (= (c4 b_16) 56)

  ;;@obstacle@ {"coordinates": [[5.510651606662122, 19.532575035741576], [2.7229253380202474, 19.532575035741576], [2.7229253380202474, 26.598647106687064], [5.510651606662122, 26.598647106687064]]}
  (= (a1 b_19) 0) (= (b1 b_19) -2) (= (c1 b_19) -54)
  (= (a2 b_19) -7) (= (b2 b_19) 0) (= (c2 b_19) -19)
  (= (a3 b_19) 0) (= (b3 b_19) 2) (= (c3 b_19) 74)
  (= (a4 b_19) 7) (= (b4 b_19) 0) (= (c4 b_19) 38)

  ;;@obstacle@ {"coordinates": [[-38.90891097608875, 24.51319211395988], [-45.080105535893466, 24.51319211395988], [-45.080105535893466, 31.604761791779175], [-38.90891097608875, 31.604761791779175]]}
  (= (a1 b_22) 0) (= (b1 b_22) -6) (= (c1 b_22) -151)
  (= (a2 b_22) -7) (= (b2 b_22) 0) (= (c2 b_22) 319)
  (= (a3 b_22) 0) (= (b3 b_22) 6) (= (c3 b_22) 195)
  (= (a4 b_22) 7) (= (b4 b_22) 0) (= (c4 b_22) -275)

  ;;@obstacle@ {"coordinates": [[-39.67448703750145, 22.548718155402845], [-41.35577162113398, 22.548718155402845], [-41.35577162113398, 27.93612456298367], [-39.67448703750145, 27.93612456298367]]}
  (= (a1 b_25) 0) (= (b1 b_25) -1) (= (c1 b_25) -37)
  (= (a2 b_25) -5) (= (b2 b_25) 0) (= (c2 b_25) 222)
  (= (a3 b_25) 0) (= (b3 b_25) 1) (= (c3 b_25) 46)
  (= (a4 b_25) 5) (= (b4 b_25) 0) (= (c4 b_25) -213)

  ;;@obstacle@ {"coordinates": [[-15.934055094576916, -28.11523624850872], [-22.315138614054238, -28.11523624850872], [-22.315138614054238, -26.933031131628898], [-15.934055094576916, -26.933031131628898]]}
  (= (a1 b_28) 0) (= (b1 b_28) -6) (= (c1 b_28) 179)
  (= (a2 b_28) -1) (= (b2 b_28) 0) (= (c2 b_28) 26)
  (= (a3 b_28) 0) (= (b3 b_28) 6) (= (c3 b_28) -171)
  (= (a4 b_28) 1) (= (b4 b_28) 0) (= (c4 b_28) -18)

  ;;@obstacle@ {"coordinates": [[52.4280003686132, -14.44789625108417], [46.11360383579017, -14.44789625108417], [46.11360383579017, -11.248469376647567], [52.4280003686132, -11.248469376647567]]}
  (= (a1 b_31) 0) (= (b1 b_31) -6) (= (c1 b_31) 91)
  (= (a2 b_31) -3) (= (b2 b_31) 0) (= (c2 b_31) -147)
  (= (a3 b_31) 0) (= (b3 b_31) 6) (= (c3 b_31) -71)
  (= (a4 b_31) 3) (= (b4 b_31) 0) (= (c4 b_31) 167)

  ;;@obstacle@ {"coordinates": [[-25.39214878924166, 29.34864237152269], [-32.68800083203215, 29.34864237152269], [-32.68800083203215, 38.524064323377296], [-25.39214878924166, 38.524064323377296]]}
  (= (a1 b_34) 0) (= (b1 b_34) -7) (= (c1 b_34) -214)
  (= (a2 b_34) -9) (= (b2 b_34) 0) (= (c2 b_34) 299)
  (= (a3 b_34) 0) (= (b3 b_34) 7) (= (c3 b_34) 281)
  (= (a4 b_34) 9) (= (b4 b_34) 0) (= (c4 b_34) -232)

  ;;@obstacle@ {"coordinates": [[-41.07662752384979, -45.201633983462024], [-45.131738782322465, -45.201633983462024], [-45.131738782322465, -36.42252453896452], [-41.07662752384979, -36.42252453896452]]}
  (= (a1 b_37) 0) (= (b1 b_37) -4) (= (c1 b_37) 183)
  (= (a2 b_37) -8) (= (b2 b_37) 0) (= (c2 b_37) 396)
  (= (a3 b_37) 0) (= (b3 b_37) 4) (= (c3 b_37) -147)
  (= (a4 b_37) 8) (= (b4 b_37) 0) (= (c4 b_37) -360)

  ;;@obstacle@ {"coordinates": [[-26.34535143839886, 36.28106529072693], [-27.962866329237418, 36.28106529072693], [-27.962866329237418, 44.79434353696732], [-26.34535143839886, 44.79434353696732]]}
  (= (a1 b_40) 0) (= (b1 b_40) -1) (= (c1 b_40) -58)
  (= (a2 b_40) -8) (= (b2 b_40) 0) (= (c2 b_40) 238)
  (= (a3 b_40) 0) (= (b3 b_40) 1) (= (c3 b_40) 72)
  (= (a4 b_40) 8) (= (b4 b_40) 0) (= (c4 b_40) -224)

  ;;@obstacle@ {"coordinates": [[-25.913269786456638, -23.167285086888114], [-33.053608303029, -23.167285086888114], [-33.053608303029, -16.146262864968236], [-25.913269786456638, -16.146262864968236]]}
  (= (a1 b_43) 0) (= (b1 b_43) -7) (= (c1 b_43) 165)
  (= (a2 b_43) -7) (= (b2 b_43) 0) (= (c2 b_43) 232)
  (= (a3 b_43) 0) (= (b3 b_43) 7) (= (c3 b_43) -115)
  (= (a4 b_43) 7) (= (b4 b_43) 0) (= (c4 b_43) -181)

  ;;@obstacle@ {"coordinates": [[-30.87663449361839, -46.778183246676456], [-39.40565674933574, -46.778183246676456], [-39.40565674933574, -41.26735934331496], [-30.87663449361839, -41.26735934331496]]}
  (= (a1 b_46) 0) (= (b1 b_46) -8) (= (c1 b_46) 398)
  (= (a2 b_46) -5) (= (b2 b_46) 0) (= (c2 b_46) 217)
  (= (a3 b_46) 0) (= (b3 b_46) 8) (= (c3 b_46) -351)
  (= (a4 b_46) 5) (= (b4 b_46) 0) (= (c4 b_46) -170)

  ;;@obstacle@ {"coordinates": [[8.42060145608764, 12.927282124847805], [7.182240018497594, 12.927282124847805], [7.182240018497594, 18.98645332317554], [8.42060145608764, 18.98645332317554]]}
  (= (a1 b_49) 0) (= (b1 b_49) -1) (= (c1 b_49) -16)
  (= (a2 b_49) -6) (= (b2 b_49) 0) (= (c2 b_49) -43)
  (= (a3 b_49) 0) (= (b3 b_49) 1) (= (c3 b_49) 23)
  (= (a4 b_49) 6) (= (b4 b_49) 0) (= (c4 b_49) 51)
)
(:goal (and
            ;;@goal_location@[19, 43]
            (= (x r) 19) (= (y r) 43)
            (taken_picture w_0)
            (taken_picture w_1)
	     )
)
)