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

;; INSERT-N-HELPER FUNCTION
(defun insert-n-helper (tList retList number index i j)
	(if (equal (car tList) nil)
		(if (< j index) 
			(progn 
				(setq retList (append retList (list nil)))
				(incf j 1)
				(insert-n-helper (cdr tList) retList number index i j)
			)
			(progn
				(setq retList (append retList (list number)))
				(setq retList (append retList (cdr tList)))
			)	
		)
		(if (equal i index)
			(progn
				(setq retList (append retList (list number)))
				(setq retList (append retList tList))
			)
			(progn
				(setq retList (append retList (list (car tList))))
				(incf i 1)
				(incf j 1)
				(insert-n-helper (cdr tList) retList number index i j)
			)	
		)	
	)
	
)

;; INSERT-N FUNCTION
(defun insert-n (tList number index)
	(if (< index 0)
		"Index value can not be less than 0"
		(insert-n-helper tList '() number index 0 0)
	)	
)


;; MAIN FUNCTION
(defun main ()
  	(with-open-file (stream #p"input_part3.csv")
	    (loop :for line := (read-csv-line stream) :while line :collect
	      	(format t "~a~%"
	      	;; CALL YOUR (MAIN) FUNCTION HERE
	      		(insert-n (read-from-string (nth 0 line)) (read-from-string (nth 1 line)) (read-from-string (nth 2 line)))
	      	)
	    )
  	)
)

;; CALL MAIN FUNCTION
(main)

#|
 	Note: Index degeri listenin length'ine esit veya buyukse "nil" atarak liste icerisi index degeri kadar buyutulerek sayının index degerine yazilmasi saglanir.
 	Ayrica bos bir listenin ilk elemanini ekrana basmak istedigimizde "nil" vermektedir. Bu durumdan yola cikarak fonksiyonumu bu kosulda yazdim.
 	Asagida kenndi test ettigim yapi bulunmaktadir.
|#

;; Other test trials other than the CSV file are as follows.

#| 
;; test
;; insert-n (tList number index)
(setq testList '(1 2 3 4 5))
(write "Test List ==> ")
(write testList)
(write-line "")
(write (insert-n testList 10 3)) ; ==>> (1 2 3 10 4 5)
(write-line "")
(write (insert-n testList 10 10)) ; ==>> (1 2 3 4 5 NIL NIL NIL NIL NIL 10)
(write-line "")
(write (insert-n testList 10 -5)) ; ==>> Index value can not be less than 0
(write-line "")
(write-line "")

(setq testList2 '(1 2 3 nil nil nil 4 5))
(write "Test List2 ==> ")
(write testList2)
(write-line "")
(write (insert-n testList2 10 4)) ; ==>> (1 2 3 NIL 10 NIL 4 5)
|#
