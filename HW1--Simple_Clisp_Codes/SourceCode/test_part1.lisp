(load "csv-parser.lisp")
(in-package :csv-parser)

;; (read-from-string STRING)
;; This function converts the input STRING to a lisp object.
;; In this code, I use this function to convert lists (in string format) from csv file to real lists.

;; (nth INDEX LIST)
;; This function allows us to access value at INDEX of LIST.
;; Example: (nth 0 '(a b c)) => a

;; !!! VERY VERY VERY IMPORTANT NOTE !!!
;; FOR EACH ARGUMENT IN CSV FILE
;; USE THE CODE (read-from-string (nth ARGUMENT-INDEX line))
;; Example: (mypart1-funct (read-from-string (nth 0 line)) (read-from-string (nth 1 line)))

;; DEFINE YOUR FUNCTION(S) HERE

;; LIST-LEVELLER FUNCTION
(defun list-leveller(lists)
	(setq checkElement (car lists))
	(if (equal checkElement nil)
		returnList
		(progn 
			(if (equal (type-of checkElement) (type-of lists))
				(progn
					(setq checkElement (append checkElement (cdr lists)))
					(list-leveller checkElement)
				)
				(progn 
					(setq returnList (append returnList (list checkElement))) ; Add elements to an empty list 
					(list-leveller (cdr lists))
				) 
			) 
		)
	)
)

;; MAIN FUNCTION
(defun main ()
  	(with-open-file (stream #p"input_part1.csv")
	    (loop :for line := (read-csv-line stream) :while line :collect
	      	(format t "~a~%"
	      	;; CALL YOUR (MAIN) FUNCTION HERE
		      	(progn
		      		(setq returnList '()) ;An empty list to add element
		      		(list-leveller (read-from-string (nth 0 line)))
		      	)
	      	)
	    )
  	)
)

;; CALL MAIN FUNCTION
(main)

