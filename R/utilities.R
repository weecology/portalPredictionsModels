#' @title Argument matching with defaults
#'
#' @description Expansion of \code{\link[base]{match.call}} to include
#'  default formal values.
#'
#' @param definition A \code{function}, by default the function from which 
#'  \code{match.call.defaults} is called. 
#'
#' @param call An unevaluated \code{call} to the function specified by 
#'  \code{definition}, as generated by \code{\link[base]{call}}.
#'
#' @param expand.dots \code{logical} defining if arguments matching 
#'  \code{...} in the call be included or left as a \code{...} argument
#'
#' @param envir An \code{environment}, from which the \code{...} in 
#'  \code{call} are retrieved, if any.
#'
#' @references 
#'  DesignLibrary's \code{match.call.defaults} function. \cr
#'  Stack overflow post reply by Roland. \href{https://bit.ly/2PtEgy1}{URL}
#'
#' @examples
#'  fun <- function(arg1 = "ok", ...) {
#'    match.call.defaults()
#'  }
#'  fun()
#'  fun(arg2 = "hi")
#'
#' @export
#'
match.call.defaults <- function(definition = sys.function(sys.parent()), 
                                call = sys.call(sys.parent()), 
                                expand.dots = TRUE, envir = parent.frame(2L)){
  call <- match.call(definition = definition, call = call, 
                     expand.dots = expand.dots, envir = envir)
  formals <- formals(fun = definition)
  if (expand.dots && "..." %in% names(formals)){
      formals[["..."]] <- NULL
  }
  diffs <- setdiff(names(formals), names(call))
  for (i in diffs){
    call[i] <- list(formals[[i]])
  }
  match.call(definition = definition, call = call, expand.dots = TRUE, 
             envir = envir)
}
#' @title Create a named empty list
#'
#' @description Produces a list with \code{NULL} for each element named 
#'  according to \code{element_names}.
#' 
#' @param element_names \code{character} vector of names for the elements
#'  in the list.
#'
#' @return \code{list} with names \code{element_names} and values \code{NULL}.
#'
#' @examples
#'  named_null_list(c("a", "b", "c"))
#'
#' @export
#'
named_null_list <- function(element_names = NULL){
  return_if_null(element_names)
  nelements <- length(element_names)
  out <- vector("list", nelements)
  names(out) <- element_names
  out
}

#' @title Error if a function's request is deeper than can be handled
#'
#' @description Produces an informative error message when a function 
#'  that should only be called inside of other functions is called outside
#'  of a function (hence the request to the function is too deep for
#'  what it can handle).
#' 
#' @param lev The number of frames back in the stack where the request needs
#'  to be able to be evaluated.
#'
#' @return Throws an error if the function is called in a place where it 
#'  cannot operate and returns \code{NULL} otherwise.
#'
#' @examples
#'  \dontrun{
#'  # will error:
#'  # error_if_deep(-10)
#'  }
#'  error_if_deep(0)
#'
#' @export
#'
error_if_deep <- function(lev){
  lev2 <- lev - 1
  too_deep <- tryCatch(sys.call(lev2), error = function(x){NA})
  if(!is.null(too_deep) && !is.call(too_deep) && is.na(too_deep)){
    msg <- "too deep; function should only be called inside other functions"
    stop(msg, call. = FALSE)
  } 
}



#' @title Update a list's elements
#'
#' @description Update a list with new values for elements
#'
#' @param orig_list \code{list} to be updated with \code{...}. 
#'
#' @param ... Named elements to update in \code{orig_list}
#'
#' @return Updated \code{list}.
#'
#' @examples
#'  orig_list <- list(a = 1, b = 3, c = 4)
#'  update_list(orig_list)
#'  update_list(orig_list, a = "a")
#'  update_list(orig_list, a = 10, b = NULL)
#'
#' @export
#'
update_list <- function(orig_list = list(), ...){
  if(!is.list(orig_list)){
    stop("orig_list must be a list", call. = FALSE)
  } 
  update_elems <- list(...)
  nupdate_elems <- length(update_elems)
  norig_elems <- length(orig_list)
  update_list <- vector("list", length = norig_elems)
  names(update_list) <- names(orig_list)
  if(norig_elems > 0){
    for(i in 1:norig_elems){
      if(!is.null(orig_list[[i]])){
        update_list[[i]] <- orig_list[[i]]
      }
    }
  }
  if(nupdate_elems > 0){
    names_update_elems <- names(update_elems)
    for(i in 1:nupdate_elems){
      if(!is.null(update_elems[[i]])){
        update_list[[names_update_elems[i]]] <- update_elems[[i]]
      }
    }
  }
  update_list
}



