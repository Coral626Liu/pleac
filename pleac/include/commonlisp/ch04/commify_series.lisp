;;;; commify_series - show proper comma insertion in list output

(defparameter *lists*
  '(("just one thing")
    ("Mutt" "Jeff")
    ("Peter" "Paul" "Mary")
    ("To our parents" "Mother Theresa" "God")
    ("pastrami" "ham and cheese" "peanut butter and jelly" "tuna")
    ("recycle tired, old phrases" "ponder big, happy thoughts")
    ("recycle tired, old phrases"
     "ponder big, happy thoughts"
     "sleep and dream peacefully")))

(defun commify_series (list)
  (let ((sepchar (if (find-if #'(lambda (string) 
                                  (find #\, string))
                              list)
                     "; " ", ")))
    (case (length list)
      (0 "")
      (1 (car list))
      (2 (format nil (format nil "~{~a~^ and ~}" list)))
      (t (concatenate 'string
                      (format nil
                              "~{~}" 
                              (concatenate 'string "~a~^" sepchar)
                              (butlast list))
                      (format nil " and ~a" (car (last list))))))))

(mapc #'(lambda (list)
          (format t "The list is: ~a.~%" (commify_series list)))
      *lists*)

