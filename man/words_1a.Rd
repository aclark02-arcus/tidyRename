% Generated by roxygen2: do not edit by hand
% Please edit documentation in R/utils.R
\name{words_1a}
\alias{words_1a}
\title{Insert a space between a number followed by a character to create the assumed
"words" in the character vector}
\usage{
words_1a(x)
}
\arguments{
\item{x}{a character vector where matches are sought, or an object which can
be coerced by as.character to a character vector. Long vectors are
supported.}
}
\description{
Insert a space between a number followed by a character to create the assumed
"words" in the character vector
}
\examples{
if(interactive()) {
  words_1a(x = "iAte1grape")
}
}
\keyword{internal}
