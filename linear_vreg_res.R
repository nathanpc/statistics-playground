#' linear_vreg_res.R
#' Calculates the resistor values to be used in a op-amp based linear voltage
#' regulator according to a specific selection of voltage references.
#' 
#' @author Nathan Campos <nathanpc@dreamintech.net>

# Generates a E12 series of resistors.
e12_resistors <- function (steps = c(1000, 10000, 100000)) {
  base = c(1.0, 1.2, 1.5, 1.8, 2.2, 2.7, 3.3, 3.9, 4.7, 5.6, 6.8, 8.2)
  e12 = c()
  
  for (i in steps) {
    for (j in base) {
      e12 = c(e12, j * i)
    }
  }
  
  return(e12)
}

# Calculates all the resistor combinations possible.
resistor_combinations <- function (desired, refs, res, updev = 0.1, dwndev = 0.1) {
  vref = c()
  r1 = c()
  r2 = c()
  vout = c()

  for (ref in refs) {
    # Check if the reference is too close to the desired output.
    if (ref > (desired - dwndev) && ref < (desired + updev)) {
      cat(sprintf("%sV reference is inside the Vout range. Skipping...\n", ref))
      next
    }
    
    for (r1v in res) {
      for (r2v in res) {
        vo = ref * (1 + (r1v / r2v))
        
        if (vo >= round(desired - dwndev, 1) &&
            vo <= round(desired + updev, 1)) {
          vref = c(vref, ref)
          r1 = c(r1, r1v)
          r2 = c(r2, r2v)
          vout = c(vout, vo)
          
          cat(sprintf("REF(%s) R1(%s) R2(%s) = %#.4gV\n", ref, r1v, r2v, vo))
        }
      }
    }
  }
  
  return(data.frame(vref, r1, r2, vout))
}

refs <- c(0.6, 1.25, 2.5, 3.3, 5)
res <- e12_resistors()
combinations <- resistor_combinations(10.6, refs, res, updev = 0.1, dwndev = 0)
