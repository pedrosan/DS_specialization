## Put comments here that give an overall description of what your
## functions do

## Function setting up the object that will store the data in a matrix
## and define operations on it.
## The 'set' function tests if the argument it receives is :
##  + a matrix, and then if it is square
##  + a vector, and then it if can be converted into a square matrix
## If it can't set a valid (i.e. square) matrix from the input, the output is NULL.
## Otherwise the matrix and its inverse are stored in the environment associated 
## with the functions created by 'makeCacheMatrix', thus remaining accessible to them
## over different calls.

makeCacheMatrix <- function(X = matrix()) {
    InvX <- NULL
    set <- function(y) {
	# is it a matrix? 
	if(is.matrix(y)) {

	    # is it square?
	    if( nrow(y) == ncol(y) ) {
                X <<- y
	    } else {
	        message("input (matrix) invalid : not square ")
                X <<- NULL
	    }

	# is it a vector?
	} else if(is.vector(y)) {
	    message("input is a vector")

	    # can it be used to make a square matrix?
	    test <- as.integer(round(sqrt(length(y)))**2.)
	    if( test == length(y) ) {
	        test <- as.integer(round(sqrt(length(y))))
	        X <<- array(y, dim=c(test,test))
	        message("input (vector) converted into a square matrix")
	    } else {
	        message("input (vector) unusable : can not be converted into a square matrix")
	        X <<- NULL
	    }
	} else {
	    message("input invalid")
	    X <<- NULL
	}
        InvX <<- NULL
    }
    get <- function() X
    set.inverse <- function(inverse) InvX <<- inverse
    get.inverse <- function() InvX
    list(set = set, 
         get = get,
         set.inverse = set.inverse,
         get.inverse = get.inverse)
}

## 'cacheSolve' uses the functions defined by 'makeCacheMatrix' to get the data
## corresponding to the argument name and to set the inverse matrix in their environment.
## This latter is actually handled by 'set.inverse' not by 'cacheSolve', whose
## assignments are all of the standard type (<-).
## 
## 'cacheSolve' does not try to catch any problem or error, it assumes that the data
## it gets and the functions it calls are ok.
## 
## While testing a few times I got an error from 'solve' or deeper calls, 
## that I don't believe signal a problem with this simple function itself.
## 

cacheSolve <- function(X, ...) {
    m <- X$get.inverse()
    if(!is.null(m)) {
        message("inverse matrix exists : getting cached data")
        return(m)
    }
    data <- X$get()
    m <- solve(data)
    X$set.inverse(m)
    m
}

