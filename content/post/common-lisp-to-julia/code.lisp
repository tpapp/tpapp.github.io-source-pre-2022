(defmethod mysum ((vec vector))
  (let ((s 0))
    (loop for elt across vec
       do (incf s elt))
    s))