#' @title Conform NA entries to "NA" entries
#'
#' @description Given the species abbreviation NA, when data are read in, 
#'  there can be an \code{NA} when it should be an \code{"NA"}. This function
#'  conforms the entries to be proper character values. 
#'
#' @param dfv Either [1] a \code{data.frame} containing \code{colname} as a 
#'  column with \code{NA}s that need to be conformed to \code{"NA"}s or [2]
#'  a vector with \code{NA}s that need to be conformed to \code{"NA"}s.
#'
#' @param colname \code{character} value of the column name in \code{tab} to 
#'  conform the \code{NA}s to \code{"NA"}s.
#'
#' @param arg_checks \code{logical} value of if the arguments should be
#'   checked using standard protocols via \code{\link{check_args}}. The 
#'   default (\code{arg_checks = TRUE}) ensures that all inputs are 
#'   formatted correctly and provides directed error messages if not. \cr
#'   However, in sandboxing, it is often desirable to be able to deviate from 
#'   strict argument expectations. Setting \code{arg_checks = FALSE} triggers
#'   many/most/all enclosed functions to not check any arguments using 
#'   \code{\link{check_args}}, and as such, \emph{caveat emptor}.
#'
#' @return \code{x} with any \code{NA} in \code{colname} replaced with 
#'  \code{"NA"}.
#'
#' @examples
#'  na_conformer(c("a", "b", NA, "c"))
#'
#' @export
#'
na_conformer <- function(dfv, colname = "species", arg_checks = TRUE){
  check_args(arg_checks)
  if (is.vector(dfv)){
    naentries <- which(is.na(dfv))
    dfv[naentries] <- "NA"
  } else if (is.data.frame(dfv)){
    nasppname <- which(is.na(dfv[ , colname]))
    if (length(nasppname) > 0){
      dfv[nasppname, colname] <- "NA"
    }
  } 
  dfv
}


#' @title Save data out to a csv, appending the file if it already exists
#'
#' @description Appending a \code{.csv} without re-writing the header of the
#'  file. If the doesn't exist, it will be created.
#'
#' @param df \code{data.frame} table to be written out.
#'
#' @param filename \code{character} filename of existing \code{.csv} to be 
#'  appended.
#'
#' @param arg_checks \code{logical} value of if the arguments should be
#'   checked using standard protocols via \code{\link{check_args}}. The 
#'   default (\code{arg_checks = TRUE}) ensures that all inputs are 
#'   formatted correctly and provides directed error messages if not. \cr
#'   However, in sandboxing, it is often desirable to be able to deviate from 
#'   strict argument expectations. Setting \code{arg_checks = FALSE} triggers
#'   many/most/all enclosed functions to not check any arguments using 
#'   \code{\link{check_args}}, and as such, \emph{caveat emptor}.
#'
#' @return \code{NULL}.
#'
#' @examples
#'  \donttest{
#'   df <- data.frame(x = 1:10)
#'   fpath <- file_path(files = "xx.csv")
#'   append_csv(df, fpath)
#'  }
#'
#' @export
#'
append_csv <- function(df, filename, arg_checks = TRUE){
  check_args(arg_checks)
  write.table(df, filename, sep = ",", row.names = FALSE, 
    col.names = !file.exists(filename), append = file.exists(filename))
  NULL
}

