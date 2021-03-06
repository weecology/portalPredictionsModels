% Generated by roxygen2: do not edit by hand
% Please edit documentation in R/prepare_models.R
\name{write_model}
\alias{write_model}
\alias{model_template}
\alias{control_list_arg}
\title{Write the template for a model into model subdirectory}
\usage{
write_model(
  name = NULL,
  data_sets = NULL,
  covariatesTF = NULL,
  lag = NULL,
  main = ".",
  control_model = NULL,
  control_files = files_control(),
  control_runjags = NULL,
  max_E = NULL,
  quiet = FALSE,
  verbose = TRUE,
  arg_checks = TRUE
)

model_template(
  name = NULL,
  data_sets = NULL,
  covariatesTF = FALSE,
  lag = NULL,
  main = ".",
  control_files = files_control(),
  max_E = NULL,
  control_runjags = NULL,
  quiet = FALSE,
  verbose = FALSE,
  arg_checks = TRUE
)

control_list_arg(control_list = NULL, list_function = NULL, arg_checks = TRUE)
}
\arguments{
\item{name}{\code{character} value of the name of the model.}

\item{data_sets}{\code{character} vector of the rodent data set names
that the model is applied to.}

\item{covariatesTF}{\code{logical} indicator for if the model requires 
covariates.}

\item{lag}{\code{integer} (or integer \code{numeric}) lag time used for the
covariates or \code{NULL} if \code{covariatesTF} is \code{FALSE}.}

\item{main}{\code{character} value of the name of the main component of
the directory tree.}

\item{control_model}{\code{list} of model-level controls, including
\code{name}, a \code{character} value of the model's name;
\code{covariatesTF}, a \code{logical} indicator for if the model requires 
covariates; and \code{lag}, a \code{integer} (or integer \code{numeric}) 
lag time used for the covariates or \code{NA} if 
\code{covariatesTF = FALSE}. Only used if the specific valued argument
is \code{NULL}.}

\item{control_files}{\code{list} of names of the folders and files within
the sub directories and saving strategies (save, overwrite, append, etc.).
Generally shouldn't need to be edited. See \code{\link{files_control}}.}

\item{control_runjags}{\code{list} of arguments passed to 
\code{\link[runjags]{run.jags}} via \code{\link{runjags_control}}.}

\item{max_E}{\code{integer} (or integer \code{numeric}) for the maximum 
embedding dimension to search amongst for EDM models. See 
\code{\link[rEDM]{simplex}} for more information.}

\item{quiet}{\code{logical} indicator controlling if messages are printed.}

\item{verbose}{\code{logical} indicator if detailed messages should be
shown.}

\item{arg_checks}{\code{logical} value of if the arguments should be
checked using standard protocols via \code{\link{check_args}}. The 
default (\code{arg_checks = TRUE}) ensures that all inputs are 
formatted correctly and provides directed error messages if not. \cr}

\item{control_list}{\code{list} of arguments passed to 
\code{list_function}.}

\item{list_function}{\code{character} value name of the function to 
send \code{control_list} arguments to within the model script.}
}
\value{
\code{write_mode} \code{\link{write}}s the model script out
 and returns \code{NULL}. \cr \cr
 \code{model_template}: \code{character}-valued text for a model script 
 to be housed in the model directory. \cr \cr
 \code{control_list_arg}: \code{character}-valued text for part of a 
 model script. \cr \cr
}
\description{
\code{write_model} creates a template script (as written by 
 \code{model_template}) for a given model. \cr \cr
 \code{model_template} creates the \code{character}-valued
 text for a model script to be housed in the model directory, as written
 out by \code{write_model}. \cr \cr
 \code{control_list_arg} creates the \code{character}-valued
 text for a specific list argument into model function within a model
 script to be housed in the model directory.
}
\examples{
 \donttest{
  create_dir()
  write_model("AutoArima")
  model_template()
  control_list_arg(runjags_control(nchains = 3), "runjags_control")
 }

}
