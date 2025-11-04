;; A simple LISP interpreter written by Dr Klefstad for ICS 141 at UC Irvine.
;; I deleted key portions of it to allow you to learn more about evaluation.

;; I inserted NIL in places where I deleted code to allow them to load and run,
;; but nil is the wrong value to return. You must think about what to do instead.

;; Note the new top-level function, my-top, is defined at the bottom of this file
;; defines a new REPL read-eval-print loop that you can use to test your interpreter.

;; To run this, load this file into the lisp interpreter, then call
;; (my-top)
;; then type in expressions to be evaluated.

;; The homework assignment gives a list of good test cases which are
;; listed in order that you should probably implement thim in to ensure you
;; enough working to go on to the next test case.

;; We will use association lists, alists, for the stack of variables and
;; their values to implement dynamic scoping.  An alist is a list of this form:
;; ((var1 . val1) (var2 . val2) ... (varN . valN))
;; where each vari is a symbol representing a variable (or parameter) name
;; and each vali is the value of the variable.  assoc returns the association
;; of a given symbol, e.g,
;; (assoc 'myvar '((a . 10)(b a b c)(myvar d e f)))
;; returns (myvar d e f) and you take the cdr of that to get myvar's value
;; (d e f)

;; my-assoc returns the association (binding) of a variable in the association
;; list. An association list may contain multiple definitions of a variable
;; with the same name, for example with parameters to a recursive function.
;; Assoc always finds the first association of a variable, and this is how we
;; implement dynamic scoping. 

;; As evaluation proceeds deeper into recursion, new variables are added onto
;; the front of the current association list.  New defintions of a variable 
;; will hide previously made definitions effectively hiding them from access.
;; The previously made definitions will come back into scope when
;; recursive evaluation unwinds.

;; We us a special global variable, called global-alist, for saving top-level
;; definitions made using defun or setq. Note the global-alist is passed in
;; to my-eval only in the call made by my-top defined below.


(defvar global-alist nil)

(defun my-assoc (v alist)
  (cond ((null alist) nil)
        ((eq v (car (car alist))) (car alist))
        (t (my-assoc v (cdr alist)))
  )
)


(defun my-eval (e alist)
    (cond ((atom e) (my-eval-atom e alist))
          (t (my-apply (car e) (cdr e) alist))
    )
)