#' @title Calculate the fraction of the year from a date
#' 
#' @description Based on the year in which the date occurred, determine the
#'   fraction of the year (foy) for the date (in relation to New Year's Eve
#'   in that year). 
#'
#' @param dates \code{Date}(s) or \code{Date}-conformable value(s) to be 
#'   converted to the fraction of the year.
#'
#' @param arg_checks \code{logical} value of if the arguments should be
#'   checked using standard protocols via \code{\link{check_args}}. The 
#'   default (\code{arg_checks = TRUE}) ensures that all inputs are 
#'   formatted correctly and provides directed error messages if not. \cr
#'   However, in sandboxing, it is often desirable to be able to deviate from 
#'   strict argument expectations. Setting \code{arg_checks = FALSE} triggers
#'   many/most/all enclosed functions to not check any arguments using 
#'   \code{\link{check_args}}, and as such, \emph{caveat emptor}.
#'
#' @return \code{numeric} value(s) of the fraction of the year.
#'
#' @examples
#'  foy(Sys.Date())
#'
#' @export
#'
foy <- function(dates = NULL, arg_checks = TRUE){
  return_if_null(dates)
  check_args(arg_checks)
  dates <- as.Date(dates)
  jday <- as.numeric(format(dates, "%j"))
  nye <- as.Date(paste0(format(dates, "%Y"), "-12-31"))
  nyejday <- as.numeric(format(nye, "%j"))
  round(jday / nyejday, 3)
}

#' @title Remove files from the tmp subdirectory
#'
#' @description Clear the files from the tmp subdirectory.
#'
#' @param main \code{character} value of the name of the main component of
#'  the directory tree. 
#'
#' @param cleanup \code{logical} indicator if any files put into the tmp
#'  subdirectory should be removed at the end of the process. 
#'
#' @param quiet \code{logical} indicator if progress messages should be
#'  quieted.
#'
#' @param verbose \code{logical} indicator of whether or not to print out
#'   all of the information or just tidy messages. 
#'
#' @param bline \code{logical} indicator if horizontal break lines should be
#'  made or not. For toggling separately from the more general \code{quiet}
#'  argument. 
#'
#' @param arg_checks \code{logical} value of if the arguments should be
#'  checked using standard protocols via \code{\link{check_args}}. The 
#'  default (\code{arg_checks = TRUE}) ensures that all inputs are 
#'  formatted correctly and provides directed error messages if not. 
#'
#' @return \code{NULL}, with the tmp subdirectory's files removed.
#'
#' @examples
#'  \donttest{
#'   create_dir()
#'   clear_tmp
#'  }
#'
#' @export
#'
clear_tmp <- function(main = ".", bline = TRUE, quiet = FALSE, 
                      verbose = FALSE, cleanup = TRUE, arg_checks = TRUE){
  check_args(arg_checks)
  tmp_path <- tmp_path(main = main, arg_checks = arg_checks)
  tmp_exist <- dir.exists(tmp_path)
  tmp_files <- list.files(tmp_path)
  ntmp_files <- length(tmp_files)
  if(!cleanup){
    return()
  }
  messageq_break(bline = bline, quiet = quiet, arg_checks = arg_checks)
  messageq("Clearing tmp subdirectory", quiet)

  if(tmp_exist){
    if(ntmp_files > 0){
      tmp_files_full_paths <- file_path(main = main, sub = "tmp", 
                                        files = tmp_files, 
                                        arg_checks = arg_checks)
      unlink(tmp_files_full_paths, force = TRUE, recursive = TRUE)
      msg <- "    *temporary files cleared from tmp subdirectory*"
    } else {
      msg <- "    *tmp subdirectory already clear*"
    }
  } else{
    msg <- "    *tmp subdirectory not present for clearing*"
  }
  messageq(msg, !verbose)
  NULL
}



