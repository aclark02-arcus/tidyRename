% Generated by roxygen2: do not edit by hand
% Please edit documentation in R/utils.R
\name{words_a1}
\alias{words_a1}
\title{Insert a space between a character followed by a number to create the assumed
"words" in the character vector}
\usage{
words_a1(x)
}
\arguments{
\item{x}{a character vector where matches are sought, or an object which can
be coerced by as.character to a character vector. Long vectors are
supported.}
}
\description{
Insert a space between a character followed by a number to create the assumed
"words" in the character vector
}
\examples{
if(interactive()) {
  words_a1("iAte1grape")
}
}
\keyword{internal}
