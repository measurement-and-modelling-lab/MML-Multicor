function (data, datatype, hypothesis, deletion, N) {

    if (ncol(hypothesis) != 5) {
        stop("The hypothesis matrix has the wrong number of columns.")
    }

    ## There must be at least one fixed value hypothesis or one relational hypothesis
    if (!(0 %in% hypothesis[,4] || TRUE %in% duplicated(hypothesis[,4]))) {
        stop("The hypothesis matrix doesn't assert a testable hypothesis.")
    }

    if (NA %in% hypothesis) {
        stop("The hypothesis matrix has a missing element.")
    } else if (!is.numeric(hypothesis)) {
        stop('The hypothesis matrix has a non-numeric element.')
    } else if (!all(abs(hypothesis[,5]) <= 1)) {
        stop('The hypothesis matrix has a fixed value that is less than -1 or greater than 1.')
    } else if (!all(hypothesis[,1:4] %% 1 == 0)) {
        stop('The hypothesis matrix has a non-integer where it shouldn\'t.')
    } else if (!all(hypothesis[,1:3] > 0)) {
        stop('The hypothesis matrix has a non-positive number where it shouldn\'t.')
    } else if (!all(hypothesis[,4] >= 0)) {
        stop('The parameter tag column of the hypothesis matrix has a negative number.')
    } else if (!all(hypothesis[,1] == 1)) {
        stop('The hypothesis matrix references a non-existent group.')
    } else if (TRUE %in% duplicated(hypothesis[,2:3])) {
        stop('The hypothesis matrix references the same correlation twice.')
    }

    for (i in 1:nrow(hypothesis)) {
        variables <- ncol(data)
        row.index <- hypothesis[i,2]
        col.index <- hypothesis[i,3]
        if (row.index > variables) {
            message <- paste("Row", i, "of the hypothesis matrix references a non-existent variable.")
            stop(message)
        } else if (col.index > variables) {
            message <- paste("Row", i, "of the hypothesis matrix references a non-existent variable.")
            stop(message)
        }
    }

    rows <- nrow(data)
    cols <- ncol(data)

    if (!is.numeric(data)) {
        stop("Data matrix has at least one non-numeric entry.")
    }

    if (deletion == "nodeletion") {
        if (NA %in% data) {
            stop('Data matrix has at least one empty entry.')
        }
    }

    if (datatype == "rawdata") {

        if (rows <= cols) {
            stop("A raw data matrix must have more observations than variables.")
        }

        if (deletion != "nodeletion") {
            R <- cor(data, use="pairwise")
            if (NA %in% R) {
                stop("There is too much missing data to proceed.")
            }
        }
    }


    if (datatype == 'correlation') {

        if (N <= cols) {
            stop("You have as many or more variables than observations.")
        }

        if (!all(abs(data) <= 1)) {
            stop('Correlation matrix has a value that is less than -1 or greater than 1.')
        }

        if (rows != cols) {
            stop('Correlation matrix is not square.')
        }
    }
}
