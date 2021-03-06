% Generated by roxygen2: do not edit by hand
% Please edit documentation in R/repo_public.R
\name{repo_load}
\alias{repo_load}
\title{Loads an item to current workspace}
\usage{
repo_load(names, overwrite_existing = F, env = parent.frame())
}
\arguments{
\item{names}{List or vector of repository item names.}

\item{overwrite_existing}{Overwrite an existing variable by the
same name in the current workspace. If F (defaults) throws an
error.}

\item{env}{Environment to load the variable into (parent environment
by default).}
}
\value{
Nothing, used for side effects.
}
\description{
Like \code{repo_get}, returns the contents of a stored item. But,
unlike \code{repo_get}, loads it to the current namespace.
}
