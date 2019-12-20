#' analyze.R
#' Data analysis on package tracking information.
#'
#' @author Nathan Campos <nathanpc@dreamintech.net>

library(RSQLite)
library(ggplot2)

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

#' Grabs a perfect data frame for plotting the data for a country.
#'
#' @param  conn    Database connection.
#' @param  country Country name.
#' @return         Data frame to work with the data.
country_data <- function (conn, country) {
    data <- dbGetQuery(conn, "SELECT origin, carrier, wait_period, shipped,
                       delivered FROM Packages WHERE origin = ? ORDER BY
                       carrier ASC", params = list(country))

    return(data)
}

#' Exports the plot to a PDF file.
#'
#' @param graph ggplot2 graph object.
#' @param fn    Output PDF filename.
export_plot <- function (graph, fn) {
    pdf(fn)
    print(graph)
    dev.off()
}

#' The script main entry point.
main <- function () {
    # Connect to database.
    conn <- dbConnect(RSQLite::SQLite(), "data/database.db")

    # Grab various data points.
    carriers <- get_carriers(conn)
    countries <- get_countries(conn)

    # Get the data by country.
    df <- country_data(conn, "China")
    print(df)

    # Plot the data.
    graph <- ggplot(df, aes(x = wait_period, color = carrier, fill = carrier))
    graph <- graph + geom_density(alpha = 0.5)
    graph <- graph + labs(title = "Package Wait Period from China",
                         subtitle = "How long do you have to wait for a package to arrive?",
                         x = "Wait Period (Days)",
                         y = "Density",
                         fill = "Carriers",
                         color = "Carriers",
                         caption = "Data and Visualization by Nathan Campos (@nathanpc)")
    graph <- graph + theme(legend.position = "bottom")
    graph <- graph + expand_limits(x = 0, y = 0)
    print(graph)

    # Clean up.
    dbDisconnect(conn)
}

# Run the script.
main()
