#' analyze.R
#' Data analysis on package tracking information.
#'
#' @author Nathan Campos <nathanpc@dreamintech.net>

library(RSQLite)

#' Retrieves all the carrier names from the database.
#'
#' @param  conn Database connection.
#' @return      Vector with carrier names.
get_carriers <- function (conn) {
    carriers <- dbGetQuery(conn,
                           "SELECT carrier FROM Packages ORDER BY carrier ASC")
    return(unique(carriers$carrier))
}

#' Retrieves all the origin countries from the database.
#'
#' @param  conn Database connection.
#' @return      Vector with country names.
get_countries <- function (conn) {
    countries <- dbGetQuery(conn,
                            "SELECT origin FROM Packages ORDER BY origin ASC")
    return(unique(countries$origin))
}

#' The script main entry point.
main <- function () {
    # Connect to database.
    conn <- dbConnect(RSQLite::SQLite(), "data/database.db")

    # Get carriers.
    carriers <- get_carriers(conn)
    print(carriers)

    # Get countries.
    countries <- get_countries(conn)
    print(countries)

    # Get all the packages.
    packs <- dbGetQuery(conn, "SELECT * FROM Packages ORDER BY wait_period ASC")

    # Clean up.
    dbDisconnect(conn)
}

# Run the script.
main()