#' @title Combine a historical table and a cast table
#'
#' @description A simple utility for combining a table of historical data
#'  and a table of cast data that might need to be assigned to either one
#'  or the other.
#'
#' @param hist_tab,cast_tab A pair of \code{data.frame}s with the same columns
#'  including a code{date} column of \code{Date}s, which is used to align 
#'  them.
#'
#' @param winner \code{character} value either {"hist"} or \code{"cast"} to
#'  decide who wins any ties. In the typical portalcasting space, this is 
#'  kept at its default value throughout. In the case of \code{NA} values,
#'  this will be overriden to use the entry that has no missing entries.
#'
#' @param column \code{character} indicating the column to use for identifying
#'  entries in combining.
#'
#' @param arg_checks \code{logical} value of if the arguments should be
#'  checked using standard protocols via \code{\link{check_args}}. The 
#'  default (\code{arg_checks = TRUE}) ensures that all inputs are 
#'  formatted correctly and provides directed error messages if not. 
#'
#' @return \code{data.frame} combining \code{hist_tab} and \code{cast_tab}.
#' 
#' @examples
#'  hist_tab <- data.frame(date = seq(Sys.Date(), Sys.Date() + 5, 1), x = 1:6)
#'  cast_tab <- data.frame(date = seq(Sys.Date() + 5, Sys.Date() + 10, 1),
#'                         x = 101:106)
#'  combine_hist_and_cast(hist_tab, cast_tab, "hist") 
#'  combine_hist_and_cast(hist_tab, cast_tab, "cast")  
#'
#' @export
#'
combine_hist_and_cast <- function(hist_tab = NULL, cast_tab = NULL, 
                                  winner = "hist", column = "date",
                                  arg_checks = TRUE){
  check_args(arg_checks)
  return_if_null(hist_tab, cast_tab)
  return_if_null(cast_tab, hist_tab)

  hist_tab$x_source <- "hist"
  cast_tab$x_source <- "cast"
  out <- rbind(hist_tab, cast_tab)
  in_out <- rep(TRUE, NROW(out))
  dupes <- names(which(table(out[,column]) > 1))

  ndupes <- length(dupes) 
  if(ndupes > 0){
    for(i in 1:ndupes){
      which_duped <- which(out$moon == dupes[i])

      which_duped_hist <- which(as.character(out[,column]) == dupes[i] &
                                out$x_source == "hist")
      which_duped_cast <- which(as.character(out[,column]) == dupes[i] &
                                out$x_source == "cast") 

      hist_dupe_NA <- any(is.na(out[which_duped_hist, ]))
      cast_dupe_NA <- any(is.na(out[which_duped_cast, ]))

      if(winner == "hist"){
        if(!hist_dupe_NA){
          in_out[which_duped_cast] <- FALSE
        } else{
          in_out[which_duped_hist] <- FALSE   
        }
      } else if(winner == "cast"){
        if(!cast_dupe_NA){
          in_out[which_duped_hist] <- FALSE
        } else{
          in_out[which_duped_cast] <- FALSE   
        }
      }
    }
  }
  out <- out[ , -which(colnames(out) == "x_source")]
  out[in_out, ]
}

#' @title Add a date to a table that has the year month and day as components 
#' 
#' @description Add a date (as a \code{Date}) column to a table that has the 
#'  year month and day as components.
#' 
#' @param df \code{data.frame} with columns named \code{year}, \code{month},
#'  and \code{day}. 
#'
#' @param arg_checks \code{logical} value of if the arguments should be
#'   checked using standard protocols via \code{\link{check_args}}. The 
#'   default (\code{arg_checks = TRUE}) ensures that all inputs are 
#'   formatted correctly and provides directed error messages if not. \cr
#'   However, in sandboxing, it is often desirable to be able to deviate from 
#'   strict argument expectations. Setting \code{arg_checks = FALSE} triggers
#'   many/most/all enclosed functions to not check any arguments using 
#'   \code{\link{check_args}}, and as such, \emph{caveat emptor}.
#'
#' @return \code{data.frame} \code{df} with column of \code{Date}s 
#'  named \code{date} added.
#'
#' @examples
#'  df <- data.frame(year = 2010, month = 2, day = 1:10)
#'  add_date_from_components(df)
#'
#' @export
#'
add_date_from_components <- function(df, arg_checks = TRUE){
  check_args(arg_checks)
  yrs <- df$year
  mns <- df$month
  dys <- df$day
  df$date <- as.Date(paste(yrs, mns, dys, sep = "-"))
  df
}




