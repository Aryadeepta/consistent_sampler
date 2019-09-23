Skip to content
Why GitHub?
Enterprise
Explore
Marketplace
Pricing
Search

Sign in
Sign up
210juliamatlab/MatLang
 Code Issues 5 Pull requests 0 Projects 1 Security Insights
Join GitHub today
GitHub is home to over 40 million developers working together to host and review code, manage projects, and build software together.

MatLang/docs/makeLocal.jl
@aminya aminya Update makeLocal.jl
99b9cc2 4 minutes ago
49 lines (42 sloc)  1.28 KB

# # make file only for local make of the document.
# this result in errors in Travis
#
# ## To build the documentation locally
#
# ### Running inside Julia REPL:
#  cd to docs folder `cd("path to docs\\MatLang\\docs")` and run the following command:
# ```
# include("makeLocal.jl")
# ```
#
# ### Running inside OS Terminal:
# cd to docs folder using OS terminal and run the following command (julia path should be added to OS path):
# ```
# julia --color=yes makeLocal.jl
# ```


using Pkg
pkg"activate .."
push!(LOAD_PATH,"../src/")

#

using Documenter, MatLang

makedocs(;
    modules=[consistent_sampler],
	format = Documenter.HTML(
        prettyurls = prettyurls = get(ENV, "CI", nothing) == "true",
    ),
    pages=[
        "Home" => "index.md",
        "Functions" => "functions.md",
        "Development - Contribution" => "development.md",
        "Native Julia noteworthy differences from MATLAB" => "juliavsmatlab.md"
    ],
    repo="https://github.com/juliamatlab/MatLang/blob/{commit}{path}#L{line}",
    sitename="MatLang",
    authors="Arya - JuliaMatlab",
)