(defun my-eval-atom (e alist)
    (cond ((null e) nil)
        ((eq e 't) 't)
        ((numberp e) e)
        ((stringp e) e)
        ((symbolp e)
            (cond((my-assoc e alist)
                    (cdr(my-assoc e alist))
                    )
                ((my-assoc e global-alist)
                    (cdr (my-assoc e global-alist)))
                (t nil)
            )

        )
        (t e)
    )

)


(defun my-apply (fn args alist)
    (cond ((atom fn) (my-apply-atom fn args alist))
          ( t (my-apply-lambda fn args alist)))
)


(defun my-eval-list (l alist)
    (cond ((null l) nil)
        ((null (cdr l))
            (my-eval (car l) alist)
        )
        (t
            (my-eval (car l) alist)
            (my-eval-list (cdr l) alist)
        )
    )
)

(defun my-apply-lambda (fn args alist)
    (my-eval-list (cdr(cdr fn))
        (my-bind-formals (car (cdr fn)) args alist)
    )
)

;; You need to write this one.

(defun my-bind-formals (formals actuals alist)
    (cond ((null formals) alist)
        (t
            (cons (cons (car formals) (my-eval (car actuals) alist))
            (my-bind-formals (cdr formals) (cdr actuals) alist)
            )
        )
    )
)


(defun my-plus (args alist acc)
    (cond ((null args) acc)
        (t (my-plus (cdr args) alist (+ acc (my-eval (car args) alist))))
    )
)

(defun my-times (args alist acc)
    (cond ((null args) acc)
        (t (my-times (cdr args) alist (* acc (my-eval (car args) alist))))
    )
)

(defun my-minus (args alist)
    (cond ((null args) 0)
        ((null (cdr args)) (- 0 (my-eval (car args) alist)))
        (t (my-minus-next (cdr args) alist (my-eval (car args) alist)))
    )
)

(defun my-minus-next (args alist acc)
    (cond ((null args) acc)
        (t (my-minus-next (cdr args) alist (- acc (my-eval (car args) alist))))
    )
)

(defun my-quote-list (vals)
    (cond ((null vals) nil)
        (t (cons (cons 'quote (cons (car vals) nil))
            (my-quote-list (cdr vals))
            )
        )
    )
)

(defun my-apply-atom (fn args alist)
    (cond ((eq fn 'eq)
           (eq (my-eval (car args) alist) 
           (my-eval (cadr args) alist)))

          ((eq fn 'equal)
            (equal (my-eval (car args) alist)
                    (my-eval (car (cdr args)) alist))
          )

          ((eq fn 'car)
		    (car (my-eval (car args) alist))
          )
          
          ((eq fn 'cdr)
		    (cdr (my-eval (car args) alist))
          )
          ((eq fn 'cons)
		    (cons (my-eval (car args) alist)
                    (my-eval (car (cdr args)) alist)
            )
          )
          ((eq fn 'quote)
		    (car args)
          )

           ((eq fn 'atom)
            (atom (my-eval (car args) alist))
          )

          ((eq fn 'null)
            (null (my-eval (car args) alist))
          )

          ((eq fn 'listp)
            (cond ((null (my-eval (car args) alist)) 't)
                    ((atom (my-eval (car args) alist)) nil)
                    (t 't)
            )
          )

          ((eq fn 'setq)
            (my-eval-setq (car args) (my-eval (car (cdr args)) alist))
          )


          ((eq fn 'cond)
            (my-eval-cond args alist)
          )

          ((eq fn 'defun) 
            (my-eval-defun args alist)
          )

          ((eq fn 'eval)
            (my-eval (my-eval (car args) alist) alist)
          )

          ((eq fn 'print)
            (print (my-eval (car args) alist))
          )

          ((eq fn '+)
            (my-plus args alist 0)
          )

          ((eq fn '-)
            (my-minus args alist)
          )

          ((eq fn '*)
            (my-times args alist 1)
          )



		  (t
            (cond ((my-assoc fn alist)
                    (my-apply
                        (cons 'lambda
                            (cons (car (cdr (my-assoc fn alist)))
                            (cdr (cdr (my-assoc fn alist)))))   
                        args alist))
                   ((my-assoc fn global-alist)
                    (my-apply
                        (cons 'lambda
                                (cons (car (cdr (my-assoc fn global-alist)))
                                       (cdr (cdr (my-assoc fn global-alist)))))
                        args alist)
                   )

                   (t nil)
            )

          )
    )
)


(defun my-eval-setq (var val)
    (setq global-alist (cons (cons var val) global-alist))
    val
)


(defun my-eval-cond (clauses alist)
    (cond
        ((null clauses) nil)
        (t 
            (cond
                ((my-eval (car (car clauses)) alist)
                (cond
                    ((null (cdr (car clauses))) (my-eval (car (car clauses)) alist))
                    (t(my-eval-list (cdr (car clauses)) alist))
                )
                )
                (t (my-eval-cond (cdr clauses) alist))
            )
        )
    )
)


(defun my-eval-defun (body alist)
    (setq global-alist
        (cons (cons (car body) (cons (car (cdr body)) (cdr (cdr body))))
                global-alist))
    (car body)
)




(defun my-top ()
    (prog ()
        top
            ;; read an s-expression, evaluate it using my-eval passing in the global-alist,
            ;; then print the result, functions and global variables will be on global-alist

            (print (my-eval (read) global-alist))
            (terpri) ;; prints a newline
            (go top) ;; loops forever
    )
)
