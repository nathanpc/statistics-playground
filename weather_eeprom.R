#' Simulating EEPROM data that will be created by the weather station project.
#' 
#' @author Nathan Campos \email{nathanpc@@dreamintech.net}

# How a data pack looks like:
# 1 byte  -> Day
# 1 byte  -> Month
# 1 byte  -> Hour
# 1 byte  -> Minute
# 4 bytes -> Temperature 
# 4 bytes -> Light
# 4 bytes -> Humidity
# 4 bytes -> Pressure

#' Splits a longer byte into smaller ones.
split_bigger_byte <- function (byte) {
  full_bytes <- floor(byte / 256)
  half_byte <- byte %% 256
  empty_bytes <- 3 - full_bytes  # 4 bytes - Half (1) - Full
  bytes <- c()

  if (full_bytes > 0) {
    # Populate the full bytes.
    for (i in 1:full_bytes) {
      bytes <- c(bytes, 256)
    }
  }

  if (full_bytes < 4) {
    # Add the half byte.
    bytes <- c(bytes, half_byte)
  }

  if (empty_bytes > 1) {
    # Fill the empty bytes.
    for (i in 1:empty_bytes) {
      bytes <- c(bytes, 0)
    }
  }
  
  return(bytes)
}

#' Creates a Data Pack to put into the EEPROM.
create_data_pack <- function (day, mon, hr, min, temp, light, hum, prs) {
  pack <- list()

  # Date and Time.
  attr(pack, "day")     <- day
  attr(pack, "month")   <- mon
  attr(pack, "hour")    <- hr
  attr(pack, "minutes") <- min

  # Sensor data.
  attr(pack, "temperature") <- split_bigger_byte(temp)
  attr(pack, "light_level") <- split_bigger_byte(light)
  attr(pack, "humidity") <- split_bigger_byte(hum)
  attr(pack, "pressure") <- split_bigger_byte(prs)

  return(pack)
}