#' @title Remove any specific incomplete entries as noted by an NA
#'
#' @description Remove any incomplete entries in a table, as determined by
#'  the presence of an \code{NA} entry in a specific column 
#'  (\code{colname}).
#'
#' @param df \code{data.frame} table to be written out.
#'
#' @param colname A single \code{character} value of the column to use
#'  to remove incomplete entries. 
#'
#' @param arg_checks \code{logical} value of if the arguments should be
#'  checked using standard protocols via \code{\link{check_args}}. The 
#'  default (\code{arg_checks = TRUE}) ensures that all inputs are 
#'  formatted correctly and provides directed error messages if not. 
#'
#' @return \code{df} without any incomplete entries. 
#'
#' @examples
#'  df <- data.frame(c1 = c(1:9, NA), c2 = 11:20)
#'  remove_incompletes(df, "c1")
#'
#' @export
#'
remove_incompletes <- function(df, colname, arg_checks = TRUE){
  check_args(arg_checks)
  incompletes <- which(is.na(df[ , colname]))
  if (length(incompletes) > 0){
    df <- df[-incompletes, ]
  }
  df
}

#' @title Determine the depth of a list
#'
#' @description Evaluate an input for the depth of its nesting. 
#'
#' @details If \code{xlist = list()}, then technically the input value is a 
#'  list, but is empty (of length \code{0}), so depth is returned as \code{0}.
#'
#' @param xlist Focal input \code{list}.
#'
#' @return \code{integer} value of the depth of the list.
#' 
#' @examples
#'  list_depth("a")
#'  list_depth(list())
#'  list_depth(list("a"))
#'  list_depth(list(list("a")))
#'
#' @export 
#'
list_depth <- function(xlist){
  xx <- match.call()
  xxx <- deparse(xx[[2]])
  if(xxx == "list()"){
    0L
  } else if (is.list(xlist)){
    1L + max(sapply(xlist, list_depth))
  } else {
    0L
  }
}

#' @title If a value is NULL, trigger the parent function's return
#'
#' @description If the focal input is \code{NULL}, return \code{value} from
#'  the parent function. Should only be used within a function.
#'
#' @param x Focal input.
#'
#' @param value If \code{x} is \code{NULL}, \code{\link{return}} this input
#'  from the parent function. 
#'
#' @return If \code{x} is not \code{NULL}, \code{NULL} is returned. If 
#'  \code{x} is \code{NULL}, the result of \code{\link{return}} with 
#'  \code{value} as its input evaluated within the parent function's 
#'  environment is returned.
#' 
#' @examples
#'  ff <- function(x = 1, null_return = "hello"){
#'    return_if_null(x, null_return)
#'    x
#'  }
#'  ff()
#'  ff(NULL)
#'
#' @export 
#'
return_if_null <- function(x, value = NULL){
  if(is.null(x)){
    do.call(return, list(value), envir = sys.frame(-1))
  } 
}


#' @title Replace a value with an alternative if it is NULL or if it is NA
#'
#' @description 
#'  \code{ifnull} replaces the focal input with the alternative value if it
#'   is \code{NULL}. \cr \cr
#'  \code{ifna} replaces the focal input with the alternative value if it
#'   is \code{NA}.
#'
#' @param x Focal input.
#'
#' @param alt Alternative value.
#'
#' @return 
#'  \code{ifnull}: \code{x} if not \code{NULL}, \code{alt} otherwise. \cr \cr
#'  \code{ifna}:  \code{x} if not \code{NA}, \code{alt} otherwise. 
#' 
#' @examples
#'  ifnull(NULL, 123)
#'  ifnull(TRUE, 123)
#'  ifnull(FALSE, 123)
#'  ifna(NA, 123)
#'  ifna(FALSE, 123)
#'  ifna(NA, NA)
#'
#' @name alternative_values
#'
NULL

#' @rdname alternative_values
#'
#' @export 
#'
ifnull <- function(x = NULL, alt = NULL){
  if(is.null(x)){
    x <- alt
  }
  x
}

#' @rdname alternative_values
#'
#' @export 
#'
ifna <- function(x = NULL, alt = NA){
  ifelse(is.na(x), alt, x)
}