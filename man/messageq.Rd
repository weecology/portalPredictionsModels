% Generated by roxygen2: do not edit by hand
% Please edit documentation in R/messaging.R
\name{messageq}
\alias{messageq}
\title{Optionally generate a message based on a logical input}
\usage{
messageq(msg = NULL, quiet = FALSE, arg_checks = TRUE)
}
\arguments{
\item{msg}{\code{character} vector of the message(s) to generate or 
\code{NULL}. If more than one element is contained in \code{msg}, they
are concatenated with a newline between.}

\item{quiet}{\code{logical} indicator controlling if the message is
generated. If \code{NULL}, it is as if \code{TRUE}.}

\item{arg_checks}{\code{logical} value of if the arguments should be
checked using standard protocols via \code{\link{check_args}}. The 
default (\code{arg_checks = TRUE}) ensures that all inputs are 
formatted correctly and provides directed error messages if not.}
}
\value{
A message is given, and \code{NULL} returned.
}
\description{
Given the input to \code{quiet}, generate the message(s) 
  in \code{msg} or not.
}
\examples{
 messageq("Hello world", FALSE)
 messageq("Hello world", TRUE)

}
